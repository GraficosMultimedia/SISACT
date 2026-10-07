<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';

function calculator_settings(array $defaults = []): array {
    $settings = $defaults;
    try {
        $stmt = db()->query("SELECT setting_key, setting_value FROM cp_settings WHERE setting_key LIKE 'calculator.%'");
        foreach ($stmt->fetchAll() as $row) {
            $settings[(string)$row['setting_key']] = (float)$row['setting_value'];
        }
    } catch (Throwable $e) {
        // Si la migración todavía no fue ejecutada, se usan los valores entregados por el formulario.
    }
    return $settings;
}

function calculator_save_settings(array $values): void {
    $pdo = db();
    $stmt = $pdo->prepare('INSERT INTO cp_settings(setting_key,setting_value,created_at,updated_at) VALUES(?,?,NOW(),NOW()) ON DUPLICATE KEY UPDATE setting_value=VALUES(setting_value),updated_at=NOW()');
    foreach ($values as $key => $value) {
        $stmt->execute([$key, number_format((float)$value, 4, '.', '')]);
    }
}

function money(float $value): string {
    return '$' . number_format($value, 2, '.', ',');
}

function pct(float $value): string {
    return number_format($value, 2, '.', '') . '%';
}

function sale_from_cost(float $cost, float $marginPct): float {
    $margin = max(0.0, min(99.99, $marginPct)) / 100;
    return $margin >= 0.9999 ? $cost : $cost / (1 - $margin);
}

function calc_bastidor(array $input): array {
    $wCm = max(0.0, (float)($input['width_cm'] ?? 0));
    $hCm = max(0.0, (float)($input['height_cm'] ?? 0));
    $crossbars = max(0, (int)($input['crossbars'] ?? 0));
    $ptrRate = max(0.0, (float)($input['ptr_m'] ?? 0));
    $canvasRate = max(0.0, (float)($input['canvas_m2'] ?? 0));
    $printRate = max(0.0, (float)($input['print_m2'] ?? 0));
    $laborHours = max(0.0, (float)($input['labor_hours'] ?? 0));
    $laborRate = max(0.0, (float)($input['labor_hour'] ?? 0));
    $wastePct = max(0.0, min(100.0, (float)($input['waste_pct'] ?? 0)));
    $marginPct = max(0.0, min(99.0, (float)($input['margin_pct'] ?? 0)));

    $w = $wCm / 100;
    $h = $hCm / 100;
    $area = $w * $h;
    $perimeter = 2 * ($w + $h);
    $ptrMeters = $perimeter + ($crossbars * $w);
    $wasteFactor = 1 + ($wastePct / 100);

    $ptrCost = $ptrMeters * $ptrRate * $wasteFactor;
    $canvasCost = $area * $canvasRate * $wasteFactor;
    $printCost = $area * $printRate * $wasteFactor;
    $laborCost = $laborHours * $laborRate;
    $cost = $ptrCost + $canvasCost + $printCost + $laborCost;
    $sale = sale_from_cost($cost, $marginPct);

    return [
        'area' => $area,
        'perimeter' => $perimeter,
        'ptr_meters' => $ptrMeters,
        'ptr_cost' => $ptrCost,
        'canvas_cost' => $canvasCost,
        'print_cost' => $printCost,
        'labor_cost' => $laborCost,
        'cost' => $cost,
        'margin_pct' => $marginPct,
        'profit' => $sale - $cost,
        'sale' => $sale,
        'unit_sale' => $sale,
    ];
}

function calc_cnc(array $input): array {
    $wCm = max(0.0, (float)($input['width_cm'] ?? 0));
    $hCm = max(0.0, (float)($input['height_cm'] ?? 0));
    $qty = max(1, (int)($input['quantity'] ?? 1));
    $materialRate = max(0.0, (float)($input['material_m2'] ?? 0));
    $consumptionPct = max(0.0, min(100.0, (float)($input['consumption_pct'] ?? 0)));
    $machineMinutes = max(0.0, (float)($input['machine_minutes'] ?? 0));
    $setupMinutes = max(0.0, (float)($input['setup_minutes'] ?? 0));
    $machineRate = max(0.0, (float)($input['machine_hour'] ?? 0));
    $laborMinutes = max(0.0, (float)($input['labor_minutes'] ?? 0));
    $laborRate = max(0.0, (float)($input['labor_hour'] ?? 0));
    $marginPct = max(0.0, min(99.0, (float)($input['margin_pct'] ?? 0)));

    $area = ($wCm / 100) * ($hCm / 100);
    $materialArea = $area * $qty * (1 + $consumptionPct / 100);
    $materialCost = $materialArea * $materialRate;
    $machineHours = ($setupMinutes + ($machineMinutes * $qty)) / 60;
    $machineCost = $machineHours * $machineRate;
    $laborHours = ($laborMinutes * $qty) / 60;
    $laborCost = $laborHours * $laborRate;
    $cost = $materialCost + $machineCost + $laborCost;
    $sale = sale_from_cost($cost, $marginPct);

    return [
        'area_piece' => $area,
        'material_area' => $materialArea,
        'material_cost' => $materialCost,
        'machine_hours' => $machineHours,
        'machine_cost' => $machineCost,
        'labor_hours' => $laborHours,
        'labor_cost' => $laborCost,
        'cost' => $cost,
        'margin_pct' => $marginPct,
        'profit' => $sale - $cost,
        'sale' => $sale,
        'unit_cost' => $cost / $qty,
        'unit_sale' => $sale / $qty,
        'quantity' => $qty,
    ];
}
