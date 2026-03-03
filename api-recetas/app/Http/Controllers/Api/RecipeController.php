<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Recipe;
use App\Models\RecipeImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB; // Para transacciones seguras

class RecipeController extends Controller {

    // GET /api/recipes — Público, con filtros y carga de relaciones
    public function index(Request $request) {
        $query = Recipe::with(['user:id,name', 'categories:id,name', 'images'])
            ->where('status', 'Publicada');

        if ($request->keyword) {
            $query->where('title', 'like', "%{$request->keyword}%");
        }
        if ($request->user_id) {
            $query->where('user_id', $request->user_id);
        }
        if ($request->category_id) {
            $query->whereHas('categories', fn($q) => $q->where('categories.id', $request->category_id));
        }

        return response()->json($query->latest()->paginate(10));
    }

    // GET /api/recipes/{id} — Detalle completo con reseñas
public function show($id) {
    $recipe = Recipe::with([
        'user:id,name', 
        'categories:id,name', 
        'images', 
        'reviews.user:id,name'
    ])->findOrFail($id);

    return response()->json($recipe);
}

    // POST /api/recipes — Crear con validación y subida de imagen
public function store(Request $request) {
    try {
        $request->validate([
            'title'        => 'required|string|max:255',
            'instructions' => 'required|string',
            'category_id'  => 'nullable|exists:categories,id',
            'new_category' => 'nullable|string|max:50',
            'images'       => 'required|image|mimes:jpg,jpeg,png|max:2048', 
        ]);

        return DB::transaction(function () use ($request) {
            // 1. Crear receta (SIN category_id aquí, va en la tabla pivote)
            $recipe = Recipe::create([
                'title'        => $request->title,
                'instructions' => $request->instructions,
                'status'       => 'Publicada',
                'user_id'      => $request->user()->id,
            ]);

            // 2. Vincular Categoría (Tabla recipe_category de tus fotos)
            if ($request->filled('new_category')) {
                // Buscamos si ya existe la categoría por nombre
                $category = \App\Models\Category::where('name', $request->new_category)->first();

                // Si no existe, la creamos asignando el user_id manualmente
                if (!$category) {
                    $category = \App\Models\Category::create([
                        'name' => $request->new_category,
                        'user_id' => $request->user()->id // Cumplimos con la restricción de tu migración
                    ]);
                }
                
                $recipe->categories()->sync([$category->id]);
            }

            // 3. Imagen
            if ($request->hasFile('images')) {
                $path = $request->file('images')->store('recipes', 'public');
                $recipe->images()->create([
                    'image_path' => $path,
                    'is_main'    => true
                ]);
                $recipe->update(['main_image' => $path]);
            }

            return response()->json($recipe->load(['categories', 'images']), 201);
        });
    } catch (\Exception $e) {
        // Esto enviará el error real al log de Laravel
        return response()->json(['error' => $e->getMessage()], 500);
    }
}

    // PUT /api/recipes/{id} — Actualizar (Solo el dueño)
public function update(Request $request, $id) {
    $recipe = Recipe::where('id', $id)->where('user_id', $request->user()->id)->firstOrFail();

    $request->validate([
        'title'        => 'sometimes|required|string|max:255',
        'instructions' => 'sometimes|required|string',
        'category_id'  => 'nullable|exists:categories,id',
        'new_category' => 'nullable|string|max:50',
        'images'       => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
    ]);

    return DB::transaction(function () use ($request, $recipe) {
        $recipe->update($request->only(['title', 'instructions', 'status']));

        // ACTUALIZAR CATEGORÍA EN EDICIÓN
        if ($request->new_category) {
            $category = \App\Models\Category::firstOrCreate(['name' => $request->new_category]);
            $recipe->categories()->sync([$category->id]);
        } elseif ($request->has('category_id')) {
            // El sync con array vacío [] quita la categoría si mandan null
            $recipe->categories()->sync($request->category_id ? [$request->category_id] : []);
        }

        if ($request->hasFile('images')) {
            $file = $request->file('images');
            $path = $file->store('recipes', 'public');

            RecipeImage::create([
                'recipe_id'  => $recipe->id, 
                'image_path' => $path,
                'is_main'    => true
            ]);

            $recipe->update(['main_image' => $path]);
        }

        return response()->json($recipe->load(['categories', 'images']));
    });
}

    // DELETE /api/recipes/{id}
    public function destroy(Request $request, $id) {
        $recipe = Recipe::where('id', $id)->where('user_id', $request->user()->id)->firstOrFail();
        
        // Opcional: Borrar archivos físicos del storage antes de borrar la BD
        foreach($recipe->images as $img) {
            Storage::disk('public')->delete($img->image_path);
        }
        
        $recipe->delete();
        return response()->json(['message' => 'Receta y fotos eliminadas correctamente']);
    }

    // GET /api/my-recipes
    public function myRecipes(Request $request) {
        $recipes = Recipe::with(['categories:id,name', 'images'])
            ->where('user_id', $request->user()->id)
            ->latest()
            ->paginate(10);

        return response()->json($recipes);
    }
}