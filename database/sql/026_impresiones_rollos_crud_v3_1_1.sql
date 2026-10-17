-- SISACT · Impresiones · Rollos CRUD Hotfix V3.1.1
-- El instalador hace esta migración de forma idempotente.

ALTER TABLE cp_print_rolls
    ADD COLUMN is_archived TINYINT(1) NOT NULL DEFAULT 0 AFTER status;

CREATE TABLE cp_print_roll_adjustments (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    roll_id BIGINT UNSIGNED NULL,
    action_name VARCHAR(30) NOT NULL,
    before_json LONGTEXT NULL,
    after_json LONGTEXT NULL,
    note VARCHAR(255) NULL,
    created_by BIGINT UNSIGNED NULL,
    created_at DATETIME NOT NULL,
    PRIMARY KEY (id),
    KEY idx_print_roll_adjustments_roll (roll_id),
    KEY idx_print_roll_adjustments_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
