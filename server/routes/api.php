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

Route::get('/teams/{team_no?}', [TeamController::class, 'index']);
Route::get('/teams/events/{id}', [TeamController::class, 'getTeamsByEventId']);
Route::get('/teams/image/{filename}', [TeamController::class, 'getImage']);
Route::post('/teams/update-image/{team_no}', [TeamController::class, 'updateTeamImage']);
Route::get('/teams/getRank/{team_no}/{event_id}', [TeamController::class, 'getRank']);

Route::post('/floors/{floor_no}', [FloorController::class, 'store']);
Route::get('/floors/getFloorTeamCount/{event_id}', [FloorController::class, 'getFloorTeamCount']);

Route::get('/user/location/{email?}', [UserLocationController::class, 'show']);
Route::put('/user/location/{email}', [UserLocationController::class, 'update']);

Route::get('/memberfileimages/{team_no?}', [MemberimagesController::class, 'index']);
Route::post('/memberfileimages/update-image/{team_no}', [MemberimagesController::class, 'updateTeamImage']);
Route::get('/memberfileimages/memberfileimages/{filename}', [MemberimagesController::class, 'getImage']);

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
    Route::post('/', [OverviewController::class, 'store']);

    // Cập nhật comment theo team_no và id của comment
    Route::put('/{team_no}', [OverviewController::class, 'update']);
});

Route::prefix('favorite')->group(function () {
    // Lấy danh sách các comment, có thể lọc theo team_no
    Route::get('/{user_email?}', [FavoriteController::class, 'index']);

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

    Route::put('/{id}', [EventController::class, 'update']);
    Route::post('/updateTeamImage/{id}', [EventController::class, 'updateTeamImage']);
    Route::get('/eventimages/{filename}', [EventController::class, 'getImage']);
    // Route::get('/{eventName}', [EventController::class, 'getFirstImageByEventName']);

    // Cập nhật comment theo team_no và id của comment
    Route::delete('/{id}', [EventController::class, 'destroy']);
});
Route::prefix('eventsmanage')->group(function () {

    Route::get('/', [EventManageController::class, 'index']);
    Route::post('/', [EventManageController::class, 'store']);
    // Route::put('/{id}', [EventController::class, 'update']);
    Route::delete('/{team_no}/{event_id}', [EventManageController::class, 'destroy']);
});

// Route::get('/overview/{team_no?}', [OverviewController::class, 'index']);