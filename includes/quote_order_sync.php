<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/cotizaciones.php';
require_once __DIR__ . '/ordenes.php';

function quote_order_sync_allowed_status(string $status): bool {
    return in_array($status, ['pending', 'in_progress'], true);
}

function quote_order_diff(int $quoteId, int $orderId): array {
    $quote = quote_get($quoteId);
    $order = order_get($orderId);
    if (!$quote || !$order) {
        return ['exists' => false, 'changes' => []];
    }

    $qTotals = quote_totals($quoteId);
    $qItems = quote_items($quoteId);
    $oItems = order_items($orderId);
    $changes = [];

    if ((int)($quote['customer_id'] ?? 0) !== (int)($order['customer_id'] ?? 0)) {
        $changes[] = 'cliente';
    }
    if (round((float)($qTotals['total'] ?? 0), 2) !== round((float)$order['total'], 2)) {
        $changes[] = 'total';
    }

    // La fecha de entrega/compromiso de la orden debe coincidir con
    // la fecha de vencimiento de la cotización.
    $quoteDueDate = trim((string)($quote['valid_until'] ?? ''));
    $orderDueDate = trim((string)($order['due_date'] ?? ''));
    if ($quoteDueDate !== $orderDueDate) {
        $changes[] = 'fecha de entrega';
    }
    if (count($qItems) !== count($oItems)) {
        $changes[] = 'conceptos';
    } else {
        foreach ($qItems as $i => $qi) {
            $oi = $oItems[$i] ?? null;
            if (!$oi) { $changes[] = 'conceptos'; break; }
            if ((string)$qi['description'] !== (string)$oi['description']
                || round((float)$qi['quantity'], 3) !== round((float)$oi['quantity'], 3)
                || round((float)$qi['unit_price'], 2) !== round((float)$oi['unit_price'], 2)
                || round((float)$qi['subtotal'], 2) !== round((float)$oi['subtotal'], 2)) {
                $changes[] = 'conceptos';
                break;
            }
        }
    }

    return [
        'exists' => true,
        'changes' => array_values(array_unique($changes)),
        'can_sync' => quote_order_sync_allowed_status((string)$order['status']),
        'quote' => $quote,
        'order' => $order,
    ];
}

function sync_order_from_quote(int $quoteId, int $orderId, int $userId, string $note = ''): array {
    $diff = quote_order_diff($quoteId, $orderId);
    if (!$diff['exists']) {
        throw new RuntimeException('La cotización o la orden no existe.');
    }
    if (!$diff['can_sync']) {
        throw new RuntimeException('La orden está cerrada y se conserva como histórico.');
    }

    $quote = $diff['quote'];
    $order = $diff['order'];
    $qItems = quote_items($quoteId);
    $qTotals = quote_totals($quoteId);

    $pdo = db();
    $pdo->beginTransaction();
    try {
        // Los datos comerciales de la orden se originan en la cotización.
        $pdo->prepare('UPDATE cp_orders SET customer_id=?, total=?, due_date=?, updated_by=?, updated_at=NOW() WHERE id=?')
            ->execute([
                (int)($quote['customer_id'] ?? 0),
                (float)($qTotals['total'] ?? 0),
                trim((string)($quote['valid_until'] ?? '')) ?: null,
                $userId,
                $orderId
            ]);

        $pdo->prepare('DELETE FROM cp_order_items WHERE order_id=?')->execute([$orderId]);
        $ins = $pdo->prepare('INSERT INTO cp_order_items(order_id,quote_item_id,description,quantity,unit_price,subtotal,sort_order,created_at,updated_at) VALUES(?,?,?,?,?,?,?,NOW(),NOW())');
        foreach ($qItems as $i => $item) {
            $ins->execute([
                $orderId,
                $item['id'] ?? null,
                $item['description'],
                $item['quantity'],
                $item['unit_price'],
                $item['subtotal'],
                $i
            ]);
        }

        $history = trim($note) !== '' ? trim($note) : 'Orden sincronizada desde la cotización ' . ($quote['quote_number'] ?? '#' . $quoteId);
        $pdo->prepare('INSERT INTO cp_order_history(order_id,old_status,new_status,note,changed_by,created_at) VALUES(?,?,?,?,?,NOW())')
            ->execute([$orderId, (string)$order['status'], (string)$order['status'], $history, $userId]);

        $pdo->commit();
        return ['ok' => true, 'items' => count($qItems), 'total' => (float)($qTotals['total'] ?? 0)];
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) $pdo->rollBack();
        throw $e;
    }
}
