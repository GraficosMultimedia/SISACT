<?php
declare(strict_types=1);

/*
 * Endpoint de recepción.
 *
 * Whapi debe apuntar a:
 * /api/whatsapp/webhook.php
 *
 * La persistencia depende del formato que entregue el webhook
 * configurado en Whapi. Este archivo conserva el payload recibido
 * en cp_whatsapp_log cuando la tabla existe.
 */

require_once __DIR__ . '/bootstrap.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    wa_json(['ok' => false, 'error' => 'Método no permitido.'], 405);
}

$raw = file_get_contents('php://input');
$payload = json_decode($raw, true);

if (!is_array($payload)) {
    wa_json(['ok' => false, 'error' => 'Payload JSON inválido.'], 400);
}

try {
    $pdo = wa_db();

    $tables = $pdo->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN);

    if (in_array('cp_whatsapp_log', $tables, true)) {
        $stmt = $pdo->prepare("
            INSERT INTO cp_whatsapp_log
                (event_type, payload, created_at)
            VALUES
                (?, ?, NOW())
        ");

        $stmt->execute([
            (string)($payload['event'] ?? 'webhook'),
            json_encode(
                $payload,
                JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
            ),
        ]);
    }

    wa_json([
        'ok' => true,
        'received' => true,
    ]);
} catch (Throwable $e) {
    wa_json([
        'ok' => false,
        'error' => $e->getMessage(),
    ], 500);
}
