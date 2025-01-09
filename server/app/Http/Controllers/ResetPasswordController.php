<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log; // Thêm để sử dụng Log
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Password;
class ResetPasswordController extends Controller
{
    //
    public function resetApp(Request $request)
{
    // Kiểm tra email từ request
    $request->validate([
        'email' => 'required|email',
    ]);

    // Gửi yêu cầu reset mật khẩu
    $response = Password::broker()->sendResetLink($request->only('email'));

    if ($response == Password::RESET_LINK_SENT) {
        Log::info('Email sent successfully');
        return response()->json(['message' => 'Reset link sent successfully'], 200);
    } else {
        Log::error('Failed to send reset link', ['response' => $response]);
        return response()->json(['message' => 'Unable to send reset link'], 400);
    }

}
public function resetPassword(Request $request)
{
    // Validate request
    $request->validate([
        'token' => 'required',
        'email' => 'required|email',
        'password' => 'required|confirmed|min:8',
    ]);

    // Đổi mật khẩu
    $response = Password::reset(
        $request->only('email', 'password', 'password_confirmation', 'token'),
        function ($user, $password) {
            $user->forceFill([
                'password' => Hash::make($password)
            ])->save();
        }
    );

    // Kiểm tra kết quả reset mật khẩu
    if ($response == Password::PASSWORD_RESET) {
        return response()->json(['message' => 'Password has been successfully changed'], 200);
    }

    return response()->json(['message' => 'Failed to reset password'], 400);
}

}