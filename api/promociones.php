<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/promociones.php';

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store, max-age=0');

$channel = strtolower(trim((string)($_GET['channel'] ?? 'web')));
if (!in_array($channel, ['web','catalog','whatsapp'], true)) $channel = 'web';

try {
    $rows = promotion_active_list($channel, 100);
    $out = [];
    foreach ($rows as $row) {
        $products = [];
        foreach (($row['products'] ?? []) as $product) {
            $products[] = [
                'id' => (int)$product['id'],
                'name' => (string)$product['name'],
                'sku' => (string)($product['sku'] ?? ''),
                'sale_price' => $product['sale_price'] !== null ? (float)$product['sale_price'] : null,
                'image_url' => $product['image_path'] ?: null,
            ];
        }
        $out[] = [
            'id' => (int)$row['id'],
            'title' => (string)$row['title'],
            'slug' => (string)$row['slug'],
            'label' => (string)$row['label'],
            'description' => (string)($row['description'] ?? ''),
            'promo_type' => (string)$row['promo_type'],
            'normal_price' => $row['normal_price'] !== null ? (float)$row['normal_price'] : null,
            'promo_price' => $row['promo_price'] !== null ? (float)$row['promo_price'] : null,
            'discount_percent' => $row['discount_percent'] !== null ? (float)$row['discount_percent'] : null,
            'quantity_available' => $row['quantity_available'] !== null ? (int)$row['quantity_available'] : null,
            'start_date' => (string)$row['start_date'],
            'end_date' => $row['end_date'] ?: null,
            'image_url' => $row['display_image'] ?: null,
            'products' => $products,
            'whatsapp_text' => promotion_whatsapp_text($row),
        ];
    }
    echo json_encode(['ok'=>true,'channel'=>$channel,'count'=>count($out),'promotions'=>$out], JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['ok'=>false,'error'=>'No se pudieron cargar las promociones.'], JSON_UNESCAPED_UNICODE);
}
