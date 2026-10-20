<?php
declare(strict_types=1);

/**
 * Diagnóstico temporal de admin/impresion_precios.php
 * NO modifica la base de datos.
 * Eliminar después de terminar la prueba.
 */

header('Content-Type: text/html; charset=UTF-8');

$results = [];
$pdo = null;

function esc($value): string {
    return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
}

function ok(string $name, string $detail = ''): void {
    global $results;
    $results[] = ['OK', $name, $detail];
}

function fail(string $name, Throwable $e): void {
    global $results;
    $results[] = ['ERROR', $name, get_class($e) . ': ' . $e->getMessage()];
}

try {
    require_once __DIR__ . '/../config/bootstrap.php';
    ok('bootstrap.php', 'Cargado correctamente.');
} catch (Throwable $e) {
    fail('bootstrap.php', $e);
}

try {
    if (!function_exists('cp_db')) {
        throw new RuntimeException('La función cp_db() no existe después de cargar bootstrap.php.');
    }
    $pdo = cp_db();
    ok('cp_db()', 'Conexión PDO obtenida correctamente.');
} catch (Throwable $e) {
    fail('cp_db()', $e);
}

if ($pdo instanceof PDO) {
    $tests = [
        'cp_print_sizes' => 'SELECT COUNT(*) FROM cp_print_sizes',
        'cp_print_materials' => 'SELECT COUNT(*) FROM cp_print_materials',
        'cp_print_finishes' => 'SELECT COUNT(*) FROM cp_print_finishes',
        'cp_print_prices' => 'SELECT COUNT(*) FROM cp_print_prices',
    ];

    foreach ($tests as $name => $sql) {
        try {
            $count = (int)$pdo->query($sql)->fetchColumn();
            ok($name, 'Tabla accesible. Registros: ' . $count);
        } catch (Throwable $e) {
            fail($name, $e);
        }
    }

    try {
        $sql = "SELECT
                    p.id,
                    p.size_id,
                    p.material_id,
                    p.finish_id,
                    p.color_mode,
                    p.side_mode,
                    p.min_qty,
                    p.price,
                    p.enabled,
                    s.name AS size_name,
                    m.name AS material_name,
                    f.name AS finish_name
                FROM cp_print_prices p
                INNER JOIN cp_print_sizes s ON s.id = p.size_id
                INNER JOIN cp_print_materials m ON m.id = p.material_id
                INNER JOIN cp_print_finishes f ON f.id = p.finish_id
                ORDER BY s.sort_order, m.sort_order, f.sort_order, p.color_mode, p.side_mode, p.min_qty, p.id
                LIMIT 1";
        $stmt = $pdo->query($sql);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        ok('Consulta completa de tarifas', $row
            ? 'JOIN correcto. Se encontró al menos una tarifa.'
            : 'JOIN correcto, pero no hay tarifas.');
    } catch (Throwable $e) {
        fail('Consulta completa de tarifas', $e);
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
<title>Diagnóstico impresión precios</title>
<style>
body{font-family:Arial,sans-serif;background:#f4f6f8;margin:0;padding:24px;color:#1f2937}
.wrap{max-width:1000px;margin:auto;background:#fff;border-radius:12px;padding:24px;box-shadow:0 4px 20px rgba(0,0,0,.08)}
h1{margin-top:0}
.status{padding:14px;border-radius:8px;margin-bottom:18px;font-weight:700;background:<?= $hasError ? '#fee2e2' : '#dcfce7' ?>;color:<?= $hasError ? '#991b1b' : '#166534' ?>}
table{width:100%;border-collapse:collapse}
th,td{padding:12px;border-bottom:1px solid #e5e7eb;text-align:left;vertical-align:top}
th{background:#f9fafb}
.ok{color:#166534;font-weight:700}
.err{color:#b91c1c;font-weight:700}
code{white-space:pre-wrap;word-break:break-word}
.note{margin-top:20px;color:#6b7280;font-size:13px}
</style>
</head>
<body>
<div class="wrap">
<h1>Diagnóstico de impresión_precios.php</h1>
<div class="status"><?= $hasError ? 'SE ENCONTRÓ UN ERROR' : 'PRUEBAS BÁSICAS CORRECTAS' ?></div>
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
Archivo temporal de diagnóstico. No realiza INSERT, UPDATE ni DELETE.
Después de la prueba, elimínalo de cPanel.
</div>
</div>
</body>
</html>
