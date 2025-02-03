<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\Team;
use App\Models\Event;
use App\Models\Eventsmange;
use App\Models\Floor;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
class TeamController extends Controller
{
    //
    public function getTeamsByEventId($id)
{
    // Kiểm tra xem event có tồn tại không
    $event = Event::find($id);

    if (!$event) {
        return response()->json([
            'message' => 'Event not found',
        ], 404);
    }

    // Truy vấn SQL lấy danh sách team theo event_id
    $teamsSQL = DB::select("
        SELECT t.*
        FROM teams AS t
        JOIN eventsmanage AS ea ON ea.team_no = t.team_no
        JOIN events AS e ON e.id = ea.event_id
        WHERE e.id = ?
        ORDER BY t.rank DESC
    ", [$id]);

    // Kiểm tra xem có dữ liệu hay không
    if (empty($teamsSQL)) {
        return response()->json([
            'message' => 'No teams found for this event',
        ], 404);
    }

    // Trả về danh sách team
    return response()->json([
        'event' => $event->event_name,
        'teams' => $teamsSQL,
    ]);
}

public function store(Request $request, $eventId)
{
    // Validate the incoming request data
    $request->validate([
        'team_no' => 'required|string|unique:teams,team_no', // team_no must be unique
        'teamfileimages' => 'nullable|file|mimes:jpg,jpeg,png,gif', // Validate image file
        'floor_no' => 'required|exists:floors,floor_no', // Ensure floor_no exists in floors table
        // 'rank' => 'nullable|numeric', // Optional rank field
    ]);
    $validFloor = Floor::where('event_id', $eventId)
                   ->where('floor_no', $request->floor_no)
                   ->exists();

if ($request->floor_no && !$validFloor) {
    return response()->json(['message' => 'floor_no does not exist for this event'], 404);
}
    $imagePath = null;
    if ($request->hasFile('teamfileimages')) {
        // If the image file is provided, store it
        $file = $request->file('teamfileimages');
        $fileName = 'team_' . time() . '_' . uniqid() . '.' . $file->getClientOriginalExtension();
        $imagePath = $file->storeAs('teamfileimages', $fileName, 'public'); // Store in 'teamfileimages' folder
    }

    // Create the team record in the database
    $team = Team::create([
        'team_no' => $request->team_no,
        'teamfileimages' => $imagePath, // Store image path
        'floor_no' => $request->floor_no,
        // 'rank' => $request->rank,
    ]);

    // Create the record in the Eventsmange table to link team with event
    $eventManage = Eventsmange::create([
        'event_id' => $eventId, // Use eventId directly
        'team_no' => $request->team_no,
    ]);

    return response()->json([
        'message' => 'Team created successfully',
        'team' => $team,
        'event_manage' => $eventManage,
    ], 201);
}

public function update(Request $request,$event_id, $team_no)
{
    $request->validate([
        'teamfileimages' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        'floor_no' => 'nullable|exists:floors,floor_no',
    ]);
    $validFloor = Floor::where('event_id', $event_id)
                   ->where('floor_no', $request->floor_no)
                   ->exists();

if ($request->floor_no && !$validFloor) {
    return response()->json(['message' => 'floor_no does not exist for this event'], 404);
}

    $team = Team::where('team_no', $team_no)->first();

    if (!$team) {
        return response()->json(['message' => 'Team not found'], 404);
    }

    // Khởi tạo mảng chứa dữ liệu cần cập nhật
    $dataToUpdate = [];

    // Kiểm tra nếu có tệp hình ảnh mới
    if ($request->hasFile('teamfileimages')) {
        // Xóa ảnh cũ nếu có
        if ($team->teamfileimages) {
            Storage::disk('public')->delete($team->teamfileimages);
        }

        // Lưu ảnh mới
        $file = $request->file('teamfileimages');
        $fileName = 'team_' . time() . '_' . uniqid() . '.' . $file->getClientOriginalExtension();
        $imagePath = $file->storeAs('teamfileimages', $fileName, 'public');
        $dataToUpdate['teamfileimages'] = $imagePath;
    }

    // Cập nhật floor_no nếu có
    if ($request->has('floor_no')) {
        $dataToUpdate['floor_no'] = $request->floor_no;
    }

    // Cập nhật bản ghi
    $team->update($dataToUpdate);

    return response()->json($team);
}



public function destroy($team_no)
{
    // Tìm team theo team_no
    $team = Team::where('team_no', $team_no)->first();

    // Kiểm tra nếu team tồn tại
    if ($team) {
        $team->delete();
        return response()->json(['message' => 'Team deleted successfully', 'data' => $team], 200);
    } else {
        return response()->json(['message' => 'Team not found'], 404);
    }
}



    public function index($team_no = null)
    {
        try {
            // Truy vấn để tính toán rank trung bình từ bảng comment và cập nhật vào bảng teams
            DB::update('
            UPDATE teams t
                JOIN (
                    SELECT team_no, AVG(`rank`) AS avg_rank
                    FROM comment
                    GROUP BY team_no
                ) AS avg_data ON t.team_no = avg_data.team_no
                SET t.rank = avg_data.avg_rank;
            ');


            // Trả về danh sách team hoặc một team cụ thể
            return response()->json($team_no ? Team::find($team_no) : Team::all());


        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to update team ranks', 'message' => $e->getMessage()]);
        }
    }

public function getRank($team_no, $event_id)
{
    try {
        // Kiểm tra xem event có tồn tại không
        $event = DB::table('events')->where('id', $event_id)->first();
        if (!$event) {
            return response()->json(['message' => 'Event not found'], 404);
        }

        // Cập nhật rank trung bình cho các team thuộc event cụ thể
        DB::update('
            UPDATE teams t
            JOIN (
                SELECT c.team_no, AVG(c.rank) AS avg_rank
                FROM comment c
                JOIN eventsmanage em ON c.team_no = em.team_no
                WHERE em.event_id = ?
                GROUP BY c.team_no
            ) AS avg_data ON t.team_no = avg_data.team_no
            SET t.rank = avg_data.avg_rank
        ', [$event_id]);

        // Lấy rank của team cụ thể
        $rank = DB::table('teams')
            ->join('eventsmanage', 'teams.team_no', '=', 'eventsmanage.team_no')
            ->where('teams.team_no', $team_no)
            ->where('eventsmanage.event_id', $event_id)
            ->value('teams.rank');

        if (is_null($rank)) {
            return response()->json(['message' => 'Team not found or not in the specified event'], 404);
        }

        return response()->json([
            'team_no' => $team_no,
            'rank' => $rank,
        ]);

    } catch (\Exception $e) {
        // Xử lý lỗi nếu có
        return response()->json(['error' => 'Failed to update or retrieve team rank', 'message' => $e->getMessage()], 500);
    }
}

    public function getImage($filename)
{
    Log::info("Filename requested: $filename");

    $path = storage_path('app/public/teamfileimages/' . $filename);
    Log::info('Path to file: ' . $path); // Ghi lại đường dẫn đến file

    if (!file_exists($path)) {
        return response()->json(['message' => 'Image not found'], 404);
    }

    return response()->file($path); // Trả về tệp hình ảnh
}

}