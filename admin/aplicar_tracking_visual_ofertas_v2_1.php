<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';

require_auth();

$title = 'Seguimiento Visual V2.1 · Polish + Mobile';
$root = dirname(__DIR__);
$trackingPath = $root . '/seguimiento.php';
$error = null;
$messages = [];

function tsv21_backup(string $path): void
{
    if (!is_file($path)) {
        throw new RuntimeException('No se encontró ' . $path . '.');
    }

    $backup = $path . '.bak_tracking_visual_v2_1';

    if (!is_file($backup) && !copy($path, $backup)) {
        throw new RuntimeException(
            'No se pudo crear respaldo de ' . basename($path) . '.'
        );
    }
}

function tsv21_write(string $path, string $content): void
{
    $tmp = $path . '.tsv21.tmp';

    if (file_put_contents($tmp, $content, LOCK_EX) === false) {
        throw new RuntimeException(
            'No se pudo escribir ' . basename($path) . '.'
        );
    }

    $perms = @fileperms($path);
    if ($perms !== false) {
        @chmod($tmp, $perms & 0777);
    }

    if (!rename($tmp, $path)) {
        @unlink($tmp);
        throw new RuntimeException(
            'No se pudo reemplazar ' . basename($path) . '.'
        );
    }

    if (function_exists('opcache_invalidate')) {
        @opcache_invalidate($path, true);
    }
}

function tsv21_patch(string $src): string
{
    if (str_contains($src, 'SISACT_TRACKING_VISUAL_POLISH_V2_1')) {
        return $src;
    }

    if (!str_contains($src, 'SISACT_TRACKING_VISUAL_PREMIUM_V2')) {
        throw new RuntimeException(
            'V2.1 requiere Seguimiento Visual + Ofertas V2 Premium instalado y funcionando.'
        );
    }

    if (!str_contains($src, 'seguimiento-visual-ofertas-v2.css')) {
        throw new RuntimeException(
            'seguimiento.php no está cargando el CSS V2 Premium esperado.'
        );
    }

    /*
     * CSS V2.1 se carga DESPUÉS de V2 para actuar como capa de overrides.
     */
    $v2CssPattern = '#<link rel="stylesheet" href="/assets/css/seguimiento-visual-ofertas-v2\.css\?v=[^"]+">#';

    if (!preg_match($v2CssPattern, $src, $m)) {
        throw new RuntimeException(
            'No se encontró la referencia exacta al CSS V2 Premium.'
        );
    }

    $v21Css =
        $m[0]
        . "\n"
        . '<link rel="stylesheet" href="/assets/css/seguimiento-visual-ofertas-v2-1.css?v=20261024-1">'
        . "\n"
        . '<!-- SISACT_TRACKING_VISUAL_POLISH_V2_1 -->';

    $src = preg_replace(
        $v2CssPattern,
        $v21Css,
        $src,
        1
    );

    if (!is_string($src)) {
        throw new RuntimeException(
            'No se pudo insertar el CSS V2.1.'
        );
    }

    /*
     * JS V2.1: centra la etapa actual del Kanban en móvil y añade mejoras
     * de accesibilidad. Se carga con defer y no bloquea el render.
     */
    $bodyClose = '</body>';

    if (!str_contains($src, $bodyClose)) {
        throw new RuntimeException(
            'seguimiento.php: no se encontró </body>.'
        );
    }

    $script =
        '<script src="/assets/js/seguimiento-visual-ofertas-v2-1.js?v=20261024-1" defer></script>';

    $src = str_replace(
        $bodyClose,
        $script . "\n" . $bodyClose,
        $src
    );

    return $src;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión expiró. Recarga la página.';
    } else {
        try {
            $action = (string)($_POST['action'] ?? '');

            if ($action === 'install') {
                if (!is_file($trackingPath)) {
                    throw new RuntimeException('No se encontró seguimiento.php.');
                }

                $current = (string)file_get_contents($trackingPath);

                if ($current === '') {
                    throw new RuntimeException('No se pudo leer seguimiento.php.');
                }

                /*
                 * Construir primero. Si el marker V2 no existe,
                 * no se escribe nada.
                 */
                $new = tsv21_patch($current);

                tsv21_backup($trackingPath);
                tsv21_write($trackingPath, $new);

                $messages[] = 'V2.1 instalada correctamente sobre V2 Premium.';
                $messages[] = 'Kanban con mayor contraste y desplazamiento táctil en móvil.';
                $messages[] = 'Hero, estado actual, KPIs e historia refinados.';
                $messages[] = 'Promociones optimizadas como carrusel táctil en móvil.';
                $messages[] = 'No se modificó lógica, base de datos, pagos, CFDI ni estados.';
            }

            if ($action === 'revert') {
                $backup =
                    $trackingPath
                    . '.bak_tracking_visual_v2_1';

                if (!is_file($backup)) {
                    throw new RuntimeException(
                        'No existe respaldo V2.1 de seguimiento.php.'
                    );
                }

                if (!copy($backup, $trackingPath)) {
                    throw new RuntimeException(
                        'No se pudo restaurar seguimiento.php.'
                    );
                }

                if (function_exists('opcache_invalidate')) {
                    @opcache_invalidate($trackingPath, true);
                }

                $messages[] =
                    'seguimiento.php restaurado exactamente al estado anterior a V2.1.';
            }
        } catch (Throwable $e) {
            $error = $e->getMessage();
        }
    }
}

$cssReady = is_file(
    $root
    . '/assets/css/seguimiento-visual-ofertas-v2-1.css'
);

$jsReady = is_file(
    $root
    . '/assets/js/seguimiento-visual-ofertas-v2-1.js'
);

$v2HelperReady = is_file(
    $root
    . '/includes/tracking_experience_v2.php'
);

require __DIR__ . '/../includes/header.php';
?>
<style>
.tsv21{max-width:1080px;margin:20px auto}
.tsv21-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:10px;margin:18px 0}
.tsv21-stat{padding:14px;border:1px solid rgba(255,255,255,.1);border-radius:12px}
.tsv21-stat small{display:block;color:var(--muted)}
.tsv21-stat strong{display:block;margin-top:5px}
.tsv21-ok{color:#67e7be}
.tsv21-note{padding:15px;border:1px solid rgba(82,208,255,.20);border-radius:12px;background:rgba(82,208,255,.05);line-height:1.7}
.tsv21-mobile{margin-top:12px;padding:15px;border:1px solid rgba(36,189,136,.20);border-radius:12px;background:rgba(36,189,136,.05);line-height:1.7}
@media(max-width:760px){.tsv21-grid{grid-template-columns:1fr 1fr}}
</style>

<div class="tsv21">
  <div class="card" style="padding:22px">
    <span class="eyebrow">SEGUIMIENTO · PULIDO FINO + MOBILE</span>
    <h2>Seguimiento Visual + Ofertas V2.1</h2>

    <p class="muted">
      Actualización incremental sobre V2 Premium. Refina el diseño aprobado y convierte el seguimiento móvil en una composición realmente responsive y táctil.
    </p>

    <?php if ($error): ?>
      <div class="notice danger"><?=e($error)?></div>
    <?php endif; ?>

    <?php foreach ($messages as $message): ?>
      <div class="notice"><span class="ok">✓</span> <?=e($message)?></div>
    <?php endforeach; ?>

    <div class="tsv21-grid">
      <div class="tsv21-stat">
        <small>Base V2 Premium</small>
        <strong class="<?=$v2HelperReady?'tsv21-ok':''?>">
          <?=$v2HelperReady?'✓ detectada':'faltante'?>
        </strong>
      </div>

      <div class="tsv21-stat">
        <small>CSS V2.1</small>
        <strong class="<?=$cssReady?'tsv21-ok':''?>">
          <?=$cssReady?'✓ listo':'faltante'?>
        </strong>
      </div>

      <div class="tsv21-stat">
        <small>UX móvil</small>
        <strong class="<?=$jsReady?'tsv21-ok':''?>">
          <?=$jsReady?'✓ listo':'faltante'?>
        </strong>
      </div>

      <div class="tsv21-stat">
        <small>Base de datos</small>
        <strong class="tsv21-ok">Sin cambios</strong>
      </div>
    </div>

    <div class="tsv21-note">
      <strong>Pulido visual</strong><br>
      Mayor contraste del Kanban · ring más ligero · etapa actual reforzada · KPIs compactos · tarjetas de producción refinadas · promociones con mayor presencia comercial.
    </div>

    <div class="tsv21-mobile">
      <strong>Optimización móvil</strong><br>
      Kanban táctil con scroll horizontal y centrado automático de la etapa actual · hero compacto · KPIs 2×2 · historial en una columna · CTAs de 44–46 px · promociones como carrusel horizontal con scroll-snap.
    </div>

    <form method="post" style="display:flex;gap:10px;flex-wrap:wrap;margin-top:18px">
      <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">

      <button
        class="btn btn-primary"
        type="submit"
        name="action"
        value="install"
      >
        Instalar V2.1
      </button>

      <a
        class="btn btn-secondary"
        href="/seguimiento.php"
        target="_blank"
        rel="noopener"
      >
        Abrir seguimiento
      </a>

      <button
        class="btn btn-secondary"
        type="submit"
        name="action"
        value="revert"
        onclick="return confirm('¿Restaurar seguimiento.php al estado anterior a V2.1?');"
      >
        Revertir V2.1
      </button>
    </form>
  </div>
</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
