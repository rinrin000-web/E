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
        if ($team_no) {
            // Lọc theo team_no
            return Memberimages::where('team_no', $team_no)->get();
        } else {
            // Lấy tất cả bản ghi
            return Memberimages::all();
        }
    }




    public function getImage($filename)
{


    $path = storage_path('app/public/memberfileimages/' . $filename);

    if (!file_exists($path)) {
        return response()->json(['message' => 'Image not found'], 404);
    }

    return response()->file($path);
}
public function update(Request $request, $id)
{
    // Xác thực đầu vào
    $request->validate([
        'memberfileimages' => 'required|image|mimes:jpg,jpeg,png|max:2048',
    ]);

    // Tìm bản ghi ảnh theo ID
    $memberImage = Memberimages::find($id);

    if (!$memberImage) {
        return response()->json(['message' => 'Image not found'], 404);
    }

    // Nếu ảnh cũ tồn tại, xóa nó khỏi storage
    $oldFilePath = storage_path('app/' . $memberImage->memberfileimages);
    if (file_exists($oldFilePath)) {
        unlink($oldFilePath);
    }

    // Lưu ảnh mới vào storage
    if ($request->hasFile('memberfileimages')) {
        $file = $request->file('memberfileimages');
        $fileName = $file->store('memberfileimages');

        // Cập nhật đường dẫn ảnh mới vào cơ sở dữ liệu
        $memberImage->memberfileimages = $fileName;
        $memberImage->save();

        return response()->json([
            'message' => 'Image updated successfully',
            'image' => $memberImage,
        ], 200);
    }

    return response()->json(['message' => 'No image uploaded'], 400);
}

public function destroy($id)
{
    // Tìm ảnh theo ID
    $memberImage = Memberimages::find($id);

    if (!$memberImage) {
        return response()->json(['message' => 'Image not found'], 404);
    }

    // Lấy đường dẫn file
    $filePath = storage_path('app/' . $memberImage->memberfileimages);

    // Xóa file từ storage nếu tồn tại
    if (file_exists($filePath)) {
        unlink($filePath);
    }

    // Xóa bản ghi trong database
    $memberImage->delete();

    return response()->json(['message' => 'Image deleted successfully'], 200);
}



}
