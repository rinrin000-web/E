<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Floor;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

use function Laravel\Prompts\select;

class UserLocationController extends Controller
{
    /**
     * Hiển thị thông tin vị trí người dùng.
     *
     * @param int $userId
     * @return \Illuminate\Http\Response
     */
    public function show()
    {

        return User::all();
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

    public function updateRole(Request $request)
{
    if (!$request->has('email')) {
        return response()->json(['message' => 'Email không được cung cấp'], 400);
    }
    $user = User::where('email', $request->email)->first();

    if (!$user) {
        return response()->json(['message' => 'Người dùng không tồn tại'], 404);
    }

    $user->is_admin = 1;
    $user->save(); // Lưu thay đổi vào cơ sở dữ liệu

    return response()->json([
        'message' => 'Cập nhật quyền thành công',
        'user' => $user,
    ]);
}

    public function deleteRole(Request $request)
    {

        if (!$request->has('email')) {
            return response()->json(['message' => 'Email không được cung cấp'], 400);
        }
        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json(['message' => 'Người dùng không tồn tại'], 404);
        }

        $user->is_admin = 0;
        $user->save(); // Lưu thay đổi vào cơ sở dữ liệu

        return response()->json([
            'message' => 'Cập nhật quyền thành công',
            'user' => $user,
        ]);
    }
    public function searchEmails(Request $request)
{
    $keyword = $request->input('keyword');

    // Tìm kiếm email phù hợp
    $emails = User::where('email', 'like', '%' . $keyword . '%')
        ->pluck('email'); // Chỉ lấy danh sách email

    return response()->json($emails);
}
    public function isAdmin(){
        $isAdmin = DB::select(
            "select email from users where is_admin = 1"
        );
        return response()->json([
            'isAdmin' => $isAdmin,
        ]);
    }
    public function isUser(){
        $isUser = DB::select(
            "select email from users where is_admin = 0"
        );
        return response()->json([
            'isUser' => $isUser,
        ]);
    }
}