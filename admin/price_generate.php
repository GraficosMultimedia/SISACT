<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/bootstrap.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: impresion_precios.php');
    exit;
}

cp_check_csrf($_POST['csrf'] ?? null);

$db = cp_db();
$sizes = $db->query("SELECT id FROM cp_print_sizes WHERE enabled=1 ORDER BY id")->fetchAll(PDO::FETCH_COLUMN);
$materials = $db->query("SELECT id FROM cp_print_materials WHERE enabled=1 ORDER BY id")->fetchAll(PDO::FETCH_COLUMN);
$finishes = $db->query("SELECT id FROM cp_print_finishes WHERE enabled=1 ORDER BY id")->fetchAll(PDO::FETCH_COLUMN);

$created = 0;
$existing = 0;
$db->beginTransaction();
try {
    $exists = $db->prepare('SELECT id FROM cp_print_prices WHERE size_id=? AND material_id=? AND finish_id=? AND color_mode=? AND pricing_mode=? LIMIT 1');
    $insert = $db->prepare('INSERT INTO cp_print_prices (size_id, material_id, finish_id, color_mode, pricing_mode, unit_price, min_qty, enabled, created_at, updated_at) VALUES (?,?,?,?,?,0.00,1,0,NOW(),NOW())');

    foreach ($sizes as $sizeId) {
        foreach ($materials as $materialId) {
            foreach ($finishes as $finishId) {
                foreach (['color','bw'] as $colorMode) {
                    foreach (['per_page','per_sheet'] as $pricingMode) {
                        $exists->execute([(int)$sizeId,(int)$materialId,(int)$finishId,$colorMode,$pricingMode]);
                        if ($exists->fetchColumn()) {
                            $existing++;
                            continue;
                        }
                        $insert->execute([(int)$sizeId,(int)$materialId,(int)$finishId,$colorMode,$pricingMode]);
                        $created++;
                    }
                }
            }
        }
    }
    $db->commit();
} catch (Throwable $e) {
    if ($db->inTransaction()) $db->rollBack();
    http_response_code(500);
    exit('No se pudieron generar las combinaciones: ' . $e->getMessage());
}

$theoretical = count($sizes) * count($materials) * count($finishes) * 2 * 2;
header('Location: impresion_precios.php?generated=' . $created . '&total=' . $theoretical . '&existing=' . $existing);
exit;
