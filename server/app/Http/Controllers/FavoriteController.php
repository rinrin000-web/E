<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Favorite;

class FavoriteController extends Controller
{
    // Lấy danh sách các yêu thích của người dùng (theo email)
    public function index($user_email = null)
    {
        $favorites = $user_email ? Favorite::where('user_email', $user_email)->get() : Favorite::all();

        return response()->json([
            'status' => true,
            'data' => $favorites
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

        // if ($favorite) {
        //     // Nếu đã tồn tại, lật giá trị is_favorite
        //     $favorite->is_favorite = !$favorite->is_favorite;
        //     $favorite->favorited_at = $favorite->is_favorite ? now() : null;
        //     $favorite->save();

        //     return response()->json([
        //         'status' => true,
        //         'message' => 'Favorite status updated successfully!',
        //         'data' => $favorite
        //     ], 200);
        // }
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