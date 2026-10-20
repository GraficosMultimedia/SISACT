<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/ordenes.php';

function finance_tables_ready(): bool {
    try {
        $stmt = db()->query("SHOW TABLES LIKE 'cp_payments'");
        if (!(bool)$stmt->fetchColumn()) return false;
        $stmt = db()->query("SHOW TABLES LIKE 'cp_invoices'");
        return (bool)$stmt->fetchColumn();
    } catch (Throwable $e) {
        return false;
    }
}

function finance_payment_methods(): array {
    return [
        'cash' => 'Efectivo',
        'transfer' => 'Transferencia',
        'card' => 'Tarjeta',
        'deposit' => 'Depósito',
        'oxxo' => 'OXXO',
        'other' => 'Otro',
    ];
}

function finance_payment_statuses(): array {
    return [
        'confirmed' => 'Confirmado',
        'cancelled' => 'Cancelado',
    ];
}

function finance_invoice_statuses(): array {
    return [
        'draft' => 'Borrador',
        'issued' => 'Emitida',
        'cancelled' => 'Cancelada',
    ];
}

function finance_order_summary(int $orderId): array {
    $result = [
        'order_total' => 0.0,
        'paid_total' => 0.0,
        'balance' => 0.0,
        'payment_count' => 0,
        'invoice_count' => 0,
    ];
    if (!finance_tables_ready()) return $result;

    $st = db()->prepare('SELECT total FROM cp_orders WHERE id=? LIMIT 1');
    $st->execute([$orderId]);
    $result['order_total'] = (float)($st->fetchColumn() ?: 0);

    $st = db()->prepare("SELECT COALESCE(SUM(amount),0), COUNT(*) FROM cp_payments WHERE order_id=? AND status='confirmed'");
    $st->execute([$orderId]);
    [$paid, $count] = $st->fetch(PDO::FETCH_NUM) ?: [0, 0];
    $result['paid_total'] = (float)$paid;
    $result['payment_count'] = (int)$count;
    $result['balance'] = max(0.0, $result['order_total'] - $result['paid_total']);

    if ($result['order_total'] === 0.0) {
        $result['balance'] = 0.0;
    }

    $st = db()->prepare('SELECT COUNT(*) FROM cp_invoices WHERE order_id=?');
    $st->execute([$orderId]);
    $result['invoice_count'] = (int)$st->fetchColumn();
    return $result;
}

function finance_payment_get(int $id): ?array {
    if (!finance_tables_ready()) return null;
    $st = db()->prepare(
        'SELECT p.*, o.order_number, o.total AS order_total, c.name AS customer_name
         FROM cp_payments p
         INNER JOIN cp_orders o ON o.id=p.order_id
         LEFT JOIN cp_customers c ON c.id=p.customer_id
         WHERE p.id=? LIMIT 1'
    );
    $st->execute([$id]);
    $row = $st->fetch();
    return $row ?: null;
}

function finance_payment_list(?int $orderId = null, int $limit = 150): array {
    if (!finance_tables_ready()) return [];
    $limit = max(1, min(500, $limit));
    if ($orderId !== null) {
        $st = db()->prepare(
            "SELECT p.*,o.order_number,c.name AS customer_name
             FROM cp_payments p
             INNER JOIN cp_orders o ON o.id=p.order_id
             LEFT JOIN cp_customers c ON c.id=p.customer_id
             WHERE p.order_id=?
             ORDER BY p.payment_date DESC,p.id DESC
             LIMIT {$limit}"
        );
        $st->execute([$orderId]);
    } else {
        $st = db()->query(
            "SELECT p.*,o.order_number,c.name AS customer_name
             FROM cp_payments p
             INNER JOIN cp_orders o ON o.id=p.order_id
             LEFT JOIN cp_customers c ON c.id=p.customer_id
             ORDER BY p.payment_date DESC,p.id DESC
             LIMIT {$limit}"
        );
    }
    return $st->fetchAll();
}

function finance_invoice_get(int $id): ?array {
    if (!finance_tables_ready()) return null;
    $st = db()->prepare(
        'SELECT i.*,o.order_number,o.total AS order_total,c.name AS customer_name
         FROM cp_invoices i
         INNER JOIN cp_orders o ON o.id=i.order_id
         LEFT JOIN cp_customers c ON c.id=i.customer_id
         WHERE i.id=? LIMIT 1'
    );
    $st->execute([$id]);
    $row = $st->fetch();
    return $row ?: null;
}

function finance_invoice_list(int $limit = 150): array {
    if (!finance_tables_ready()) return [];
    $limit = max(1, min(500, $limit));
    $st = db()->query(
        "SELECT i.*,o.order_number,c.name AS customer_name,
                (SELECT COALESCE(SUM(p.amount),0) FROM cp_payments p WHERE p.order_id=o.id AND p.status='confirmed') AS paid_total,
                o.total AS order_total
         FROM cp_invoices i
         INNER JOIN cp_orders o ON o.id=i.order_id
         LEFT JOIN cp_customers c ON c.id=i.customer_id
         ORDER BY i.invoice_date DESC,i.id DESC
         LIMIT {$limit}"
    );
    return $st->fetchAll();
}

function finance_order_options(): array {
    $st = db()->query(
        "SELECT o.id,o.order_number,o.total,o.order_date,o.due_date,
                c.name AS customer_name,
                (SELECT COALESCE(SUM(p.amount),0) FROM cp_payments p WHERE p.order_id=o.id AND p.status='confirmed') AS paid_total
         FROM cp_orders o
         LEFT JOIN cp_customers c ON c.id=o.customer_id
         WHERE o.status<>'cancelled'
         ORDER BY o.id DESC
         LIMIT 250"
    );
    return $st->fetchAll();
}

function finance_dashboard_totals(): array {
    $out = ['orders_total'=>0.0,'paid_total'=>0.0,'balance_total'=>0.0,'payments_count'=>0,'invoices_count'=>0];
    if (!finance_tables_ready()) return $out;

    $st = db()->query("SELECT COALESCE(SUM(total),0), COUNT(*) FROM cp_orders WHERE status<>'cancelled'");
    [$ordersTotal, $ordersCount] = $st->fetch(PDO::FETCH_NUM) ?: [0,0];
    $out['orders_total'] = (float)$ordersTotal;

    $st = db()->query("SELECT COALESCE(SUM(amount),0), COUNT(*) FROM cp_payments WHERE status='confirmed'");
    [$paidTotal, $paymentsCount] = $st->fetch(PDO::FETCH_NUM) ?: [0,0];
    $out['paid_total'] = (float)$paidTotal;
    $out['payments_count'] = (int)$paymentsCount;
    $out['balance_total'] = max(0.0, $out['orders_total'] - $out['paid_total']);

    $out['invoices_count'] = (int)db()->query('SELECT COUNT(*) FROM cp_invoices WHERE status<>\'cancelled\'')->fetchColumn();
    return $out;
}

function finance_invoice_number_next(): string {
    $prefix = 'F-' . date('Y') . '-';
    $st = db()->prepare('SELECT invoice_number FROM cp_invoices WHERE invoice_number LIKE ? ORDER BY id DESC LIMIT 1');
    $st->execute([$prefix . '%']);
    $last = $st->fetchColumn();
    $n = 1;
    if (is_string($last) && preg_match('/-(\d+)$/', $last, $m)) $n = (int)$m[1] + 1;
    return $prefix . str_pad((string)$n, 5, '0', STR_PAD_LEFT);
}
