-- SISACT · Flujo Web → Orden Formal V1
-- Preferir /admin/aplicar_flujo_web_orden_v1.php porque verifica
-- columna por columna antes de modificar.

ALTER TABLE cp_web_quote_requests
    ADD COLUMN converted_order_id BIGINT UNSIGNED NULL AFTER converted_at,
    ADD COLUMN converted_order_at DATETIME NULL AFTER converted_order_id;

CREATE TABLE cp_web_quote_item_links (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    request_id BIGINT UNSIGNED NOT NULL,
    request_item_id BIGINT UNSIGNED NULL,
    request_file_id BIGINT UNSIGNED NOT NULL,
    quote_id BIGINT UNSIGNED NOT NULL,
    quote_item_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_web_quote_item_link (request_item_id, quote_item_id),
    KEY idx_web_quote_item_request (request_id),
    KEY idx_web_quote_item_quote (quote_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cp_web_quote_order_files (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    request_id BIGINT UNSIGNED NOT NULL,
    request_file_id BIGINT UNSIGNED NOT NULL,
    order_id BIGINT UNSIGNED NOT NULL,
    order_photo_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_web_order_file (request_file_id, order_id),
    KEY idx_web_order_request (request_id),
    KEY idx_web_order_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
