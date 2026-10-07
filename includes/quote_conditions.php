<?php
declare(strict_types=1);

/**
 * Ensures the optional commercial-condition templates table exists.
 * This prevents the quote screen from returning HTTP 500 when the migration
 * has not yet been executed manually. The normal SQL migration remains
 * available for controlled deployments.
 */
function quote_conditions_ensure_table(): bool {
    static $ready = null;
    if ($ready !== null) return $ready;
    try {
        $pdo = db();
        $pdo->exec("CREATE TABLE IF NOT EXISTS cp_quote_condition_templates (
            id INT UNSIGNED NOT NULL AUTO_INCREMENT,
            name VARCHAR(150) NOT NULL,
            payment_terms VARCHAR(190) DEFAULT NULL,
            delivery_time VARCHAR(190) DEFAULT NULL,
            delivery_place VARCHAR(190) DEFAULT NULL,
            terms TEXT,
            is_default TINYINT(1) NOT NULL DEFAULT 0,
            enabled TINYINT(1) NOT NULL DEFAULT 1,
            sort_order INT NOT NULL DEFAULT 0,
            created_by INT UNSIGNED DEFAULT NULL,
            updated_by INT UNSIGNED DEFAULT NULL,
            created_at DATETIME NOT NULL,
            updated_at DATETIME NOT NULL,
            PRIMARY KEY (id),
            KEY idx_cpct_enabled (enabled, sort_order, id),
            KEY idx_cpct_default (is_default, enabled)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");

        $exists = (bool)$pdo->query('SELECT 1 FROM cp_quote_condition_templates LIMIT 1')->fetchColumn();
        if (!$exists) {
            $st = $pdo->prepare('INSERT INTO cp_quote_condition_templates
                (name,payment_terms,delivery_time,delivery_place,terms,is_default,enabled,sort_order,created_at,updated_at)
                VALUES(?,?,?,?,?,?,?,?,NOW(),NOW())');
            $st->execute([
                'Condición general Colibrí Print',
                '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.',
                'Tiempo estimado según proyecto y disponibilidad de materiales.',
                'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.',
                'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.',
                1,1,0
            ]);
        }
        $ready = true;
    } catch (Throwable $e) {
        $ready = false;
    }
    return $ready;
}

function quote_condition_templates(bool $includeDisabled = false): array {
    if (!quote_conditions_ensure_table()) return [];
    $sql = 'SELECT * FROM cp_quote_condition_templates';
    if (!$includeDisabled) $sql .= ' WHERE enabled=1';
    $sql .= ' ORDER BY is_default DESC, sort_order ASC, name ASC, id ASC';
    try { return db()->query($sql)->fetchAll(PDO::FETCH_ASSOC); }
    catch (Throwable $e) { return []; }
}

function quote_condition_get(int $id): ?array {
    if ($id <= 0 || !quote_conditions_ensure_table()) return null;
    try {
        $st = db()->prepare('SELECT * FROM cp_quote_condition_templates WHERE id=? LIMIT 1');
        $st->execute([$id]);
        $row = $st->fetch(PDO::FETCH_ASSOC);
        return $row ?: null;
    } catch (Throwable $e) { return null; }
}

function quote_condition_default(): ?array {
    if (!quote_conditions_ensure_table()) return null;
    try {
        $st = db()->query('SELECT * FROM cp_quote_condition_templates WHERE enabled=1 ORDER BY is_default DESC, sort_order ASC, id ASC LIMIT 1');
        $row = $st->fetch(PDO::FETCH_ASSOC);
        return $row ?: null;
    } catch (Throwable $e) { return null; }
}

function quote_condition_set_default(int $id): void {
    if (!quote_conditions_ensure_table()) throw new RuntimeException('No está disponible la tabla de condiciones comerciales.');
    $pdo = db();
    $pdo->beginTransaction();
    try {
        $pdo->exec('UPDATE cp_quote_condition_templates SET is_default=0');
        $st = $pdo->prepare('UPDATE cp_quote_condition_templates SET is_default=1, enabled=1, updated_at=NOW() WHERE id=?');
        $st->execute([$id]);
        $pdo->commit();
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) $pdo->rollBack();
        throw $e;
    }
}
