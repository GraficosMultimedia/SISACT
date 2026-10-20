<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/cotizaciones.php';

function order_statuses(): array {
    return [
        'pending' => 'Pendiente',
        'in_progress' => 'En proceso',
        'completed' => 'Completada',
        'delivered' => 'Entregada',
        'cancelled' => 'Cancelada',
    ];
}
function order_status_label(string $status): string {
    $s=order_statuses();
    if(isset($s[$status])) return $s[$status];
    // cp_order_history también conserva cambios de etapa de producción.
    $productionLabels=[
        'design'=>'Diseño',
        'approval'=>'Aprobación',
        'printing'=>'Impresión',
        'production'=>'Producción',
        'quality'=>'Calidad',
        'ready'=>'Listo para entrega',
    ];
    return $productionLabels[$status] ?? 'Desconocido';
}
function order_number_next(): string {
    $prefix='OS-'.date('Y').'-';
    $st=db()->prepare('SELECT order_number FROM cp_orders WHERE order_number LIKE ? ORDER BY id DESC LIMIT 1');
    $st->execute([$prefix.'%']);
    $last=$st->fetchColumn();
    $n=1;
    if(is_string($last) && preg_match('/-(\d+)$/',$last,$m)) $n=(int)$m[1]+1;
    return $prefix.str_pad((string)$n,5,'0',STR_PAD_LEFT);
}
function order_get(int $id): ?array {
    $st=db()->prepare(
        'SELECT o.*, q.quote_number, q.issue_date AS quote_issue_date,
                c.name AS customer_name,c.email AS customer_email,c.phone AS customer_phone,
                c.address AS customer_address,c.city AS customer_city,c.state AS customer_state,
                c.tax_number AS customer_tax_number,
                u.name AS responsible_name
         FROM cp_orders o
         LEFT JOIN cp_quotes q ON q.id=o.quote_id
         LEFT JOIN cp_customers c ON c.id=o.customer_id
         LEFT JOIN cp_users u ON u.id=o.responsible_user_id
         WHERE o.id=? LIMIT 1'
    );
    $st->execute([$id]);
    $row=$st->fetch();
    return $row ?: null;
}
function order_for_quote(int $quoteId): ?array {
    $st=db()->prepare('SELECT id,order_number,status FROM cp_orders WHERE quote_id=? LIMIT 1');
    $st->execute([$quoteId]);
    $row=$st->fetch();
    return $row ?: null;
}
function order_items(int $orderId): array {
    $st=db()->prepare('SELECT * FROM cp_order_items WHERE order_id=? ORDER BY sort_order,id');
    $st->execute([$orderId]);
    return $st->fetchAll();
}
function order_history(int $orderId): array {
    $st=db()->prepare(
        'SELECT h.*,u.name AS user_name
         FROM cp_order_history h LEFT JOIN cp_users u ON u.id=h.changed_by
         WHERE h.order_id=? ORDER BY h.id DESC'
    );
    $st->execute([$orderId]);
    return $st->fetchAll();
}
function order_total_from_quote(int $quoteId): float {
    $t=quote_totals($quoteId);
    return (float)($t['total'] ?? 0);
}
