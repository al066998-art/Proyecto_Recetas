<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Review;
use App\Models\Recipe;
use Illuminate\Http\Request;

class ReviewController extends Controller {

public function store(Request $request, $id) {
        // 1. Validar que la receta existe
        $recipe = Recipe::findOrFail($id);

        // 2. Validaciones profesionales
        $request->validate([
            'rating'  => 'required|integer|min:1|max:5',
            'comment' => 'required|string|max:1000', 
        ]);

        // 3. Lógica de Identificación Dinámica
        // Intentamos obtener al usuario. Si es invitado, $user será null.
        $user = $request->user();
        $userId = $user ? $user->id : null;

        // 4. Verificar duplicados SOLO para usuarios registrados
        // Esto permite que el profesor o invitados evalúen sin ser bloqueados por falta de ID.
        if ($userId) {
            $exists = Review::where('recipe_id', $id)
                            ->where('user_id', $userId)
                            ->exists();

            if ($exists) {
                return response()->json(['message' => 'Ya has dejado una reseña para esta receta.'], 403);
            }
        }

        // 5. Crear la reseña vinculada (user_id será null si es invitado)
        $review = Review::create([
            'recipe_id' => $id,
            'user_id'   => $userId, 
            'rating'    => $request->rating,
            'comment'   => $request->comment,
        ]);

        return response()->json([
            'message' => 'Reseña guardada con éxito',
            // Cargamos la relación del usuario (si es invitado, el nombre saldrá como nulo en el JSON)
            'review'  => $review->load('user:id,name') 
        ], 201);
    }
}