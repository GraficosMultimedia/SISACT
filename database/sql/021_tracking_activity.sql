CREATE TABLE IF NOT EXISTS cp_tracking_events (
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
order_id INT NOT NULL,
customer_id INT NULL,
event_type VARCHAR(40) NOT NULL,
document_id INT NULL,
invoice_id INT NULL,
receipt_id INT NULL,
visitor_hash CHAR(64) NULL,
device_type VARCHAR(20) NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id),
KEY idx_tracking_events_order_created (order_id,created_at),
KEY idx_tracking_events_customer_created (customer_id,created_at),
KEY idx_tracking_events_type_created (event_type,created_at),
KEY idx_tracking_events_created_id (created_at,id),
KEY idx_tracking_events_document (document_id),
KEY idx_tracking_events_invoice (invoice_id),
KEY idx_tracking_events_receipt (receipt_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS cp_tracking_event_reads (
user_id INT NOT NULL,
last_event_id BIGINT UNSIGNED NOT NULL DEFAULT 0,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (user_id),
KEY idx_tracking_event_reads_last (last_event_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
