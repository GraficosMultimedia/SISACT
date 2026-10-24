<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';

require_auth();

$title = 'Seguimiento Visual + Ofertas V1.1';
$root = dirname(__DIR__);
$trackingPath = $root . '/seguimiento.php';
$error = null;
$messages = [];

function tsv11_backup(string $path): void
{
    if (!is_file($path)) {
        throw new RuntimeException('No se encontró ' . $path . '.');
    }
    $backup = $path . '.bak_tracking_visual_v1_1';
    if (!is_file($backup) && !copy($path, $backup)) {
        throw new RuntimeException('No se pudo respaldar ' . basename($path) . '.');
    }
}

function tsv11_write(string $path, string $content): void
{
    $tmp = $path . '.tsv11.tmp';
    if (file_put_contents($tmp, $content, LOCK_EX) === false) {
        throw new RuntimeException('No se pudo escribir ' . basename($path) . '.');
    }
    $perms = @fileperms($path);
    if ($perms !== false) {
        @chmod($tmp, $perms & 0777);
    }
    if (!rename($tmp, $path)) {
        @unlink($tmp);
        throw new RuntimeException('No se pudo reemplazar ' . basename($path) . '.');
    }
    if (function_exists('opcache_invalidate')) {
        @opcache_invalidate($path, true);
    }
}

function tsv11_patch(string $src): string
{
    if (str_contains($src, 'SISACT_TRACKING_VISUAL_OFFERS_V1_1')) {
        return $src;
    }

    // 1. Helper central.
    $companyInclude = "require_once __DIR__ . '/includes/company.php';";
    if (!str_contains($src, $companyInclude)) {
        throw new RuntimeException('seguimiento.php: no se encontró includes/company.php.');
    }
    $src = str_replace(
        $companyInclude,
        $companyInclude
        . "\nrequire_once __DIR__ . '/includes/tracking_experience_v1_1.php';"
        . "\n// SISACT_TRACKING_VISUAL_OFFERS_V1_1",
        $src
    );

    // 2. Datos visuales. Se insertan antes del HTML y funcionan tanto con
    //    clientHistory (vista antigua) como con kanbanHistory (vista nueva).
    $htmlMarker = "?>\n<!doctype html>";
    if (!str_contains($src, $htmlMarker)) {
        $htmlMarker = "?>\r\n<!doctype html>";
    }
    if (!str_contains($src, $htmlMarker)) {
        throw new RuntimeException('seguimiento.php: no se encontró el inicio del HTML.');
    }

    $dataBlock = <<<'PHP'

/* SISACT_TRACKING_VISUAL_DATA_V1_1 */
$trackingVisualHistory = [];
if (isset($kanbanHistory) && is_array($kanbanHistory) && $kanbanHistory) {
    $trackingVisualHistory = $kanbanHistory;
} elseif (isset($clientHistory) && is_array($clientHistory)) {
    $trackingVisualHistory = $clientHistory;
}

$trackingVisualCurrentKey = 'pending';
if (isset($kanbanCurrent) && is_string($kanbanCurrent) && $kanbanCurrent !== '') {
    $trackingVisualCurrentKey = $kanbanCurrent;
} elseif (isset($currentInternal) && is_string($currentInternal) && $currentInternal !== '') {
    $trackingVisualCurrentKey = $currentInternal;
} elseif (isset($currentClient) && is_string($currentClient) && $currentClient !== '') {
    $trackingVisualCurrentKey = $currentClient;
}

$trackingVisualCancelled = isset($isCancelled) ? (bool)$isCancelled : false;
$trackingExperienceV11 = trackexp_v11_build(
    $order,
    $trackingVisualHistory,
    $trackingVisualCurrentKey,
    $company
);
$trackingVisualHistory = $trackingExperienceV11['history'];
$trackingVisualStats = $trackingExperienceV11['stats'];
$trackingOfferCards = $trackingExperienceV11['offers'];
$trackingVisualStarted = $trackingExperienceV11['started_at'];
$trackingVisualUpdated = $trackingExperienceV11['updated_at'];
$trackingVisualNext = $trackingExperienceV11['next_meta'];
PHP;

    $src = str_replace(
        $htmlMarker,
        $dataBlock . "\n" . $htmlMarker,
        $src
    );

    // 3. CSS externo.
    if (!str_contains($src, 'seguimiento-visual-ofertas-v1-1.css')) {
        $headClose = '</head>';
        if (!str_contains($src, $headClose)) {
            throw new RuntimeException('seguimiento.php: no se encontró </head>.');
        }
        $src = str_replace(
            $headClose,
            '<link rel="stylesheet" href="/assets/css/seguimiento-visual-ofertas-v1-1.css?v=20261024-1">' . "\n" . $headClose,
            $src
        );
    }

    // 4. Historial: NO se compara el HTML completo.
    //    Se reemplaza todo lo que exista entre la sección history y two-col.
    $historyStart = strpos($src, '<section class="history tracking-card">');
    if ($historyStart === false) {
        throw new RuntimeException('seguimiento.php: no se encontró <section class="history tracking-card">.');
    }

    $twoColStart = strpos($src, '<section class="two-col">', $historyStart);
    if ($twoColStart === false) {
        throw new RuntimeException('seguimiento.php: no se encontró la sección two-col posterior al historial.');
    }

    $historyHtml = <<<'HTML'
<section class="history tracking-card">
  <div class="tracking-story-head">
    <div>
      <span class="eyebrow">ACTUALIZACIONES</span>
      <h2 style="margin:3px 0 0;color:var(--navy)">Tu pedido paso a paso</h2>
      <p>Conoce lo que ya hicimos, dónde se encuentra tu pedido y cuál será el siguiente movimiento. Queremos que seguir tu orden sea tan claro y creativo como el trabajo que estamos produciendo para ti.</p>
    </div>
    <div class="tracking-story-stamp">
      <span>Historia del pedido</span>
      <strong>Inicio: <?=track_e($trackingVisualStarted)?><br>Actualizado: <?=track_e($trackingVisualUpdated)?></strong>
    </div>
  </div>

  <div class="tracking-story-kpis">
    <?php foreach ($trackingVisualStats as $stat): ?>
      <div class="tracking-story-kpi tone-<?=track_e((string)($stat['tone'] ?? 'cyan'))?>">
        <span><?=track_e((string)($stat['label'] ?? 'Dato'))?></span>
        <strong><?=track_e((string)($stat['value'] ?? ''))?></strong>
        <small><?=track_e((string)($stat['hint'] ?? ''))?></small>
      </div>
    <?php endforeach; ?>
  </div>

  <?php if (!$trackingVisualHistory): ?>
    <p class="muted" style="margin-top:18px">Aún no hay actualizaciones registradas.</p>
  <?php else: ?>
    <div class="tracking-story-grid">
      <?php foreach ($trackingVisualHistory as $idx=>$entry):
        $isCurrent = ((string)($entry['key'] ?? '') === $trackingVisualCurrentKey);
      ?>
        <article class="tracking-story-card <?=$isCurrent?'is-current':''?>">
          <?php if ($isCurrent): ?>
            <span class="tracking-story-current">Etapa actual</span>
          <?php endif; ?>

          <div class="tracking-story-card-head">
            <div class="tracking-story-icon"><?=track_e((string)($entry['icon'] ?? '●'))?></div>
            <div>
              <span class="tracking-story-step">Movimiento <?=str_pad((string)($idx+1),2,'0',STR_PAD_LEFT)?></span>
              <h3><?=track_e((string)($entry['label'] ?? 'Actualización'))?></h3>
              <span class="tracking-story-date"><?=track_date($entry['created_at'] ?? null,'d/m/Y H:i')?></span>
              <span class="tracking-story-status"><?=$isCurrent?'● En proceso':'✓ Registrado'?></span>
            </div>
          </div>

          <?php if (trim((string)($entry['note'] ?? '')) !== ''): ?>
            <p class="tracking-story-note"><?=nl2br(track_e((string)$entry['note']))?></p>
          <?php else: ?>
            <p class="tracking-story-note">Esta etapa quedó registrada dentro del proceso de producción de tu pedido.</p>
          <?php endif; ?>

          <div class="tracking-story-footer">
            <span><?=track_e((string)($order['order_number'] ?? 'Orden de servicio'))?></span>
            <strong><?=track_e((string)($entry['label'] ?? ''))?></strong>
          </div>
        </article>
      <?php endforeach; ?>
    </div>
  <?php endif; ?>
</section>

HTML;

    $src = substr($src, 0, $historyStart)
        . $historyHtml
        . substr($src, $twoColStart);

    // 5. Ofertas: insertar DESPUÉS de la sección two-col actual, sin tocarla.
    $twoColStart = strpos($src, '<section class="two-col">', $historyStart);
    if ($twoColStart === false) {
        throw new RuntimeException('seguimiento.php: no se pudo relocalizar two-col.');
    }
    $twoColEnd = strpos($src, '</section>', $twoColStart);
    if ($twoColEnd === false) {
        throw new RuntimeException('seguimiento.php: no se encontró el cierre de two-col.');
    }
    $twoColEnd += strlen('</section>');

    $offersHtml = <<<'HTML'

<?php if ($order && !$trackingVisualCancelled && !empty($trackingOfferCards)): ?>
<section class="tracking-card tracking-offers">
  <div class="tracking-offers-head">
    <div>
      <span class="eyebrow">EXCLUSIVO PARA TI</span>
      <h2 style="margin:3px 0 0;color:var(--navy)">Promociones y servicios que puedes aprovechar hoy</h2>
      <p>Mientras seguimos trabajando tu pedido, descubre otras soluciones disponibles en Colibrí Print. Esta vitrina utiliza el mismo catálogo comercial que mostramos en nuestra experiencia pública de cotizaciones.</p>
    </div>
    <a href="<?=track_e(trackexp_v11_site_url((string)($company['website'] ?? '')) . '/#servicios')?>" target="_blank" rel="noopener">Ver todos los servicios →</a>
  </div>

  <div class="tracking-offer-grid">
    <?php foreach ($trackingOfferCards as $offer): ?>
      <article class="tracking-offer accent-<?=track_e((string)($offer['accent'] ?? 'cyan'))?>">
        <div class="tracking-offer-icon"><?=track_e((string)($offer['icon'] ?? '✨'))?></div>
        <span class="tracking-offer-tag"><?=track_e((string)($offer['tag'] ?? 'Destacado'))?></span>
        <h3><?=track_e((string)($offer['title'] ?? 'Servicio'))?></h3>
        <p><?=track_e((string)($offer['text'] ?? ''))?></p>
        <a href="<?=track_e((string)($offer['href'] ?? '#'))?>" target="_blank" rel="noopener"><?=track_e((string)($offer['cta'] ?? 'Ver más'))?> →</a>
      </article>
    <?php endforeach; ?>
  </div>
</section>
<?php endif; ?>
HTML;

    $src = substr($src, 0, $twoColEnd)
        . $offersHtml
        . substr($src, $twoColEnd);

    return $src;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión expiró. Recarga la página.';
    } else {
        try {
            $action = (string)($_POST['action'] ?? '');

            if ($action === 'install') {
                $current = (string)file_get_contents($trackingPath);
                if ($current === '') {
                    throw new RuntimeException('No se pudo leer seguimiento.php.');
                }

                // El parche se construye completo antes de escribir.
                $new = tsv11_patch($current);
                tsv11_backup($trackingPath);
                tsv11_write($trackingPath, $new);

                $messages[] = 'V1.1 instalada correctamente.';
                $messages[] = 'Se conservó el Kanban completo actual.';
                $messages[] = 'El historial fue sustituido por el nuevo bloque visual.';
                $messages[] = 'Se agregó la vitrina comercial con las mismas ofertas de cotizacion_pdf_publica.php.';
            }

            if ($action === 'revert') {
                $backup = $trackingPath . '.bak_tracking_visual_v1_1';
                if (!is_file($backup)) {
                    throw new RuntimeException('No existe respaldo V1.1 de seguimiento.php.');
                }
                if (!copy($backup, $trackingPath)) {
                    throw new RuntimeException('No se pudo restaurar seguimiento.php.');
                }
                if (function_exists('opcache_invalidate')) {
                    @opcache_invalidate($trackingPath, true);
                }
                $messages[] = 'seguimiento.php restaurado desde el respaldo V1.1.';
            }
        } catch (Throwable $e) {
            $error = $e->getMessage();
        }
    }
}

$helperReady = is_file($root . '/includes/tracking_experience_v1_1.php');
$cssReady = is_file($root . '/assets/css/seguimiento-visual-ofertas-v1-1.css');

require __DIR__ . '/../includes/header.php';
?>
<style>
.tsv11{max-width:1040px;margin:20px auto}.tsv11-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:10px;margin:18px 0}.tsv11-stat{padding:14px;border:1px solid rgba(255,255,255,.1);border-radius:11px}.tsv11-stat small{display:block;color:var(--muted)}.tsv11-stat strong{display:block;margin-top:5px}.tsv11-ok{color:#67e7be}.tsv11-info{padding:15px;border:1px solid rgba(82,208,255,.20);border-radius:12px;background:rgba(82,208,255,.05);line-height:1.7}@media(max-width:760px){.tsv11-grid{grid-template-columns:1fr 1fr}}
</style>
<div class="tsv11">
  <div class="card" style="padding:22px">
    <span class="eyebrow">SEGUIMIENTO · HOTFIX VISUAL</span>
    <h2>Seguimiento Visual + Ofertas V1.1</h2>
    <p class="muted">Versión compatible con el Kanban completo actualmente instalado. Ya no depende de encontrar el HTML literal del bloque antiguo “Lo que ha pasado”.</p>

    <?php if ($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>
    <?php foreach ($messages as $message): ?><div class="notice"><span class="ok">✓</span> <?=e($message)?></div><?php endforeach; ?>

    <div class="tsv11-grid">
      <div class="tsv11-stat"><small>Helper</small><strong class="<?=$helperReady?'tsv11-ok':''?>"><?=$helperReady?'✓ listo':'faltante'?></strong></div>
      <div class="tsv11-stat"><small>CSS visual</small><strong class="<?=$cssReady?'tsv11-ok':''?>"><?=$cssReady?'✓ listo':'faltante'?></strong></div>
      <div class="tsv11-stat"><small>Kanban actual</small><strong class="tsv11-ok">✓ se conserva</strong></div>
      <div class="tsv11-stat"><small>Ofertas</small><strong class="tsv11-ok">✓ catálogo V2</strong></div>
    </div>

    <div class="tsv11-info">
      <strong>Cambio del instalador</strong><br>
      V1 buscaba todo el bloque HTML antiguo de forma literal.<br>
      V1.1 localiza únicamente los límites estructurales:<br>
      <code>&lt;section class="history tracking-card"&gt;</code> → <code>&lt;section class="two-col"&gt;</code><br>
      Esto permite trabajar con el seguimiento Kanban de 8 etapas que ya tienes instalado.
    </div>

    <form method="post" style="display:flex;gap:10px;flex-wrap:wrap;margin-top:18px">
      <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
      <button class="btn btn-primary" type="submit" name="action" value="install">Instalar V1.1</button>
      <a class="btn btn-secondary" href="/seguimiento.php" target="_blank" rel="noopener">Abrir seguimiento</a>
      <button class="btn btn-secondary" type="submit" name="action" value="revert" onclick="return confirm('¿Restaurar seguimiento.php desde el respaldo V1.1?');">Revertir</button>
    </form>
  </div>
</div>
<?php require __DIR__ . '/../includes/footer.php'; ?>
