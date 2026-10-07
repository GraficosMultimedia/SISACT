<?php
declare(strict_types=1);

/*
 * Diagnóstico temporal para Colibrí Print México.
 * IMPORTANTE: eliminar este archivo después de usarlo.
 * No muestra ni expone tokens, contraseñas ni datos sensibles.
 */

header('Content-Type: text/html; charset=UTF-8');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');

function escd($v): string {
    return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8');
}
function okrow(string $label, string $value='OK'): void {
    echo '<div class="row ok"><b>✓ '.escd($label).'</b><span>'.escd($value).'</span></div>';
}
function failrow(string $label, string $value): void {
    echo '<div class="row fail"><b>✕ '.escd($label).'</b><span>'.escd($value).'</span></div>';
}
function section(string $title): void {
    echo '<h2>'.escd($title).'</h2>';
}
function shortException(Throwable $e): string {
    return get_class($e) . ': ' . $e->getMessage() . ' @ línea ' . $e->getLine();
}

echo '<!doctype html><html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">';
echo '<title>Diagnóstico PDF - Colibrí Print México</title>';
echo '<style>body{margin:0;background:#071019;color:#eaf0f6;font:14px Arial,sans-serif;padding:24px}.wrap{max-width:900px;margin:auto}.card{background:#0e1721;border:1px solid #22384c;border-radius:18px;padding:22px;margin:14px 0}h1{font-size:28px;margin:0 0 8px}h2{font-size:16px;color:#ffbf19;margin:28px 0 10px}.row{display:flex;justify-content:space-between;gap:20px;padding:10px 12px;border-radius:10px;margin:5px 0}.ok{background:#09251b;border:1px solid #145b42}.fail{background:#2a1117;border:1px solid #762335}.row span{color:#aebdca;text-align:right;word-break:break-word}.warn{background:#251e09;border:1px solid #75601a;padding:13px;border-radius:12px;color:#ffe28a}.mono{font-family:Consolas,monospace;font-size:12px;background:#081018;border:1px solid #1d3040;padding:12px;border-radius:10px;white-space:pre-wrap;word-break:break-word}</style></head><body><div class="wrap">';
echo '<div class="card"><h1>Diagnóstico de orden_pdf.php</h1><p>Este diagnóstico comprueba el entorno real de producción y detecta el punto exacto del HTTP 500. No genera ni publica el PDF.</p><div class="warn">Cuando terminemos, elimina este archivo del servidor.</div></div>';

section('1. Entorno PHP');
okrow('PHP', PHP_VERSION);
okrow('SAPI', php_sapi_name());
okrow('DOCUMENT_ROOT', $_SERVER['DOCUMENT_ROOT'] ?? '(vacío)');
okrow('Extensión PDO', extension_loaded('pdo') ? 'Sí' : 'No');
okrow('PDO MySQL', extension_loaded('pdo_mysql') ? 'Sí' : 'No');
okrow('iconv', extension_loaded('iconv') ? 'Sí' : 'No');
okrow('mbstring', extension_loaded('mbstring') ? 'Sí' : 'No');

section('2. Archivos requeridos');
$required = [
    '/config/runtime.php',
    '/includes/actions.php',
    '/includes/ordenes.php',
    '/includes/cotizaciones.php',
    '/includes/finanzas.php',
    '/includes/produccion.php',
];
foreach ($required as $f) {
    $abs = __DIR__ . $f;
    if (is_file($abs)) okrow($f, 'Existe');
    else failrow($f, 'NO EXISTE');
}

section('3. Carga de dependencias');
$loadResults = [];
foreach ($required as $f) {
    try {
        require_once __DIR__ . $f;
        $loadResults[$f] = true;
        okrow('Carga '.$f, 'OK');
    } catch (Throwable $e) {
        $loadResults[$f] = false;
        failrow('Carga '.$f, shortException($e));
    }
}

$functions = [
    'db','current_user','require_auth','order_get','order_items','order_history',
    'quote_get','finance_payment_list','finance_order_summary',
    'production_get_stage','production_stage_label','company_profile'
];

section('4. Funciones necesarias');
foreach ($functions as $fn) {
    if (function_exists($fn)) okrow($fn, 'Disponible');
    else failrow($fn, 'NO DISPONIBLE');
}

section('5. Sesión / autenticación');
try {
    if (function_exists('current_user')) {
        $u = current_user();
        okrow('current_user()', is_array($u) ? 'Respuesta recibida' : 'Sin usuario');
    } else {
        failrow('current_user()', 'La función no existe');
    }
    if (function_exists('require_auth')) {
        okrow('require_auth()', 'La función existe');
    }
} catch (Throwable $e) {
    failrow('Autenticación', shortException($e));
}

section('6. Base de datos');
$pdo = null;
try {
    if (!function_exists('db')) throw new RuntimeException('db() no existe');
    $pdo = db();
    okrow('db()', 'Conexión obtenida');
    okrow('PDO driver', (string)$pdo->getAttribute(PDO::ATTR_DRIVER_NAME));
    $tables = ['cp_orders','cp_order_items','cp_order_history','cp_quotes','cp_quote_items','cp_payments','cp_customers','cp_settings'];
    foreach ($tables as $table) {
        try {
            $st = $pdo->query("SHOW TABLES LIKE " . $pdo->quote($table));
            okrow($table, $st->fetchColumn() ? 'Existe' : 'NO EXISTE');
        } catch (Throwable $e) {
            failrow($table, shortException($e));
        }
    }
} catch (Throwable $e) {
    failrow('Conexión DB', shortException($e));
}

$id=(int)($_GET['id'] ?? 14);
section('7. Prueba con orden #'.$id);
$order=null;

foreach ([
    'order_get'=>function()use($id){return order_get($id);},
    'order_items'=>function()use($id){return order_items($id);},
    'order_history'=>function()use($id){return order_history($id);},
    'finance_payment_list'=>function()use($id){return finance_payment_list($id);},
    'finance_order_summary'=>function()use($id){return finance_order_summary($id);},
    'production_get_stage'=>function()use($id){return production_get_stage($id);},
    'company_profile'=>function(){return company_profile();},
] as $name=>$call) {
    try {
        $v=$call();
        $summary=is_array($v) ? ('array('.count($v).')') : gettype($v);
        if ($name==='order_get') {
            $order=is_array($v)?$v:null;
            if (!$order) $summary='Orden no encontrada';
        }
        okrow($name.'()', $summary);
    } catch (Throwable $e) {
        failrow($name.'()', shortException($e));
    }
}

if ($order) {
    section('8. Campos críticos de orden');
    foreach (['id','order_number','quote_id','customer_id','status','order_date','due_date','total','customer_name','created_at','updated_at'] as $k) {
        if (array_key_exists($k,$order)) {
            $v=$order[$k];
            if (in_array($k,['customer_name'],true)) $v=$v!==null?'Presente':'Vacío';
            okrow($k, is_scalar($v)?(string)$v:'Presente');
        } else {
            failrow($k,'No existe en order_get()');
        }
    }
}

section('9. Renderer PDF');
$renderer=__DIR__.'/includes/orden_pdf_renderer.php';
if (is_file($renderer)) {
    try {
        require_once $renderer;
        okrow('includes/orden_pdf_renderer.php','Cargado');
        foreach(['CorporateOrderPdf','generate_order_pdf','cwrap','cmoney','cdate','cstatus'] as $fnOrClass) {
            if (class_exists($fnOrClass) || function_exists($fnOrClass)) okrow($fnOrClass,'Disponible');
            else failrow($fnOrClass,'NO DISPONIBLE');
        }
    } catch (Throwable $e) {
        failrow('Carga renderer', shortException($e));
    }
} else {
    failrow('includes/orden_pdf_renderer.php','NO EXISTE');
}

section('10. Resultado');
echo '<div class="card"><div class="mono">Si aparece una fila ✕, esa es la zona que debemos corregir. Envía una captura de esta página o copia las filas con ✕.</div></div>';

echo '</div></body></html>';
