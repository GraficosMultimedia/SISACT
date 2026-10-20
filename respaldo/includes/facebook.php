<?php
declare(strict_types=1);
require_once __DIR__ . '/company.php';
require_once __DIR__ . '/promociones.php';

function facebook_setting(string $key, string $default = ''): string {
    return setting_get('facebook.' . $key, $default);
}

function facebook_is_enabled(): bool {
    return facebook_setting('enabled', '0') === '1';
}

function facebook_auto_publish_enabled(): bool {
    return facebook_setting('auto_publish', '1') === '1';
}

function facebook_configured(): bool {
    return facebook_is_enabled()
        && trim(facebook_setting('page_id')) !== ''
        && trim(facebook_setting('page_access_token')) !== '';
}

function facebook_graph_version(): string {
    $v = trim(facebook_setting('graph_version', 'v26.0'));
    if (!preg_match('/^v\d+\.\d+$/', $v)) $v = 'v26.0';
    return $v;
}

function facebook_base_url(): string {
    $url = trim(facebook_setting('public_base_url', ''));
    if ($url === '') {
        $company = company_profile();
        $url = trim((string)($company['website'] ?? 'https://colibriprint.com.mx'));
    }
    return rtrim($url, '/');
}

function facebook_absolute_url(?string $pathOrUrl): string {
    $value = trim((string)$pathOrUrl);
    if ($value === '') return '';
    if (preg_match('#^https?://#i', $value)) return $value;
    return facebook_base_url() . '/' . ltrim($value, '/');
}

function facebook_promotion_config(int $promotionId): array {
    $stmt = db()->prepare('SELECT * FROM cp_promotion_facebook WHERE promotion_id=? LIMIT 1');
    $stmt->execute([$promotionId]);
    $row = $stmt->fetch();
    return $row ?: [
        'promotion_id' => $promotionId,
        'enabled' => 1,
        'custom_message' => '',
        'status' => 'pending',
        'facebook_page_id' => '',
        'facebook_post_id' => '',
        'image_url' => '',
        'last_error' => '',
        'response_json' => '',
        'attempts' => 0,
        'last_attempt_at' => null,
        'published_at' => null,
    ];
}

function facebook_promotion_upsert(int $promotionId, bool $enabled, string $customMessage): void {
    $stmt = db()->prepare('INSERT INTO cp_promotion_facebook(promotion_id,enabled,custom_message,status,created_at,updated_at) VALUES(?,?,?,\'pending\',NOW(),NOW()) ON DUPLICATE KEY UPDATE enabled=VALUES(enabled),custom_message=VALUES(custom_message),updated_at=NOW()');
    $stmt->execute([$promotionId, $enabled ? 1 : 0, $customMessage !== '' ? $customMessage : null]);
}

function facebook_promotion_text(array $promotion, ?string $customMessage = null): string {
    $customMessage = trim((string)$customMessage);
    if ($customMessage !== '') return $customMessage;

    $company = company_profile();
    $lines = [];
    $label = trim((string)($promotion['label'] ?? 'OFERTA'));
    $title = trim((string)($promotion['title'] ?? 'Promoción'));
    $description = trim((string)($promotion['description'] ?? ''));
    $lines[] = '🔥 ' . $label . ' 🔥';
    $lines[] = $title;
    if ($description !== '') $lines[] = $description;

    $products = promotion_products_for((int)$promotion['id']);
    if ($products) {
        $names = array_values(array_filter(array_map(static fn($p) => trim((string)$p['name']), $products)));
        if ($names) $lines[] = '✅ ' . implode(' · ', array_slice($names, 0, 4));
    }

    $normal = $promotion['normal_price'] !== null ? (float)$promotion['normal_price'] : null;
    $promo = $promotion['promo_price'] !== null ? (float)$promotion['promo_price'] : null;
    $percent = $promotion['discount_percent'] !== null ? (float)$promotion['discount_percent'] : null;
    if ($promo !== null) $lines[] = '💥 Precio promocional: ' . promotion_format_price($promo);
    if ($normal !== null && $promo !== null) $lines[] = '🏷️ Antes: ' . promotion_format_price($normal);
    if ($percent !== null && $percent > 0) {
        $pct = rtrim(rtrim(number_format($percent, 2, '.', ''), '0'), '.');
        $lines[] = '🎯 Descuento: ' . $pct . '%';
    }

    $start = !empty($promotion['start_date']) ? date('d/m/Y', strtotime((string)$promotion['start_date'])) : '';
    $end = !empty($promotion['end_date']) ? date('d/m/Y', strtotime((string)$promotion['end_date'])) : '';
    if ($start && $end) $lines[] = '📅 Vigencia: ' . $start . ' al ' . $end;
    elseif ($start) $lines[] = '📅 Disponible desde: ' . $start;

    if ($promotion['quantity_available'] !== null && $promotion['quantity_available'] !== '') {
        $lines[] = '📦 Disponibilidad promocional: ' . (int)$promotion['quantity_available'];
    }

    $phone = trim((string)($company['phone'] ?? ''));
    if ($phone !== '') $lines[] = '📲 Cotiza por WhatsApp: ' . $phone;
    $address = trim((string)($company['address'] ?? ''));
    $city = trim((string)($company['city'] ?? ''));
    $state = trim((string)($company['state'] ?? ''));
    $location = trim($address . ($city ? ', ' . $city : '') . ($state ? ', ' . $state : ''));
    if ($location !== '') $lines[] = '📍 ' . $location;
    $lines[] = '🌐 ' . facebook_base_url() . '/promociones-publicas.php';
    $lines[] = 'Colibrí Print México | Tu idea, nuestra impresión.';
    return implode("\n", $lines);
}

function facebook_curl(string $method, string $url, array $fields = []): array {
    if (!function_exists('curl_init')) throw new RuntimeException('La extensión cURL de PHP no está disponible en el servidor.');
    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_CUSTOMREQUEST => strtoupper($method),
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_CONNECTTIMEOUT => 10,
        CURLOPT_TIMEOUT => 30,
        CURLOPT_SSL_VERIFYPEER => true,
        CURLOPT_SSL_VERIFYHOST => 2,
        CURLOPT_HTTPHEADER => ['Accept: application/json'],
    ]);
    if ($fields) curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
    $body = curl_exec($ch);
    if ($body === false) {
        $err = curl_error($ch);
        curl_close($ch);
        throw new RuntimeException('Facebook cURL: ' . $err);
    }
    $status = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    $decoded = json_decode((string)$body, true);
    if (!is_array($decoded)) $decoded = ['raw' => (string)$body];
    return [$status, $decoded];
}

function facebook_test_connection(): array {
    if (!facebook_configured()) {
        return ['ok' => false, 'status' => 0, 'data' => ['error' => 'Facebook no está configurado.']];
    }
    $pageId = trim(facebook_setting('page_id'));
    $token = trim(facebook_setting('page_access_token'));
    $version = facebook_graph_version();
    $url = 'https://graph.facebook.com/' . $version . '/' . rawurlencode($pageId) . '?fields=id,name&access_token=' . rawurlencode($token);
    [$status, $data] = facebook_curl('GET', $url);
    return ['ok' => $status >= 200 && $status < 300 && empty($data['error']), 'status' => $status, 'data' => $data];
}

function facebook_publish_promotion(int $promotionId, bool $force = false): array {
    if ($promotionId <= 0) return ['status' => 'error', 'message' => 'Promoción inválida.'];
    $pdo = db();
    $promotion = promotion_get($promotionId);
    if (!$promotion) return ['status' => 'error', 'message' => 'La promoción no existe.'];

    $cfg = facebook_promotion_config($promotionId);
    if ((int)$cfg['enabled'] !== 1) return ['status' => 'disabled', 'message' => 'Facebook está desactivado para esta promoción.'];
    if (!$force && !facebook_auto_publish_enabled()) return ['status' => 'disabled', 'message' => 'La publicación automática de Facebook está desactivada.'];
    if (!facebook_configured()) return ['status' => 'error', 'message' => 'Facebook no está configurado: faltan Página o Page Access Token.'];

    $state = promotion_effective_state($promotion);
    if (!$force && $state !== 'active') return ['status' => 'pending', 'message' => 'La promoción aún no está vigente.'];
    if (!$force && (string)$cfg['status'] === 'published') return ['status' => 'published', 'message' => 'La promoción ya fue publicada en Facebook.', 'post_id' => $cfg['facebook_post_id']];

    $products = promotion_products_for($promotionId);
    $imagePath = trim((string)($promotion['image_path'] ?? ''));
    if ($imagePath === '' && !empty($products[0]['image_path'])) $imagePath = (string)$products[0]['image_path'];
    $imageUrl = facebook_absolute_url($imagePath);
    if ($imageUrl === '') return ['status' => 'error', 'message' => 'La promoción no tiene imagen de campaña ni imagen de producto disponible.'];

    $message = facebook_promotion_text($promotion, (string)($cfg['custom_message'] ?? ''));
    $pageId = trim(facebook_setting('page_id'));
    $token = trim(facebook_setting('page_access_token'));
    $version = facebook_graph_version();
    $url = 'https://graph.facebook.com/' . $version . '/' . rawurlencode($pageId) . '/photos';

    $attempts = (int)$cfg['attempts'] + 1;
    $pdo->prepare('UPDATE cp_promotion_facebook SET status=\'publishing\',attempts=?,last_attempt_at=NOW(),last_error=NULL,facebook_page_id=?,image_url=?,updated_at=NOW() WHERE promotion_id=?')
        ->execute([$attempts, $pageId, $imageUrl, $promotionId]);

    try {
        [$status, $data] = facebook_curl('POST', $url, [
            'url' => $imageUrl,
            'caption' => $message,
            'published' => 'true',
            'access_token' => $token,
        ]);
        $postId = (string)($data['post_id'] ?? $data['id'] ?? '');
        if ($status >= 200 && $status < 300 && empty($data['error']) && $postId !== '') {
            $pdo->prepare('UPDATE cp_promotion_facebook SET status=\'published\',facebook_post_id=?,response_json=?,published_at=NOW(),updated_at=NOW() WHERE promotion_id=?')
                ->execute([$postId, json_encode($data, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES), $promotionId]);
            log_activity('create', 'facebook', 'Promoción #' . $promotionId . ' publicada automáticamente en Facebook. Post: ' . $postId);
            return ['status' => 'published', 'message' => 'Publicada en Facebook.', 'post_id' => $postId, 'response' => $data];
        }
        $error = (string)($data['error']['message'] ?? ('Facebook respondió HTTP ' . $status));
        $pdo->prepare('UPDATE cp_promotion_facebook SET status=\'error\',last_error=?,response_json=?,updated_at=NOW() WHERE promotion_id=?')
            ->execute([$error, json_encode($data, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES), $promotionId]);
        return ['status' => 'error', 'message' => $error, 'response' => $data];
    } catch (Throwable $e) {
        $pdo->prepare('UPDATE cp_promotion_facebook SET status=\'error\',last_error=?,updated_at=NOW() WHERE promotion_id=?')
            ->execute([$e->getMessage(), $promotionId]);
        return ['status' => 'error', 'message' => $e->getMessage()];
    }
}

function facebook_pending_promotions(int $limit = 20): array {
    $limit = max(1, min(100, $limit));
    $sql = "SELECT p.id
            FROM cp_promotions p
            LEFT JOIN cp_promotion_facebook f ON f.promotion_id=p.id
            WHERE p.status='active'
              AND p.start_date <= CURDATE()
              AND (p.end_date IS NULL OR p.end_date >= CURDATE())
              AND COALESCE(f.enabled,1)=1
              AND COALESCE(f.status,'pending') <> 'published'
            ORDER BY p.start_date ASC,p.id ASC
            LIMIT " . $limit;
    return array_map('intval', array_column(db()->query($sql)->fetchAll(), 'id'));
}
