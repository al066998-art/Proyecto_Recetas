<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens; 

class User extends Authenticatable {
    use HasApiTokens, HasFactory, Notifiable; // El trait HasApiTokens es vital

    protected $fillable = ['name', 'email', 'password'];
    protected $hidden = ['password', 'remember_token'];

    public function recipes() {
        return $this->hasMany(Recipe::class);
    }

    public function categories() {
        return $this->hasMany(Category::class);
    }
}