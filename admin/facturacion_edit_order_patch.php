<?php
declare(strict_types=1);
/*
 * Patch V1: asegurar que al editar una factura existente la orden de servicio
 * ya vinculada aparezca seleccionada.
 *
 * Uso: reemplazar manualmente el bloque correspondiente en admin/facturacion.php.
 * No modifica endpoints, BD ni lógica de guardado.
 */

$replacement = <<<'PHPBLOCK'
$selectedOrder = null;
$orderOptions = [];

if ($editing && (int)$invoice['order_id'] > 0) {
    try {
        $st = db()->prepare(
            "SELECT o.id,o.order_number,o.total,o.order_date,o.due_date,o.customer_id,
                    c.name AS customer_name
             FROM cp_orders o
             LEFT JOIN cp_customers c ON c.id=o.customer_id
             WHERE o.id=? AND o.status<>'cancelled'
             LIMIT 1"
        );
        $st->execute([(int)$invoice['order_id']]);
        $selectedOrder = $st->fetch() ?: null;

        // Para edición: entregar al <select> al menos la orden ya vinculada.
        // Así no dependemos de cargar las 250 órdenes globales.
        if ($selectedOrder) {
            $orderOptions[] = $selectedOrder;
        }
    } catch (Throwable $e) {
        $selectedOrder = null;
    }
}
PHPBLOCK;

header('Content-Type: text/plain; charset=utf-8');
echo "PATCH V1\n\n";
echo "Problema detectado: \$orderOptions se inicializa como [] y nunca se llena en la ruta de edición.\n\n";
echo "Sustituye ese bloque por:\n\n";
echo $replacement;
?>
