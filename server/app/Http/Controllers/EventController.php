<?php

namespace App\Http\Controllers;

use App\Models\Event;
use App\Models\Eventsmange;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class EventController extends Controller
{
    // Lấy danh sách tất cả sự kiện
    public function index()
    {
        return response()->json(Event::all(), 200, [], JSON_PRETTY_PRINT);
    }

    // Tạo mới một sự kiện
    public function store(Request $request)
    {
        $request->validate([
            'event_name' => 'required|string|max:255',
            'event_date' => 'required|date',
            'images' => 'nullable|file|mimes:jpeg,png,jpg,gif|max:2048',
            // 'team_no' => 'required|string|exists:teams,team_no', // Đảm bảo team_no tồn tại trong bảng teams
        ]);

        // Lưu ảnh nếu có
        $imagePath = null;
        if ($request->hasFile('images')) {
            $file = $request->file('images');
            $fileName = $request->event_name . '_' . time() . '_' . uniqid() . '.' . $file->getClientOriginalExtension();
            $imagePath = $file->storeAs('eventimages', $fileName, 'public');
        }

        // Tạo sự kiện mới
        $event = Event::create([
            'event_name' => $request->event_name,
            'event_description' => $request->event_description ?? null,
            'event_date' => $request->event_date,
            'images' => $imagePath,
        ]);

        // Liên kết sự kiện với team_no trong bảng eventsmange
        // $emanage = Eventsmange::create([
        //     'event_id' => $event->id, // Liên kết với ID sự kiện
        //     'team_no' => $request->team_no, // Liên kết với team
        // ]);

        return response()->json([
            'event' => $event,
            // 'eventsmange' => $emanage,
        ], 201);
    }

    public function update(Request $request, $eventId)
{
    $request->validate([
        'event_name' => 'nullable|string|max:255',
        'event_date' => 'nullable|date',
        'images' => 'nullable|file|mimes:jpeg,png,jpg,gif|max:2048',
    ]);

    $event = Event::where('id', $eventId)->first();

    if (!$event) {
        return response()->json(['message' => 'Event not found'], 404);
    }

    // Khởi tạo mảng chứa dữ liệu cần cập nhật
    $dataToUpdate = [];

    // Kiểm tra và thêm các trường cần cập nhật
    if ($request->has('event_name')) {
        $dataToUpdate['event_name'] = $request->event_name;
    }

    if ($request->has('event_date')) {
        $dataToUpdate['event_date'] = $request->event_date;
    }

    if ($request->hasFile('images')) {
        // Xóa ảnh cũ nếu có
        if ($event->images) {
            Storage::disk('public')->delete($event->images);
        }

        // Lưu ảnh mới
        $file = $request->file('images');
        $imagePath = $file->store('eventimages', 'public');
        $dataToUpdate['images'] = $imagePath;
    }

    // Cập nhật bản ghi
    $event->update($dataToUpdate);

    return response()->json($event);
}

    // public function update(Request $request,$id)
    // {
    //     $events = Event::find($id);
    //     $events->update($request->all());
    //     return response()->json($events);
    // }


    // Cập nhật ảnh theo event_name
    // public function updateTeamImage(Request $request, $id)
    // {
    //     $request->validate([
    //         'images' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',  // Xác thực file ảnh
    //     ]);

    //     // Tìm sự kiện theo event_name
    //     $event = Event::where('id', $id)->first();

    //     if (!$event) {
    //         return response()->json(['message' => 'Event not found'], 404);
    //     }

    //     // Xử lý upload ảnh (nếu có)
    //     if ($request->hasFile('images')) {
    //         $file = $request->file('images');
    //         // $fileName = $eventName . '_' . time() . '_' . uniqid() . '.' . $file->getClientOriginalExtension();
    //         $imagePath = $file->store('eventimages');

    //         // Xóa ảnh cũ nếu có
    //         if ($event->images) {
    //             Storage::disk('public')->delete($event->images);
    //         }

    //         $event->images = $imagePath;
    //         $event->save();

    //         return response()->json(['message' => 'Image updated successfully', 'event' => $event], 200);
    //     } else {
    //         return response()->json(['message' => 'No image uploaded'], 400);
    //     }
    // }

    // Lấy ảnh theo tên file
    public function getImage($filename)
    {
        $path = storage_path('app/public/eventimages/' . $filename);

        if (!file_exists($path)) {
            return response()->json(['message' => 'Image not found'], 404);
        }

        return response()->file($path);
    }




    // Xóa sự kiện
    public function destroy($eventId)
    {
        $event = Event::where('id', $eventId)->first();

        if (!$event) {
            return response()->json(['message' => 'Event not found'], 404);
        }

        // Xóa ảnh nếu có
        if ($event->images) {
            Storage::disk('public')->delete($event->images);
        }

        $event->delete();

        return response()->json(['message' => 'Event deleted successfully', 'data' => $event], 200);
    }
}