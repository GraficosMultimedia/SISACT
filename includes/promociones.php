<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';

function promotion_types(): array {
    return [
        'fixed' => 'Precio especial',
        'percent' => 'Descuento porcentual',
    ];
}

function promotion_statuses(): array {
    return [
        'draft' => 'Borrador',
        'active' => 'Activa',
        'paused' => 'Pausada',
    ];
}

function promotion_format_price(?float $value): string {
    return $value === null ? '—' : '$' . number_format($value, 2, '.', ',');
}

function promotion_slugify(string $value): string {
    $value = trim($value);
    if (function_exists('iconv')) $value = iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $value) ?: $value;
    $value = strtolower($value);
    $value = preg_replace('/[^a-z0-9]+/', '-', $value) ?? '';
    return trim($value, '-');
}

function promotion_unique_slug(PDO $pdo, string $title, int $ignoreId = 0): string {
    $base = promotion_slugify($title);
    if ($base === '') $base = 'promocion';
    $slug = $base;
    $n = 2;
    while (true) {
        if ($ignoreId > 0) {
            $stmt = $pdo->prepare('SELECT id FROM cp_promotions WHERE slug=? AND id<>? LIMIT 1');
            $stmt->execute([$slug, $ignoreId]);
        } else {
            $stmt = $pdo->prepare('SELECT id FROM cp_promotions WHERE slug=? LIMIT 1');
            $stmt->execute([$slug]);
        }
        if (!$stmt->fetchColumn()) return $slug;
        $slug = $base . '-' . $n++;
    }
}

function promotion_effective_state(array $promotion): string {
    $status = (string)($promotion['status'] ?? 'draft');
    if ($status !== 'active') return $status;
    $today = new DateTimeImmutable('today');
    try {
        $start = new DateTimeImmutable((string)$promotion['start_date']);
        if ($start > $today) return 'scheduled';
        if (!empty($promotion['end_date'])) {
            $end = new DateTimeImmutable((string)$promotion['end_date']);
            if ($end < $today) return 'expired';
        }
    } catch (Throwable $e) {
        return $status;
    }
    return 'active';
}

function promotion_effective_state_label(string $state): string {
    return [
        'draft' => 'Borrador',
        'active' => 'Activa',
        'paused' => 'Pausada',
        'scheduled' => 'Programada',
        'expired' => 'Expirada',
    ][$state] ?? ucfirst($state);
}

function promotion_get(int $id): ?array {
    if ($id <= 0) return null;
    $stmt = db()->prepare('SELECT * FROM cp_promotions WHERE id=? LIMIT 1');
    $stmt->execute([$id]);
    $row = $stmt->fetch();
    return $row ?: null;
}

function promotion_product_ids(int $promotionId): array {
    if ($promotionId <= 0) return [];
    $stmt = db()->prepare('SELECT product_id FROM cp_promotion_products WHERE promotion_id=? ORDER BY sort_order,id');
    $stmt->execute([$promotionId]);
    return array_map('intval', array_column($stmt->fetchAll(), 'product_id'));
}

function promotion_products_for(int $promotionId): array {
    if ($promotionId <= 0) return [];
    $stmt = db()->prepare(
        'SELECT p.id,p.name,p.sku,p.sale_price,
                (SELECT pi.path FROM cp_product_images pi WHERE pi.product_id=p.id AND pi.enabled=1 ORDER BY pi.sort_order,pi.id LIMIT 1) AS image_path
         FROM cp_promotion_products pp
         INNER JOIN cp_products p ON p.id=pp.product_id
         WHERE pp.promotion_id=?
         ORDER BY pp.sort_order,p.name'
    );
    $stmt->execute([$promotionId]);
    return $stmt->fetchAll();
}

function promotion_active_list(?string $channel = null, int $limit = 50): array {
    $limit = max(1, min(200, $limit));
    $conditions = [
        "p.status='active'",
        'p.start_date <= CURDATE()',
        '(p.end_date IS NULL OR p.end_date >= CURDATE())',
    ];
    $params = [];

    if ($channel === 'web') {
        $conditions[] = 'p.show_web=1';
    } elseif ($channel === 'catalog') {
        $conditions[] = 'p.show_catalog=1';
    } elseif ($channel === 'whatsapp') {
        $conditions[] = 'p.show_whatsapp=1';
    }

    $sql = 'SELECT p.*,
                   (SELECT pi.path FROM cp_product_images pi INNER JOIN cp_promotion_products pp2 ON pp2.product_id=pi.product_id WHERE pp2.promotion_id=p.id AND pi.enabled=1 ORDER BY pp2.sort_order,pi.sort_order,pi.id LIMIT 1) AS fallback_image
            FROM cp_promotions p
            WHERE ' . implode(' AND ', $conditions) . '
            ORDER BY p.start_date DESC,p.id DESC
            LIMIT ' . $limit;
    $stmt = db()->prepare($sql);
    $stmt->execute($params);
    $rows = $stmt->fetchAll();

    foreach ($rows as &$row) {
        $row['products'] = promotion_products_for((int)$row['id']);
        $row['display_image'] = $row['image_path'] ?: ($row['fallback_image'] ?? null);
        unset($row['fallback_image']);
    }
    unset($row);
    return $rows;
}

function promotion_whatsapp_text(array $promotion, ?string $siteUrl = null): string {
    $title = trim((string)($promotion['title'] ?? 'Promoción'));
    $label = trim((string)($promotion['label'] ?? 'OFERTA'));
    $description = trim((string)($promotion['description'] ?? ''));
    $lines = ['✨ ' . $label . ': ' . $title];
    if ($description !== '') $lines[] = $description;

    $normal = isset($promotion['normal_price']) && $promotion['normal_price'] !== null ? (float)$promotion['normal_price'] : null;
    $promo = isset($promotion['promo_price']) && $promotion['promo_price'] !== null ? (float)$promotion['promo_price'] : null;
    $percent = isset($promotion['discount_percent']) && $promotion['discount_percent'] !== null ? (float)$promotion['discount_percent'] : null;

    if ($promo !== null) $lines[] = '💥 Precio promocional: ' . promotion_format_price($promo);
    if ($normal !== null && $promo !== null) $lines[] = 'Antes: ' . promotion_format_price($normal);
    if ($percent !== null && $percent > 0) $lines[] = '🏷️ Descuento: ' . rtrim(rtrim(number_format($percent, 2, '.', ''), '0'), '.') . '%';

    $start = !empty($promotion['start_date']) ? date('d/m/Y', strtotime((string)$promotion['start_date'])) : null;
    $end = !empty($promotion['end_date']) ? date('d/m/Y', strtotime((string)$promotion['end_date'])) : null;
    if ($start && $end) $lines[] = '📅 Vigencia: ' . $start . ' al ' . $end;
    elseif ($start) $lines[] = '📅 Disponible desde: ' . $start;

    if (array_key_exists('quantity_available', $promotion)) {
        $qty = $promotion['quantity_available'];
        if ($qty !== null && $qty !== '') $lines[] = '📦 Disponibilidad promocional: ' . (int)$qty;
    }

    if ($siteUrl) $lines[] = '🌐 ' . rtrim($siteUrl, '/');
    $lines[] = 'Colibrí Print México';
    return (string)($promotion['whatsapp_text'] ?? '') !== '' ? trim((string)$promotion['whatsapp_text']) : implode("\n", $lines);
}
