-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         8.4.3 - MySQL Community Server - GPL
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Volcando estructura para tabla proyecto_recetas.categories
CREATE TABLE IF NOT EXISTS `categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `categories_user_id_foreign` (`user_id`),
  CONSTRAINT `categories_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla proyecto_recetas.categories: ~1 rows (aproximadamente)
INSERT INTO `categories` (`id`, `name`, `user_id`, `created_at`, `updated_at`) VALUES
	(1, 'Postres', 1, '2026-03-03 14:11:55', '2026-03-03 14:11:55'),
	(2, 'Mariscos', 2, '2026-03-03 17:53:47', '2026-03-03 17:53:47');

-- Volcando estructura para tabla proyecto_recetas.migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla proyecto_recetas.migrations: ~1 rows (aproximadamente)
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '2014_10_12_000000_create_users_table', 1),
	(2, '2026_02_28_203809_create_personal_access_tokens_table', 1),
	(3, '2026_03_03_064525_create_categories_table', 1),
	(4, '2026_03_03_064532_create_recipes_table', 1),
	(5, '2026_03_03_064536_create_recipe_category_table', 1),
	(6, '2026_03_03_064541_create_recipe_images_table', 1),
	(7, '2026_03_03_064545_create_reviews_table', 1);

-- Volcando estructura para tabla proyecto_recetas.personal_access_tokens
CREATE TABLE IF NOT EXISTS `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla proyecto_recetas.personal_access_tokens: ~1 rows (aproximadamente)

-- Volcando estructura para tabla proyecto_recetas.recipes
CREATE TABLE IF NOT EXISTS `recipes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `instructions` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('Publicada','Borrador') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Borrador',
  `main_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `recipes_user_id_foreign` (`user_id`),
  CONSTRAINT `recipes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla proyecto_recetas.recipes: ~2 rows (aproximadamente)
INSERT INTO `recipes` (`id`, `title`, `instructions`, `status`, `main_image`, `user_id`, `created_at`, `updated_at`) VALUES
	(2, 'Pay de Queso', 'Mezclar ingredientes y hornear', 'Borrador', 'recipes/nzkAdk7NOJuL1oUkYXId5g0fNQ5ZAXx0y8ZFAcvY.jpg', 1, '2026-03-03 14:32:53', '2026-03-03 14:32:53'),
	(4, 'Pay de queso', 'El pay de queso clásico se elabora con una base de galletas Marías molidas y mantequilla, y un relleno cremoso de queso crema, leche condensada, leche evaporada, huevos y vainilla. Se hornea a 180°C durante 40-45 minutos hasta que esté firme y dorado. Es ideal refrigerarlo antes de servir.\r\nIngredientes Principales (para 1 pay grande):\r\nBase: 2 tubos de galletas Marías (aprox. 200-250g) y 180g de mantequilla sin sal derretida.\r\nRelleno: 1-2 barras de queso crema (190g - 200g c/u), 1 lata de leche condensada (La Lechera), 1 lata de leche evaporada (Carnation), 3-4 huevos, y 1 cucharadita de vainilla.\r\nPreparación:\r\nBase: Triturar las galletas y mezclarlas con la mantequilla derretida hasta formar una pasta. Presionar esta mezcla en el fondo y paredes de un molde para pay. Refrigerar 15-30 min.\r\nRelleno: Licuar el queso crema (a temperatura ambiente), la leche condensada, la leche evaporada, los huevos y la vainilla hasta obtener una mezcla suave y sin grumos.\r\nHorneado: Verter la mezcla en la base de galleta. Hornear a 180°C durante 40 a 50 minutos, o hasta que al insertar un palillo, este salga limpio.\r\nFinalizar: Dejar enfriar a temperatura ambiente y luego refrigerar por al menos 2 horas antes de desmoldar y servir.', 'Publicada', 'recipes/8HUNuY6cGBlR95KngKqu4N6gH3q0EosANWnb6RNd.jpg', 1, '2026-03-03 16:27:56', '2026-03-03 16:27:56'),
	(14, 'Camarones empanizados', 'Hacer unos camarones empanizados perfectos es más fácil de lo que parece si sigues el orden correcto. Aquí tienes la receta clásica paso a paso:\r\nIngredientes\r\nCamarones: 1/2 kg de camarón grande (limpios, sin cáscara y con o sin colita).\r\nPara el sazón: Sal, pimienta, ajo en polvo y opcionalmente páprika.\r\nEstaciones de empanizado:\r\nHarina: 1 taza de harina de trigo (puedes mezclarla con maicena para más firmeza).\r\nHuevo: 2 piezas batidas (algunos añaden un chorrito de leche o agua mineral para que sea más ligero).\r\nPan molido: 2 tazas de pan molido o Panko para un terminado extra crujiente.\r\nAceite: Suficiente para freír (vegetal o de cártamo).\r\nInstrucciones paso a paso\r\nPreparación: Lava y seca muy bien los camarones con papel absorbente; la humedad es el enemigo de un buen empanizado. Si prefieres, hazles un corte mariposa por el lomo para que luzcan más grandes.\r\nSazonado: Condimenta los camarones directamente con sal, pimienta y ajo en polvo.\r\nEl Sistema de las 3 Capas:\r\nPasa el camarón por la harina y sacude el exceso.\r\nSumérgelo en el huevo batido cubriéndolo por completo.\r\nCúbrelo con el pan molido, presionando ligeramente para que se adhiera bien.\r\nFritura: Calienta el aceite a fuego medio-alto (180°C aprox.). Fríe los camarones por tandas para no enfriar el aceite, durante 2 a 3 minutos o hasta que estén dorados uniformemente.\r\nEscurrido: Retira y coloca sobre papel absorbente para eliminar el exceso de grasa.', 'Publicada', 'recipes/I7U64Ys4HSK6PuV4X3Iotu4hFv89lri0jWq6EnAw.jpg', 2, '2026-03-03 17:53:47', '2026-03-03 17:53:47');

-- Volcando estructura para tabla proyecto_recetas.recipe_category
CREATE TABLE IF NOT EXISTS `recipe_category` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `recipe_id` bigint unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `recipe_category_recipe_id_foreign` (`recipe_id`),
  KEY `recipe_category_category_id_foreign` (`category_id`),
  CONSTRAINT `recipe_category_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recipe_category_recipe_id_foreign` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla proyecto_recetas.recipe_category: ~2 rows (aproximadamente)
INSERT INTO `recipe_category` (`id`, `recipe_id`, `category_id`, `created_at`, `updated_at`) VALUES
	(2, 2, 1, NULL, NULL),
	(3, 4, 1, NULL, NULL),
	(4, 14, 2, NULL, NULL);

-- Volcando estructura para tabla proyecto_recetas.recipe_images
CREATE TABLE IF NOT EXISTS `recipe_images` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `recipe_id` bigint unsigned NOT NULL,
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_main` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `recipe_images_recipe_id_foreign` (`recipe_id`),
  CONSTRAINT `recipe_images_recipe_id_foreign` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla proyecto_recetas.recipe_images: ~2 rows (aproximadamente)
INSERT INTO `recipe_images` (`id`, `recipe_id`, `image_path`, `is_main`, `created_at`, `updated_at`) VALUES
	(2, 2, 'recipes/nzkAdk7NOJuL1oUkYXId5g0fNQ5ZAXx0y8ZFAcvY.jpg', 1, '2026-03-03 14:32:53', '2026-03-03 14:32:53'),
	(4, 4, 'recipes/8HUNuY6cGBlR95KngKqu4N6gH3q0EosANWnb6RNd.jpg', 1, '2026-03-03 16:27:56', '2026-03-03 16:27:56'),
	(5, 14, 'recipes/I7U64Ys4HSK6PuV4X3Iotu4hFv89lri0jWq6EnAw.jpg', 1, '2026-03-03 17:53:47', '2026-03-03 17:53:47');

-- Volcando estructura para tabla proyecto_recetas.reviews
CREATE TABLE IF NOT EXISTS `reviews` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `recipe_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `rating` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reviews_recipe_id_foreign` (`recipe_id`),
  KEY `reviews_user_id_foreign` (`user_id`),
  CONSTRAINT `reviews_recipe_id_foreign` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla proyecto_recetas.reviews: ~0 rows (aproximadamente)
INSERT INTO `reviews` (`id`, `recipe_id`, `user_id`, `comment`, `rating`, `created_at`, `updated_at`) VALUES
	(1, 2, 1, '¡Ahora sí, el sistema de reseñas funciona perfecto!', 5, '2026-03-03 14:41:31', '2026-03-03 14:41:31'),
	(2, 4, 2, 'Me parece perfecta padrino', 5, '2026-03-03 16:51:44', '2026-03-03 16:51:44'),
	(3, 4, NULL, 'Siento que le falto mas datos', 4, '2026-03-03 17:02:43', '2026-03-03 17:02:43');

-- Volcando estructura para tabla proyecto_recetas.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla proyecto_recetas.users: ~1 rows (aproximadamente)
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
	(1, 'Rafael', 'rafa@ejemplo.com', NULL, '$2y$12$c1URYY.B2eGKogBXXpc0/eBHJnmXIBSVSD1VYFAKzrfUfm6zIExEu', NULL, '2026-03-03 14:11:18', '2026-03-03 14:11:18'),
	(2, 'Raziel', 'raziel@ejemplo.com', NULL, '$2y$12$0u4PCGKMED52HPC9PNeiHOx/EZN7IK5LZM9DshpebzXKY3EPZpkl.', NULL, '2026-03-03 16:30:28', '2026-03-03 16:30:28');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
