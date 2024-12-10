<?php

namespace App\Http\Controllers;

use App\Models\Eventsmange;
use Illuminate\Http\Request;

class EventManageController extends Controller
{
    //
    public function index()
    {
        return response()->json(Eventsmange::all(),200,[], JSON_PRETTY_PRINT);
    }

    // Thêm đội vào sự kiện
    public function store(Request $request)
    {
        $request->validate([
            'team_no' => 'required|string|exists:teams,team_no',
            'event_id' => 'required|integer|exists:events,id',
        ]);

        $eventManage = Eventsmange::create([
            'team_no' => $request->team_no,
            'event_id' => $request->event_id,
        ]);

        return response()->json($eventManage, 201);
    }

    // Xóa đội khỏi sự kiện
    public function destroy($team_no, $event_id)
    {
        $eventManage = Eventsmange::where('team_no', $team_no)->where('event_id', $event_id)->first();

        if (!$eventManage) {
            return response()->json(['message' => 'Event manage not found'], 404);
        }

        $eventManage->delete();
        return response()->json(['message' => 'Team removed from event']);
    }
}