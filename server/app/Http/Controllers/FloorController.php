<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Floor;
use App\Models\User;

class FloorController extends Controller
{
    /**
     * Handle the incoming request.
     */
    public function store(Request $request, $floor_no)
    {
        // Validate dữ liệu từ yêu cầu API
        $request->validate([
            'contents' => 'required|string|max:255',
        ]);

         // Tìm bản ghi floor dựa trên floor_no
         $floor = Floor::where('floor_no', $floor_no)->first();

         // Kiểm tra xem floor có tồn tại không
         if (!$floor) {
             return response()->json([
                 'message' => 'Floor not found.'
             ], 404);
         }
        $floor->contents = $request->contents; // Gán nội dung từ API
        $floor->save(); // Lưu vào database

        // Trả về phản hồi JSON
        return response()->json([
            'message' => 'Floor content inserted successfully!',
            'data' => $floor,
        ], 201);
    }
    // public function index()
    // {
    //     $floor = Floor::all();
    //     return response()->json($floor);
    // }
    public function index()
    {
        $floors = Floor::all();

        foreach ($floors as $floor) {

            $floor->teamcount = $floor->teams()->count();
            $floor->userCount = $floor->users()->count();
        }

        return response()->json($floors);
    }

}
