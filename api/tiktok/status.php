<?php
declare(strict_types=1);

require_once __DIR__ . '/../../tiktok-callback/api.php';
header('Content-Type: application/json; charset=UTF-8');

try {
    $token = tiktok_token_with_refresh();
    if (!tiktok_token_has_scope($token, 'video.publish')) {
        http_response_code(403);
        echo json_encode(['ok'=>false,'error'=>'scope_not_authorized','message'=>'La cuenta no tiene autorizado video.publish.'], JSON_UNESCAPED_UNICODE);
        exit;
    }

    $body = json_decode((string)file_get_contents('php://input'), true);
    $publishId = trim((string)($body['publish_id'] ?? $_GET['publish_id'] ?? ''));
    if ($publishId === '') {
        http_response_code(422);
        echo json_encode(['ok'=>false,'error'=>'missing_publish_id']);
        exit;
    }

    $ch = curl_init('https://open.tiktokapis.com/v2/post/publish/status/fetch/');
    curl_setopt_array($ch, [
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => json_encode(['publish_id'=>$publishId]),
        CURLOPT_HTTPHEADER => ['Authorization: Bearer '.$token['access_token'], 'Content-Type: application/json'],
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 30,
    ]);
    $response = curl_exec($ch);
    $http = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $error = curl_error($ch);
    curl_close($ch);

    if ($response === false) throw new RuntimeException($error ?: 'Error cURL');
    $data = json_decode($response, true);
    if (!is_array($data)) throw new RuntimeException('Respuesta JSON inválida de TikTok.');

    http_response_code($http >= 200 && $http < 300 ? 200 : $http);
    echo json_encode(['ok'=>$http >= 200 && $http < 300, 'data'=>$data], JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['ok'=>false,'error'=>'server_error','message'=>$e->getMessage()], JSON_UNESCAPED_UNICODE);
}
