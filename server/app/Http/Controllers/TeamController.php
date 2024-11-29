<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\Team;
use App\Models\Event;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

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



    public function updateTeamImage(Request $request, $team_no)
    {
        $request->validate([
            'teamfileimages' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',  // Xác thực file ảnh
        ]);

        // Xử lý upload ảnh (nếu có)
        if ($request->hasFile('teamfileimages')) {
            // $imagePath = $request->file('teamfileimages')->store('teams', 'public');
            $file = $request->file('teamfileimages');
            $imagePath = $file->store('teamfileimages');
            $fileName = $file->hashName();

            // Cập nhật cột teamfileimages của bản ghi cụ thể với id = $id
            $team = Team::find($team_no); // Tìm bản ghi theo id
            if ($team) {
                $team->update([
                    'teamfileimages' => $fileName,
                ]);

                return response()->json(['message' => 'Image updated successfully', 'team' => $team], 200);
            } else {
                return response()->json(['message' => 'Team not found'], 404);
            }
        } else {
            return response()->json(['message' => 'No image uploaded'], 400);
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
//     public function getRank($team_no)
// {
//     try {
//         // Truy vấn để tính toán rank trung bình từ bảng comment và cập nhật vào bảng teams
//         DB::update('
//             UPDATE teams t
//                 JOIN (
//                     SELECT team_no, AVG(`rank`) AS avg_rank
//                     FROM comment
//                     GROUP BY team_no
//                 ) AS avg_data ON t.team_no = avg_data.team_no
//                 SET t.rank = avg_data.avg_rank;
//             ');

//         $rank = DB::table('teams')
//         ->where('team_no', $team_no)
//         ->value('rank');

//         if (is_null($rank)) {
//             return response()->json(['message' => 'Team not found'], 404);
//         }
//         return response()->json(['rank' => $rank]);

//     } catch (\Exception $e) {
//         // Xử lý lỗi nếu có
//         return response()->json(['error' => 'Failed to update team ranks', 'message' => $e->getMessage()]);
//     }
// }
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




    // function Search($team_no){
    //     return Team::where("team_no",$team_no)->get();
    // }
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