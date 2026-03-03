## 📌 Resumen de Endpoints

 Endpoints disponibles en la API
| Método  | Ruta                                      | Auth |
|---------|-------------------------------------------|------|
| POST    | /api/register                             | No   |
| POST    | /api/login                                | No   |
| POST    | /api/logout                               | Sí   |
| GET     | /api/recipes                              | No   |
| GET     | /api/recipes/{id}                         | No   |
| POST    | /api/recipes                              | Sí   |
| PUT     | /api/recipes/{id}                         | Sí   |
| DELETE  | /api/recipes/{id}                         | Sí   |
| POST    | /api/recipes/{id}/images                  | Sí   |
| PATCH   | /api/recipes/{id}/main-image              | Sí   |
| GET     | /api/my-recipes                           | Sí   |
| POST    | /api/recipes/{id}/reviews                 | No   |
| GET     | /api/categories                           | No   |
| POST    | /api/categories                           | Sí   |
| DELETE  | /api/categories/{id}                      | Sí   |

Para levantar la api

composer require laravel/sanctum
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

# Crear el storage link para imágenes
php artisan storage:link

# Correr migraciones
php artisan migrate

# Levantar servidor
php artisan serve