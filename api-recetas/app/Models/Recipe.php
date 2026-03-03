<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Recipe extends Model {
    protected $fillable = [
        'title', 
        'instructions', 
        'status', 
        'main_image', 
        'user_id'
    ];

    public function user() {
        return $this->belongsTo(User::class);
    }

    public function categories() {
        
        return $this->belongsToMany(Category::class, 'recipe_category');
    }

    public function images() {
        return $this->hasMany(RecipeImage::class);
    }

    public function reviews() {
        return $this->hasMany(Review::class);
    }
}