<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Recipe;
use App\Models\RecipeImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class RecipeController extends Controller {

    // GET /api/recipes — público, con filtros y paginación
    public function index(Request $request) {
        $query = Recipe::with(['user:id,name', 'categories:id,name', 'images'])
            ->where('status', 'published');

        if ($request->keyword) {
            $query->where('title', 'like', "%{$request->keyword}%");
        }
        if ($request->user_id) {
            $query->where('user_id', $request->user_id);
        }
        if ($request->category_id) {
            $query->whereHas('categories', fn($q) => $q->where('categories.id', $request->category_id));
        }
        if ($request->date) {
            $query->whereDate('created_at', $request->date);
        }

        return response()->json($query->latest()->paginate(10));
    }

    // GET /api/recipes/{id}
    public function show($id) {
        $recipe = Recipe::with(['user:id,name', 'categories:id,name', 'images', 'reviews'])->findOrFail($id);
        return response()->json($recipe);
    }

    // POST /api/recipes — requiere auth
    public function store(Request $request) {
        $request->validate([
            'title'        => 'required|string',
            'content'      => 'required',
            'status'       => 'in:published,draft',
            'category_ids' => 'array',
            'images'       => 'array',
            'images.*'     => 'image|max:2048',
        ]);

        $recipe = Recipe::create([
            'title'   => $request->title,
            'content' => $request->content,
            'status'  => $request->status ?? 'draft',
            'user_id' => $request->user()->id,
        ]);

        if ($request->category_ids) {
            $recipe->categories()->sync($request->category_ids);
        }

        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $index => $file) {
                $path = $file->store('recipes', 'public');
                $isMain = $index === 0;
                RecipeImage::create(['recipe_id' => $recipe->id, 'path' => $path, 'is_main' => $isMain]);
                if ($isMain) {
                    $recipe->update(['main_image' => $path]);
                }
            }
        }

        return response()->json($recipe->load(['categories', 'images']), 201);
    }

    // PUT /api/recipes/{id} — requiere auth + ser dueño
    public function update(Request $request, $id) {
        $recipe = Recipe::where('id', $id)->where('user_id', $request->user()->id)->firstOrFail();

        $recipe->update($request->only(['title', 'content', 'status']));

        if ($request->category_ids) {
            $recipe->categories()->sync($request->category_ids);
        }

        return response()->json($recipe->load(['categories', 'images']));
    }

    // DELETE /api/recipes/{id} — requiere auth + ser dueño
    public function destroy(Request $request, $id) {
        $recipe = Recipe::where('id', $id)->where('user_id', $request->user()->id)->firstOrFail();
        $recipe->delete();
        return response()->json(['message' => 'Receta eliminada']);
    }

    // POST /api/recipes/{id}/images — subir imágenes adicionales
    public function addImages(Request $request, $id) {
        $recipe = Recipe::where('id', $id)->where('user_id', $request->user()->id)->firstOrFail();

        $request->validate(['images' => 'required|array', 'images.*' => 'image|max:2048']);

        $uploaded = [];
        foreach ($request->file('images') as $file) {
            $path = $file->store('recipes', 'public');
            $uploaded[] = RecipeImage::create(['recipe_id' => $recipe->id, 'path' => $path, 'is_main' => false]);
        }

        return response()->json($uploaded, 201);
    }

    // PATCH /api/recipes/{id}/main-image — marcar imagen principal
    public function setMainImage(Request $request, $id) {
        $request->validate(['image_id' => 'required|exists:recipe_images,id']);

        $recipe = Recipe::where('id', $id)->where('user_id', $request->user()->id)->firstOrFail();

        RecipeImage::where('recipe_id', $recipe->id)->update(['is_main' => false]);
        $image = RecipeImage::find($request->image_id);
        $image->update(['is_main' => true]);
        $recipe->update(['main_image' => $image->path]);

        return response()->json(['message' => 'Imagen principal actualizada']);
    }

    // GET /api/my-recipes — recetas del usuario autenticado (draft + published)
    public function myRecipes(Request $request) {
        $recipes = Recipe::with(['categories:id,name', 'images'])
            ->where('user_id', $request->user()->id)
            ->latest()
            ->paginate(10);

        return response()->json($recipes);
    }
}