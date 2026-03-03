# 🍳 Recetas Gourmet - Proyecto Final UAC

Sistema integral de gestión de recetas culinarias desarrollado como proyecto académico para la **Universidad Autónoma de Campeche**. La plataforma permite a los usuarios explorar, crear y calificar delicias gastronómicas en un entorno moderno y eficiente.

---

## 🚀 Funcionalidades Principales

* **🔐 Autenticación Segura**: Registro e inicio de sesión gestionado con **Laravel Sanctum**.
* **📖 Catálogo Público**: Visualización de recetas abierta para todo público (invitados y usuarios registrados).
* **📂 Categorización Inteligente**: Filtro por categorías dinámicas (Postres, Mariscos, etc.) y búsqueda por palabras clave en tiempo real.
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

## 📊 Arquitectura de Datos

El sistema utiliza una base de datos relacional con las siguientes entidades principales:



* **Users**: Gestiona la información de los autores.
* **Recipes**: Almacena el contenido, instrucciones y estado de las recetas.
* **Categories**: Permite la clasificación lógica del contenido.
* **Reviews**: Sistema de retroalimentación de la comunidad.
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

## ✒️ Autor
* **Rafael** - *Desarrollador Full Stack*
* **Oziel** - *Desarrollador Backend*