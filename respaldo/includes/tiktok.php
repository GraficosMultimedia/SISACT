<?php
declare(strict_types=1);

require_once __DIR__ . '/company.php';

function tiktok_setting(string $key, string $default = ''): string {
    return setting_get('tiktok.' . $key, $default);
}

function tiktok_set(string $key, ?string $value): void {
    setting_set('tiktok.' . $key, $value);
}

function tiktok_enabled(): bool {
    return tiktok_setting('enabled', '0') === '1';
}

function tiktok_configured(): bool {
    return trim(tiktok_setting('client_key')) !== ''
        && trim(tiktok_setting('client_secret')) !== ''
        && trim(tiktok_setting('redirect_uri')) !== '';
}

function tiktok_connected(): bool {
    return trim(tiktok_setting('access_token')) !== ''
        && trim(tiktok_setting('open_id')) !== '';
}

function tiktok_scopes(): string {
    $scope = trim(tiktok_setting('scopes', 'user.info.basic,video.publish'));
    return $scope !== '' ? $scope : 'user.info.basic,video.publish';
}

function tiktok_redirect_uri(): string {
    $configured = trim(tiktok_setting('redirect_uri'));
    if ($configured !== '') return $configured;

    $scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
    $host = trim((string)($_SERVER['HTTP_HOST'] ?? ''));
    return $host !== '' ? $scheme . '://' . $host . '/api/tiktok/callback.php' : '';
}

function tiktok_authorize_url(string $state): string {
    $query = http_build_query([
        'client_key' => trim(tiktok_setting('client_key')),
        'response_type' => 'code',
        'scope' => tiktok_scopes(),
        'redirect_uri' => tiktok_redirect_uri(),
        'state' => $state,
    ], '', '&', PHP_QUERY_RFC3986);

    return 'https://www.tiktok.com/v2/auth/authorize/?' . $query;
}

function tiktok_curl(string $method, string $url, array $headers = [], ?string $body = null): array {
    if (!function_exists('curl_init')) {
        throw new RuntimeException('La extensión cURL de PHP no está disponible.');
    }

    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_CUSTOMREQUEST => strtoupper($method),
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_CONNECTTIMEOUT => 10,
        CURLOPT_TIMEOUT => 45,
        CURLOPT_SSL_VERIFYPEER => true,
        CURLOPT_SSL_VERIFYHOST => 2,
        CURLOPT_HTTPHEADER => $headers,
    ]);

    if ($body !== null) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, $body);
    }

    $raw = curl_exec($ch);
    if ($raw === false) {
        $error = curl_error($ch);
        curl_close($ch);
        throw new RuntimeException('TikTok cURL: ' . $error);
    }

    $status = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    $json = json_decode((string)$raw, true);
    if (!is_array($json)) {
        $json = ['raw' => (string)$raw];
    }

    return [$status, $json];
}

function tiktok_token_request(string $grantType, string $codeOrRefresh): array {
    $payload = http_build_query([
        'client_key' => trim(tiktok_setting('client_key')),
        'client_secret' => trim(tiktok_setting('client_secret')),
        'grant_type' => $grantType,
        $grantType === 'authorization_code' ? 'code' : 'refresh_token' => $codeOrRefresh,
        'redirect_uri' => tiktok_redirect_uri(),
    ], '', '&', PHP_QUERY_RFC3986);

    [$status, $data] = tiktok_curl(
        'POST',
        'https://open.tiktokapis.com/v2/oauth/token/',
        ['Content-Type: application/x-www-form-urlencoded', 'Accept: application/json'],
        $payload
    );

    if ($status < 200 || $status >= 300 || !empty($data['error'])) {
        $message = (string)($data['error_description'] ?? $data['error']['message'] ?? $data['error'] ?? ('TikTok HTTP ' . $status));
        throw new RuntimeException($message);
    }

    return $data;
}

function tiktok_save_tokens(array $token): void {
    tiktok_set('access_token', (string)($token['access_token'] ?? ''));
    tiktok_set('refresh_token', (string)($token['refresh_token'] ?? ''));
    tiktok_set('open_id', (string)($token['open_id'] ?? ''));
    $expires = (int)($token['expires_in'] ?? 0);
    $refreshExpires = (int)($token['refresh_expires_in'] ?? 0);
    tiktok_set('token_expires_at', $expires > 0 ? (string)(time() + $expires) : '');
    tiktok_set('refresh_token_expires_at', $refreshExpires > 0 ? (string)(time() + $refreshExpires) : '');
}

function tiktok_refresh_access_token(): bool {
    $refresh = trim(tiktok_setting('refresh_token'));
    if ($refresh === '') return false;

    $token = tiktok_token_request('refresh_token', $refresh);
    tiktok_save_tokens($token);
    return trim(tiktok_setting('access_token')) !== '';
}

function tiktok_access_token(bool $refreshIfNeeded = true): string {
    $token = trim(tiktok_setting('access_token'));
    $expiresAt = (int)tiktok_setting('token_expires_at', '0');

    if ($refreshIfNeeded && ($token === '' || ($expiresAt > 0 && $expiresAt <= time() + 300))) {
        try {
            if (tiktok_refresh_access_token()) {
                $token = trim(tiktok_setting('access_token'));
            }
        } catch (Throwable $e) {
            if ($token === '') {
                throw $e;
            }
        }
    }

    if ($token === '') {
        throw new RuntimeException('La cuenta de TikTok no está conectada.');
    }

    return $token;
}

function tiktok_clear_connection(): void {
    foreach ([
        'access_token',
        'refresh_token',
        'open_id',
        'username',
        'display_name',
        'avatar_url',
        'token_expires_at',
        'refresh_token_expires_at',
    ] as $key) {
        tiktok_set($key, '');
    }
}

function tiktok_creator_info(): array {
    $accessToken = tiktok_access_token();
    [$status, $data] = tiktok_curl(
        'POST',
        'https://open.tiktokapis.com/v2/post/publish/creator_info/query/',
        [
            'Authorization: Bearer ' . $accessToken,
            'Content-Type: application/json; charset=UTF-8',
            'Accept: application/json',
        ],
        '{}'
    );

    if ($status < 200 || $status >= 300 || !empty($data['error']) && ($data['error']['code'] ?? '') !== 'ok') {
        $message = (string)($data['error']['message'] ?? $data['error'] ?? ('TikTok HTTP ' . $status));
        throw new RuntimeException($message);
    }

    $info = is_array($data['data'] ?? null) ? $data['data'] : [];
    if (!empty($info['creator_username'])) tiktok_set('username', (string)$info['creator_username']);
    if (!empty($info['creator_nickname'])) tiktok_set('display_name', (string)$info['creator_nickname']);
    if (!empty($info['creator_avatar_url'])) tiktok_set('avatar_url', (string)$info['creator_avatar_url']);
    return $info;
}

function tiktok_profile_info(): array {
    $accessToken = tiktok_access_token();
    [$status, $data] = tiktok_curl(
        'GET',
        'https://open.tiktokapis.com/v2/user/info/?fields=open_id,avatar_url,display_name',
        [
            'Authorization: Bearer ' . $accessToken,
            'Accept: application/json',
        ]
    );

    if ($status < 200 || $status >= 300 || !empty($data['error']) && ($data['error']['code'] ?? '') !== 'ok') {
        $message = (string)($data['error']['message'] ?? $data['error'] ?? ('TikTok HTTP ' . $status));
        throw new RuntimeException($message);
    }

    $info = is_array($data['data']['user'] ?? null) ? $data['data']['user'] : [];
    if (!empty($info['open_id'])) tiktok_set('open_id', (string)$info['open_id']);
    if (!empty($info['display_name'])) tiktok_set('display_name', (string)$info['display_name']);
    if (!empty($info['avatar_url'])) tiktok_set('avatar_url', (string)$info['avatar_url']);
    return $info;
}

function tiktok_absolute_public_url(string $value): string {
    $value = trim($value);
    if ($value === '') return '';

    if (preg_match('#^https?://#i', $value)) return $value;

    $company = company_profile();
    $base = rtrim((string)($company['website'] ?? ''), '/');
    if ($base === '') {
        throw new RuntimeException('Configura el sitio web público de la empresa antes de usar PULL_FROM_URL.');
    }
    return $base . '/' . ltrim($value, '/');
}

function tiktok_video_init_from_url(string $videoUrl, string $title, string $privacy, bool $disableComment, bool $disableDuet, bool $disableStitch, bool $isAiGenerated = false): array {
    $accessToken = tiktok_access_token();
    $payload = [
        'post_info' => [
            'title' => $title,
            'privacy_level' => $privacy,
            'disable_comment' => $disableComment,
            'disable_duet' => $disableDuet,
            'disable_stitch' => $disableStitch,
            'brand_organic_toggle' => true,
            'is_aigc' => $isAiGenerated,
        ],
        'source_info' => [
            'source' => 'PULL_FROM_URL',
            'video_url' => $videoUrl,
        ],
    ];

    [$status, $data] = tiktok_curl(
        'POST',
        'https://open.tiktokapis.com/v2/post/publish/video/init/',
        [
            'Authorization: Bearer ' . $accessToken,
            'Content-Type: application/json; charset=UTF-8',
            'Accept: application/json',
        ],
        json_encode($payload, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE)
    );

    if ($status < 200 || $status >= 300 || !empty($data['error']) && ($data['error']['code'] ?? '') !== 'ok') {
        $message = (string)($data['error']['message'] ?? $data['error'] ?? ('TikTok HTTP ' . $status));
        throw new RuntimeException($message);
    }

    return $data['data'] ?? [];
}

function tiktok_supported_privacy_options(array $creatorInfo): array {
    $options = $creatorInfo['privacy_level_options'] ?? [];
    return is_array($options) ? array_values(array_filter(array_map('strval', $options))) : [];
}

function tiktok_default_privacy(array $creatorInfo): string {
    $options = tiktok_supported_privacy_options($creatorInfo);
    return $options[0] ?? 'PUBLIC_TO_EVERYONE';
}
