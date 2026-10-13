<?php
declare(strict_types=1);
require_once __DIR__ . '/tracking_activity.php';

function tracking_activity_log_verified(
    string $eventType,
    int $orderId,
    ?int $customerId = null,
    ?int $documentId = null,
    ?int $invoiceId = null,
    ?int $receiptId = null,
    string $visitorSalt = '',
    int $dedupeSeconds = 0
): ?int {
    if ($orderId <= 0 || !tracking_activity_tables_ready()) return null;
    if (!isset(tracking_activity_event_types()[$eventType])) return null;

    try {
        if ($customerId === null) {
            $customerId = tracking_activity_customer_for_order($orderId);
        }

        $visitorHash = tracking_activity_visitor_hash(
            $visitorSalt !== '' ? $visitorSalt : (string)$orderId
        );

        if ($dedupeSeconds > 0 && $visitorHash !== null) {
            $cutoff = date('Y-m-d H:i:s', time() - max(1, min(3600, $dedupeSeconds)));
            $check = db()->prepare(
                'SELECT id FROM cp_tracking_events
                 WHERE order_id=? AND event_type=? AND visitor_hash=? AND created_at>=?
                 ORDER BY id DESC LIMIT 1'
            );
            $check->execute([$orderId,$eventType,$visitorHash,$cutoff]);
            $existingId = (int)($check->fetchColumn() ?: 0);
            if ($existingId > 0) return $existingId;
        }

        $st = db()->prepare(
            'INSERT INTO cp_tracking_events
             (order_id,customer_id,event_type,document_id,invoice_id,receipt_id,visitor_hash,device_type,created_at)
             VALUES(?,?,?,?,?,?,?,?,NOW())'
        );
        $st->execute([
            $orderId,
            $customerId ?: null,
            $eventType,
            $documentId ?: null,
            $invoiceId ?: null,
            $receiptId ?: null,
            $visitorHash,
            tracking_activity_device_type(),
        ]);
        return (int)db()->lastInsertId();
    } catch (Throwable $e) {
        error_log('[SISACT][tracking_activity_verified] '.$e->getMessage());
        return null;
    }
}
