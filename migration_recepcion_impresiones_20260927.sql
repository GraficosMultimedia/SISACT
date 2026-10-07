-- Colibrí Print - mejoras de conservación/eliminación de trabajos de recepción
-- Ejecutar una sola vez sobre la base de datos actual.

ALTER TABLE cp_print_requests
  ADD COLUMN archive_status ENUM('active','archived') NOT NULL DEFAULT 'active' AFTER status,
  ADD COLUMN archived_at DATETIME NULL DEFAULT NULL AFTER archive_status,
  ADD COLUMN archived_by INT UNSIGNED NULL DEFAULT NULL AFTER archived_at;

UPDATE cp_print_requests
SET archive_status='active'
WHERE archive_status IS NULL OR archive_status='';

-- Índice para separar rápidamente recepción activa de historial.
ALTER TABLE cp_print_requests
  ADD KEY ix_cp_print_requests_archive_status (archive_status, status);
