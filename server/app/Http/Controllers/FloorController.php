<?php

namespace App\Http\Controllers;

use App\Models\Event;
use App\Models\Eventsmange;
use Illuminate\Http\Request;
use App\Models\Floor;
use App\Models\Team;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class FloorController extends Controller
{
    /**
     * Handle the incoming request.
     */
//     public function index($event_id)
// {
//     // Find the event by ID
//     $event = Event::find($event_id);
//     if (!$event) {
//         return response()->json([
//             'message' => 'Event not found',
//         ], 404);
//     }

//     // Check if the event has related management data
//     $eventmanage = DB::select("
//         select ea.event_id from eventsmanage as ea
//         join events as e on e.id = ea.event_id
//         where e.id = ?
//     ", [$event_id]);
//     if (!$eventmanage) {
//         return response()->json([
//             'message' => 'Event management not found',
//         ], 404);
//     }

//     // Get floor details for the event
//     $floorSQL = DB::select("
//         select * from floors where event_id = ?
//     ", [$event_id]);
//     if (empty($floorSQL)) {
//         return response()->json([
//             'message' => 'No floors found for this event',
//         ], 404);
//     }

//     // Return the event and floor data
//     return response()->json([
//         // 'event' => $eventmanage,
//         'floors' => $floorSQL,
//     ]);
// }

public function store(Request $request, $event_id)
{
    // Validate the request
    $validatedData = $request->validate([
        'floor_no' => 'required|integer',
        'contents' => 'nullable|string',
        'fakeusercount' => 'nullable|integer',
    ]);

    // Check if the event exists
    $event = Event::find($event_id);
    if (!$event) {
        return response()->json([
            'message' => 'Event not found',
        ], 404);
    }

    // Check if floor_no already exists for the given event_id
    $existingFloor = Floor::where('floor_no', $validatedData['floor_no'])
                          ->where('event_id', $event_id)
                          ->first();

    if ($existingFloor) {
        return response()->json([
            'message' => 'Floor already exists for this event.',
            'floor' => $existingFloor,
        ], 409); // HTTP 409 Conflict
    }

    // Create a new floor
    $floor = new Floor();
    $floor->floor_no = $validatedData['floor_no'];
    $floor->contents = $validatedData['contents'] ?? null;
    // $floor->fakeusercount = $validatedData['fakeusercount'] ?? 0; // Default to 0
    $floor->event_id = $event_id;

    // Save the new floor record
    $floor->save();

    // Return a success response
    return response()->json([
        'message' => 'Floor created successfully!',
        'floor' => $floor,
    ]);
}


    public function update(Request $request, $floor_no, $event_id) {
        // Kiểm tra sự tồn tại của sự kiện
        // $event = Event::find($event_id);
        // if (!$event) {
        //     return response()->json([
        //         'message' => 'Event not found',
        //     ], 404);
        // }
        // $eventmanage = Eventsmange::where('event_id', $event_id)->first();
        //     if (!$eventmanage) {
        //         return response()->json([
        //             'message' => 'Event management not found',
        //         ], 404);
        //     }

        // Validate đầu vào
        $request->validate([
            'contents' => 'nullable|string',
            // 'fakeusercount' => 'nullable|integer',
        ]);

        // Lấy thông tin floor theo floor_no và event_id
        $floor = Floor::where('floor_no', $floor_no)->where('event_id', $event_id)->first();

        if (!$floor) {
            return response()->json([
                'message' => 'Floor not found.',
            ], 404); // HTTP 404 Not Found
        }

        // Cập nhật bản ghi
        $floor->contents = $request->contents;
        // $floor->fakeusercount = $request->fakeusercount ?? 0; // Nếu không có giá trị thì mặc định là 0
        $floor->save();

        // Trả về thông tin bản ghi đã cập nhật
        return response()->json([
            'message' => 'Floor updated successfully!',
            'floor' => $floor,
        ]);
    }


    public function destroy($floor_no, $event_id) {
        // Kiểm tra sự tồn tại của tầng (floor)
        $floor = Floor::where('floor_no', $floor_no)->where('event_id', $event_id)->first();

        if (!$floor) {
            return response()->json([
                'message' => 'Floor not found.',
            ], 404); // HTTP 404 Not Found
        }

        // Xóa các đội trong tầng đang xóa
        DB::table('teams')->where('floor_no', $floor_no)->delete();

        // Xóa tầng (floor)
        $floor->delete();

        // Trả về thông báo thành công
        return response()->json([
            'message' => 'Floor and associated teams deleted successfully!',
        ]);
    }


public function getFloorTeamCount($event_id)
{
    // Lấy tất cả các tầng có event_id tương ứng
    $floors = Floor::where('event_id', $event_id)->get(); // Lọc theo event_id

    foreach ($floors as $floor) {
        // Tính số lượng đội cho từng tầng
        $teamCount = Team::where('floor_no', $floor->floor_no)
            ->whereHas('eventsManage', function ($query) use ($event_id) {
                $query->where('event_id', $event_id); // Lọc theo event_id
            })
            ->count(); // Đếm số đội

        $floor->teamcount = $teamCount;
        $floor->userCount = $floor->users()->count();
    }

    return response()->json($floors);
}

public function resetFakeUserCount($event_id) {
    // Lấy tất cả các bản ghi liên quan đến event_id
    $floors = Floor::where('event_id', $event_id)->get();

    // Kiểm tra nếu không tìm thấy bản ghi
    if ($floors->isEmpty()) {
        return response()->json([
            'message' => 'No floors found for the given event_id.',
        ], 404); // HTTP 404 Not Found
    }

    // Đặt giá trị fakeusercount về 0 cho tất cả các bản ghi
    foreach ($floors as $floor) {
        $floor->fakeusercount = 0;
        $floor->save();
    }

    // Trả về danh sách các bản ghi đã cập nhật
    return response()->json([
        'message' => 'All fakeusercount values have been reset to 0.',
        'floors' => $floors,
    ]);
}

public function updateUserCount(Request $request, $floor_no, $event_id) {

    // Validate đầu vào
    $request->validate([
        // 'contents' => 'nullable|string',
        'fakeusercount' => 'nullable|integer',
    ]);

    // Lấy thông tin floor theo floor_no và event_id
    $floor = Floor::where('floor_no', $floor_no)->where('event_id', $event_id)->first();

    if (!$floor) {
        return response()->json([
            'message' => 'Floor not found.',
        ], 404); // HTTP 404 Not Found
    }

    // Cập nhật bản ghi
    // $floor->contents = $request->contents;
    $floor->fakeusercount = $request->fakeusercount ?? 0; // Nếu không có giá trị thì mặc định là 0
    $floor->save();

    // Trả về thông tin bản ghi đã cập nhật
    return response()->json([
        'message' => 'Floor updated successfully!',
        'floor' => $floor,
    ]);
}

}