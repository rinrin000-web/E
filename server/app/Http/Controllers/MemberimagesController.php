<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Memberimages;

class MemberimagesController extends Controller
{
    //
    //
    public function updateTeamImage(Request $request, $team_no)
{
    $request->validate([
        'memberfileimages' => 'required|image|mimes:jpg,jpeg,png|max:2048',
    ]);

    if ($request->hasFile('memberfileimages')) {
        $file = $request->file('memberfileimages');
        $fileName = $file->store('memberfileimages');

        $memberImage = new Memberimages();
        $memberImage->team_no = $team_no;
        $memberImage->memberfileimages = $fileName;
        $memberImage->save();

        return response()->json(['message' => 'Image uploaded successfully', 'image' => $memberImage], 201);
    } else {
        return response()->json(['message' => 'No image uploaded'], 400);
    }
}




    // Hiển thị danh sách các team
    public function index($team_no = null)
{
    return $team_no ? Memberimages::find('team_no') : Memberimages::all();
}



    public function getImage($filename)
{


    $path = storage_path('app/public/memberfileimages/' . $filename);

    if (!file_exists($path)) {
        return response()->json(['message' => 'Image not found'], 404);
    }

    return response()->file($path);
}


}