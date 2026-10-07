-- Colibrí Print: autorización pública de cotizaciones web
-- Ejecutar una sola vez sobre la base colibrip_abcsistema.

ALTER TABLE cp_quotes
  ADD COLUMN client_approved_at DATETIME NULL AFTER status,
  ADD COLUMN client_approval_ip VARCHAR(45) NULL AFTER client_approved_at;

-- El flujo web conserva el mismo request_token como enlace seguro de seguimiento.
-- No se crean tokens nuevos para la solicitud porque request_token ya es único.
