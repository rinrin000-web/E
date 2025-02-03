<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Favorite;

class FavoriteController extends Controller
{

    public function index($user_email, $event_id)
    {
        $favorites = Favorite::query();

        // Nếu có `user_email`, lọc theo email người dùng
        if ($user_email) {
            $favorites->where('user_email', $user_email);
        }

        // Nếu có `event_id`, lọc theo sự kiện thông qua mối quan hệ với `Team` và `Eventsmange`
        if ($event_id) {
            $favorites->whereHas('team.eventsManage.events', function ($query) use ($event_id) {
                // Thay 'events.event_id' bằng 'events.id' vì 'id' là khóa chính của bảng events
                $query->where('events.id', $event_id);
            });
        }

        // Lấy kết quả
        $favorites = $favorites->get();

        return response()->json([
            'status' => true,
            'data' => $favorites,
        ], 200);
    }




    // Lưu hoặc cập nhật trạng thái yêu thích
    public function store(Request $request)
    {
        // Xác thực dữ liệu đầu vào
        $request->validate([
            'user_email' => 'required|string',
            'team_no' => 'required|string',
        ]);

        // Kiểm tra xem bản ghi đã tồn tại hay chưa
        $favorite = Favorite::where('user_email', $request->user_email)
                            ->where('team_no', $request->team_no)
                            ->first();

        if (!$favorite) {
            // Nếu chưa tồn tại, tạo mới với is_favorite = true
            $favorite = Favorite::create([
                'user_email' => $request->user_email,
                'team_no' => $request->team_no,
                'is_favorite' => true,
                'favorited_at' => now(),
            ]);

            return response()->json([
                'status' => true,
                'message' => 'Favorite created successfully!',
                'data' => $favorite
            ], 201);
        }
    }

    // Xóa yêu thích của người dùng
    public function destroy($user_email, $team_no)
    {
        $favorite = Favorite::where('user_email', $user_email)
                            ->where('team_no', $team_no)
                            ->first();

        if (!$favorite) {
            return response()->json([
                'status' => false,
                'message' => 'Favorite not found'
            ], 404);
        }

        $favorite->delete();

        return response()->json([
            'status' => true,
            'message' => 'Favorite deleted successfully!'
        ], 200);
    }
}