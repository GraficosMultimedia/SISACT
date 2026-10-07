<?php
declare(strict_types=1);

require_once __DIR__ . '/../../tiktok-callback/api.php';
header('Content-Type: application/json; charset=UTF-8');

try {
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405);
        echo json_encode(['ok'=>false,'error'=>'method_not_allowed']);
        exit;
    }

    $token = tiktok_token_with_refresh();
    if (!tiktok_token_has_scope($token, 'video.publish')) {
        http_response_code(403);
        echo json_encode(['ok'=>false,'error'=>'scope_not_authorized','message'=>'La cuenta no tiene autorizado video.publish.'], JSON_UNESCAPED_UNICODE);
        exit;
    }

    $body = json_decode((string)file_get_contents('php://input'), true);
    if (!is_array($body)) {
        http_response_code(400);
        echo json_encode(['ok'=>false,'error'=>'invalid_json']);
        exit;
    }

    $title = trim((string)($body['title'] ?? ''));
    $privacy = trim((string)($body['privacy_level'] ?? ''));
    $videoSize = (int)($body['video_size'] ?? 0);
    $chunkSize = (int)($body['chunk_size'] ?? 0);
    $totalChunks = (int)($body['total_chunk_count'] ?? 0);

    if ($privacy === '' || $videoSize <= 0 || $chunkSize <= 0 || $totalChunks <= 0) {
        http_response_code(422);
        echo json_encode(['ok'=>false,'error'=>'missing_publish_parameters','message'=>'privacy_level, video_size, chunk_size y total_chunk_count son obligatorios para FILE_UPLOAD.'], JSON_UNESCAPED_UNICODE);
        exit;
    }

    $payload = [
        'post_info' => [
            'title' => mb_substr($title, 0, 2200),
            'privacy_level' => $privacy,
        ],
        'source_info' => [
            'source' => 'FILE_UPLOAD',
            'video_size' => $videoSize,
            'chunk_size' => $chunkSize,
            'total_chunk_count' => $totalChunks,
        ],
    ];

    $ch = curl_init('https://open.tiktokapis.com/v2/post/publish/video/init/');
    curl_setopt_array($ch, [
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => json_encode($payload, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES),
        CURLOPT_HTTPHEADER => ['Authorization: Bearer '.$token['access_token'], 'Content-Type: application/json; charset=UTF-8'],
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
