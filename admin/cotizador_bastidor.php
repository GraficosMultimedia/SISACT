<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/calculadoras.php';
require_auth();
$title='Bastidor + Lona';
$defaults=['calculator.bastidor.ptr_m'=>65,'calculator.bastidor.canvas_m2'=>55,'calculator.bastidor.print_m2'=>85,'calculator.bastidor.labor_hour'=>120,'calculator.bastidor.waste_pct'=>10,'calculator.bastidor.margin_pct'=>35];
$s=calculator_settings($defaults);
$input=['width_cm'=>'','height_cm'=>'','crossbars'=>0,'ptr_m'=>$s['calculator.bastidor.ptr_m'],'canvas_m2'=>$s['calculator.bastidor.canvas_m2'],'print_m2'=>$s['calculator.bastidor.print_m2'],'labor_hours'=>1,'labor_hour'=>$s['calculator.bastidor.labor_hour'],'waste_pct'=>$s['calculator.bastidor.waste_pct'],'margin_pct'=>$s['calculator.bastidor.margin_pct']];
$result=null;
if($_SERVER['REQUEST_METHOD']==='POST'){
  if(!csrf_check($_POST['_csrf']??null)){$error='La sesión del formulario expiró. Recarga la página.';}
  else{$input=array_merge($input,[
    'width_cm'=>max(0,(float)($_POST['width_cm']??0)),'height_cm'=>max(0,(float)($_POST['height_cm']??0)),'crossbars'=>max(0,(int)($_POST['crossbars']??0)),
    'ptr_m'=>max(0,(float)($_POST['ptr_m']??0)),'canvas_m2'=>max(0,(float)($_POST['canvas_m2']??0)),'print_m2'=>max(0,(float)($_POST['print_m2']??0)),
    'labor_hours'=>max(0,(float)($_POST['labor_hours']??0)),'labor_hour'=>max(0,(float)($_POST['labor_hour']??0)),'waste_pct'=>max(0,min(100,(float)($_POST['waste_pct']??0))),'margin_pct'=>max(0,min(99,(float)($_POST['margin_pct']??0)))
  ]);if($input['width_cm']<=0||$input['height_cm']<=0)$error='Captura ancho y alto mayores a cero.';else{$result=calc_bastidor($input);$_SESSION['cp_pending_quote']=['source'=>'bastidor_lona','title'=>'Bastidor + Lona','input'=>$input,'result'=>$result,'created_at'=>date('c')];log_activity('calculate','calculators','Cálculo interno Bastidor + Lona');}}
}
require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/cotizadores.css">
<div class="toolbar"><div class="toolbar-title"><span class="eyebrow">FASE 4 · COTIZADOR</span><h2>Bastidor + Lona</h2><span class="muted">Costos internos y precio de venta estimado.</span></div><div class="toolbar-actions"><?=cancel_button('/admin/cotizadores.php')?></div></div>
<?php if(!empty($error)): ?><div class="notice danger" style="margin-bottom:14px"><?=e($error)?></div><?php endif; ?>
<div class="calc-layout"><div class="card"><form method="post"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><div class="section-label">Medidas y estructura</div><div class="form-grid"><div class="field"><label>Ancho (cm)</label><input data-auto-focus type="number" step="0.01" min="0" name="width_cm" value="<?=e((string)$input['width_cm'])?>" required></div><div class="field"><label>Alto (cm)</label><input type="number" step="0.01" min="0" name="height_cm" value="<?=e((string)$input['height_cm'])?>" required></div><div class="field"><label>Travesaños</label><input type="number" min="0" step="1" name="crossbars" value="<?=e((string)$input['crossbars'])?>"></div><div class="field"><label>Horas de mano de obra</label><input type="number" step="0.01" min="0" name="labor_hours" value="<?=e((string)$input['labor_hours'])?>"></div></div><div class="section-label" style="margin-top:20px">Tarifas internas</div><div class="form-grid"><div class="field"><label>PTR / metro</label><input type="number" step="0.01" min="0" name="ptr_m" value="<?=e((string)$input['ptr_m'])?>"></div><div class="field"><label>Lona / m²</label><input type="number" step="0.01" min="0" name="canvas_m2" value="<?=e((string)$input['canvas_m2'])?>"></div><div class="field"><label>Impresión / m²</label><input type="number" step="0.01" min="0" name="print_m2" value="<?=e((string)$input['print_m2'])?>"></div><div class="field"><label>Mano de obra / hora</label><input type="number" step="0.01" min="0" name="labor_hour" value="<?=e((string)$input['labor_hour'])?>"></div><div class="field"><label>Desperdicio</label><div class="input-suffix"><input type="number" step="0.01" min="0" max="100" name="waste_pct" value="<?=e((string)$input['waste_pct'])?>"><span>%</span></div></div><div class="field"><label>Margen sobre venta</label><div class="input-suffix"><input type="number" step="0.01" min="0" max="99" name="margin_pct" value="<?=e((string)$input['margin_pct'])?>"><span>%</span></div></div></div><div class="form-actions"><?=cancel_button('/admin/cotizadores.php')?><?=save_button('Calcular costo')?></div></form></div>
<div class="card result-card result-preview-card">
  <div class="result-preview-head"><div><span class="eyebrow">RESULTADO DEL CÁLCULO</span><h3>Listo para revisar</h3></div><span class="result-lock">🔒 Interno</span></div>
  <div id="calcResultPreview" class="result-preview">
    <?php if($result): ?><div class="result-preview-price"><span>Precio de venta estimado</span><strong><?=money($result['sale'])?></strong><small>Utilidad: <?=money($result['profit'])?></small></div><button type="button" class="btn btn-primary js-open-result">Ver desglose completo</button><?php else: ?><div class="empty">Captura las medidas y presiona <strong>Calcular costo</strong>. El resultado aparecerá en una ventana emergente.</div><?php endif; ?>
  </div>
</div></div>
<?php if($result): ?><script>window.CP_CALC_RESULT=<?=json_encode(['type'=>'Bastidor + Lona','input'=>$input,'result'=>$result],JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES|JSON_NUMERIC_CHECK)?>;</script><?php endif; ?>
<div class="notice calc-footnote">El desperdicio se aplica a PTR, lona e impresión. El resultado se guarda temporalmente en la sesión para que la Fase 5 pueda convertirlo en una cotización formal, sin volver a capturar los datos.</div>
<script src="/assets/js/cotizadores.js" defer></script>
<?php require __DIR__ . '/../includes/footer.php'; ?>
