-- ============================================================
-- SISACT / Colibrí Print México
-- Dashboard Intelligence V1
-- Migración opcional: módulo de egresos
-- ============================================================
--
-- SEGURIDAD:
-- - Crea una tabla nueva: cp_expenses.
-- - NO altera tablas existentes.
-- - NO cambia conexiones ni configuración.
-- - Puede ejecutarse antes o después de reemplazar dashboard.php.
-- - dashboard.php detecta automáticamente si la tabla existe.
--

CREATE TABLE IF NOT EXISTS `cp_expenses` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `expense_date` date NOT NULL,
  `due_date` date DEFAULT NULL,
  `category` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Otros',
  `supplier` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(15,2) NOT NULL DEFAULT '0.00',
  `payment_method` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'other',
  `reference` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receipt_reference` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'paid',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cp_expenses_date` (`expense_date`),
  KEY `idx_cp_expenses_due_date` (`due_date`),
  KEY `idx_cp_expenses_status` (`status`),
  KEY `idx_cp_expenses_category` (`category`),
  KEY `idx_cp_expenses_order` (`order_id`),
  KEY `idx_cp_expenses_created_by` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
