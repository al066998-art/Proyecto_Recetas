# 🍳 Recetas Gourmet - Proyecto Final UAC

Sistema integral de gestión de recetas culinarias desarrollado como proyecto académico para la **Universidad Autónoma de Campeche**. La plataforma permite a los usuarios explorar, crear y calificar delicias gastronómicas en un entorno moderno y eficiente.

---

## 🚀 Funcionalidades Principales

* **🔐 Autenticación Segura**: Registro e inicio de sesión gestionado con **Laravel Sanctum**.
* **📖 Catálogo Público**: Visualización de recetas abierta para todo público (invitados y registrados).
* **📂 Categorización Inteligente**: Filtro por categorías dinámicas (Postres, Mariscos, etc.) y búsqueda por título en tiempo real.
* **➕ Creación Dinámica**: Los autores pueden definir nuevas categorías al momento de publicar su platillo.
* **⭐ Comunidad**: Sistema de reseñas y calificaciones (1-5 estrellas) para fomentar la interacción.
* **🖼️ Gestión Multimedia**: Carga y almacenamiento de imágenes en el servidor para cada receta.

---

## 🛠️ Stack Tecnológico

| Componente | Tecnología |
| :--- | :--- |
| **Backend** | Laravel 11 (API REST) |
| **Frontend** | Vue.js 3 + Vite |
| **Base de Datos** | MySQL / MariaDB |
| **Autenticación** | Laravel Sanctum |

---

## 🛣️ Documentación de Endpoints (API)

De acuerdo con la rúbrica de evaluación, se detallan las rutas principales que permiten la integración entre el Backend y el Frontend:

### 🔓 Rutas Públicas
| Método | Endpoint | Descripción |
| :--- | :--- | :--- |
| **GET** | `/api/recipes` | Obtiene el listado de recetas con filtros. |
| **GET** | `/api/recipes/{id}` | Detalle de una receta con autor y reseñas. |
| **POST** | `/api/login` | Autentica usuarios y devuelve el Token. |

### 🔐 Rutas Protegidas (Requieren Token)
| Método | Endpoint | Descripción |
| :--- | :--- | :--- |
| **POST** | `/api/recipes` | Crea una receta con imagen y categorías. |
| **PUT** | `/api/recipes/{id}` | Actualización de contenido (Solo autores). |
| **POST** | `/api/recipes/{id}/reviews` | Publica una reseña y calificación. |

---

## 📊 Arquitectura de Datos

El sistema utiliza una base de datos relacional. El diagrama de relaciones se presenta a continuación:

[Image of an Entity-Relationship Diagram showing users, recipes, and categories with many-to-many relationships]

* **Users**: Gestiona la información de los autores.
* **Recipes**: Almacena instrucciones y estado de las recetas.
* **Categories**: Permite la clasificación lógica del contenido.
* **Recipe_Category**: Tabla pivote para la relación Muchos a Muchos entre recetas y categorías.

---

## ⚙️ Instalación y Configuración

### Backend (Laravel)
1.  Clonar repositorio.
2.  Ejecutar `composer install`.
3.  Configurar archivo `.env` con credenciales de base de datos.
4.  Ejecutar `php artisan migrate`.
5.  Lanzar servidor: `php artisan serve`.

### Frontend (Vue)
1.  Entrar a la carpeta `frontend-recetas`.
2.  Ejecutar `npm install`.
3.  Lanzar aplicación: `npm run dev`.

---

## ✒️ Autores
* **Rafael** - *Desarrollador Full Stack*
* **Oziel** - *Desarrollador Backend*