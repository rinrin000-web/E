<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Floor;
use App\Models\Team;
use App\Models\User;

class FloorController extends Controller
{
    /**
     * Handle the incoming request.
     */
    public function store(Request $request)
    {
        // Validate dữ liệu từ yêu cầu API
        $request->validate([
            'contents' => 'required|string|max:255', // Nội dung là bắt buộc và tối đa 255 ký tự
        ]);

        // Tạo một tầng mới
        $floor = new Floor();
        $floor->floor_no = $request->floor_no; // Gán nội dung từ yêu cầu
        $floor->contents = $request->contents; // Gán nội dung từ yêu cầu
        $floor->save(); // Lưu tầng mới vào cơ sở dữ liệu

        // Trả về phản hồi JSON
        return response()->json([
            'message' => 'New floor created successfully!',
            'data' => $floor,
        ], 201);
    }

    public function update(Request $request, $floor_no) {
        $floor = Floor::where('floor_no', $floor_no)->first();

        if (!$floor) {
            return response()->json([
                'message' => 'Floor not found.'
            ], 404); // HTTP 404 Not Found
        }

        $floor->update($request->all());
        return response()->json($floor);
    }

    public function destroy($floor_no){
        $floor = Floor::where('floor_no',$floor_no)->first();

        if(!$floor){
            return response()->json(['message' =>'floor not found '],400);
        }
        $floor->delete();
        return response()->json(['message' =>'floor_no delete successfully','data'=> $floor],200);
    }
    public function getFloorTeamCount($event_id)
{
    $floors = Floor::all(); // Lấy tất cả các tầng

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


}
