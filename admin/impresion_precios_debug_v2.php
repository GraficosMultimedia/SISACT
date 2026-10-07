<?php
declare(strict_types=1);

/**
 * Diagnóstico temporal v2 para admin/impresion_precios.php
 * IMPORTANTE: este archivo NO modifica la base de datos.
 */

header('Content-Type: text/html; charset=UTF-8');

$results = [];

function esc($v): string {
    return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8');
}

function add_ok(string $test, string $detail): void {
    global $results;
    $results[] = ['OK', $test, $detail];
}

function add_error(string $test, Throwable $e): void {
    global $results;
    $results[] = ['ERROR', $test, get_class($e) . ': ' . $e->getMessage()];
}

try {
    require_once __DIR__ . '/../config/bootstrap.php';
    add_ok('bootstrap.php', 'Cargado correctamente.');
} catch (Throwable $e) {
    add_error('bootstrap.php', $e);
}

$db = null;

try {
    if (!function_exists('cp_db')) {
        throw new RuntimeException('cp_db() no está disponible.');
    }
    $db = cp_db();
    add_ok('cp_db()', 'Conexión PDO obtenida correctamente.');
} catch (Throwable $e) {
    add_error('cp_db()', $e);
}

if ($db instanceof PDO) {
    $tableTests = [
        'cp_print_sizes' => 'SELECT COUNT(*) FROM cp_print_sizes',
        'cp_print_materials' => 'SELECT COUNT(*) FROM cp_print_materials',
        'cp_print_finishes' => 'SELECT COUNT(*) FROM cp_print_finishes',
        'cp_print_prices' => 'SELECT COUNT(*) FROM cp_print_prices',
    ];

    foreach ($tableTests as $name => $sql) {
        try {
            $count = (int)$db->query($sql)->fetchColumn();
            add_ok($name, "Tabla accesible. Registros: {$count}.");
        } catch (Throwable $e) {
            add_error($name, $e);
        }
    }

    // Mostrar columnas reales de cp_print_prices sin exponer datos sensibles.
    try {
        $columns = $db->query('SHOW COLUMNS FROM cp_print_prices')->fetchAll(PDO::FETCH_COLUMN);
        add_ok('Columnas cp_print_prices', implode(', ', $columns));
    } catch (Throwable $e) {
        add_error('Columnas cp_print_prices', $e);
    }

    // EXACTAMENTE la consulta que usa el impresion_precios.php de GitHub actual.
    try {
        $sql = "
            SELECT
                p.*,
                s.name AS size_name,
                m.name AS material_name,
                f.name AS finish_name
            FROM cp_print_prices p
            JOIN cp_print_sizes s ON s.id = p.size_id
            JOIN cp_print_materials m ON m.id = p.material_id
            JOIN cp_print_finishes f ON f.id = p.finish_id
            ORDER BY s.sort_order,m.sort_order,f.sort_order,p.color_mode
        ";
        $rows = $db->query($sql)->fetchAll(PDO::FETCH_ASSOC);
        add_ok('Consulta exacta de impresion_precios.php', 'Consulta ejecutada correctamente. Registros: ' . count($rows) . '.');
    } catch (Throwable $e) {
        add_error('Consulta exacta de impresion_precios.php', $e);
    }

    // También verificamos las tres consultas iniciales del archivo.
    $catalogQueries = [
        'Consulta tamaños' => 'SELECT * FROM cp_print_sizes ORDER BY sort_order,id',
        'Consulta materiales' => 'SELECT * FROM cp_print_materials ORDER BY sort_order,id',
        'Consulta acabados' => 'SELECT * FROM cp_print_finishes ORDER BY sort_order,id',
    ];

    foreach ($catalogQueries as $name => $sql) {
        try {
            $rows = $db->query($sql)->fetchAll(PDO::FETCH_ASSOC);
            add_ok($name, 'Consulta ejecutada correctamente. Registros: ' . count($rows) . '.');
        } catch (Throwable $e) {
            add_error($name, $e);
        }
    }
}

$hasError = false;
foreach ($results as $r) {
    if ($r[0] === 'ERROR') {
        $hasError = true;
        break;
    }
}
?>
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Diagnóstico impresión precios v2</title>
<style>
body{font-family:Arial,sans-serif;background:#f4f6f8;margin:0;padding:24px;color:#1f2937}
.wrap{max-width:1100px;margin:auto;background:#fff;border-radius:12px;padding:24px;box-shadow:0 4px 20px rgba(0,0,0,.08)}
h1{margin-top:0}.status{padding:14px;border-radius:8px;margin-bottom:18px;font-weight:700}
.okbox{background:#dcfce7;color:#166534}.errbox{background:#fee2e2;color:#991b1b}
table{width:100%;border-collapse:collapse}th,td{padding:11px;border-bottom:1px solid #e5e7eb;text-align:left;vertical-align:top}
th{background:#f9fafb}.ok{color:#166534;font-weight:700}.err{color:#b91c1c;font-weight:700}
code{white-space:pre-wrap;word-break:break-word}.note{margin-top:20px;color:#6b7280;font-size:13px}
</style>
</head>
<body>
<div class="wrap">
<h1>Diagnóstico de impresión_precios.php v2</h1>
<div class="status <?= $hasError ? 'errbox' : 'okbox' ?>">
<?= $hasError ? 'SE ENCONTRÓ UN ERROR REAL' : 'TODAS LAS PRUEBAS CORRECTAS' ?>
</div>
<table>
<thead><tr><th>Estado</th><th>Prueba</th><th>Resultado</th></tr></thead>
<tbody>
<?php foreach ($results as $r): ?>
<tr>
<td class="<?= $r[0] === 'OK' ? 'ok' : 'err' ?>"><?= esc($r[0]) ?></td>
<td><?= esc($r[1]) ?></td>
<td><code><?= esc($r[2]) ?></code></td>
</tr>
<?php endforeach; ?>
</tbody>
</table>
<div class="note">
Diagnóstico temporal v2. No realiza INSERT, UPDATE ni DELETE. Elimina este archivo de cPanel después de la prueba.
</div>
</div>
</body>
</html>
