<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';

require_auth();

$title = 'Seguimiento Visual V2 Premium';
$root = dirname(__DIR__);
$trackingPath = $root . '/seguimiento.php';
$error = null;
$messages = [];

function tsv2_backup(string $path): void
{
    if (!is_file($path)) {
        throw new RuntimeException('No se encontró ' . $path . '.');
    }

    $backup = $path . '.bak_tracking_visual_v2';
    if (!is_file($backup) && !copy($path, $backup)) {
        throw new RuntimeException('No se pudo crear respaldo de ' . basename($path) . '.');
    }
}

function tsv2_write(string $path, string $content): void
{
    $tmp = $path . '.tsv2.tmp';
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

function tsv2_remove_v11_offers(string $src): string
{
    $startMarker = '<?php if ($order && !$trackingVisualCancelled && !empty($trackingOfferCards)): ?>';
    $sectionMarker = '<section class="tracking-card tracking-offers">';

    $sectionPos = strpos($src, $sectionMarker);
    if ($sectionPos === false) {
        return $src;
    }

    $start = strrpos(substr($src, 0, $sectionPos), $startMarker);
    if ($start === false) {
        throw new RuntimeException('seguimiento.php: se encontró la vitrina V1.1 pero no su apertura PHP.');
    }

    $sectionEnd = strpos($src, '</section>', $sectionPos);
    if ($sectionEnd === false) {
        throw new RuntimeException('seguimiento.php: no se encontró el cierre de la vitrina V1.1.');
    }
    $sectionEnd += strlen('</section>');

    $phpEnd = strpos($src, '<?php endif; ?>', $sectionEnd);
    if ($phpEnd === false) {
        throw new RuntimeException('seguimiento.php: no se encontró el cierre PHP de la vitrina V1.1.');
    }
    $phpEnd += strlen('<?php endif; ?>');

    return substr($src, 0, $start) . substr($src, $phpEnd);
}

function tsv2_patch(string $src): string
{
    if (str_contains($src, 'SISACT_TRACKING_VISUAL_PREMIUM_V2')) {
        return $src;
    }

    if (!str_contains($src, 'SISACT_TRACKING_VISUAL_OFFERS_V1_1')) {
        throw new RuntimeException(
            'V2 requiere que Seguimiento Visual + Ofertas V1.1 esté instalado y funcionando.'
        );
    }

    // 1. Helper V2 sin retirar V1.1 todavía; se conserva compatibilidad.
    $v11Include = "require_once __DIR__ . '/includes/tracking_experience_v1_1.php';";
    if (!str_contains($src, $v11Include)) {
        throw new RuntimeException('seguimiento.php: no se encontró el helper V1.1.');
    }

    $src = str_replace(
        $v11Include,
        $v11Include
        . "\nrequire_once __DIR__ . '/includes/tracking_experience_v2.php';"
        . "\n// SISACT_TRACKING_VISUAL_PREMIUM_V2",
        $src
    );

    // 2. Datos premium antes del HTML.
    $htmlMarker = "?>\n<!doctype html>";
    if (!str_contains($src, $htmlMarker)) {
        $htmlMarker = "?>\r\n<!doctype html>";
    }
    if (!str_contains($src, $htmlMarker)) {
        throw new RuntimeException('seguimiento.php: no se encontró el inicio del HTML.');
    }

    $dataBlock = <<<'PHP'

/* SISACT_TRACKING_VISUAL_DATA_V2 */
$trackingPremium = trackexp_v2_build(
    $order,
    $trackingVisualHistory,
    $trackingVisualCurrentKey,
    $company,
    $trackingVisualCancelled
);
$trackingPremiumHistory = $trackingPremium['history'];
$trackingPremiumOffers = $trackingPremium['offers'];
$trackingPremiumProgress = (int)$trackingPremium['progress_pct'];
$trackingPremiumCurrent = $trackingPremium['current_meta'];
$trackingPremiumNext = $trackingPremium['next_meta'];
PHP;

    $src = str_replace(
        $htmlMarker,
        $dataBlock . "\n" . $htmlMarker,
        $src
    );

    // 3. CSS V2 se carga después de V1.1 y puede refinar estilos sin romperlo.
    if (!str_contains($src, 'seguimiento-visual-ofertas-v2.css')) {
        $headClose = '</head>';
        if (!str_contains($src, $headClose)) {
            throw new RuntimeException('seguimiento.php: no se encontró </head>.');
        }

        $src = str_replace(
            $headClose,
            '<link rel="stylesheet" href="/assets/css/seguimiento-visual-ofertas-v2.css?v=20261024-1">' . "\n" . $headClose,
            $src
        );
    }

    // 4. Reemplazar únicamente el bloque visual history -> two-col.
    $historyStart = strpos($src, '<section class="history tracking-card">');
    if ($historyStart === false) {
        throw new RuntimeException('seguimiento.php: no se encontró el historial V1.1.');
    }

    $twoColStart = strpos($src, '<section class="two-col">', $historyStart);
    if ($twoColStart === false) {
        throw new RuntimeException('seguimiento.php: no se encontró two-col posterior al historial.');
    }

    $historyHtml = <<<'HTML'
<section class="history tracking-card tracking-premium">
  <div class="tracking-premium-hero">
    <div class="tracking-premium-copy">
      <span class="tracking-premium-kicker">Experiencia Colibrí · Seguimiento en vivo</span>
      <h2><?=track_e((string)$trackingPremium['headline'])?></h2>
      <p><?=track_e((string)($trackingPremiumCurrent['message'] ?? 'Consulta el avance de tu orden y cada movimiento confirmado por nuestro equipo.'))?></p>

      <div class="tracking-premium-chips">
        <span class="tracking-premium-chip">Orden <strong><?=track_e((string)$trackingPremium['order_number'])?></strong></span>
        <span class="tracking-premium-chip">Inicio <strong><?=track_e((string)$trackingPremium['started_at'])?></strong></span>
        <span class="tracking-premium-chip">Tiempo registrado <strong><?=track_e((string)$trackingPremium['duration'])?></strong></span>
      </div>
    </div>

    <div class="tracking-premium-ring" style="--tracking-progress:<?=$trackingPremiumProgress?>%">
      <div class="tracking-premium-ring-content">
        <strong><?=$trackingPremiumProgress?>%</strong>
        <span><?=$trackingPremium['is_complete']?'completado':'avance'?></span>
      </div>
    </div>
  </div>

  <div class="tracking-premium-current">
    <div class="tracking-premium-current-main">
      <div class="tracking-premium-current-icon"><?=track_e((string)($trackingPremiumCurrent['icon'] ?? '●'))?></div>
      <div>
        <span>Estado actual</span>
        <strong><?=track_e((string)($trackingPremiumCurrent['label'] ?? 'Pedido'))?></strong>
      </div>
    </div>

    <div class="tracking-premium-next">
      <?= $trackingVisualCancelled ? 'Proceso detenido' : 'Próximo paso' ?>
      <b><?=track_e((string)($trackingPremiumNext['icon'] ?? '→'))?> <?=track_e((string)($trackingPremiumNext['label'] ?? 'Por confirmar'))?></b>
    </div>
  </div>

  <div class="tracking-premium-metrics">
    <div class="tracking-premium-metric tone-pink">
      <span>Movimientos</span>
      <strong><?=((int)$trackingPremium['movement_count'])?> registrados</strong>
      <small>Cambios confirmados dentro del expediente de producción.</small>
    </div>
    <div class="tracking-premium-metric tone-purple">
      <span>Última actualización</span>
      <strong><?=track_e((string)$trackingPremium['updated_at'])?></strong>
      <small>Último movimiento reportado por nuestro equipo.</small>
    </div>
    <div class="tracking-premium-metric tone-green">
      <span>Avance general</span>
      <strong><?=$trackingPremiumProgress?>% del recorrido</strong>
      <small>Calculado sobre las etapas del Kanban de Producción.</small>
    </div>
    <div class="tracking-premium-metric tone-gold">
      <span>Siguiente objetivo</span>
      <strong><?=track_e((string)($trackingPremiumNext['label'] ?? 'Por confirmar'))?></strong>
      <small><?=track_e((string)($trackingPremiumNext['message'] ?? 'Continuaremos actualizando tu pedido.'))?></small>
    </div>
  </div>

  <div class="tracking-premium-section-head">
    <div>
      <span class="eyebrow">HISTORIA DE PRODUCCIÓN</span>
      <h3>Cada etapa cuenta una parte de tu pedido</h3>
      <p>Te mostramos los movimientos registrados para que conozcas qué ocurrió, cuándo ocurrió y en qué punto se encuentra tu proyecto.</p>
    </div>
    <div class="tracking-premium-legend"><i></i> Información confirmada en SISACT</div>
  </div>

  <?php if (!$trackingPremiumHistory): ?>
    <p class="muted" style="padding:20px 30px 30px">Aún no hay movimientos registrados.</p>
  <?php else: ?>
    <div class="tracking-premium-story">
      <?php foreach ($trackingPremiumHistory as $idx=>$entry):
        $entryKey=(string)($entry['key'] ?? '');
        $isCurrent=($entryKey === $trackingVisualCurrentKey);
        $isComplete=!$isCurrent;
      ?>
        <article class="tracking-premium-card <?=$isCurrent?'is-current':''?> <?=$isComplete?'is-complete':''?>">
          <div class="tracking-premium-card-head">
            <div class="tracking-premium-card-icon"><?=track_e((string)($entry['icon'] ?? '●'))?></div>
            <div>
              <span class="tracking-premium-card-index">Movimiento <?=str_pad((string)($idx+1),2,'0',STR_PAD_LEFT)?></span>
              <h4><?=track_e((string)($entry['label'] ?? 'Actualización'))?></h4>
              <time><?=track_date($entry['created_at'] ?? null,'d/m/Y H:i')?></time>
              <span class="tracking-premium-card-state"><?=$isCurrent?'● Etapa actual':'✓ Registrado'?></span>
            </div>
          </div>

          <p class="tracking-premium-card-note"><?=nl2br(track_e((string)($entry['note'] ?? 'Movimiento registrado en el proceso de producción.')))?></p>

          <div class="tracking-premium-card-footer">
            <span><?=track_e((string)$trackingPremium['order_number'])?></span>
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

    // 5. Retirar vitrina V1.1 e insertar V2 después del resumen two-col.
    $src = tsv2_remove_v11_offers($src);

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

<?php if ($order && !$trackingVisualCancelled && !empty($trackingPremiumOffers)): ?>
<section class="tracking-card tracking-offers-v2">
  <div class="tracking-offers-v2-head">
    <div class="tracking-offers-v2-headline">
      <div>
        <span class="tracking-offers-v2-kicker">Selección Colibrí · Exclusivo para clientes</span>
        <h2>Ideas para tu próximo proyecto</h2>
        <p>Tu seguimiento también puede inspirarte. Descubre otros servicios de Colibrí Print y consulta las promociones vigentes para impresión, personalización y fabricación.</p>
      </div>
      <a class="tracking-offers-v2-main-cta" href="<?=track_e((string)$trackingPremium['whatsapp_url'])?>" target="_blank" rel="noopener">💬 Consultar promociones</a>
    </div>
  </div>

  <div class="tracking-offers-v2-grid">
    <?php foreach ($trackingPremiumOffers as $offer): ?>
      <article class="tracking-offer-v2 accent-<?=track_e((string)($offer['accent'] ?? 'cyan'))?>">
        <div class="tracking-offer-v2-top">
          <div class="tracking-offer-v2-icon"><?=track_e((string)($offer['icon'] ?? '✨'))?></div>
          <span class="tracking-offer-v2-tag"><?=track_e((string)($offer['tag'] ?? 'Destacado'))?></span>
        </div>
        <span class="tracking-offer-v2-eyebrow"><?=track_e((string)($offer['eyebrow'] ?? 'SERVICIO'))?></span>
        <h3><?=track_e((string)($offer['title'] ?? 'Servicio Colibrí Print'))?></h3>
        <p><?=track_e((string)($offer['text'] ?? ''))?></p>
        <span class="tracking-offer-v2-benefit">✦ <?=track_e((string)($offer['benefit'] ?? 'Consulta disponibilidad'))?></span>
        <a href="<?=track_e((string)($offer['href'] ?? '#'))?>" target="_blank" rel="noopener">
          <?=track_e((string)($offer['cta'] ?? 'Ver más'))?>
          <span>→</span>
        </a>
      </article>
    <?php endforeach; ?>
  </div>

  <div class="tracking-offers-v2-foot">
    <span><strong>Nota:</strong> precios, disponibilidad y promociones pueden cambiar. Confirma la oferta vigente antes de ordenar.</span>
    <a href="<?=track_e((string)$trackingPremium['site_url'])?>/#servicios" target="_blank" rel="noopener">Explorar todos los servicios →</a>
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
                if (!is_file($trackingPath)) {
                    throw new RuntimeException('No se encontró seguimiento.php.');
                }

                $current = (string)file_get_contents($trackingPath);
                if ($current === '') {
                    throw new RuntimeException('No se pudo leer seguimiento.php.');
                }

                $new = tsv2_patch($current);
                tsv2_backup($trackingPath);
                tsv2_write($trackingPath, $new);

                $messages[] = 'V2 Premium instalada correctamente.';
                $messages[] = 'Se conservó la lógica V1.1, Kanban, pagos, comprobantes y CFDI.';
                $messages[] = 'Se agregó porcentaje visual de avance y resumen premium del pedido.';
                $messages[] = 'Se renovó la historia de producción y la vitrina de servicios/promociones.';
            }

            if ($action === 'revert') {
                $backup = $trackingPath . '.bak_tracking_visual_v2';
                if (!is_file($backup)) {
                    throw new RuntimeException('No existe respaldo V2 de seguimiento.php.');
                }

                if (!copy($backup, $trackingPath)) {
                    throw new RuntimeException('No se pudo restaurar seguimiento.php.');
                }

                if (function_exists('opcache_invalidate')) {
                    @opcache_invalidate($trackingPath, true);
                }

                $messages[] = 'seguimiento.php restaurado al estado anterior a V2.';
            }
        } catch (Throwable $e) {
            $error = $e->getMessage();
        }
    }
}

$helperReady = is_file($root . '/includes/tracking_experience_v2.php');
$cssReady = is_file($root . '/assets/css/seguimiento-visual-ofertas-v2.css');
$v11Ready = is_file($root . '/includes/tracking_experience_v1_1.php');

require __DIR__ . '/../includes/header.php';
?>
<style>
.tsv2{max-width:1080px;margin:20px auto}.tsv2-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:10px;margin:18px 0}.tsv2-stat{padding:14px;border:1px solid rgba(255,255,255,.1);border-radius:12px}.tsv2-stat small{display:block;color:var(--muted)}.tsv2-stat strong{display:block;margin-top:5px}.tsv2-ok{color:#67e7be}.tsv2-note{padding:15px;border:1px solid rgba(82,208,255,.20);border-radius:12px;background:rgba(82,208,255,.05);line-height:1.7}.tsv2-premium{margin-top:12px;padding:14px;border:1px solid rgba(255,79,140,.18);border-radius:12px;background:linear-gradient(135deg,rgba(22,169,239,.06),rgba(255,79,140,.05));line-height:1.7}@media(max-width:760px){.tsv2-grid{grid-template-columns:1fr 1fr}}
</style>
<div class="tsv2">
  <div class="card" style="padding:22px">
    <span class="eyebrow">SEGUIMIENTO · EXPERIENCIA PREMIUM</span>
    <h2>Seguimiento Visual + Ofertas V2 Premium</h2>
    <p class="muted">Actualización sobre V1.1 validada. Refina únicamente la experiencia del cliente y mantiene intacta la lógica operativa.</p>

    <?php if ($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>
    <?php foreach ($messages as $message): ?><div class="notice"><span class="ok">✓</span> <?=e($message)?></div><?php endforeach; ?>

    <div class="tsv2-grid">
      <div class="tsv2-stat"><small>Base V1.1</small><strong class="<?=$v11Ready?'tsv2-ok':''?>"><?=$v11Ready?'✓ detectada':'faltante'?></strong></div>
      <div class="tsv2-stat"><small>Helper Premium</small><strong class="<?=$helperReady?'tsv2-ok':''?>"><?=$helperReady?'✓ listo':'faltante'?></strong></div>
      <div class="tsv2-stat"><small>CSS Premium</small><strong class="<?=$cssReady?'tsv2-ok':''?>"><?=$cssReady?'✓ listo':'faltante'?></strong></div>
      <div class="tsv2-stat"><small>Base de datos</small><strong class="tsv2-ok">Sin cambios</strong></div>
    </div>

    <div class="tsv2-note">
      <strong>Se conserva</strong><br>
      Kanban de 8 etapas · validación de cancelaciones · pagos · comprobantes · CFDI · conceptos · desglose comercial · token público.
    </div>

    <div class="tsv2-premium">
      <strong>V2 Premium agrega</strong><br>
      Anillo de avance porcentual · resumen ejecutivo de la orden · tiempo registrado · próximo objetivo · storytelling visual de cada movimiento · vitrina comercial premium con CTAs y promociones/servicios actuales.
    </div>

    <form method="post" style="display:flex;gap:10px;flex-wrap:wrap;margin-top:18px">
      <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
      <button class="btn btn-primary" type="submit" name="action" value="install">Instalar V2 Premium</button>
      <a class="btn btn-secondary" href="/seguimiento.php" target="_blank" rel="noopener">Abrir seguimiento</a>
      <button class="btn btn-secondary" type="submit" name="action" value="revert" onclick="return confirm('¿Restaurar seguimiento.php al estado anterior a V2?');">Revertir V2</button>
    </form>
  </div>
</div>
<?php require __DIR__ . '/../includes/footer.php'; ?>
