<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\Team;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

class TeamController extends Controller
{
    //
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
    public function getRank($team_no)
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

        $rank = DB::table('teams')
        ->where('team_no', $team_no)
        ->value('rank');

        if (is_null($rank)) {
            return response()->json(['message' => 'Team not found'], 404);
        }
        return response()->json(['rank' => $rank]);

    } catch (\Exception $e) {
        // Xử lý lỗi nếu có
        return response()->json(['error' => 'Failed to update team ranks', 'message' => $e->getMessage()]);
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