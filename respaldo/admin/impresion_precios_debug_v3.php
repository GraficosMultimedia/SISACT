<?php
declare(strict_types=1);

/**
 * Diagnóstico temporal v3.
 * Reproduce la preparación de datos de admin/impresion_precios.php
 * y prueba header.php/footer.php por separado.
 * NO modifica la base de datos.
 */

header('Content-Type: text/html; charset=UTF-8');

$stage = 'inicio';
$results = [];

function esc3($v): string {
    return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8');
}

function ok3(string $test, string $detail = ''): void {
    global $results;
    $results[] = ['OK', $test, $detail];
}

function err3(string $test, string $detail): void {
    global $results;
    $results[] = ['ERROR', $test, $detail];
}

/*
 * Si PHP termina por un error fatal o por exit/die durante header/footer,
 * este shutdown handler muestra exactamente en qué etapa ocurrió.
 */
register_shutdown_function(function () {
    global $stage, $results;

    $fatal = error_get_last();
    $hasFatal = $fatal && in_array($fatal['type'], [
        E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR
    ], true);

    if ($hasFatal) {
        $results[] = [
            'ERROR',
            'FATAL durante ' . $stage,
            $fatal['message'] . ' en ' . $fatal['file'] . ':' . $fatal['line']
        ];
    } elseif ($stage !== 'fin') {
        $results[] = [
            'ERROR',
            'La ejecución terminó durante ' . $stage,
            'El script no llegó al siguiente marcador.'
        ];
    }

    if ($stage !== 'fin') {
        while (ob_get_level() > 0) {
            ob_end_clean();
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
        <title>Diagnóstico impresión precios v3</title>
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
        <h1>Diagnóstico de impresión_precios.php v3</h1>
        <div class="status <?= $hasError ? 'errbox' : 'okbox' ?>">
        <?= $hasError ? 'SE ENCONTRÓ UN ERROR' : 'PRUEBA COMPLETADA' ?>
        </div>
        <table>
        <thead><tr><th>Estado</th><th>Prueba</th><th>Resultado</th></tr></thead>
        <tbody>
        <?php foreach ($results as $r): ?>
        <tr>
        <td class="<?= $r[0] === 'OK' ? 'ok' : 'err' ?>"><?= esc3($r[0]) ?></td>
        <td><?= esc3($r[1]) ?></td>
        <td><code><?= esc3($r[2]) ?></code></td>
        </tr>
        <?php endforeach; ?>
        </tbody>
        </table>
        <div class="note">
        Diagnóstico temporal. No realiza INSERT, UPDATE ni DELETE.
        Elimina este archivo de cPanel después de la prueba.
        </div>
        </div>
        </body>
        </html>
        <?php
    }
});

try {
    $stage = 'bootstrap.php';
    require_once __DIR__ . '/../config/bootstrap.php';
    ok3('bootstrap.php', 'Cargado correctamente.');

    $stage = 'cp_db()';
    if (!function_exists('cp_db')) {
        throw new RuntimeException('cp_db() no está disponible.');
    }
    $db = cp_db();
    ok3('cp_db()', 'Conexión PDO obtenida correctamente.');

    $stage = 'consultas SQL';
    $sizes = $db->query("SELECT * FROM cp_print_sizes ORDER BY sort_order,id")->fetchAll();
    $materials = $db->query("SELECT * FROM cp_print_materials ORDER BY sort_order,id")->fetchAll();
    $finishes = $db->query("SELECT * FROM cp_print_finishes ORDER BY sort_order,id")->fetchAll();

    $prices = $db->query("
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
    ")->fetchAll();

    ok3('Consultas SQL de impresion_precios.php',
        "sizes=" . count($sizes) .
        ", materials=" . count($materials) .
        ", finishes=" . count($finishes) .
        ", prices=" . count($prices));

    $msg = $_GET['ok'] ?? '';
    $title = 'Configuración de impresión';

    /*
     * PRUEBA EXACTA DEL HEADER.
     * La salida se captura para que no rompa el diagnóstico.
     */
    $stage = 'includes/header.php';
    ob_start();
    require __DIR__ . '/../includes/header.php';
    $headerOutput = ob_get_clean();

    ok3('includes/header.php',
        'Cargado correctamente. Salida generada: ' . strlen($headerOutput) . ' bytes.');

    /*
     * PRUEBA DEL FOOTER.
     */
    $stage = 'includes/footer.php';
    ob_start();
    require __DIR__ . '/../includes/footer.php';
    $footerOutput = ob_get_clean();

    ok3('includes/footer.php',
        'Cargado correctamente. Salida generada: ' . strlen($footerOutput) . ' bytes.');

    $stage = 'fin';

} catch (Throwable $e) {
    $results[] = [
        'ERROR',
        'Excepción durante ' . $stage,
        get_class($e) . ': ' . $e->getMessage() .
        ' en ' . $e->getFile() . ':' . $e->getLine()
    ];
    $stage = 'fin';
}

/* Render normal cuando no hubo exit/fatal. */
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
<title>Diagnóstico impresión precios v3</title>
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
<h1>Diagnóstico de impresión_precios.php v3</h1>
<div class="status <?= $hasError ? 'errbox' : 'okbox' ?>">
<?= $hasError ? 'SE ENCONTRÓ UN ERROR' : 'PRUEBA COMPLETADA' ?>
</div>
<table>
<thead><tr><th>Estado</th><th>Prueba</th><th>Resultado</th></tr></thead>
<tbody>
<?php foreach ($results as $r): ?>
<tr>
<td class="<?= $r[0] === 'OK' ? 'ok' : 'err' ?>"><?= esc3($r[0]) ?></td>
<td><?= esc3($r[1]) ?></td>
<td><code><?= esc3($r[2]) ?></code></td>
</tr>
<?php endforeach; ?>
</tbody>
</table>
<div class="note">
Diagnóstico temporal v3. No realiza INSERT, UPDATE ni DELETE. Elimina este archivo de cPanel después de la prueba.
</div>
</div>
</body>
</html>
