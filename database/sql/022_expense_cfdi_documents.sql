-- ============================================================
-- SISACT / Colibrí Print México
-- Control Administrativo + Egresos CFDI V1
-- Migración 022: expediente XML de egresos
-- ============================================================
--
-- SEGURIDAD:
-- - Crea UNA tabla nueva: cp_expense_documents.
-- - NO altera cp_expenses.
-- - NO modifica órdenes, pagos, facturación ni producción.
-- - UUID y SHA-256 son únicos para impedir doble registro del mismo CFDI.
--

CREATE TABLE IF NOT EXISTS `cp_expense_documents` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `expense_id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `xml_sha256` char(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `serie` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `folio` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `issued_at` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MXN',
  `tipo_comprobante` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `issuer_rfc` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `issuer_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receiver_rfc` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receiver_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtotal` decimal(15,2) NOT NULL DEFAULT '0.00',
  `tax` decimal(15,2) NOT NULL DEFAULT '0.00',
  `total` decimal(15,2) NOT NULL DEFAULT '0.00',
  `payment_form` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_method` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `xml_path` varchar(700) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_cp_expense_documents_uuid` (`uuid`),
  UNIQUE KEY `uq_cp_expense_documents_sha256` (`xml_sha256`),
  KEY `idx_cp_expense_documents_expense` (`expense_id`),
  KEY `idx_cp_expense_documents_issuer` (`issuer_rfc`),
  KEY `idx_cp_expense_documents_receiver` (`receiver_rfc`),
  KEY `idx_cp_expense_documents_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
