<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Floor;
use Illuminate\Http\Request;

class UserLocationController extends Controller
{
    /**
     * Hiển thị thông tin vị trí người dùng.
     *
     * @param int $userId
     * @return \Illuminate\Http\Response
     */
    public function show($email=null)
    {
        // $user = User::findOrFail($userId);  // Lấy thông tin người dùng

        // // Nếu người dùng chưa có tầng nào
        // if (!$user->floor_no) {
        //     return response()->json([
        //         'message' => 'User has no floor assigned',
        //     ], 404);
        // }

        // // Lấy thông tin tầng của người dùng
        // $floor = Floor::find($user->floor_no);

        // return response()->json([
        //     'user' => $user,
        //     'floor' => $floor
        // ]);
        return $email ? User::where('email', $email)->get() : User::all();
    }

    /**
     * Cập nhật vị trí của người dùng trong tầng.
     *
     * @param int $userId
     * @param Request $request
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $email)
    {
        // Validate thông tin từ request
        $request->validate([
            'floor_no' => 'nullable|exists:floors,floor_no',  // Kiểm tra nếu tầng tồn tại
        ]);

        // Tìm người dùng dựa trên email
        $user = User::where('email', $email)->first();

        // Nếu không tìm thấy người dùng
        if (!$user) {
            return response()->json([
                'message' => 'User not found',
            ], 404);
        }

        // Nếu người dùng chưa có tầng nào, thì cập nhật
        if (!$user->floor_no) {
            $user->floor_no = $request->floor_no;
            $user->save();

            return response()->json([
                'message' => 'User has been assigned to a floor',
                'user' => $user,
            ]);
        }

        // Nếu người dùng đã có tầng, cập nhật lại vị trí
        $user->floor_no = $request->floor_no;
        $user->save();

        return response()->json([
            'message' => 'User location updated successfully',
            'user' => $user,
        ]);
    }
}