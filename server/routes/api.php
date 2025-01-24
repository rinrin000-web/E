<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\TeamController;
use App\Http\Controllers\FloorController;
use App\Http\Controllers\MemberimagesController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\OverviewController;
use App\Http\Controllers\UserLocationController;
use App\Http\Controllers\FavoriteController;
use App\Http\Controllers\EventController;
use App\Http\Controllers\EventManageController;
use App\Http\Controllers\ResetPasswordController;
use Illuminate\Support\Facades\Mail;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });
Route::post('login', [UserController::class, 'login'])->name('login');
Route::get('login', [UserController::class, 'login'])->name('login');
Route::post('signup', [UserController::class, 'signup']);
Route::get('signup', [UserController::class, 'signup']);
Route::get('logout', [UserController::class, 'logout']);
// routes/api.php
// Route::post('/password/reset', 'Auth\ResetPasswordController@resetApp');
Route::post('/password/reset', [ResetPasswordController::class, 'resetApp'])->name('password.reset');
Route::put('/password/update', [ResetPasswordController::class, 'resetPassword']);
Route::post('/send-email', function (Request $request) {
    $details = [
        'title' => $request->input('title'),
        'body' => $request->input('body'),
    ];

    $recipient = $request->input('email');

    try {
        Mail::to($recipient)->send(new \App\Mail\TestMail($details));
        return response()->json(['message' => 'Email sent successfully!'], 200);
    } catch (\Exception $e) {
        return response()->json(['message' => 'Failed to send email', 'error' => $e->getMessage()], 500);
    }
});
// admin権限のあるユーザの操作
Route::middleware('auth:api', 'admin_auth')->group(function(){
    Route::get('/admin', function(){
        return 'you are admin user!';
    });
});

// user権限、admin権限のあるユーザの操作
Route::middleware('auth:api')->group(function(){
    Route::get('/user', function(){
        return 'you are member user!';
    });
});
Route::get('/user/user', [UserController::class, 'index']);


Route::prefix('teams')->group(function () {
    // Route::get('{team_no?}', [TeamController::class, 'index']);
    Route::get('events/{id}', [TeamController::class, 'getTeamsByEventId']);
    Route::get('teamfileimages/{filename}', [TeamController::class, 'getImage']);
    // Route::post('update-image/{team_no}', [TeamController::class, 'updateTeamImage']);
    Route::post('/{eventId}', [TeamController::class, 'store']);
    Route::post('update-image/{event_id}/{team_no}', [TeamController::class, 'update']);
    Route::get('getRank/{team_no}/{event_id}', [TeamController::class, 'getRank']);
    Route::delete('/{team_no}', [TeamController::class, 'destroy']);
});
Route::prefix('floors')->group(function () {
    Route::get('/{event_id}', [FloorController::class, 'index']);
    Route::post('/{event_id}', [FloorController::class, 'store']);
    Route::post('/{floor_no}/{event_id}', [FloorController::class, 'update']);
    Route::post('/reset/reset/{event_id}', [FloorController::class, 'resetFakeUserCount']);
    Route::post('/updateUserCount/{floor_no}/{event_id}', [FloorController::class, 'updateUserCount']);
    Route::delete('/{floor_no}/{event_id}', [FloorController::class, 'destroy']);
    Route::get('/getFloorTeamCount/{event_id}', [FloorController::class, 'getFloorTeamCount']);

});

Route::get('/user/location/{email?}', [UserLocationController::class, 'show']);
Route::put('/user/location/{email}', [UserLocationController::class, 'update']);

Route::prefix('memberfileimages')->group(function () {
    Route::get('{team_no?}', [MemberimagesController::class, 'index']);
    Route::delete('/{id}', [MemberimagesController::class, 'destroy']);
    Route::post('/update-image/{team_no}', [MemberimagesController::class, 'updateTeamImage']);
    Route::post('{id}', [MemberimagesController::class, 'update']);
    Route::get('/memberfileimages/{filename}', [MemberimagesController::class, 'getImage']);
});

// Route::get('/comment/{team_no?}', [CommentController::class, 'index']);
// Route::post('/comment/addComment/{team_no}', [CommentController::class, 'addComment']);
// Route::put('/comment/updateComment/{team_no}', [CommentController::class, 'updateComment']);
Route::prefix('comments')->group(function () {
    // Lấy danh sách các comment, có thể lọc theo team_no
    Route::get('/{team_no?}', [CommentController::class, 'index']);

    // Tạo mới comment
    Route::post('/', [CommentController::class, 'store']);

    // Lấy chi tiết một comment
    Route::get('/user/{team_no}/{comment_user}', [CommentController::class, 'show']);
    // Route::get('/getHistory/{user}', [CommentController::class, 'getHistory']);

    // Cập nhật comment theo team_no và id của comment
    Route::put('/{team_no}/{comment_user}', [CommentController::class, 'update']);

    // Xóa comment theo team_no và id của comment
    Route::delete('/{team_no}/{comment_user}', [CommentController::class, 'destroy']);
});

Route::prefix('overviews')->group(function () {
    // Lấy danh sách các comment, có thể lọc theo team_no
    Route::get('/{team_no?}', [OverviewController::class, 'index']);
    // Tạo mới comment
    Route::post('/{team_no}', [OverviewController::class, 'store']);

    // Cập nhật comment theo team_no và id của comment
    Route::put('/{team_no}', [OverviewController::class, 'update']);
});

Route::prefix('favorite')->group(function () {
    // Lấy danh sách các comment, có thể lọc theo team_no
    Route::get('/{user_email}/{event_id}', [FavoriteController::class, 'index']);

    // Tạo mới comment
    Route::post('/', [FavoriteController::class, 'store']);

    // Cập nhật comment theo team_no và id của comment
    Route::delete('/{user_email}/{team_no}', [FavoriteController::class, 'destroy']);
});

Route::prefix('events')->group(function () {
    // Lấy danh sách các comment, có thể lọc theo team_no
    Route::get('/', [EventController::class, 'index']);

    // Tạo mới comment
    Route::post('/', [EventController::class, 'store']);

    Route::post('/{eventId}', [EventController::class, 'update']);
    // Route::post('/updateTeamImage/{id}', [EventController::class, 'updateTeamImage']);
    Route::get('/eventimages/{filename}', [EventController::class, 'getImage']);
    // Route::get('/{eventName}', [EventController::class, 'getFirstImageByEventName']);

    // Cập nhật comment theo team_no và id của comment
    Route::delete('/{eventId}', [EventController::class, 'destroy']);
});
Route::prefix('eventsmanage')->group(function () {

    Route::get('/', [EventManageController::class, 'index']);
    Route::post('/', [EventManageController::class, 'store']);
    // Route::put('/{id}', [EventController::class, 'update']);
    Route::delete('/{team_no}/{event_id}', [EventManageController::class, 'destroy']);
});

// Route::get('/overview/{team_no?}', [OverviewController::class, 'index']);
