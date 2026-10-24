<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';

require_auth();

$title = 'Cancelados → Ofertas V1';

$root = dirname(__DIR__);

$trackingPath =
    $root
    . '/seguimiento.php';

$publicQuotePath =
    $root
    . '/cotizacion_pdf_publica.php';

$error = null;
$messages = [];

function crov1_backup(string $path): void
{
    if (!is_file($path)) {
        throw new RuntimeException(
            'No se encontró '
            . $path
            . '.'
        );
    }

    $backup =
        $path
        . '.bak_cancelados_ofertas_v1';

    if (
        !is_file($backup)
        && !copy($path, $backup)
    ) {
        throw new RuntimeException(
            'No se pudo respaldar '
            . basename($path)
            . '.'
        );
    }
}

function crov1_write(string $path, string $content): void
{
    $tmp =
        $path
        . '.crov1.tmp';

    if (
        file_put_contents(
            $tmp,
            $content,
            LOCK_EX
        )
        === false
    ) {
        throw new RuntimeException(
            'No se pudo escribir '
            . basename($path)
            . '.'
        );
    }

    $perms = @fileperms($path);

    if ($perms !== false) {
        @chmod(
            $tmp,
            $perms & 0777
        );
    }

    if (!rename($tmp, $path)) {
        @unlink($tmp);

        throw new RuntimeException(
            'No se pudo reemplazar '
            . basename($path)
            . '.'
        );
    }

    if (
        function_exists(
            'opcache_invalidate'
        )
    ) {
        @opcache_invalidate(
            $path,
            true
        );
    }
}

function crov1_patch_tracking(string $src): string
{
    if (
        str_contains(
            $src,
            'SISACT_CANCELLED_TO_OFFERS_V1'
        )
    ) {
        return $src;
    }

    $companyInclude =
        "require_once __DIR__ . '/includes/company.php';";

    if (!str_contains($src, $companyInclude)) {
        throw new RuntimeException(
            'seguimiento.php: no se encontró includes/company.php.'
        );
    }

    $src =
        str_replace(
            $companyInclude,
            $companyInclude
            . "\n"
            . "require_once __DIR__ . '/includes/cancelled_public_landing_v1.php';\n"
            . "// SISACT_CANCELLED_TO_OFFERS_V1",
            $src
        );

    $orderMarker =
        "\$order = \$token !== '' ? tracking_order_by_token(\$token) : null;";

    if (!str_contains($src, $orderMarker)) {
        throw new RuntimeException(
            'seguimiento.php: no se encontró la carga de la orden por token.'
        );
    }

    $redirectBlock = <<<'PHP'

/*
 * Si la orden, su etapa de producción o su cotización origen
 * están canceladas, el cliente ya no ve un seguimiento operativo.
 * Se redirige a la landing pública de ofertas.
 */
if (
    $order
    && cancelled_landing_v1_is_cancelled_order(
        (int)$order['id']
    )
) {
    header(
        'Location: '
        . cancelled_landing_v1_tracking_redirect_url(
            $token
        ),
        true,
        302
    );
    exit;
}
PHP;

    return str_replace(
        $orderMarker,
        $orderMarker
        . $redirectBlock,
        $src
    );
}

function crov1_patch_public_quote(string $src): string
{
    if (
        str_contains(
            $src,
            'SISACT_CANCELLED_LANDING_ORDER_TOKEN_V1'
        )
    ) {
        return $src;
    }

    $rendererInclude =
        "require_once __DIR__ . '/includes/cotizacion_pdf_renderer.php';";

    if (!str_contains($src, $rendererInclude)) {
        throw new RuntimeException(
            'cotizacion_pdf_publica.php: no se encontró cotizacion_pdf_renderer.php.'
        );
    }

    $src =
        str_replace(
            $rendererInclude,
            $rendererInclude
            . "\n"
            . "require_once __DIR__ . '/includes/cancelled_public_landing_v1.php';\n"
            . "// SISACT_CANCELLED_LANDING_ORDER_TOKEN_V1",
            $src
        );

    /*
     * qpv2_unavailable se usa ahora también como landing deliberada.
     * Conservamos 404 como default para enlaces inválidos, pero permitimos
     * 200 para un estado cancelado real.
     */
    $signature =
        'function qpv2_unavailable(array $company, string $title, string $message): never {';

    if (!str_contains($src, $signature)) {
        throw new RuntimeException(
            'cotizacion_pdf_publica.php: no se encontró qpv2_unavailable().'
        );
    }

    $src =
        str_replace(
            $signature,
            'function qpv2_unavailable(array $company, string $title, string $message, int $httpStatus=404): never {',
            $src
        );

    $src =
        preg_replace(
            '/http_response_code\(404\);/',
            'http_response_code($httpStatus);',
            $src,
            1,
            $httpCount
        );

    if ($httpCount !== 1) {
        throw new RuntimeException(
            'cotizacion_pdf_publica.php: no se pudo parametrizar el HTTP status.'
        );
    }

    $companyMarker =
        '$company = company_profile();';

    if (!str_contains($src, $companyMarker)) {
        throw new RuntimeException(
            'cotizacion_pdf_publica.php: no se encontró company_profile().'
        );
    }

    $orderLandingBlock = <<<'PHP'

/*
 * Entrada desde seguimiento.php cuando una orden fue cancelada.
 * Se vuelve a validar el token y el estado en servidor.
 */
$orderTrackingToken = trim(
    (string)(
        $_GET['ot']
        ?? ''
    )
);

if (
    $orderTrackingToken !== ''
    && preg_match(
        '/^[a-f0-9]{64}$/i',
        $orderTrackingToken
    )
) {
    $cancelContext =
        cancelled_landing_v1_context_by_tracking_token(
            $orderTrackingToken
        );

    if (
        $cancelContext
        && !empty(
            $cancelContext['is_cancelled']
        )
    ) {
        qpv2_unavailable(
            $company,
            cancelled_landing_v1_title(
                $cancelContext
            ),
            cancelled_landing_v1_message(
                $cancelContext
            ),
            200
        );
    }
}
PHP;

    $src =
        str_replace(
            $companyMarker,
            $companyMarker
            . $orderLandingBlock,
            $src
        );

    /*
     * Mejoramos la salida directa de una cotización cancelada.
     * Ya está en cotizacion_pdf_publica.php, así que no hace falta
     * otro redirect; simplemente se presenta la landing de ofertas.
     */
    $oldCancelled = <<<'PHP'
if (!$quote || in_array((string)($quote['status'] ?? ''), ['cancelled'], true)) {
    qpv2_unavailable(
        $company,
        'Esta cotización ya no está disponible',
        'La cotización fue cerrada o dejó de estar activa.'
    );
}
PHP;

    if (!str_contains($src, $oldCancelled)) {
        throw new RuntimeException(
            'cotizacion_pdf_publica.php: no se encontró la validación de cotización cancelada.'
        );
    }

    $newCancelled = <<<'PHP'
if (!$quote) {
    qpv2_unavailable(
        $company,
        'Esta cotización ya no está disponible',
        'La cotización fue cerrada o dejó de estar activa.'
    );
}

if (
    strtolower(
        trim(
            (string)(
                $quote['status']
                ?? ''
            )
        )
    ) === 'cancelled'
) {
    qpv2_unavailable(
        $company,
        'Esta cotización fue cancelada',
        'La propuesta anterior ya no se encuentra vigente. '
        . 'Puedes solicitar una nueva cotización con precio, disponibilidad '
        . 'y tiempos actualizados, o revisar nuestros productos y ofertas actuales.',
        200
    );
}
PHP;

    $src =
        str_replace(
            $oldCancelled,
            $newCancelled,
            $src
        );

    return $src;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error =
            'La sesión expiró. Recarga la página.';
    } else {
        try {
            $action =
                (string)(
                    $_POST['action']
                    ?? ''
                );

            if ($action === 'install') {
                foreach (
                    [
                        $trackingPath,
                        $publicQuotePath,
                    ]
                    as $path
                ) {
                    if (!is_file($path)) {
                        throw new RuntimeException(
                            'No se encontró '
                            . $path
                            . '.'
                        );
                    }
                }

                /*
                 * Construir antes de escribir.
                 */
                $trackingCurrent =
                    (string)file_get_contents(
                        $trackingPath
                    );

                $publicCurrent =
                    (string)file_get_contents(
                        $publicQuotePath
                    );

                $trackingNew =
                    crov1_patch_tracking(
                        $trackingCurrent
                    );

                $publicNew =
                    crov1_patch_public_quote(
                        $publicCurrent
                    );

                crov1_backup(
                    $trackingPath
                );

                crov1_backup(
                    $publicQuotePath
                );

                crov1_write(
                    $trackingPath,
                    $trackingNew
                );

                crov1_write(
                    $publicQuotePath,
                    $publicNew
                );

                $messages[] =
                    'Órdenes canceladas en seguimiento redirigen a la landing de ofertas.';

                $messages[] =
                    'Cotizaciones canceladas muestran la misma landing de productos y promociones.';

                $messages[] =
                    'El estado se vuelve a validar en servidor para evitar falsos cancelados por URL.';
            }

            if ($action === 'revert') {
                foreach (
                    [
                        $trackingPath,
                        $publicQuotePath,
                    ]
                    as $path
                ) {
                    $backup =
                        $path
                        . '.bak_cancelados_ofertas_v1';

                    if (!is_file($backup)) {
                        throw new RuntimeException(
                            'Falta respaldo de '
                            . basename($path)
                            . '.'
                        );
                    }

                    if (!copy($backup, $path)) {
                        throw new RuntimeException(
                            'No se pudo restaurar '
                            . basename($path)
                            . '.'
                        );
                    }

                    if (
                        function_exists(
                            'opcache_invalidate'
                        )
                    ) {
                        @opcache_invalidate(
                            $path,
                            true
                        );
                    }
                }

                $messages[] =
                    'Archivos restaurados desde respaldo.';
            }
        } catch (Throwable $e) {
            $error =
                $e->getMessage();
        }
    }
}

$helperReady =
    is_file(
        $root
        . '/includes/cancelled_public_landing_v1.php'
    );

require __DIR__ . '/../includes/header.php';
?>
<style>
.crov1{
  max-width:980px;
  margin:20px auto
}
.crov1-grid{
  display:grid;
  grid-template-columns:repeat(3,minmax(0,1fr));
  gap:10px;
  margin:18px 0
}
.crov1-stat{
  padding:14px;
  border:1px solid rgba(255,255,255,.1);
  border-radius:11px
}
.crov1-stat small{
  display:block;
  color:var(--muted)
}
.crov1-stat strong{
  display:block;
  margin-top:5px
}
.crov1-ok{
  color:#67e7be
}
.crov1-flow{
  padding:15px;
  border:1px solid rgba(82,208,255,.20);
  border-radius:12px;
  background:rgba(82,208,255,.05);
  line-height:1.7
}
@media(max-width:760px){
  .crov1-grid{
    grid-template-columns:1fr
  }
}
</style>

<div class="crov1">
  <div class="card" style="padding:22px">

    <span class="eyebrow">
      CANCELACIÓN · RECUPERACIÓN COMERCIAL
    </span>

    <h2>
      Cancelados → Productos y ofertas V1
    </h2>

    <p class="muted">
      Unifica la experiencia pública: una orden o cotización cancelada deja de mostrar seguimiento/PDF operativo y presenta la landing de productos, ofertas y nueva cotización.
    </p>

    <?php if ($error): ?>
      <div class="notice danger">
        <?=e($error)?>
      </div>
    <?php endif; ?>

    <?php foreach ($messages as $message): ?>
      <div class="notice">
        <span class="ok">✓</span>
        <?=e($message)?>
      </div>
    <?php endforeach; ?>

    <div class="crov1-grid">
      <div class="crov1-stat">
        <small>Helper</small>
        <strong class="<?=$helperReady?'crov1-ok':''?>">
          <?=$helperReady?'✓ listo':'faltante'?>
        </strong>
      </div>

      <div class="crov1-stat">
        <small>Orden cancelada</small>
        <strong class="crov1-ok">
          ✓ redirección
        </strong>
      </div>

      <div class="crov1-stat">
        <small>Cotización cancelada</small>
        <strong class="crov1-ok">
          ✓ ofertas
        </strong>
      </div>
    </div>

    <div class="crov1-flow">
      <strong>Flujo público final</strong><br>
      Seguimiento vigente
      → seguimiento.php
      <br>
      Orden cancelada
      → cotizacion_pdf_publica.php?ot=TOKEN&amp;estado=cancelado
      <br>
      Cotización vigente
      → PDF de cotización
      <br>
      Cotización cancelada
      → misma landing de productos y ofertas.
    </div>

    <form
      method="post"
      style="display:flex;gap:10px;flex-wrap:wrap;margin-top:18px"
    >
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
        Instalar redirección V1
      </button>

      <a
        class="btn btn-secondary"
        href="/cotizacion_pdf_publica.php"
        target="_blank"
        rel="noopener"
      >
        Abrir landing
      </a>

      <button
        class="btn btn-secondary"
        type="submit"
        name="action"
        value="revert"
        onclick="return confirm('¿Restaurar seguimiento.php y cotizacion_pdf_publica.php?');"
      >
        Revertir
      </button>
    </form>

  </div>
</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
