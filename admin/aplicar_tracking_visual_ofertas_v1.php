<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';

require_auth();

$title = 'Seguimiento Visual + Ofertas V1';
$root = dirname(__DIR__);
$trackingPath = $root . '/seguimiento.php';
$error = null;
$messages = [];

function tsv1_backup(string $path): void
{
    if (!is_file($path)) {
        throw new RuntimeException('No se encontró ' . $path . '.');
    }
    $backup = $path . '.bak_tracking_visual_v1';
    if (!is_file($backup) && !copy($path, $backup)) {
        throw new RuntimeException('No se pudo respaldar ' . basename($path) . '.');
    }
}

function tsv1_write(string $path, string $content): void
{
    $tmp = $path . '.tsv1.tmp';
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

function tsv1_patch_tracking(string $src): string
{
    if (str_contains($src, 'SISACT_TRACKING_VISUAL_OFFERS_V1')) {
        return $src;
    }

    $companyInclude = "require_once __DIR__ . '/includes/company.php';";
    if (!str_contains($src, $companyInclude)) {
        throw new RuntimeException('seguimiento.php: no se encontró includes/company.php.');
    }

    $src = str_replace(
        $companyInclude,
        $companyInclude . "\nrequire_once __DIR__ . '/includes/tracking_experience_v1.php';\n// SISACT_TRACKING_VISUAL_OFFERS_V1",
        $src
    );    $waLine = <<<'PHP'
$waUrl = ($order && $companyWhatsAppHref !== '') ? 'https://wa.me/' . $companyWhatsAppHref . '?text=' . rawurlencode('Hola Colibrí Print México, quiero consultar mi pedido ' . ($order['order_number'] ?? '') . '.') : '#';
PHP;
    if (!str_contains($src, $waLine)) {
        throw new RuntimeException('seguimiento.php: no se encontró la línea de WhatsApp.');
    }

    $waInjected = <<<'PHP'
$waUrl = ($order && $companyWhatsAppHref !== '') ? 'https://wa.me/' . $companyWhatsAppHref . '?text=' . rawurlencode('Hola Colibrí Print México, quiero consultar mi pedido ' . ($order['order_number'] ?? '') . '.') : '#';
$trackingExpV1 = trackexp_v1_build(
    $order,
    $history,
    $clientHistory,
    $clientStages,
    $currentClient,
    $currentInternal,
    $company
);
$trackingVisualStats = $trackingExpV1['stats'];
$trackingOfferCards = $trackingExpV1['offers'];
$trackingStartedAt = $trackingExpV1['started_at'];
$trackingUpdatedAt = $trackingExpV1['updated_at'];
$trackingNextStage = $trackingExpV1['next_label'];
PHP;

    $src = str_replace(
        $waLine,
        $waInjected,
        $src
    );

    $styleMarker = ".not-found{padding:50px;text-align:center;margin-top:16px}";
    if (!str_contains($src, $styleMarker)) {
        throw new RuntimeException('seguimiento.php: no se encontró el bloque CSS esperado.');
    }

    $styleInsert = <<<'CSS'
.history-intro{display:flex;justify-content:space-between;gap:16px;align-items:flex-start;margin-top:10px;padding:16px 18px;border:1px solid #dce9f7;border-radius:18px;background:linear-gradient(135deg,#eef8ff 0%,#fff7fb 55%,#f6fbff 100%)}
.history-intro-copy h3{margin:0;color:var(--navy);font-size:18px}
.history-intro-copy p{margin:6px 0 0;color:#58708d;font-size:12px;line-height:1.65;max-width:680px}
.history-intro-badge{min-width:200px;padding:14px 16px;border-radius:16px;background:linear-gradient(135deg,#102a56,#158ddf);color:#fff;box-shadow:0 14px 32px rgba(16,42,86,.18)}
.history-intro-badge span{display:block;font-size:10px;font-weight:800;letter-spacing:.08em;text-transform:uppercase;color:#bfe8ff}
.history-intro-badge strong{display:block;margin-top:6px;font-size:13px;line-height:1.5}
.history-kpis{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-top:14px}
.history-kpi{position:relative;overflow:hidden;border:1px solid #e3ebf5;border-radius:18px;background:#fff;padding:16px 15px;box-shadow:0 10px 24px rgba(16,42,86,.06)}
.history-kpi:before{content:"";position:absolute;inset:0 auto 0 0;width:4px;border-radius:20px;background:#18a8f0}
.history-kpi.tone-pink:before{background:#ff5d8f}
.history-kpi.tone-cyan:before{background:#18a8f0}
.history-kpi.tone-green:before{background:#19a85b}
.history-kpi.tone-gold:before{background:#f4b63c}
.history-kpi span{display:block;color:#7d8ea4;font-size:10px;font-weight:800;text-transform:uppercase;letter-spacing:.07em}
.history-kpi strong{display:block;margin-top:7px;color:var(--navy);font-size:14px;line-height:1.45}
.history-kpi small{display:block;margin-top:7px;color:#678;line-height:1.55;font-size:11px}
.storyboard{margin-top:18px;display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px}
.story-card{position:relative;overflow:hidden;border:1px solid #e0eaf4;border-radius:20px;padding:18px;background:linear-gradient(180deg,#fff 0%,#fbfdff 100%);box-shadow:0 12px 26px rgba(16,42,86,.07)}
.story-card:after{content:"";position:absolute;inset:auto -55px -55px auto;width:140px;height:140px;border-radius:50%;background:radial-gradient(circle,rgba(24,168,240,.12),transparent 70%);pointer-events:none}
.story-card.is-current{border-color:#9dd8ff;background:linear-gradient(180deg,#f4fbff 0%,#fff 100%)}
.story-card.is-current:before{content:"Etapa actual";position:absolute;top:14px;right:14px;padding:6px 10px;border-radius:999px;background:#e7f7ff;color:#0b77bf;font-size:10px;font-weight:800;letter-spacing:.05em;text-transform:uppercase}
.story-card.tone-approval{border-color:#ffd78e;background:linear-gradient(180deg,#fff9eb 0%,#fff 100%)}
.story-head{display:flex;gap:12px;align-items:flex-start}
.story-icon{width:48px;height:48px;border-radius:16px;background:linear-gradient(135deg,#eef7ff,#dff2ff);border:1px solid #cde5f7;display:flex;align-items:center;justify-content:center;font-size:21px;flex:0 0 auto}
.story-card.tone-approval .story-icon{background:linear-gradient(135deg,#fff5d8,#ffeab0);border-color:#ffd47a}
.story-meta{min-width:0;flex:1}
.story-step{display:inline-block;color:#7890a7;font-size:10px;font-weight:800;letter-spacing:.08em;text-transform:uppercase}
.story-meta h3{margin:5px 0 0;color:var(--navy);font-size:17px}
.story-date{display:block;margin-top:4px;color:#8899ad;font-size:11px}
.story-badge{display:inline-flex;align-items:center;gap:6px;margin-top:11px;padding:7px 10px;border-radius:999px;background:#eef8ff;color:#0d77c4;font-size:10px;font-weight:800;text-transform:uppercase;letter-spacing:.05em}
.story-card.is-current .story-badge{background:#eaf9f1;color:#087443}
.story-note{margin:13px 0 0;color:#556981;font-size:12px;line-height:1.68}
.story-footer{display:flex;justify-content:space-between;align-items:center;gap:10px;margin-top:14px;padding-top:12px;border-top:1px dashed #e2eaf3;color:#71849c;font-size:11px}
.story-footer strong{color:var(--navy)}
.offer-showcase{margin-top:16px;padding:22px}
.offer-showcase-header{display:flex;justify-content:space-between;align-items:flex-start;gap:18px;margin-bottom:14px}
.offer-showcase-header p{margin:6px 0 0;color:#637793;font-size:12px;max-width:700px;line-height:1.65}
.offer-showcase-header a{display:inline-flex;align-items:center;gap:8px;text-decoration:none;padding:11px 14px;border-radius:12px;border:1px solid #cfe3f7;background:#f4fbff;color:#0d77c4;font-weight:800;font-size:12px}
.offer-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px}
.offer-card{position:relative;overflow:hidden;border:1px solid #dfe9f4;border-radius:20px;padding:18px;background:linear-gradient(180deg,#ffffff 0%,#fbfdff 100%);box-shadow:0 12px 26px rgba(16,42,86,.07)}
.offer-card:before{content:"";position:absolute;inset:0 auto 0 0;width:5px;background:#18a8f0}
.offer-card.accent-pink:before{background:#ff4f84}
.offer-card.accent-cyan:before{background:#18a8f0}
.offer-card.accent-green:before{background:#19a85b}
.offer-card.accent-gold:before{background:#f4b63c}
.offer-tag{display:inline-flex;padding:6px 10px;border-radius:999px;background:#eef7ff;color:#0d77c4;font-size:10px;font-weight:800;text-transform:uppercase;letter-spacing:.05em}
.offer-card.accent-pink .offer-tag{background:#fff0f5;color:#cf1f5d}
.offer-card.accent-green .offer-tag{background:#edf9f2;color:#0b7d49}
.offer-card.accent-gold .offer-tag{background:#fff6df;color:#b67a00}
.offer-card h3{margin:12px 0 0;color:var(--navy);font-size:18px}
.offer-card p{margin:9px 0 0;color:#5b7089;font-size:12px;line-height:1.68}
.offer-meta{display:block;margin-top:10px;color:#8093a8;font-size:11px;line-height:1.6}
.offer-cta{display:inline-flex;align-items:center;justify-content:center;margin-top:16px;text-decoration:none;padding:11px 14px;border-radius:12px;background:linear-gradient(135deg,#087bd9,#18a8f0);color:#fff;font-size:12px;font-weight:800;box-shadow:0 14px 28px rgba(8,123,217,.18)}
@media(max-width:900px){.history-kpis,.storyboard,.offer-grid{grid-template-columns:1fr 1fr}.history-intro{display:block}.history-intro-badge{margin-top:14px;min-width:0}}
@media(max-width:760px){.history-kpis,.storyboard,.offer-grid{grid-template-columns:1fr}.history-intro{padding:14px}.history-intro-copy h3{font-size:16px}.story-card.is-current:before{position:static;display:inline-flex;margin-bottom:10px}}
CSS;

    $src = str_replace(
        $styleMarker,
        $styleInsert . "\n" . $styleMarker,
        $src
    );

    $historyOld = <<<'PHP'
<section class="history tracking-card">
  <div class="section-title"><div><span class="eyebrow">ACTUALIZACIONES</span><h2>Lo que ha pasado</h2></div></div>
  <?php if (!$clientHistory): ?>
    <p class="muted">Aún no hay actualizaciones registradas.</p>
  <?php else: ?>
  <div class="timeline">
    <?php foreach ($clientHistory as $entry): ?>
    <div class="timeline-item <?=($entry['key']==='approval'?'timeline-approval':'')?>">
      <div class="timeline-dot"><?=$entry['icon']?></div>
      <div><strong><?=track_e($entry['label'])?></strong><time><?=track_date($entry['created_at'],'d/m/Y H:i')?></time>
      <?php if(trim((string)$entry['note'])!==''): ?><p><?=nl2br(track_e($entry['note']))?></p><?php endif; ?></div>
    </div>
    <?php endforeach; ?>
  </div>
  <?php endif; ?>
</section>
PHP;

    if (!str_contains($src, $historyOld)) {
        throw new RuntimeException('seguimiento.php: no se encontró el bloque de historial esperado.');
    }

    $historyNew = <<<'PHP'
<section class="history tracking-card">
  <div class="section-title"><div><span class="eyebrow">ACTUALIZACIONES</span><h2>Tu pedido paso a paso</h2></div></div>
  <div class="history-intro">
    <div class="history-intro-copy">
      <h3>Seguimiento más visual, claro y creativo</h3>
      <p>Transformamos el historial técnico en una experiencia más útil para tu cliente. Aquí puede entender el avance, detectar la etapa actual y ver cómo Colibrí Print está trabajando su pedido.</p>
    </div>
    <div class="history-intro-badge">
      <span>Resumen rápido</span>
      <strong>Inicio: <?=track_e($trackingStartedAt)?><br>Último movimiento: <?=track_e($trackingUpdatedAt)?><br>Próxima etapa: <?=track_e($trackingNextStage)?></strong>
    </div>
  </div>

  <div class="history-kpis">
    <?php foreach ($trackingVisualStats as $stat): ?>
      <div class="history-kpi tone-<?=track_e((string)($stat['tone'] ?? 'cyan'))?>">
        <span><?=track_e((string)($stat['label'] ?? 'Dato'))?></span>
        <strong><?=track_e((string)($stat['value'] ?? ''))?></strong>
        <small><?=track_e((string)($stat['hint'] ?? ''))?></small>
      </div>
    <?php endforeach; ?>
  </div>

  <?php if (!$clientHistory): ?>
    <p class="muted" style="margin-top:16px">Aún no hay actualizaciones registradas.</p>
  <?php else: ?>
  <div class="storyboard">
    <?php foreach ($clientHistory as $index => $entry): ?>
      <?php $isCurrentStory = ((string)($entry['key'] ?? '') === $currentClient) || (((string)($entry['key'] ?? '') === 'approval') && $currentInternal === 'approval'); ?>
      <article class="story-card <?=((string)($entry['key'] ?? '')==='approval'?'tone-approval':'')?> <?=$isCurrentStory?'is-current':''?>">
        <div class="story-head">
          <div class="story-icon"><?=$entry['icon']?></div>
          <div class="story-meta">
            <span class="story-step">Paso <?=str_pad((string)($index + 1), 2, '0', STR_PAD_LEFT)?></span>
            <h3><?=track_e((string)$entry['label'])?></h3>
            <span class="story-date"><?=track_date((string)($entry['created_at'] ?? ''),'d/m/Y H:i')?></span>
            <span class="story-badge"><?=$isCurrentStory?'🟢 Etapa en curso':'✓ Proceso completado'?></span>
          </div>
        </div>
        <?php if(trim((string)($entry['note'] ?? ''))!==''): ?>
          <p class="story-note"><?=nl2br(track_e((string)$entry['note']))?></p>
        <?php else: ?>
          <p class="story-note">Hemos registrado esta etapa dentro del flujo de producción de tu pedido.</p>
        <?php endif; ?>
        <div class="story-footer">
          <span>Pedido <?=track_e((string)($order['order_number'] ?? ''))?></span>
          <strong><?=track_e((string)$entry['label'])?></strong>
        </div>
      </article>
    <?php endforeach; ?>
  </div>
  <?php endif; ?>
</section>
PHP;

    $src = str_replace($historyOld, $historyNew, $src);

    $twoColOld = <<<'PHP'
<section class="two-col">
  <article class="current-message">
    <span class="eyebrow">ACTUALIZACIÓN</span>
    <h2><?=$clientStages[$currentClient]['icon']?> <?=track_e($clientStages[$currentClient]['label'])?></h2>
    <p><?=nl2br(track_e($latestMessage))?></p>
    <small>Última actualización: <?=track_date($history ? $history[count($history)-1]['created_at'] : null,'d/m/Y H:i')?></small>
  </article>
  <article class="order-summary">
    <span class="eyebrow">INFORMACIÓN DE LA ORDEN</span>
    <div class="info-row"><span>Pedido</span><strong><?=track_e($order['order_number'])?></strong></div>
    <div class="info-row"><span>Fecha de pedido</span><strong><?=track_date($order['order_date'])?></strong></div>
    <div class="info-row"><span>Entrega estimada</span><strong><?=track_date($order['due_date'])?></strong></div>
    <div class="info-row total"><span>Total</span><strong><?=track_money((float)$order['total'])?></strong></div>
  </article>
</section>
PHP;

    if (!str_contains($src, $twoColOld)) {
        throw new RuntimeException('seguimiento.php: no se encontró el bloque de resumen esperado.');
    }

    $twoColNew = <<<'PHP'
<section class="two-col">
  <article class="current-message">
    <span class="eyebrow">ACTUALIZACIÓN</span>
    <h2><?=$clientStages[$currentClient]['icon']?> <?=track_e($clientStages[$currentClient]['label'])?></h2>
    <p><?=nl2br(track_e($latestMessage))?></p>
    <small>Última actualización: <?=track_date($history ? $history[count($history)-1]['created_at'] : null,'d/m/Y H:i')?></small>
  </article>
  <article class="order-summary">
    <span class="eyebrow">INFORMACIÓN DE LA ORDEN</span>
    <div class="info-row"><span>Pedido</span><strong><?=track_e($order['order_number'])?></strong></div>
    <div class="info-row"><span>Fecha de pedido</span><strong><?=track_date($order['order_date'])?></strong></div>
    <div class="info-row"><span>Entrega estimada</span><strong><?=track_date($order['due_date'])?></strong></div>
    <div class="info-row total"><span>Total</span><strong><?=track_money((float)$order['total'])?></strong></div>
  </article>
</section>
<?php if ($order && !empty($trackingOfferCards)): ?>
<section class="tracking-card offer-showcase">
  <div class="offer-showcase-header">
    <div>
      <span class="eyebrow">EXCLUSIVO PARA TI</span>
      <h2 style="margin:5px 0 0;color:var(--navy)">Promociones y servicios que puedes aprovechar hoy</h2>
      <p>Aprovecha el seguimiento de tu orden para descubrir otras soluciones de Colibrí Print. Este bloque funciona como vitrina comercial para mostrar la creatividad, personalización y servicios vigentes de tu negocio.</p>
    </div>
    <a href="<?=track_e(trackexp_v1_catalog_url((string)($company['website'] ?? '')) )?>" target="_blank" rel="noopener">Ver catálogo y servicios ↗</a>
  </div>
  <div class="offer-grid">
    <?php foreach ($trackingOfferCards as $offer): ?>
      <article class="offer-card accent-<?=track_e((string)($offer['accent'] ?? 'cyan'))?>">
        <span class="offer-tag"><?=track_e((string)($offer['tag'] ?? 'Destacado'))?></span>
        <h3><?=track_e((string)($offer['title'] ?? 'Servicio'))?></h3>
        <p><?=track_e((string)($offer['text'] ?? ''))?></p>
        <?php if (trim((string)($offer['meta'] ?? '')) !== ''): ?>
          <span class="offer-meta"><?=track_e((string)$offer['meta'])?></span>
        <?php endif; ?>
        <a class="offer-cta" href="<?=track_e((string)($offer['href'] ?? '#'))?>" target="_blank" rel="noopener"><?=track_e((string)($offer['cta'] ?? 'Ver más'))?></a>
      </article>
    <?php endforeach; ?>
  </div>
</section>
<?php endif; ?>
PHP;

    $src = str_replace($twoColOld, $twoColNew, $src);

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
                $new = tsv1_patch_tracking($current);
                tsv1_backup($trackingPath);
                tsv1_write($trackingPath, $new);
                $messages[] = 'Seguimiento público actualizado con bloque visual creativo.';
                $messages[] = 'Se agregó un tablero de etapas con KPIs y tarjetas de historia.';
                $messages[] = 'Se agregó un nuevo bloque de promociones y servicios destacados.';
            }
            if ($action === 'revert') {
                $backup = $trackingPath . '.bak_tracking_visual_v1';
                if (!is_file($backup)) {
                    throw new RuntimeException('No existe respaldo para seguimiento.php.');
                }
                if (!copy($backup, $trackingPath)) {
                    throw new RuntimeException('No se pudo restaurar seguimiento.php.');
                }
                if (function_exists('opcache_invalidate')) {
                    @opcache_invalidate($trackingPath, true);
                }
                $messages[] = 'seguimiento.php restaurado desde el respaldo.';
            }
        } catch (Throwable $e) {
            $error = $e->getMessage();
        }
    }
}

$helperReady = is_file($root . '/includes/tracking_experience_v1.php');

require __DIR__ . '/../includes/header.php';
?>
<style>
.tsv1{max-width:1050px;margin:20px auto}
.tsv1-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:10px;margin:18px 0}
.tsv1-stat{padding:14px;border:1px solid rgba(255,255,255,.1);border-radius:12px}
.tsv1-stat small{display:block;color:var(--muted)}
.tsv1-stat strong{display:block;margin-top:6px}
.tsv1-ok{color:#67e7be}
.tsv1-note{padding:15px;border:1px solid rgba(82,208,255,.18);border-radius:12px;background:rgba(82,208,255,.05);line-height:1.7}
@media(max-width:760px){.tsv1-grid{grid-template-columns:1fr}}
</style>
<div class="tsv1">
  <div class="card" style="padding:22px">
    <span class="eyebrow">SEGUIMIENTO · EXPERIENCIA DEL CLIENTE</span>
    <h2>Seguimiento Visual + Ofertas V1</h2>
    <p class="muted">Moderniza el bloque de actualizaciones del seguimiento público y agrega una vitrina de promociones/servicios para que el cliente vea más valor en Colibrí Print.</p>

    <?php if ($error): ?>
      <div class="notice danger"><?=e($error)?></div>
    <?php endif; ?>

    <?php foreach ($messages as $message): ?>
      <div class="notice"><span class="ok">✓</span> <?=e($message)?></div>
    <?php endforeach; ?>

    <div class="tsv1-grid">
      <div class="tsv1-stat"><small>Helper</small><strong class="<?=$helperReady?'tsv1-ok':''?>"><?=$helperReady?'✓ listo':'faltante'?></strong></div>
      <div class="tsv1-stat"><small>Historia visual</small><strong class="tsv1-ok">✓ listo</strong></div>
      <div class="tsv1-stat"><small>KPIs del pedido</small><strong class="tsv1-ok">✓ listo</strong></div>
      <div class="tsv1-stat"><small>Promociones</small><strong class="tsv1-ok">✓ listo</strong></div>
    </div>

    <div class="tsv1-note">
      <strong>Qué instala</strong><br>
      1) Reemplaza el bloque “Lo que ha pasado” por una presentación más visual.<br>
      2) Agrega tarjetas informativas con etapa actual, etapas registradas, última actualización y próximo paso.<br>
      3) Inserta un nuevo bloque comercial con promociones y servicios destacados.
    </div>

    <form method="post" style="display:flex;gap:10px;flex-wrap:wrap;margin-top:18px">
      <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
      <button class="btn btn-primary" type="submit" name="action" value="install">Instalar V1</button>
      <a class="btn btn-secondary" href="/seguimiento.php" target="_blank" rel="noopener">Abrir seguimiento</a>
      <button class="btn btn-secondary" type="submit" name="action" value="revert" onclick="return confirm('¿Restaurar seguimiento.php?');">Revertir</button>
    </form>
  </div>
</div>
<?php require __DIR__ . '/../includes/footer.php'; ?>
