<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();

$title = 'Mercado Pago · Fix Items V1.4.1';

$root = dirname(__DIR__);
$helperPath = $root . '/includes/mercadopago.php';
$backupPath = $helperPath . '.bak_mp_items_v1_4_1';

$error = null;
$messages = [];

function mp141_write(string $path, string $content): void
{
    $tmp = $path . '.mp141.tmp';

    if (file_put_contents($tmp, $content, LOCK_EX) === false) {
        throw new RuntimeException('No se pudo escribir el archivo temporal.');
    }

    $perms = @fileperms($path);
    if ($perms !== false) {
        @chmod($tmp, $perms & 0777);
    }

    if (!rename($tmp, $path)) {
        @unlink($tmp);
        throw new RuntimeException('No se pudo reemplazar includes/mercadopago.php.');
    }

    if (function_exists('opcache_invalidate')) {
        @opcache_invalidate($path, true);
    }
}

function mp141_patch(string $src): string
{
    if (str_contains($src, 'SISACT_MP_ITEMS_V1_4_1')) {
        return $src;
    }

    $payloadPos = strpos($src, '$payload = [');

    if ($payloadPos === false) {
        throw new RuntimeException(
            'No se encontró el bloque $payload en includes/mercadopago.php.'
        );
    }

    $testMarkers = [
        "if (\$cfg['mode'] === 'test')",
        "if(\$cfg['mode']==='test')",
    ];

    $testPos = false;

    foreach ($testMarkers as $marker) {
        $p = strpos($src, $marker, $payloadPos);
        if ($p !== false) {
            $testPos = $p;
            break;
        }
    }

    if ($testPos === false) {
        throw new RuntimeException(
            'No se encontró el bloque de modo test después del payload.'
        );
    }

    if (($testPos - $payloadPos) > 7000) {
        throw new RuntimeException(
            'El bloque payload encontrado es demasiado grande. Se canceló por seguridad.'
        );
    }

    $canonical = <<<'PHP'
/* SISACT_MP_ITEMS_V1_4_1
 * Payload mínimo verificado contra el error real devuelto por Mercado Pago.
 * En items[] NO enviar unit_measure ni total_amount para esta integración.
 */
$payload = [
    'type' => 'online',
    'processing_mode' => 'manual',
    'total_amount' => $amount,
    'external_reference' => $external,
    'config' => [
        'online' => [
            'success_url' => $returnBase . '&result=success',
            'failure_url' => $returnBase . '&result=failure',
            'pending_url' => $returnBase . '&result=pending',
            'auto_return' => 'approved',
        ],
    ],
    'items' => [[
        'title' => $title,
        'quantity' => 1,
        'unit_price' => $amount,
    ]],
];

PHP;

    $patched =
        substr($src, 0, $payloadPos)
        . $canonical
        . substr($src, $testPos);

    return $patched;
}

function mp141_payload_status(string $src): array
{
    $marker = str_contains($src, 'SISACT_MP_ITEMS_V1_4_1');

    $payloadPos = strpos($src, '$payload = [');
    if ($payloadPos === false) {
        return [
            'marker' => $marker,
            'payload_found' => false,
            'unit_measure' => null,
            'item_total_amount' => null,
        ];
    }

    $testPos = strpos($src, "if (\$cfg['mode'] === 'test')", $payloadPos);
    if ($testPos === false) {
        $testPos = strpos($src, "if(\$cfg['mode']==='test')", $payloadPos);
    }

    if ($testPos === false) {
        $testPos = min(strlen($src), $payloadPos + 7000);
    }

    $payload = substr($src, $payloadPos, $testPos - $payloadPos);

    return [
        'marker' => $marker,
        'payload_found' => true,
        'unit_measure' => str_contains($payload, "'unit_measure'"),
        /*
         * Hay total_amount correcto a nivel order.
         * Detectamos solamente si aparece más de una vez dentro del payload:
         * una vez = nivel order;
         * dos o más = también está dentro de item.
         */
        'item_total_amount' => substr_count($payload, "'total_amount'") > 1,
    ];
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión expiró. Recarga esta página.';
    } else {
        try {
            $action = (string)($_POST['action'] ?? '');

            if ($action === 'install') {
                if (!is_file($helperPath)) {
                    throw new RuntimeException(
                        'No se encontró includes/mercadopago.php.'
                    );
                }

                $src = file_get_contents($helperPath);

                if ($src === false) {
                    throw new RuntimeException(
                        'No se pudo leer includes/mercadopago.php.'
                    );
                }

                $patched = mp141_patch($src);

                $status = mp141_payload_status($patched);

                if (
                    !$status['payload_found']
                    || !$status['marker']
                    || $status['unit_measure'] === true
                    || $status['item_total_amount'] === true
                ) {
                    throw new RuntimeException(
                        'La validación del payload corregido falló. '
                        . 'No se modificó el archivo.'
                    );
                }

                if (!is_file($backupPath) && !copy($helperPath, $backupPath)) {
                    throw new RuntimeException(
                        'No se pudo crear el respaldo del helper.'
                    );
                }

                mp141_write($helperPath, $patched);

                $messages[] = 'Payload Mercado Pago corregido.';
                $messages[] = "items[0].unit_measure: ELIMINADO.";
                $messages[] = "items[0].total_amount: ELIMINADO.";
                $messages[] = 'OPcache invalidado cuando está disponible.';
                $messages[] = 'Ya puedes volver a probar Pagar con Mercado Pago.';
            }

            if ($action === 'revert') {
                if (!is_file($backupPath)) {
                    throw new RuntimeException(
                        'No existe el respaldo V1.4.1.'
                    );
                }

                if (!copy($backupPath, $helperPath)) {
                    throw new RuntimeException(
                        'No se pudo restaurar includes/mercadopago.php.'
                    );
                }

                if (function_exists('opcache_invalidate')) {
                    @opcache_invalidate($helperPath, true);
                }

                $messages[] = 'Helper restaurado desde el respaldo V1.4.1.';
            }
        } catch (Throwable $e) {
            $error = $e->getMessage();
        }
    }
}

$currentText = is_file($helperPath)
    ? (string)@file_get_contents($helperPath)
    : '';

$status = mp141_payload_status($currentText);

require __DIR__ . '/../includes/header.php';
?>
<style>
.mp141-grid{
    display:grid;
    grid-template-columns:repeat(3,minmax(0,1fr));
    gap:10px;
    margin:18px 0
}
.mp141-stat{
    padding:14px;
    border:1px solid rgba(255,255,255,.1);
    border-radius:11px
}
.mp141-stat small{
    display:block;
    color:var(--muted)
}
.mp141-stat strong{
    display:block;
    margin-top:5px
}
.mp141-ok{color:#49d6a5}
.mp141-bad{color:#ff8093}
@media(max-width:700px){
    .mp141-grid{grid-template-columns:1fr}
}
</style>

<div class="card" style="max-width:940px;margin:20px auto;padding:22px">

<span class="eyebrow">MERCADO PAGO</span>

<h2>Fix Items · V1.4.1</h2>

<p class="muted">
El error real de Mercado Pago identificó exactamente:
<code>items[0].unit_measure</code> y
<code>items[0].total_amount</code>
como propiedades no soportadas.
</p>

<?php if ($error): ?>
<div class="notice danger"><?=e($error)?></div>
<?php endif; ?>

<?php foreach ($messages as $message): ?>
<div class="notice"><?=e($message)?></div>
<?php endforeach; ?>

<div class="mp141-grid">

<div class="mp141-stat">
<small>Parche V1.4.1</small>
<strong class="<?=$status['marker']?'mp141-ok':'mp141-bad'?>">
<?=$status['marker']?'INSTALADO':'PENDIENTE'?>
</strong>
</div>

<div class="mp141-stat">
<small>items.unit_measure</small>
<strong class="<?=$status['unit_measure']===false?'mp141-ok':'mp141-bad'?>">
<?=$status['unit_measure']===false?'NO SE ENVÍA':'TODAVÍA PRESENTE'?>
</strong>
</div>

<div class="mp141-stat">
<small>items.total_amount</small>
<strong class="<?=$status['item_total_amount']===false?'mp141-ok':'mp141-bad'?>">
<?=$status['item_total_amount']===false?'NO SE ENVÍA':'TODAVÍA PRESENTE'?>
</strong>
</div>

</div>

<form method="post" style="display:flex;gap:10px;flex-wrap:wrap">

<input
type="hidden"
name="_csrf"
value="<?=e(csrf_token())?>"
>

<button
class="btn btn-primary"
type="submit"
name="action"
value="install"
>
Aplicar Fix V1.4.1
</button>

<a
class="btn btn-secondary"
href="/admin/mercadopago_configurar.php"
>
Abrir Mercado Pago
</a>

<button
class="btn btn-secondary"
type="submit"
name="action"
value="revert"
>
Revertir
</button>

</form>

<p class="muted" style="margin-top:18px">
Después de verificar el checkout elimina:
<code>admin/aplicar_mercadopago_fix_items_v1_4_1.php</code>.
</p>

</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
