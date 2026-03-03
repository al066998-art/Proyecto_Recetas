<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RecipeImage extends Model {
    // Ajustado para coincidir con el nombre exacto en tu migración
    protected $fillable = ['recipe_id', 'image_path', 'is_main'];

    public function recipe() {
        return $this->belongsTo(Recipe::class);
    }
}