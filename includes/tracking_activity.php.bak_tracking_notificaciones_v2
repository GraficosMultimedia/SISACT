<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';

function tracking_activity_tables_ready(): bool
{
    static $ready = null;
    if ($ready !== null) return $ready;

    try {
        $events = (bool)db()->query("SHOW TABLES LIKE 'cp_tracking_events'")->fetchColumn();
        $reads = (bool)db()->query("SHOW TABLES LIKE 'cp_tracking_event_reads'")->fetchColumn();
        $ready = $events && $reads;
    } catch (Throwable $e) {
        $ready = false;
    }
    return $ready;
}

function tracking_activity_event_types(): array
{
    return [
        'tracking_view' => [
            'icon' => '👁',
            'label' => 'Revisó su orden',
        ],
        'cfdi_pdf_opened' => [
            'icon' => '📄',
            'label' => 'Consultó factura PDF',
        ],
        'cfdi_xml_downloaded' => [
            'icon' => '🧾',
            'label' => 'Descargó XML',
        ],
        'payment_receipt_uploaded' => [
            'icon' => '💳',
            'label' => 'Envió comprobante',
        ],
    ];
}

function tracking_activity_is_human_request(): bool
{
    $method = strtoupper((string)($_SERVER['REQUEST_METHOD'] ?? 'GET'));
    if ($method === 'HEAD') return false;

    $purpose = strtolower(
        (string)($_SERVER['HTTP_SEC_PURPOSE'] ?? $_SERVER['HTTP_PURPOSE'] ?? '')
    );
    if (str_contains($purpose, 'prefetch') || str_contains($purpose, 'preview')) {
        return false;
    }

    $ua = strtolower(trim((string)($_SERVER['HTTP_USER_AGENT'] ?? '')));
    if ($ua === '') return true;

    $blocked = [
        'bot', 'crawler', 'spider',
        'facebookexternalhit', 'facebot',
        'twitterbot', 'linkedinbot',
        'slackbot', 'discordbot', 'telegrambot',
        'whatsapp', 'skypeuripreview',
        'microsoft office existence discovery',
        'googlebot', 'bingbot', 'applebot',
        'google-pagerenderer',
        'curl/', 'wget/',
    ];

    foreach ($blocked as $needle) {
        if (str_contains($ua, $needle)) return false;
    }
    return true;
}

function tracking_activity_device_type(?string $userAgent = null): string
{
    $ua = strtolower((string)($userAgent ?? ($_SERVER['HTTP_USER_AGENT'] ?? '')));
    if ($ua === '') return 'unknown';
    if (preg_match('/ipad|tablet|kindle|silk|playbook/i', $ua)) return 'tablet';
    if (preg_match('/android|iphone|ipod|mobile/i', $ua)) return 'mobile';
    return 'desktop';
}

function tracking_activity_visitor_hash(string $salt = ''): ?string
{
    $ip = trim((string)($_SERVER['REMOTE_ADDR'] ?? ''));
    $ua = trim((string)($_SERVER['HTTP_USER_AGENT'] ?? ''));
    if ($ip === '' && $ua === '') return null;

    // No guarda la IP en texto plano. El salt limita correlación entre contextos.
    return hash('sha256', $ip . '|' . $ua . '|' . $salt . '|sisact-tracking-v1');
}

function tracking_activity_customer_for_order(int $orderId): ?int
{
    if ($orderId <= 0) return null;
    try {
        $st = db()->prepare('SELECT customer_id FROM cp_orders WHERE id=? LIMIT 1');
        $st->execute([$orderId]);
        $id = (int)$st->fetchColumn();
        return $id > 0 ? $id : null;
    } catch (Throwable $e) {
        return null;
    }
}

function tracking_activity_log(
    string $eventType,
    int $orderId,
    ?int $customerId = null,
    ?int $documentId = null,
    ?int $invoiceId = null,
    ?int $receiptId = null,
    string $visitorSalt = ''
): ?int {
    if ($orderId <= 0 || !tracking_activity_tables_ready()) return null;
    if (!isset(tracking_activity_event_types()[$eventType])) return null;
    if (!tracking_activity_is_human_request()) return null;

    try {
        if ($customerId === null) {
            $customerId = tracking_activity_customer_for_order($orderId);
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
            tracking_activity_visitor_hash($visitorSalt !== '' ? $visitorSalt : (string)$orderId),
            tracking_activity_device_type(),
        ]);

        return (int)db()->lastInsertId();
    } catch (Throwable $e) {
        // La analítica nunca debe impedir seguimiento, CFDI ni comprobantes.
        error_log('[SISACT][tracking_activity] ' . $e->getMessage());
        return null;
    }
}

function tracking_activity_log_tracking_view(int $orderId): ?int
{
    static $loggedOrders = [];

    if ($orderId <= 0) return null;
    if (isset($loggedOrders[$orderId])) return null;

    $script = basename((string)($_SERVER['SCRIPT_NAME'] ?? ''));
    if ($script !== 'seguimiento.php') return null;

    $method = strtoupper((string)($_SERVER['REQUEST_METHOD'] ?? 'GET'));
    if ($method !== 'GET') return null;

    $loggedOrders[$orderId] = true;
    return tracking_activity_log('tracking_view', $orderId);
}

function tracking_activity_recent(int $limit = 12): array
{
    if (!tracking_activity_tables_ready()) return [];

    $limit = max(1, min(50, $limit));

    try {
        $sql =
            'SELECT
                e.id,e.order_id,e.customer_id,e.event_type,e.document_id,e.invoice_id,e.receipt_id,
                e.visitor_hash,e.device_type,e.created_at,
                o.order_number,
                COALESCE(c.name,\'Cliente\') AS customer_name,
                COALESCE(i.invoice_number, d.uuid) AS invoice_number
             FROM cp_tracking_events e
             INNER JOIN cp_orders o ON o.id=e.order_id
             LEFT JOIN cp_customers c ON c.id=e.customer_id
             LEFT JOIN cp_invoice_documents d ON d.id=e.document_id
             LEFT JOIN cp_invoices i ON i.id=COALESCE(e.invoice_id,d.invoice_id)
             ORDER BY e.id DESC
             LIMIT ' . (int)$limit;

        $rows = db()->query($sql)->fetchAll(PDO::FETCH_ASSOC) ?: [];
        $types = tracking_activity_event_types();

        foreach ($rows as &$row) {
            $type = (string)$row['event_type'];
            $meta = $types[$type] ?? ['icon'=>'•','label'=>'Actividad'];
            $row['icon'] = $meta['icon'];
            $row['label'] = $meta['label'];

            $ts = strtotime((string)$row['created_at']);
            $row['created_at_iso'] = $ts ? date(DATE_ATOM, $ts) : null;
        }
        unset($row);

        return $rows;
    } catch (Throwable $e) {
        error_log('[SISACT][tracking_activity_recent] ' . $e->getMessage());
        return [];
    }
}

function tracking_activity_last_read_id(int $userId): int
{
    if ($userId <= 0 || !tracking_activity_tables_ready()) return 0;

    try {
        $st = db()->prepare('SELECT last_event_id FROM cp_tracking_event_reads WHERE user_id=? LIMIT 1');
        $st->execute([$userId]);
        return (int)($st->fetchColumn() ?: 0);
    } catch (Throwable $e) {
        return 0;
    }
}

function tracking_activity_latest_id(): int
{
    if (!tracking_activity_tables_ready()) return 0;
    try {
        return (int)(db()->query('SELECT COALESCE(MAX(id),0) FROM cp_tracking_events')->fetchColumn() ?: 0);
    } catch (Throwable $e) {
        return 0;
    }
}

function tracking_activity_unread_count(int $userId): int
{
    if ($userId <= 0 || !tracking_activity_tables_ready()) return 0;

    $lastRead = tracking_activity_last_read_id($userId);
    try {
        $st = db()->prepare('SELECT COUNT(*) FROM cp_tracking_events WHERE id>?');
        $st->execute([$lastRead]);
        return (int)$st->fetchColumn();
    } catch (Throwable $e) {
        return 0;
    }
}

function tracking_activity_mark_read(int $userId, int $eventId): void
{
    if ($userId <= 0 || $eventId < 0 || !tracking_activity_tables_ready()) return;

    $latest = tracking_activity_latest_id();
    $eventId = min($eventId, $latest);

    $st = db()->prepare(
        'INSERT INTO cp_tracking_event_reads(user_id,last_event_id,updated_at)
         VALUES(?,?,NOW())
         ON DUPLICATE KEY UPDATE
            last_event_id=GREATEST(last_event_id,VALUES(last_event_id)),
            updated_at=NOW()'
    );
    $st->execute([$userId, $eventId]);
}
