<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Comment;

class CommentController extends Controller
{
     //一覧取得
    public function index($team_no = null)
    {
        return $team_no ? Comment::where('team_no', $team_no)->get() : Comment::all();
    }


     //新規作成
     public function store(Request $request)
{
    try {
        $validatedData = $request->validate([
            'team_no' => 'required|string',
            'comment_user' => 'required|string',
            'rank' => 'nullable|integer',
            'present' => 'nullable|integer',
            'plan' => 'nullable|integer',
            'design' => 'nullable|integer',
            'tech' => 'nullable|integer',
            'comment' => 'nullable|string|max:1000'
        ]);

        $comment = new Comment();
        $comment->fill($validatedData);
        $comment->save();

        return response()->json($comment, 201);
    } catch (\Exception $e) {
        return response()->json(['error' => $e->getMessage()], 500);
    }
}


     //1件取得

        // 1件取得
    public function show($team_no,$comment_user)
    {
        // Lấy tất cả bình luận của người dùng cho team_no cụ thể
        $comments = Comment::where('comment_user', $comment_user)
                            ->where('team_no', $team_no)
                            ->get();

        if ($comments->isEmpty()) {

            return response()->json(['message' => 'You have not rated this team yet. Please submit your comment.'], 404);
        }


        return response()->json($comments, 200);
    }
    public function getHistory(Request $request, $user)
{
    $comments = Comment::where('comment_user', $user)
        ->get()
        ->map(function ($comment) {
            $comment->commented_at = $comment->created_at->format('Y-m-d H:i:s'); // Định dạng thời gian
            return $comment;
        });

    if ($comments->isEmpty()) {
        return response()->json(['message' => 'No comments found for this user'], 404);
    }

    return response()->json($comments, 200);
}




     //更新
     public function update(Request $request,$team_no,$comment_user){
        // Tìm bình luận theo comment_user và team_no
        $comment = Comment::where('comment_user', $comment_user)
        ->where('team_no', $team_no)
        ->first();

        if (!$comment) {
            return response()->json(['message' => 'No comments found for this user in this team'], 404);
        }

        $validatedData = $request->validate([
            // 'comment_user' => 'required|string',
            'rank' => 'nullable|integer',
            'present' => 'nullable|integer',
            'plan' => 'nullable|integer',
            'design' => 'nullable|integer',
            'tech' => 'nullable|integer',
            'comment' => 'nullable|string|max:1000'
        ]);

        $comment->fill($validatedData);
        $comment->save();
        return response()->json($comment, 201);
      }

     //削除
     public function destroy($team_no,$comment_user){
        // $comment = Comment::where('comment_user', $comment_user)->first();
        $comments = Comment::where('team_no', $team_no)
        ->where('comment_user', $comment_user)
        ->get();

        if ($comments->isEmpty()) {
            return response()->json(['message' => 'No comments found for this user in this team'], 404);
        }

        foreach ($comments as $comment) {
        $comment->delete();
        }
        return response()->json(['message' => 'Comment deleted successfully'], 200);
      }

}