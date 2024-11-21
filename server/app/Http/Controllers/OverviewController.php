<?php

namespace App\Http\Controllers;


use Illuminate\Http\Request;
use App\Models\Overview;

class OverviewController extends Controller
{
    //
    public function index($team_no = null)
    {
        return $team_no ? Overview::where('team_no', $team_no)->get() : Overview::all();
    }

    //新規作成
    public function store(Request $request){
        $validatedData = $request->validate([
            'team_no'=>'required|string',
            'slogan' => 'nullable|string|max:1000',
            'overallplanning' => 'nullable|string|max:1000',
            'techused' => 'nullable|string|max:1000',
            'tools' => 'nullable|string|max:1000',
        ]);

        $overview = new Overview();
        $overview->fill($validatedData);
        $overview ->save();
        return response()->json($overview, 201);
    }
    public function update(Request $request,$team_no){

        $overview = Overview::where('team_no', $team_no)
        ->first();

        if (!$overview) {
            return response()->json(['message' => 'No overview found for this user in this team'], 404);
        }

        $validatedData = $request->validate([
            'slogan' => 'nullable|string|max:1000',
            'overallplanning' => 'nullable|string|max:1000',
            'techused' => 'nullable|string|max:1000',
            'tools' => 'nullable|string|max:1000',
        ]);

        $overview->fill($validatedData);
        $overview->save();
        return response()->json($overview, 201);
    }
}