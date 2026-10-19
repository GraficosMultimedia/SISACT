<?php
declare(strict_types=1);

// Catálogo y puente del cotizador láser. Usa cp_settings y la sesión existentes.
const CP_LASER_SETTINGS_KEY = 'calculator.laser.v2';

class CpLaserVersionConflict extends RuntimeException {}

function cp_laser_number($value, string $label, float $min = 0, float $max = 1000000000, bool $optional = false): ?float {
    if ($value === '' || $value === null) {
        if ($optional) return null;
        throw new InvalidArgumentException('Captura ' . $label . '.');
    }
    if ((!is_int($value) && !is_float($value) && !is_string($value)) || !is_numeric($value)) {
        throw new InvalidArgumentException('Revisa ' . $label . '.');
    }
    $n = (float)$value;
    if (!is_finite($n) || $n < $min || $n > $max) throw new InvalidArgumentException('Revisa ' . $label . '.');
    return $n;
}

function cp_laser_text($value, string $label, int $limit, bool $required = false): string {
    if (!is_string($value) && !is_int($value) && !is_float($value) && $value !== null) throw new InvalidArgumentException('Revisa ' . $label . '.');
    $text = trim((string)$value);
    if (!preg_match('//u', $text) || preg_match_all('/./us', $text) > $limit || ($required && $text === '')) {
        throw new InvalidArgumentException('Revisa ' . $label . '.');
    }
    return $text;
}

function cp_laser_initial_state(): array {
    $materials = [];
    foreach ([3, 6, 9, 12, 15] as $thickness) {
        $materials[] = ['id'=>'mdf-' . $thickness, 'name'=>'MDF', 'thickness'=>$thickness, 'sheetWidth'=>null, 'sheetHeight'=>null, 'sheetPrice'=>null];
    }
    foreach ([3, 6] as $thickness) {
        $materials[] = ['id'=>'acrilico-' . $thickness, 'name'=>'Acrílico', 'thickness'=>$thickness, 'sheetWidth'=>null, 'sheetHeight'=>null, 'sheetPrice'=>null];
    }
    return [
        'schema'=>2,
        'machine'=>['width'=>90, 'height'=>60, 'power'=>100],
        'defaults'=>['rate'=>'', 'profit'=>'', 'profitMode'=>'markup', 'minimum'=>'', 'waste'=>'', 'tax'=>''],
        'materials'=>$materials,
    ];
}

function cp_laser_validate_state(array $input): array {
    $state = cp_laser_initial_state();
    $m = $input['machine'] ?? [];
    if (!is_array($m)) throw new InvalidArgumentException('Revisa los datos de la máquina.');
    foreach (['width', 'height', 'power'] as $key) $state['machine'][$key] = cp_laser_number($m[$key] ?? null, 'el área o potencia de la máquina', 0.01, 10000);
    $defaults = $input['defaults'] ?? [];
    if (!is_array($defaults)) throw new InvalidArgumentException('Revisa las tarifas.');
    $mode = $defaults['profitMode'] ?? 'markup';
    if (!in_array($mode, ['markup', 'margin'], true)) throw new InvalidArgumentException('Selecciona un método de utilidad válido.');
    $state['defaults']['profitMode'] = $mode;
    foreach (['rate', 'profit', 'minimum', 'waste', 'tax'] as $key) {
        $min = $key === 'rate' ? 0.01 : 0;
        $max = $key === 'profit' ? ($mode === 'margin' ? 99.99 : 10000) : (in_array($key, ['waste', 'tax'], true) ? 100 : 1000000000);
        $n = cp_laser_number($defaults[$key] ?? null, 'la tarifa ' . $key, $min, $max, true);
        $state['defaults'][$key] = $n === null ? '' : (string)$n;
    }
    $rows = $input['materials'] ?? null;
    if (!is_array($rows) || count($rows) > 150) throw new InvalidArgumentException('El catálogo admite hasta 150 materiales y espesores.');
    $ids = [];
    $names = [];
    $state['materials'] = [];
    foreach ($rows as $row) {
        if (!is_array($row)) throw new InvalidArgumentException('Revisa los materiales del catálogo.');
        $id = cp_laser_text($row['id'] ?? '', 'el identificador del material', 60, true);
        if (!preg_match('/^[A-Za-z0-9_-]+$/', $id) || isset($ids[$id])) throw new InvalidArgumentException('Hay identificadores de material repetidos o no válidos.');
        $name = cp_laser_text($row['name'] ?? '', 'el nombre del material', 80, true);
        $thickness = cp_laser_number($row['thickness'] ?? null, 'el espesor de ' . $name, 0.001, 1000);
        $normalized = strtr(strtolower((string)preg_replace('/\s+/u', ' ', $name)), ['Á'=>'á','É'=>'é','Í'=>'í','Ó'=>'ó','Ú'=>'ú','Ñ'=>'ñ','Ü'=>'ü']) . ':' . sprintf('%.4F', $thickness);
        if (isset($names[$normalized])) throw new InvalidArgumentException('Ya existe ' . $name . ' de ' . $thickness . ' mm. Edita ese registro.');
        $ids[$id] = true;
        $names[$normalized] = true;
        $state['materials'][] = [
            'id'=>$id, 'name'=>$name, 'thickness'=>$thickness,
            'sheetWidth'=>cp_laser_number($row['sheetWidth'] ?? null, 'el ancho de hoja de ' . $name, 0.01, 100000, true),
            'sheetHeight'=>cp_laser_number($row['sheetHeight'] ?? null, 'el largo de hoja de ' . $name, 0.01, 100000, true),
            'sheetPrice'=>cp_laser_number($row['sheetPrice'] ?? null, 'el costo de hoja de ' . $name, 0.01, 1000000000, true),
        ];
    }
    return $state;
}

function cp_laser_shared_state(): array {
    $stmt = db()->prepare('SELECT setting_value FROM cp_settings WHERE setting_key=? LIMIT 1');
    $stmt->execute([CP_LASER_SETTINGS_KEY]);
    $stored = $stmt->fetchColumn();
    $raw = $stored === false || $stored === null ? '' : (string)$stored;
    if ($raw === '') return ['state'=>cp_laser_initial_state(), 'version'=>hash('sha256', ''), 'exists'=>false];
    $decoded = json_decode($raw, true);
    if (!is_array($decoded)) throw new RuntimeException('No se pudo leer el catálogo láser guardado.');
    return ['state'=>cp_laser_validate_state($decoded), 'version'=>hash('sha256', $raw), 'exists'=>true];
}

function cp_laser_save_shared(array $input, string $expectedVersion, int $userId): array {
    $state = cp_laser_validate_state($input);
    $state['updated_at'] = date('c');
    $state['updated_by'] = $userId;
    $json = json_encode($state, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    if (!is_string($json) || strlen($json) > 60000) throw new InvalidArgumentException('El catálogo excede el espacio disponible. Reduce los nombres o la cantidad de registros.');
    $pdo = db();
    $pdo->beginTransaction();
    try {
        $pdo->prepare('INSERT IGNORE INTO cp_settings(setting_key,setting_value,created_at,updated_at) VALUES(?,?,NOW(),NOW())')->execute([CP_LASER_SETTINGS_KEY, '']);
        $stmt = $pdo->prepare('SELECT setting_value FROM cp_settings WHERE setting_key=? FOR UPDATE');
        $stmt->execute([CP_LASER_SETTINGS_KEY]);
        $current = (string)$stmt->fetchColumn();
        if (!hash_equals(hash('sha256', $current), $expectedVersion)) {
            throw new CpLaserVersionConflict('Otro usuario actualizó las tarifas o el catálogo. Recarga el catálogo y vuelve a aplicar tus cambios.');
        }
        $pdo->prepare('UPDATE cp_settings SET setting_value=?,updated_at=NOW() WHERE setting_key=?')->execute([$json, CP_LASER_SETTINGS_KEY]);
        $pdo->commit();
    } catch (Throwable $error) {
        if ($pdo->inTransaction()) $pdo->rollBack();
        throw $error;
    }
    return ['state'=>cp_laser_validate_state($state), 'version'=>hash('sha256', $json), 'exists'=>true];
}

function cp_laser_calculate(array $job, array $machine): array {
    $q = cp_laser_number($job['quantity'] ?? null, 'la cantidad de piezas', 1, 1000000);
    if (floor($q) !== $q) throw new InvalidArgumentException('La cantidad de piezas debe ser un número entero.');
    $w = cp_laser_number($job['width'] ?? null, 'el ancho de la pieza', 0.01, 10000);
    $h = cp_laser_number($job['height'] ?? null, 'el alto de la pieza', 0.01, 10000);
    $bedW = cp_laser_number($machine['width'] ?? null, 'el ancho útil de la máquina', 0.01, 10000);
    $bedH = cp_laser_number($machine['height'] ?? null, 'el alto útil de la máquina', 0.01, 10000);
    cp_laser_number($machine['power'] ?? null, 'la potencia de la máquina', 0.01, 10000);
    if (!(($w <= $bedW && $h <= $bedH) || ($h <= $bedW && $w <= $bedH))) throw new InvalidArgumentException('La pieza no cabe en el área de trabajo de la máquina.');
    $optional = static function(string $key, float $max = 1000000000) use ($job): float {
        return cp_laser_number($job[$key] ?? null, $key, 0, $max, true) ?? 0.0;
    };
    $thickness = $optional('thickness', 1000);
    $supply = $job['supply'] ?? '';
    if (!in_array($supply, ['shop', 'customer'], true)) throw new InvalidArgumentException('Selecciona quién proporciona el material.');
    $materialCost = 0.0;
    if ($supply === 'shop') {
        $sw = cp_laser_number($job['sheetWidth'] ?? null, 'el ancho de hoja', 0.01, 100000);
        $sh = cp_laser_number($job['sheetHeight'] ?? null, 'el largo de hoja', 0.01, 100000);
        $sp = cp_laser_number($job['sheetPrice'] ?? null, 'el costo de hoja', 0.01, 1000000000);
        $waste = $optional('waste', 100);
        $fit = max(floor(($sw + 0.00000001) / $w) * floor(($sh + 0.00000001) / $h), floor(($sw + 0.00000001) / $h) * floor(($sh + 0.00000001) / $w));
        if ($fit < 1) throw new InvalidArgumentException('La pieza no cabe en la hoja de material.');
        $chargeMode = $job['chargeMode'] ?? '';
        if (!in_array($chargeMode, ['area', 'sheets'], true)) throw new InvalidArgumentException('Selecciona cómo se cobra el material.');
        $materialCost = round($chargeMode === 'sheets' ? ceil(($q * (1 + $waste / 100) - 0.0000000001) / $fit) * $sp : $w * $h * $q * (1 + $waste / 100) / ($sw * $sh) * $sp, 2);
    }
    $cut = $optional('cutMinutes', 1000000);
    $engrave = $optional('engraveMinutes', 1000000);
    if ($cut + $engrave <= 0) throw new InvalidArgumentException('Captura al menos un tiempo de corte o grabado mayor a cero.');
    $basis = $job['timeBasis'] ?? '';
    if (!in_array($basis, ['unit', 'batch'], true)) throw new InvalidArgumentException('Selecciona si el tiempo es por pieza o por lote.');
    $rate = cp_laser_number($job['rate'] ?? null, 'el costo de máquina por minuto', 0.01, 1000000000);
    $minutes = ($cut + $engrave) * ($basis === 'unit' ? $q : 1);
    $machineCost = round($minutes * $rate, 2);
    $design = $optional('design');
    $finishing = $optional('finishing');
    $cost = round($materialCost + $machineCost + $design + $finishing, 2);
    $mode = $job['profitMode'] ?? '';
    if (!in_array($mode, ['markup', 'margin'], true)) throw new InvalidArgumentException('Selecciona un método de utilidad válido.');
    $percent = $optional('profit', $mode === 'margin' ? 99.99 : 10000);
    $suggested = round($mode === 'margin' ? $cost / (1 - $percent / 100) : $cost * (1 + $percent / 100), 2);
    $base = round(max($suggested, $optional('minimum')), 2);
    if (!is_finite($base) || $base > 1000000000000) throw new InvalidArgumentException('El importe excede el límite del cotizador.');
    $discountPct = $optional('discount', 100);
    $taxPct = $optional('tax', 100);
    $discount = round($base * $discountPct / 100, 2);
    $subtotal = round($base - $discount, 2);
    $tax = round($subtotal * $taxPct / 100, 2);
    $total = round($subtotal + $tax, 2);
    $name = ($job['material'] ?? '') === 'Otro' ? cp_laser_text($job['customMaterial'] ?? '', 'el nombre del material', 80, true) : cp_laser_text($job['material'] ?? '', 'el nombre del material', 80, true);
    return [
        'quantity'=>(int)$q, 'width'=>$w, 'height'=>$h, 'thickness'=>$thickness, 'material_name'=>$name,
        'material_cost'=>$materialCost, 'machine_cost'=>$machineCost, 'design_cost'=>round($design,2), 'finishing_cost'=>round($finishing,2),
        'minutes'=>$minutes, 'cost'=>$cost, 'base'=>$base, 'discount'=>$discount, 'discount_pct'=>$discountPct,
        'subtotal'=>$subtotal, 'tax'=>$tax, 'tax_pct'=>$taxPct, 'total'=>$total,
        'profit'=>round($subtotal - $cost, 2), 'unit_piece_sale'=>round($total / $q, 2),
    ];
}

function cp_laser_prepare_quote(array $job, array $machine): array {
    $result = cp_laser_calculate($job, $machine);
    if ($result['base'] <= 0) throw new InvalidArgumentException('Revisa el precio de venta antes de usar el resultado en una cotización.');
    $title = cp_laser_text($job['title'] ?? '', 'el nombre del trabajo', 120);
    $notes = cp_laser_text($job['notes'] ?? '', 'las notas del cliente', 2000);
    $client = cp_laser_text($job['client'] ?? '', 'el cliente de referencia', 120);
    $desc = 'Corte y grabado láser' . ($title !== '' ? ' · ' . $title : '') . ' · Lote de ' . $result['quantity'] . ' piezas · ' . $result['material_name'];
    if ($result['thickness'] > 0) $desc .= ' de ' . $result['thickness'] . ' mm';
    $desc .= ' · ' . $result['width'] . ' × ' . $result['height'] . ' cm por pieza';
    if (($job['supply'] ?? '') === 'customer') $desc .= ' · Material del cliente';
    // Una partida por lote conserva centavos, descuento e impuesto sin duplicarlos.
    $result['sale'] = $result['base'];
    $result['unit_sale'] = $result['base'];
    $result['margin_pct'] = $result['subtotal'] > 0 ? round($result['profit'] / $result['subtotal'] * 100, 4) : 0;
    return [
        'source'=>'corte_laser', 'title'=>$desc,
        'input'=>[
            'quantity'=>$result['quantity'], 'width_cm'=>$result['width'], 'height_cm'=>$result['height'],
            'material'=>$result['material_name'], 'thickness_mm'=>$result['thickness'],
            'discount_pct'=>$result['discount_pct'], 'tax_pct'=>$result['tax_pct'],
            'notes'=>$notes, 'client_reference_name'=>$client,
        ],
        'result'=>$result, 'created_at'=>date('c'),
    ];
}
