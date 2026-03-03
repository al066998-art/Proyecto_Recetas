<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller {

    // GET /api/categories — público
    public function index() {
        return response()->json(Category::all());
    }

    // POST /api/categories — requiere auth
    public function store(Request $request) {
        $request->validate(['name' => 'required|string']);

        $category = Category::create([
            'name'    => $request->name,
            'user_id' => $request->user()->id,
        ]);

        return response()->json($category, 201);
    }

    // DELETE /api/categories/{id} — solo el dueño
    public function destroy(Request $request, $id) {
        $category = Category::where('id', $id)->where('user_id', $request->user()->id)->firstOrFail();
        $category->delete();
        return response()->json(['message' => 'Categoría eliminada']);
    }
}