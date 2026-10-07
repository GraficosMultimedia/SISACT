<?php
declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

try {
    $pdo = wa_db();

    $sql = "
        SELECT
            id,
            chat_id,
            phone,
            contact_name,
            unread_count,
            created_at,
            updated_at
        FROM cp_whatsapp_chats
        ORDER BY updated_at DESC, id DESC
    ";

    $stmt = $pdo->query($sql);
    $rows = $stmt->fetchAll();

    foreach ($rows as &$row) {
        $row['id'] = (int)$row['id'];
        $row['unread_count'] = (int)($row['unread_count'] ?? 0);
        $row['contact_name'] =
            trim((string)($row['contact_name'] ?? '')) ?:
            trim((string)($row['phone'] ?? '')) ?:
            'Sin nombre';
    }

    wa_json([
        'ok' => true,
        'count' => count($rows),
        'chats' => $rows,
    ]);
} catch (Throwable $e) {
    wa_json([
        'ok' => false,
        'error' => 'No se pudieron cargar las conversaciones.',
        'detail' => $e->getMessage(),
    ], 500);
}
