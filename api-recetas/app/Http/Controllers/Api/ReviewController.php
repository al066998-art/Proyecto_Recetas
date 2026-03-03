<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller {

    // POST /api/recipes/{id}/reviews — público (sin auth)
    public function store(Request $request, $id) {
        $request->validate([
            'author_name' => 'required|string',
            'rating'      => 'required|integer|min:1|max:5',
            'comment'     => 'nullable|string',
        ]);

        $review = Review::create([
            'recipe_id'   => $id,
            'author_name' => $request->author_name,
            'rating'      => $request->rating,
            'comment'     => $request->comment,
        ]);

        return response()->json($review, 201);
    }
}