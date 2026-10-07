<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/impresiones.php';
require_auth();

$title = 'Control de metraje';
$error = null;
$saved = false;
$rollCreated = false;

try {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (!csrf_check($_POST['_csrf'] ?? null)) {
            throw new RuntimeException('La sesión del formulario expiró. Recarga la página.');
        }

        $action = (string)($_POST['action'] ?? '');
        if ($action === 'create_roll') {
            $id = print_meter_create_roll((string)($_POST['roll_name'] ?? ''), (float)($_POST['initial_m'] ?? 0));
            log_activity('create', 'print_rolls', 'Rollo creado #' . $id);
            redirect('/admin/impresiones.php?roll_created=1');
        }

        if ($action === 'register_print') {
            $payload = print_meter_normalize($_POST);
            if ($payload['roll_id'] <= 0 || $payload['linear_m'] <= 0 || $payload['job_name'] === '') {
                throw new RuntimeException('Completa rollo, trabajo y metros lineales.');
            }
            $id = print_meter_register($payload);
            log_activity('create', 'print_meter_logs', 'Trabajo impreso #' . $id . ' · ' . $payload['linear_m'] . ' m');
            redirect('/admin/impresiones.php?saved=1');
        }
    }
} catch (Throwable $e) {
    $error = $e instanceof RuntimeException ? $e->getMessage() : 'No se pudo guardar el registro.';
}

if (isset($_GET['saved'])) $saved = true;
if (isset($_GET['roll_created'])) $rollCreated = true;

$rolls = [];
$metrics = ['jobs'=>0,'printed_m'=>0,'waste_m'=>0,'good_m'=>0];
$activeRoll = null;
$rows = [];
$rollAnalytics = [];
$usageBreakdown = ['rolls'=>[],'initial_m'=>0,'used_m'=>0,'remaining_m'=>0,'waste_m'=>0,'good_m'=>0,'jobs'=>0,'used_pct'=>0,'remaining_pct'=>0,'waste_pct'=>0];
try {
    $rolls = print_meter_active_rolls();
    $metrics = print_meter_dashboard();
    $activeRoll = print_meter_active_roll();
    $rows = print_meter_rows();
    $usageBreakdown = print_meter_usage_breakdown();
    $rollAnalytics = $usageBreakdown['rolls'];
} catch (Throwable $e) {
    $error = $error ?: 'No se pudo cargar el módulo de metraje. Verifica que la migración 017 esté instalada.';
}

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/impresiones.css?v=20260918-metros1">
<link rel="stylesheet" href="/assets/css/impresiones-dashboard-v2.css?v=20260919-1">
<link rel="stylesheet" href="/assets/css/impresiones-wizard-v2.css?v=20260920-2">
<script src="/assets/js/impresiones-wizard-v2.js?v=20260920-2" defer></script>
<div class="meter-toolbar">
  <div>
    <span class="eyebrow">PRODUCCIÓN · CONTROL DE LONA</span>
    <h2>Metros de impresión</h2>
    <p class="muted">Solo registra los metros lineales consumidos por cada trabajo y descuéntalos del rollo utilizado.</p>
  </div>
</div>

<?php if ($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>
<?php if ($saved): ?><div class="notice"><span class="ok">✓</span> Impresión registrada correctamente. <strong>Movimiento #<?=e((string)($_GET['log_id'] ?? ''))?></strong> · metros descontados del rollo.</div><?php endif; ?><?php if (isset($_GET['save_error'])): ?><div class="notice danger"><strong>No se registró la impresión.</strong><br><?=e((string)$_GET['save_error'])?></div><?php endif; ?>
<?php if ($rollCreated): ?><div class="notice"><span class="ok">✓</span> Rollo creado correctamente.</div><?php endif; ?>

<div class="capture-launchbar no-print">
  <div>
    <span class="eyebrow">CAPTURA RÁPIDA · PRONTEXP</span>
    <strong>Registra un trabajo sin salir del panel</strong>
    <small>La captura se abre en una ventana guiada. El formulario conserva el proceso actual de registro y descuento.</small>
  </div>
  <button type="button" class="btn btn-primary capture-open-btn" id="openPrintCapture">＋ Registrar impresión</button>
</div>

<div class="meter-kpis">
  <div class="meter-kpi"><span>Metros disponibles</span><strong><?=number_format((float)$usageBreakdown['remaining_m'],3)?> m</strong><small>Saldo actual en rollos</small></div>
  <div class="meter-kpi used"><span>Metros consumidos</span><strong><?=number_format((float)$usageBreakdown['used_m'],3)?> m</strong><small><?=number_format((float)$usageBreakdown['used_pct'],1)?>% del material cargado</small></div>
  <div class="meter-kpi good"><span>Producción buena</span><strong><?=number_format((float)$metrics['good_m'],3)?> m</strong><small>Metros aprovechables</small></div>
  <div class="meter-kpi waste"><span>Merma</span><strong><?=number_format((float)$metrics['waste_m'],3)?> m</strong><small><?=number_format((float)$usageBreakdown['waste_pct'],1)?>% del consumo</small></div>
</div>

<section class="meter-analytics-grid">
  <article class="card meter-analytics-card">
    <div class="section-heading">
      <div>
        <span class="eyebrow">INVENTARIO DISPONIBLE</span>
        <h3>Distribución de metros disponibles</h3>
        <p class="muted">Muestra cuánto material queda en cada rollo y qué porcentaje representa dentro del inventario disponible.</p>
      </div>
      <span class="meter-analytics-total"><?=number_format((float)$usageBreakdown['remaining_m'],3)?> m disponibles</span>
    </div>

    <div class="meter-donut-layout">
      <?php
        $availableTotal=max(0.0001,(float)$usageBreakdown['remaining_m']);
        $segments=[];
        $angle=0.0;
        foreach($rollAnalytics as $index=>$roll):
          $pct=round(((float)$roll['remaining_m']/$availableTotal)*100,1);
          $next=$angle + ($pct*3.6);
          $hue=($index*57)%360;
          $segments[]='hsl('.$hue.' 80% 60%) '.$angle.'deg '.$next.'deg';
          $angle=$next;
        endforeach;
        $donutGradient=$segments ? 'conic-gradient('.implode(',',$segments).')' : 'conic-gradient(#22364a 0deg 360deg)';
      ?>
      <div class="meter-donut meter-donut-available" style="background:<?=$donutGradient?>">
        <div class="meter-donut-center">
          <strong><?=number_format((float)$usageBreakdown['remaining_m'],1)?> m</strong>
          <span>disponibles</span>
        </div>
      </div>

      <div class="meter-legend">
        <?php foreach($rollAnalytics as $index=>$roll):
          $pct=round(((float)$roll['remaining_m']/$availableTotal)*100,1);
          $hue=($index*57)%360;
        ?>
          <div class="meter-legend-item meter-legend-available">
            <span class="meter-legend-dot" style="--hue:<?=$hue?>"></span>
            <div>
              <strong><?=e($roll['roll_name'])?></strong>
              <small><?=number_format((float)$roll['remaining_m'],3)?> m disponibles · <?=$pct?>% del inventario</small>
              <small>Consumido: <?=number_format((float)$roll['used_m'],3)?> m · Inicial: <?=number_format((float)$roll['initial_m'],3)?> m</small>
            </div>
          </div>
        <?php endforeach; ?>
        <?php if(!$rollAnalytics): ?><p class="muted">Aún no hay rollos registrados.</p><?php endif; ?>
      </div>
    </div>
  </article>

  <?php $lowRolls=array_values(array_filter($rollAnalytics,fn($r)=>(float)$r['remaining_pct']<=20)); ?>
  <div class="material-alert <?=$lowRolls?'material-alert-warning':'material-alert-ok'?>">
    <div class="material-alert-icon"><?=$lowRolls?'⚠':'✓'?></div>
    <div>
      <strong><?=$lowRolls?'Atención: material bajo en un rollo':'Inventario de rollos en rango normal'?></strong>
      <p>
        <?php if($lowRolls): foreach($lowRolls as $lr): ?>
          <?=e($lr['roll_name'])?>: <b><?=number_format((float)$lr['remaining_m'],3)?> m</b> restantes<?php endforeach; ?>
        <?php else: ?>
          Ningún rollo está por debajo del 20% de su metraje inicial.
        <?php endif; ?>
      </p>
    </div>
  </div>

  <article class="card meter-analytics-card">
    <div class="section-heading">
      <div>
        <span class="eyebrow">ESTADO DE ROLLOS</span>
        <h3>¿Qué rollo se está agotando?</h3>
        <p class="muted">Barra = porcentaje consumido del metraje inicial.</p>
      </div>
    </div>

    <div class="roll-usage-list">
      <?php foreach($rollAnalytics as $roll): ?>
        <div class="roll-usage-item">
          <div class="roll-usage-top">
            <div>
              <strong><?=e($roll['roll_name'])?></strong>
              <small><?=$roll['health_label']?> · <?=$roll['jobs']?> <?=($roll['jobs']===1?'trabajo':'trabajos')?></small>
            </div>
            <b><?=number_format((float)$roll['used_pct'],1)?>%</b>
          </div>
          <div class="roll-usage-bar">
            <span class="roll-usage-fill roll-health-<?=$roll['health']?>" style="width:<?=max(0,min(100,(float)$roll['used_pct']))?>%"></span>
          </div>
          <div class="roll-usage-meta">
            <span>Inicial <b><?=number_format((float)$roll['initial_m'],3)?> m</b></span>
            <span>Usado <b><?=number_format((float)$roll['used_m'],3)?> m</b></span>
            <span>Disponible <b><?=number_format((float)$roll['remaining_m'],3)?> m</b></span>
          </div>
        </div>
      <?php endforeach; ?>
      <?php if(!$rollAnalytics): ?><p class="muted">Aún no hay rollos registrados.</p><?php endif; ?>
    </div>
  </article>
</section>

<section class="card meter-summary-card">
  <div class="section-heading">
    <div>
      <span class="eyebrow">RESUMEN DE MATERIAL</span>
      <h3>Control global del inventario de rollos</h3>
    </div>
  </div>
  <div class="meter-summary-grid">
    <div><span>Metraje inicial</span><strong><?=number_format((float)$usageBreakdown['initial_m'],3)?> m</strong><small>Suma de todos los rollos registrados</small></div>
    <div><span>Consumido</span><strong><?=number_format((float)$usageBreakdown['used_m'],3)?> m</strong><small>Descontado por trabajos</small></div>
    <div><span>Disponible</span><strong><?=number_format((float)$usageBreakdown['remaining_m'],3)?> m</strong><small>Saldo calculado en los rollos</small></div>
    <div><span>Trabajos registrados</span><strong><?=number_format((int)$usageBreakdown['jobs'])?></strong><small>Con consumo asociado</small></div>
  </div>
</section>

<section class="meter-grid-top">
  <article class="card meter-roll-card">
    <div class="section-heading">
      <div><span class="eyebrow">ROLLO ACTIVO</span><h3><?=e($activeRoll['roll_name'] ?? 'No hay rollo activo')?></h3></div>
      <?php if ($activeRoll): ?><span class="meter-balance"><?=number_format((float)$activeRoll['remaining_m'],3)?> m</span><?php endif; ?>
    </div>
    <?php if ($activeRoll): ?>
      <div class="meter-progress"><span style="width:<?=max(0,min(100,((float)$activeRoll['remaining_m']/max(0.001,(float)$activeRoll['initial_m']))*100))?>%"></span></div>
      <p class="muted">Inicial: <?=number_format((float)$activeRoll['initial_m'],3)?> m · Disponible: <?=number_format((float)$activeRoll['remaining_m'],3)?> m · Consumido: <?=number_format(max(0,(float)$activeRoll['initial_m']-(float)$activeRoll['remaining_m']),3)?> m</p>
    <?php else: ?>
      <p class="muted">Crea un rollo nuevo para comenzar a registrar impresiones.</p>
    <?php endif; ?>
    <form method="post" class="meter-roll-form">
      <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
      <input type="hidden" name="action" value="create_roll">
      <div class="field"><label>Nuevo rollo</label><input name="roll_name" placeholder="Ej. Rollo Lona 1" required></div>
      <div class="field"><label>Metros iniciales</label><input type="number" step="0.001" min="0.001" name="initial_m" placeholder="50.000" required></div>
      <button class="btn btn-primary" type="submit">+ Abrir rollo</button>
    </form>
  </article>

  <div class="capture-modal" id="printCaptureModal" aria-hidden="true">
    <div class="capture-modal-backdrop" data-close-capture></div>
    <div class="capture-modal-dialog" role="dialog" aria-modal="true" aria-labelledby="printCaptureTitle">
      <div class="capture-modal-topline">
        <span>COLIBRÍ PRINT · CONTROL DE METRAJE</span>
        <span class="capture-modal-chip">CAPTURA INTERNA</span>
      </div>
      <article class="card meter-register-card capture-modal-card" id="printCaptureCard">
        <div class="section-heading">
          <div><span class="eyebrow">PRONTEXP · CAPTURA GUIADA</span><h3>Registrar impresión</h3><p class="muted">Completa los datos, verifica el rollo y confirma antes de descontar.</p></div>
          <button type="button" class="capture-close-btn" id="closePrintCapture" aria-label="Cerrar captura">×</button>
        </div>

        <form method="post" action="/api/registrar_impresion.php" class="meter-form" id="meterForm">
          <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
          <input type="hidden" name="action" value="register_print">
          <input type="hidden" name="roll_name" id="selected_roll_name" value="">
          <div class="meter-form-grid">
            <div class="capture-step-label"><span>01</span><div><strong>Datos del trabajo</strong><small>Cuándo y qué trabajo estás registrando.</small></div></div>
            <div class="field"><label>Fecha y hora</label><input type="datetime-local" name="printed_at" value="<?=e(date('Y-m-d\TH:i'))?>" required></div>
            <div class="field"><label>Rollo</label><select name="roll_id" id="roll_id" required><option value="">Seleccionar rollo</option><?php foreach($rolls as $r): ?><option data-roll-id="<?=((int)$r['id'])?>" data-roll-name="<?=e($r['roll_name'])?>" data-remaining="<?=e((string)$r['remaining_m'])?>" value="<?=((int)$r['id'])?>" <?=($activeRoll && (int)$activeRoll['id']===(int)$r['id'])?'selected':''?>><?=e($r['roll_name'])?> · <?=number_format((float)$r['remaining_m'],3)?> m disponibles</option><?php endforeach; ?></select></div>
            <div class="field field-wide"><label>Nombre del trabajo en Printexp</label><input name="job_name" placeholder="Ej. lonas figuras y mtra.prt" required></div>
            <div class="capture-step-label"><span>02</span><div><strong>Consumo Printexp</strong><small>Captura los datos que tomaste de la pantalla.</small></div></div>
            <div class="field"><label>Job Size · largo (mm)</label><input id="job_length_mm" type="number" step="0.01" min="0" name="job_length_mm" placeholder="3810.00"></div>
            <div class="field"><label>Metros lineales</label><input id="linear_m" type="number" step="0.001" min="0" name="linear_m" placeholder="3.810" required></div>
            <div class="capture-step-label"><span>03</span><div><strong>Resultado</strong><small>Define cómo terminó la impresión.</small></div></div>
            <div class="field"><label>Resultado</label><select name="result_status" id="result_status"><?php foreach(print_meter_results() as $k=>$label): ?><option value="<?=e($k)?>"><?=e($label)?></option><?php endforeach; ?></select></div>
          </div>

          <div class="roll-selection-confirm">
            <div class="roll-selection-confirm-head">
              <span>VERIFICACIÓN DEL ROLLO</span>
              <strong id="selected_roll_label">Selecciona un rollo</strong>
            </div>
            <div class="roll-selection-confirm-grid">
              <div><small>ID</small><b id="selected_roll_id">—</b></div>
              <div><small>DISPONIBLE</small><b id="selected_roll_available">—</b></div>
              <div><small>CONSUMO</small><b id="selected_roll_consumption">—</b></div>
              <div><small>QUEDARÁ</small><b id="selected_roll_after">—</b></div>
            </div>
          </div>

          <div class="meter-preview"><span>Consumo del rollo</span><strong id="consumption_preview">0.000 m</strong><small>Todo trabajo impreso consume material. Test, cancelación, atrapamiento y reimpresión se registran como merma.</small></div>
          <div class="capture-confirm-note">🔒 El registro conserva el rollo, los metros y el historial actuales. La confirmación final se realiza antes del descuento.</div>
          <button class="btn btn-primary capture-submit" type="submit">Registrar y descontar</button>
        </form>
      </article>
    </div>
  </div>
</section>

<section class="card meter-history-card">
  <div class="section-heading"><div><span class="eyebrow">HISTORIAL</span><h3>Trabajos impresos</h3><p class="muted">Metros descontados del rollo por cada trabajo.</p></div></div>
  <div class="table-wrap"><table class="meter-table"><thead><tr><th>ID</th><th>Fecha</th><th>Rollo</th><th>Trabajo</th><th>Job Size</th><th>Metros</th><th>Resultado</th><th>Merma</th></tr></thead><tbody>
  <?php foreach($rows as $r): ?><tr><td><span class="meter-log-id">#<?=((int)$r['id'])?></span></td><td><?=e(date('d/m/Y H:i',strtotime((string)$r['printed_at'])))?></td><td><?=e($r['roll_name'])?></td><td><?=e($r['job_name'])?></td><td><?=number_format((float)$r['job_length_mm'],2)?> mm</td><td><strong><?=number_format((float)$r['linear_m'],3)?> m</strong></td><td><span class="meter-status meter-status-<?=e((string)$r['result_status'])?>"><?=e(print_meter_result_label((string)$r['result_status']))?></span></td><td><?=number_format((float)$r['waste_m'],3)?> m</td></tr><?php endforeach; ?>
  <?php if(!$rows): ?><tr><td colspan="8" class="empty">Todavía no hay trabajos registrados.</td></tr><?php endif; ?>
  </tbody></table></div>
</section>

<script>
(function(){
  const mm=document.getElementById('job_length_mm');
  const m=document.getElementById('linear_m');
  const p=document.getElementById('consumption_preview');
  const rollSelect=document.getElementById('roll_id');
  const rollNameField=document.getElementById('selected_roll_name');
  const form=document.getElementById('meterForm');

  function num(v){
    const n=parseFloat(String(v||'').replace(',','.'));
    return Number.isFinite(n) ? n : 0;
  }

  function syncRoll(){
    const opt=rollSelect?.selectedOptions?.[0];
    const name=(opt?.dataset?.rollName||'').trim();
    const id=opt?.dataset?.rollId||rollSelect?.value||'';
    const available=num(opt?.dataset?.remaining);
    const consumption=num(m?.value);

    if(rollNameField) rollNameField.value=name;

    const elName=document.getElementById('selected_roll_label');
    const elId=document.getElementById('selected_roll_id');
    const elAvail=document.getElementById('selected_roll_available');
    const elConsumption=document.getElementById('selected_roll_consumption');
    const elAfter=document.getElementById('selected_roll_after');

    if(elName) elName.textContent=name||'Selecciona un rollo';
    if(elId) elId.textContent=name ? '#'+id : '—';
    if(elAvail) elAvail.textContent=name ? available.toFixed(3)+' m' : '—';
    if(elConsumption) elConsumption.textContent=consumption>0 ? consumption.toFixed(3)+' m' : '—';
    if(elAfter) elAfter.textContent=(name&&consumption>0)?Math.max(0,available-consumption).toFixed(3)+' m':'—';
  }

  function sync(fromMm){
    const mmVal=num(mm?.value);
    if(fromMm && mmVal>0) m.value=(mmVal/1000).toFixed(3);
    const finalM=num(m?.value);
    if(p) p.textContent=finalM.toFixed(3)+' m';
    syncRoll();
  }

  mm?.addEventListener('input',()=>sync(true));
  m?.addEventListener('input',()=>sync(false));
  rollSelect?.addEventListener('change',()=>syncRoll());

  syncRoll();
  sync(false);

  form?.addEventListener('submit',function(event){
    syncRoll();

    const option=rollSelect?.selectedOptions?.[0];
    const rollName=(option?.dataset?.rollName||'').trim();
    const rollId=option?.dataset?.rollId||rollSelect?.value||'';
    const available=num(option?.dataset?.remaining);
    const consumption=num(m?.value);
    const job=(form.querySelector('[name="job_name"]')?.value||'').trim();

    if(!rollId||!rollName||!job||consumption<=0){
      event.preventDefault();
      alert('Completa el rollo, nombre del trabajo y metros antes de registrar.');
      return;
    }

    if(consumption>available+0.0001){
      event.preventDefault();
      alert(
        'NO SE PUEDE REGISTRAR\\n\\n'+
        'Rollo: '+rollName+' (#'+rollId+')\\n'+
        'Disponible: '+available.toFixed(3)+' m\\n'+
        'Consumo: '+consumption.toFixed(3)+' m'
      );
      return;
    }

    const message=
      '⚠️ CONFIRMACIÓN FINAL\\n\\n'+
      'VAS A DESCONTAR DEL SIGUIENTE ROLLO:\\n\\n'+
      'ROLLO: '+rollName+'\\n'+
      'ID: #'+rollId+'\\n'+
      'DISPONIBLE: '+available.toFixed(3)+' m\\n\\n'+
      'TRABAJO: '+job+'\\n'+
      'CONSUMO: '+consumption.toFixed(3)+' m\\n\\n'+
      'SALDO DESPUÉS: '+Math.max(0,available-consumption).toFixed(3)+' m\\n\\n'+
      '¿CONFIRMAS QUE ESTE ES EL ROLLO CORRECTO?';

    if(!window.confirm(message)){
      event.preventDefault();
    }
  });
})();
</script>
<?php require __DIR__ . '/../includes/footer.php'; ?>

<script>
(function(){
  const modal=document.getElementById('printCaptureModal');
  const open=document.getElementById('openPrintCapture');
  const close=document.getElementById('closePrintCapture');
  const form=document.getElementById('meterForm');
  if(!modal||!open) return;

  const focusable=()=>modal.querySelectorAll('button,select,input:not([type="hidden"]),textarea,a[href]');
  let lastFocus=null;

  function openCapture(){
    lastFocus=document.activeElement;
    modal.classList.add('is-open');
    modal.setAttribute('aria-hidden','false');
    document.body.classList.add('capture-modal-open');
    requestAnimationFrame(()=>{
      const first=modal.querySelector('#roll_id, input[name="job_name"], input:not([type="hidden"])');
      (first||open).focus();
    });
  }

  function closeCapture(){
    modal.classList.remove('is-open');
    modal.setAttribute('aria-hidden','true');
    document.body.classList.remove('capture-modal-open');
    if(lastFocus && typeof lastFocus.focus==='function') lastFocus.focus();
  }

  open.addEventListener('click',openCapture);
  close?.addEventListener('click',closeCapture);
  modal.addEventListener('click',e=>{
    if(e.target.matches('[data-close-capture]')) closeCapture();
  });

  document.addEventListener('keydown',e=>{
    if(!modal.classList.contains('is-open')) return;
    if(e.key==='Escape'){ e.preventDefault(); closeCapture(); return; }

    if(e.key==='Tab'){
      const items=[...focusable()].filter(el=>!el.disabled && el.offsetParent!==null);
      if(!items.length)return;
      const first=items[0], last=items[items.length-1];
      if(e.shiftKey && document.activeElement===first){e.preventDefault();last.focus();}
      else if(!e.shiftKey && document.activeElement===last){e.preventDefault();first.focus();}
    }
  });

  form?.addEventListener('submit',()=>{
    open.disabled=true;
    setTimeout(()=>{open.disabled=false;},2500);
  },{capture:true});
})();
</script>
<?php require __DIR__ . '/../includes/footer.php'; ?>