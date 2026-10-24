<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';

const CP22_MARKER = 'SISACT_TRACKING_VISUAL_MOTION_V2_2';
const CP22_BASE_MARKER = 'SISACT_TRACKING_VISUAL_POLISH_V2_1';

$root = dirname(__DIR__);
$target = $root . '/seguimiento.php';
$backup = $root . '/seguimiento.php.bak_tracking_visual_v2_2';
$cssRel = '/assets/css/seguimiento-visual-motion-v2-2.css?v=20261024-1';
$jsRel  = '/assets/js/seguimiento-visual-motion-v2-2.js?v=20261024-1';
$message = '';
$type = 'info';

function cp22_h(string $v): string { return htmlspecialchars($v, ENT_QUOTES, 'UTF-8'); }

if (!is_file($target)) {
    http_response_code(500);
    exit('No se encontró seguimiento.php');
}

$current = (string)file_get_contents($target);
$baseDetected = str_contains($current, CP22_BASE_MARKER) || str_contains($current, 'seguimiento-visual-ofertas-v2-1.css');
$installed = str_contains($current, CP22_MARKER) || str_contains($current, 'seguimiento-visual-motion-v2-2.css');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = (string)($_POST['action'] ?? '');

    if ($action === 'install') {
        if (!$baseDetected) {
            $message = 'No se detectó V2.1. Instalación detenida sin cambios.';
            $type = 'error';
        } elseif ($installed) {
            $message = 'V2.2 ya está instalada.';
            $type = 'ok';
        } else {
            if (!is_file($backup)) {
                if (!copy($target, $backup)) {
                    throw new RuntimeException('No fue posible crear el respaldo de seguimiento.php');
                }
            }

            $cssAnchor = '<link rel="stylesheet" href="/assets/css/seguimiento-visual-ofertas-v2-1.css?v=20261024-1">';
            $jsAnchor  = '<script src="/assets/js/seguimiento-visual-ofertas-v2-1.js?v=20261024-1" defer></script>';

            if (!str_contains($current, $cssAnchor) || !str_contains($current, $jsAnchor)) {
                throw new RuntimeException('No se encontraron los anchors esperados de V2.1 en seguimiento.php');
            }

            $current = str_replace(
                $cssAnchor,
                $cssAnchor . "\n<link rel=\"stylesheet\" href=\"{$cssRel}\">\n<!-- " . CP22_MARKER . ' -->',
                $current
            );
            $current = str_replace(
                $jsAnchor,
                $jsAnchor . "\n<script src=\"{$jsRel}\" defer></script>",
                $current
            );

            if (file_put_contents($target, $current, LOCK_EX) === false) {
                throw new RuntimeException('No fue posible actualizar seguimiento.php');
            }

            $message = 'V2.2 Visual Motion instalada correctamente.';
            $type = 'ok';
            $installed = true;
        }
    } elseif ($action === 'revert') {
        if (!is_file($backup)) {
            $message = 'No existe respaldo V2.2 para revertir.';
            $type = 'error';
        } elseif (!copy($backup, $target)) {
            $message = 'No se pudo restaurar el respaldo.';
            $type = 'error';
        } else {
            $message = 'V2.2 revertida. seguimiento.php volvió al estado inmediatamente anterior.';
            $type = 'ok';
            $installed = false;
        }
    }
}
?>
<!doctype html><html lang="es-MX"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Seguimiento V2.2 Visual Motion</title>
<style>
body{margin:0;background:#061426;color:#eaf6ff;font:14px system-ui,-apple-system,Segoe UI,sans-serif}.wrap{max-width:900px;margin:38px auto;padding:26px}.panel{border:1px solid #1b4c78;border-radius:20px;background:#0a2039;padding:24px;box-shadow:0 20px 60px #0005}h1{margin:0 0 8px;font-size:27px}.sub{color:#9fc5e5;line-height:1.6}.status{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin:22px 0}.card{padding:14px;border:1px solid #1f527f;border-radius:13px;background:#0b2847}.card span{display:block;color:#7eb3dc;font-size:11px}.card strong{display:block;margin-top:5px;color:#5ff3cf}.msg{padding:13px 15px;border-radius:12px;margin:16px 0}.ok{background:#07392f;border:1px solid #168b6d}.error{background:#401c28;border:1px solid #a43c5c}.info{background:#0b2d4c;border:1px solid #1e5b87}.actions{display:flex;gap:10px;flex-wrap:wrap}.actions button,.actions a{border:0;border-radius:11px;padding:12px 16px;font-weight:800;text-decoration:none;cursor:pointer}.install{background:linear-gradient(135deg,#0788ef,#22d4e9);color:white}.revert{background:#163b5e;color:#e9f6ff;border:1px solid #2d608d!important}.open{background:#fff;color:#07315e}.features{margin:20px 0;padding:16px;border-radius:14px;background:#082a4b;color:#c8e2f7;line-height:1.7}.features b{color:#fff}@media(max-width:700px){.wrap{margin:0;padding:12px}.status{grid-template-columns:1fr}}
</style></head><body><div class="wrap"><div class="panel"><h1>Seguimiento Visual Motion V2.2</h1><p class="sub">Tema dark-premium, iconografía SVG, microanimaciones y protección de orientación vertical para móvil.</p>
<?php if ($message !== ''): ?><div class="msg <?=cp22_h($type)?>"><?=cp22_h($message)?></div><?php endif; ?>
<div class="status"><div class="card"><span>Base V2.1</span><strong><?=$baseDetected?'✓ detectada':'✕ no detectada'?></strong></div><div class="card"><span>V2.2</span><strong><?=$installed?'✓ instalada':'Pendiente'?></strong></div><div class="card"><span>Base de datos</span><strong>Sin cambios</strong></div></div>
<div class="features"><b>Incluye:</b> tema azul marino/cyan inspirado en el mockup aprobado · iconos SVG propios · pulso de etapa actual · tarjetas con entrada suave · CTA con brillo · optimización mobile-first · carrusel de ofertas · overlay de orientación horizontal con efecto de gravedad.</div>
<div class="actions"><form method="post"><input type="hidden" name="action" value="install"><button class="install">Instalar V2.2</button></form><a class="open" href="/seguimiento.php" target="_blank">Abrir seguimiento</a><form method="post"><input type="hidden" name="action" value="revert"><button class="revert">Revertir V2.2</button></form></div>
</div></div></body></html>
