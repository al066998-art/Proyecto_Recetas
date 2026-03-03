<?php
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\RecipeController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\ReviewController;
use Illuminate\Support\Facades\Route;

// Auth
Route::post('/register', [AuthController::class, 'register'])->name('api.register');
Route::post('/login',    [AuthController::class, 'login'])->name('api.login');

// Públicas (No requieren Token)
Route::get('/recipes',           [RecipeController::class, 'index']);
Route::get('/recipes/{id}',      [RecipeController::class, 'show']);
Route::get('/categories',        [CategoryController::class, 'index']);
Route::post('/recipes/{id}/reviews', [ReviewController::class, 'store'])->middleware('api');

// Protegidas (Stateless con Sanctum)
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);

    // Rutas de Recetas
    Route::get('/my-recipes',                 [RecipeController::class, 'myRecipes']);
    Route::post('/recipes',                  [RecipeController::class, 'store']);
    Route::put('/recipes/{id}',               [RecipeController::class, 'update']);
    Route::delete('/recipes/{id}',            [RecipeController::class, 'destroy']);
    Route::post('/recipes/{id}/images',       [RecipeController::class, 'addImages']);
    Route::patch('/recipes/{id}/main-image',  [RecipeController::class, 'setMainImage']);

    // Rutas de Categorías
    Route::post('/categories',        [CategoryController::class, 'store']);
    Route::delete('/categories/{id}', [CategoryController::class, 'destroy']);
});