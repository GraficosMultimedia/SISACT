<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/tracking_activity.php';
require_auth();

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');

$user = current_user();
$userId = (int)($user['id'] ?? 0);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        http_response_code(419);
        echo json_encode(['ok'=>false,'error'=>'Sesión expirada.'], JSON_UNESCAPED_UNICODE);
        exit;
    }

    if (($_POST['action'] ?? '') === 'mark_read') {
        $lastEventId = max(0, (int)($_POST['last_event_id'] ?? 0));
        tracking_activity_mark_read($userId, $lastEventId);
        echo json_encode([
            'ok'=>true,
            'unread'=>tracking_activity_unread_count($userId),
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }

    http_response_code(400);
    echo json_encode(['ok'=>false,'error'=>'Acción no válida.'], JSON_UNESCAPED_UNICODE);
    exit;
}

$limit = max(1, min(20, (int)($_GET['limit'] ?? 10)));
$ready = tracking_activity_tables_ready();

echo json_encode([
    'ok'=>true,
    'ready'=>$ready,
    'csrf'=>csrf_token(),
    'latest_event_id'=>$ready ? tracking_activity_latest_id() : 0,
    'unread'=>$ready ? tracking_activity_unread_count($userId) : 0,
    'events'=>$ready ? tracking_activity_recent($limit) : [],
], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
