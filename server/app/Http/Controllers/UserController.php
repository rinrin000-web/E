<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\PasswordReset;
use \Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log; // Thêm để sử dụng Log
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Password;
class UserController extends Controller
{


    public function index()
{
    return  User::all();
}

    public function login(Request $request) {

        $credentials = $request->only(['email', 'password']); // Lấy email và password từ request
        $guard = $request->guard;

        if(Auth::guard($guard)->attempt($credentials)) {

            $user_info = User::whereEmail($request->email)->first(); // Lấy email người dùng

            if (!$user_info) {
                return response()->json(['error' => 'User not found!'], Response::HTTP_UNAUTHORIZED);
            }

            $user_id = $user_info->user_id;
            $user = User::find($user_id);


            if ($user) {

                $user->api_token = Str::random(60);
                $user->save();

                return response()->json([
                    'token' => $user->api_token,
                    'user_id' => $user->user_id,
                    'email' => $user->email,
                ], Response::HTTP_OK);
            } else {
                return response()->json(['error' => 'User not found by ID!'], Response::HTTP_UNAUTHORIZED);
            }
        }

        return response()->json(['error' => 'Login failed! Invalid credentials.'], Response::HTTP_UNAUTHORIZED);
    }

    public function signup(Request $req){
        $rules = array(
            'email' => 'required|email|unique:users',
            "password" =>"required|min:6"
        );
        $validator = Validator::make($req->all(),$rules);
        if($validator ->fails())
        {
            return $validator->errors();
        }
        else
        {
            $user = User::create([
                'email' => $req->email,
                'password' => Hash::make($req->password),
                'is_admin' => 0,
            ]);
            $result=$user->save();

            if($result){
                return ["result" =>"User registered successfully!"];
            }
            else
            {
                return ["result" =>"operation failed"];
            }
        }
    }

    // public function logout()
    // {
    //     Auth::logout();
    //     return redirect()->route('login');
    // }
    public function logout(Request $request)
    {
        // Lấy người dùng đã xác thực qua token
        $user = User::where('api_token', $request->bearerToken())->first();

        if ($user) {
            // Xóa token trong cơ sở dữ liệu
            $user->api_token = null;
            $user->save();

            return response()->json(['message' => 'Logged out successfully.'], 200);
        }

        return response()->json(['error' => 'User not authenticated.'], 401);
    }
}