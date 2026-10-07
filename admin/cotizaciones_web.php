<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();

$title='Solicitudes web de cotización';
$error=null;
$pdo=db();

function cpqw3_h($v): string {
    return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8');
}

$hasConversionColumns=false;
try {
    $st=$pdo->prepare("SELECT COUNT(*) FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA=DATABASE()
          AND TABLE_NAME='cp_web_quote_requests'
          AND COLUMN_NAME='converted_quote_id'");
    $st->execute();
    $hasConversionColumns=(int)$st->fetchColumn()===1;
} catch(Throwable $e){}

if($_SERVER['REQUEST_METHOD']==='POST' && ($_POST['action']??'')==='status'){
    if(!csrf_check($_POST['_csrf']??null)){
        $error='La sesión expiró. Recarga la página.';
    }else{
        $id=(int)($_POST['id']??0);
        $status=(string)($_POST['status']??'');
        if($id>0 && in_array($status,['new','reviewing','quoted','closed','spam'],true)){
            try{
                $st=$pdo->prepare('UPDATE cp_web_quote_requests SET status=?,updated_at=NOW() WHERE id=?');
                $st->execute([$status,$id]);
                redirect('/admin/cotizaciones_web.php?updated=1');
            }catch(Throwable $e){
                $error='No se pudo actualizar el estado.';
            }
        }
    }
}

$rows=[];
try{
    $extra=$hasConversionColumns?',converted_quote_id,converted_at':'';
    $st=$pdo->query(
        "SELECT id,request_token,service_key,customer_name,email,phone,quantity,desired_date,
                attachment_name,status,created_at,updated_at,request_text{$extra}
         FROM cp_web_quote_requests
         ORDER BY id DESC LIMIT 200"
    );
    $rows=$st->fetchAll(PDO::FETCH_ASSOC);
}catch(Throwable $e){
    $error='No se pudieron cargar las solicitudes web.';
}

require __DIR__ . '/../includes/header.php';
?>

<style>
#cpqw3{
  --bg:#071321;--panel:#0b1b2a;--panel2:#0d2232;--line:#21465f;
  --text:#f5f8fb;--muted:#8fa6b6;--cyan:#22c8f1;--green:#20d69a;
  --yellow:#ffbf1e;--red:#ff607a;--blue:#398fff;
}
#cpqw3 *{box-sizing:border-box}
#cpqw3 .wrap{max-width:1360px;margin:0 auto;padding:4px 0 48px}
#cpqw3 .head{display:flex;justify-content:space-between;align-items:end;gap:24px;padding:10px 0 22px;border-bottom:1px solid rgba(255,255,255,.09)}
#cpqw3 .eyebrow{font-size:10px;font-weight:900;letter-spacing:.16em;color:#1bd4ff;text-transform:uppercase}
#cpqw3 h1{font-size:clamp(30px,3vw,44px);line-height:1.05;margin:6px 0}
#cpqw3 .lead{color:var(--muted);font-size:14px;line-height:1.55;margin:0;max-width:800px}
#cpqw3 .head-actions,#cpqw3 .global-actions{display:flex;gap:8px;flex-wrap:wrap}
#cpqw3 .btn3{
  appearance:none;border:1px solid #2b526c;background:#10283a;color:#fff;border-radius:10px;
  min-height:40px;padding:9px 13px;font:800 12px/1 Arial,sans-serif;text-decoration:none;
  display:inline-flex;align-items:center;justify-content:center;gap:7px;cursor:pointer
}
#cpqw3 .btn3:hover:not(:disabled){border-color:#46d8ff;transform:translateY(-1px)}
#cpqw3 .btn3:disabled{opacity:.4;cursor:not-allowed}
#cpqw3 .primary{background:linear-gradient(135deg,#189ff7,#20c9ed);border-color:transparent}
#cpqw3 .convert{background:#0d3e34;border-color:#1b6b59;color:#7df0cc}
#cpqw3 .danger{background:#3a1421;border-color:#6e2840;color:#ff8da2}
#cpqw3 .notice3{padding:11px 13px;border-radius:10px;background:#0c2232;border:1px solid #26516a;color:#b6cad6;font-size:12px;margin:14px 0}
#cpqw3 .toolbar{
  display:flex;justify-content:space-between;align-items:center;gap:14px;
  padding:12px 14px;margin:16px 0;border:1px solid var(--line);border-radius:13px;background:linear-gradient(180deg,#0d2030,#091724)
}
#cpqw3 .master{display:flex;align-items:center;gap:9px;font-size:13px;font-weight:800}
#cpqw3 input[type=checkbox]{accent-color:#1bc5ed}
#cpqw3 .selection-count{font-size:11px;color:#7894a7}
#cpqw3 .list{display:grid;gap:13px}
#cpqw3 .card3{
  border:1px solid #1d4058;border-radius:15px;overflow:hidden;
  background:radial-gradient(circle at 100% 0%,rgba(34,200,241,.06),transparent 30%),linear-gradient(180deg,#0c1d2b,#091622)
}
#cpqw3 .card-head{display:grid;grid-template-columns:22px minmax(0,1fr) auto;gap:12px;align-items:start;padding:16px 17px;border-bottom:1px solid rgba(255,255,255,.075)}
#cpqw3 .ref{font-size:16px;font-weight:900}.name{color:#fff}
#cpqw3 .meta{display:flex;gap:11px;flex-wrap:wrap;color:#849db0;font-size:10px;margin-top:6px}
#cpqw3 .meta b{color:#ffc11f}
#cpqw3 .status{padding:6px 9px;border-radius:999px;font-size:9px;font-weight:1000;text-transform:uppercase}
#cpqw3 .new{color:#ffd05a;background:#3a2a07}.reviewing{color:#6fe1ff;background:#103447}.quoted{color:#71edbe;background:#0c392e}.closed{color:#acb8c2;background:#22303a}.spam{color:#ff8296;background:#3d1520}
#cpqw3 .body{display:grid;grid-template-columns:minmax(0,1.6fr) minmax(245px,.65fr);gap:15px;padding:15px 17px}
#cpqw3 .preview{
  max-height:210px;overflow:auto;white-space:pre-wrap;overflow-wrap:anywhere;
  padding:12px;border-radius:11px;background:#061019;border:1px solid rgba(255,255,255,.06);
  color:#b8c8d3;font:11px/1.55 Consolas,monospace
}
#cpqw3 .file{display:flex;gap:7px;flex-wrap:wrap;align-items:center;margin-top:9px;padding:9px 10px;border-radius:9px;border:1px solid rgba(34,200,241,.18);background:#081a26;color:#9bb0bd;font-size:10px}
#cpqw3 .file strong{color:#fff;overflow-wrap:anywhere}.file a{color:#61dcff;font-weight:800;text-decoration:none}
#cpqw3 .side{display:grid;gap:8px;align-content:start}
#cpqw3 .side .btn3{width:100%}
#cpqw3 .converted{
  padding:10px;border-radius:10px;border:1px solid #1a6259;background:#0a2927;color:#86ecd6;
  font-size:10px;line-height:1.5
}
#cpqw3 .locked{padding:10px;border:1px dashed #2a485b;border-radius:10px;color:#8399a8;font-size:10px}
#cpqw3 .status-form{display:grid;grid-template-columns:minmax(0,1fr) auto;gap:7px}
#cpqw3 .status-form select{width:100%;min-height:39px;background:#07131f;color:#fff;border:1px solid #244a63;border-radius:9px;padding:8px 10px;font-size:11px}
#cpqw3 .empty{padding:30px;text-align:center;border:1px dashed #29475c;border-radius:14px;color:#8da2b1}
#cpqw3 .focus{outline:2px solid #21c8f3}
@media(max-width:900px){
  #cpqw3 .head{align-items:flex-start;flex-direction:column}
  #cpqw3 .head-actions{width:100%}#cpqw3 .head-actions .btn3{flex:1}
  #cpqw3 .toolbar{align-items:stretch;flex-direction:column}
  #cpqw3 .global-actions{width:100%}#cpqw3 .global-actions .btn3{flex:1}
  #cpqw3 .body{grid-template-columns:1fr}
}
@media(max-width:560px){
  #cpqw3 .card-head{grid-template-columns:22px minmax(0,1fr)}
  #cpqw3 .status{grid-column:2;justify-self:start}
  #cpqw3 .status-form{grid-template-columns:1fr}
  #cpqw3 .side .btn3{min-height:44px}
}
</style>

<main id="cpqw3">
<div class="wrap">
  <header class="head">
    <div>
      <div class="eyebrow">PLATAFORMA · ENTRADA WEB · CENTRO DE CONTROL</div>
      <h1>Solicitudes web de cotización</h1>
      <p class="lead">Gestiona los expedientes enviados desde la pasarela pública. Convierte una solicitud en cotización sin volver a capturar sus datos.</p>
    </div>
    <div class="head-actions">
      <a class="btn3 primary" href="/cotizador.php" target="_blank" rel="noopener">Abrir pasarela ↗</a>
      <a class="btn3" href="/admin/cotizaciones_web.php">↻ Actualizar</a>
    </div>
  </header>

  <?php if($error):?><div class="notice3"><?=cpqw3_h($error)?></div><?php endif;?>
  <?php if(isset($_GET['updated'])):?><div class="notice3">✓ Estado actualizado.</div><?php endif;?>
  <?php if(isset($_GET['edited'])):?><div class="notice3">✓ Solicitud actualizada.</div><?php endif;?>
  <?php if(isset($_GET['deleted'])):?><div class="notice3">✓ Solicitud(es) eliminada(s).</div><?php endif;?>
  <?php if(isset($_GET['blocked'])):?><div class="notice3">ℹ Las solicitudes ya convertidas permanecen protegidas.</div><?php endif;?>
  <?php if(isset($_GET['converted'])):?><div class="notice3">✓ Solicitud convertida correctamente en cotización.</div><?php endif;?>

  <section class="toolbar" aria-label="Acciones globales">
    <label class="master"><input type="checkbox" id="cpqw3All"><span>Seleccionar todo</span><span class="selection-count" id="cpqw3Count">0 seleccionadas</span></label>
    <div class="global-actions">
      <button type="button" class="btn3" id="cpqw3Edit" disabled>✎ Editar</button>
      <button type="button" class="btn3 convert" id="cpqw3Convert" disabled>⚡ Convertir</button>
      <button type="button" class="btn3 danger" id="cpqw3Delete" disabled>🗑 Borrar</button>
    </div>
  </section>

  <section class="list">
  <?php foreach($rows as $row):
    $id=(int)$row['id'];
    $reference='CPQ-'.str_pad((string)$id,6,'0',STR_PAD_LEFT);
    $status=strtolower((string)$row['status']);
    $statusClass=preg_replace('/[^a-z]/','',$status);
    $convertedId=$hasConversionColumns?(int)($row['converted_quote_id']??0):0;
    $requestText=(string)$row['request_text'];
    $filePath='';
    $marker=strpos($requestText,'[CPQ_JSON]');
    if($marker!==false){
      $payload=json_decode(trim(substr($requestText,$marker+strlen('[CPQ_JSON]'))),true);
      if(is_array($payload))$filePath=(string)($payload['attachment']['relative_path']??'');
    }
  ?>
    <article class="card3" id="cpqw3-<?=$id?>">
      <div class="card-head">
        <input class="cpqw3Select" type="checkbox" value="<?=$id?>" data-converted="<?=$convertedId>0?'1':'0'?>" aria-label="Seleccionar <?=$reference?>">
        <div>
          <div class="ref"><?=$reference?> <span class="name">· <?=cpqw3_h($row['customer_name'])?></span></div>
          <div class="meta">
            <span><b>Servicio:</b> <?=cpqw3_h($row['service_key'])?></span>
            <?php if($row['quantity']!==''):?><span><b>Cantidad:</b> <?=cpqw3_h($row['quantity'])?></span><?php endif;?>
            <?php if($row['desired_date']):?><span><b>Fecha:</b> <?=cpqw3_h($row['desired_date'])?></span><?php endif;?>
            <span><b>Recibido:</b> <?=cpqw3_h(date('d/m/Y H:i',strtotime((string)$row['created_at'])))?></span>
          </div>
        </div>
        <span class="status <?=$statusClass?>"><?=cpqw3_h($row['status'])?></span>
      </div>

      <div class="body">
        <div>
          <div class="preview"><?=cpqw3_h($requestText)?></div>
          <?php if($row['attachment_name']):?>
            <div class="file">📎 <strong><?=cpqw3_h($row['attachment_name'])?></strong>
              <?php if($filePath && preg_match('#^/uploads/cotizador/[A-Za-z0-9/_\.-]+$#',$filePath)):?>
                <a href="<?=cpqw3_h($filePath)?>" target="_blank" rel="noopener">Abrir archivo ↗</a>
              <?php endif;?>
            </div>
          <?php endif;?>
        </div>

        <div class="side">
          <?php if($convertedId>0):?>
            <div class="converted">✓ Convertida a cotización formal<br><strong>ID: <?=$convertedId?></strong></div>
            <a class="btn3" href="/admin/cotizacion.php?id=<?=$convertedId?>">📄 Abrir cotización</a>
          <?php else:?>
            <form method="post" action="/admin/cotizacion_desde_web.php" onsubmit="return confirm('Se creará una cotización formal usando los datos de esta solicitud. No tendrás que capturarlos nuevamente. ¿Continuar?');">
              <input type="hidden" name="_csrf" value="<?=cpqw3_h(csrf_token())?>">
              <input type="hidden" name="request_id" value="<?=$id?>">
              <button class="btn3 convert" type="submit">⚡ Convertir en cotización</button>
            </form>
          <?php endif;?>

          <a class="btn3" href="/admin/cotizacion_web_editar.php?id=<?=$id?>">✎ Editar</a>

          <?php if($convertedId<=0):?>
            <form method="post" action="/admin/cotizacion_web_eliminar.php" onsubmit="return confirm('¿Eliminar <?=$reference?>? El archivo adjunto también se eliminará.');">
              <input type="hidden" name="_csrf" value="<?=cpqw3_h(csrf_token())?>">
              <input type="hidden" name="ids[]" value="<?=$id?>">
              <button class="btn3 danger" type="submit">🗑 Borrar</button>
            </form>
          <?php else:?>
            <div class="locked">🔒 Protegida por cotización</div>
          <?php endif;?>

          <?php if($row['phone']):?>
            <a class="btn3" href="https://wa.me/<?=cpqw3_h(preg_replace('/\D+/','',(string)$row['phone']))?>?text=<?=rawurlencode('Hola '.(string)$row['customer_name'].', damos seguimiento a tu solicitud '.$reference.'.')?>" target="_blank" rel="noopener">💬 WhatsApp</a>
          <?php endif;?>
          <?php if($row['email']):?><a class="btn3" href="mailto:<?=cpqw3_h($row['email'])?>">✉ Correo</a><?php endif;?>

          <form method="post" class="status-form">
            <input type="hidden" name="_csrf" value="<?=cpqw3_h(csrf_token())?>">
            <input type="hidden" name="action" value="status">
            <input type="hidden" name="id" value="<?=$id?>">
            <select name="status" aria-label="Estado">
              <?php foreach(['new'=>'Nueva','reviewing'=>'En revisión','quoted'=>'Cotizada','closed'=>'Cerrada','spam'=>'Spam'] as $k=>$label):?>
                <option value="<?=$k?>" <?=$status===$k?'selected':''?>><?=$label?></option>
              <?php endforeach;?>
            </select>
            <button class="btn3" type="submit">Guardar</button>
          </form>
        </div>
      </div>
    </article>
  <?php endforeach; ?>
  <?php if(!$rows):?><div class="empty">No hay solicitudes web registradas.</div><?php endif;?>
  </section>
</div>
</main>

<form id="cpqw3DeleteForm" method="post" action="/admin/cotizacion_web_eliminar.php" style="display:none">
  <input type="hidden" name="_csrf" value="<?=cpqw3_h(csrf_token())?>">
  <div id="cpqw3DeleteFields"></div>
</form>

<script>
(() => {
  'use strict';
  const page=document.getElementById('cpqw3');
  const all=document.getElementById('cpqw3All');
  const boxes=[...page.querySelectorAll('.cpqw3Select')];
  const count=document.getElementById('cpqw3Count');
  const edit=document.getElementById('cpqw3Edit');
  const convert=document.getElementById('cpqw3Convert');
  const del=document.getElementById('cpqw3Delete');
  const delForm=document.getElementById('cpqw3DeleteForm');
  const delFields=document.getElementById('cpqw3DeleteFields');

  function selected(){return boxes.filter(b=>b.checked);}
  function refresh(){
    const list=selected();
    count.textContent=list.length+(list.length===1?' seleccionada':' seleccionadas');
    edit.disabled=list.length!==1;
    convert.disabled=list.length!==1 || list[0]?.dataset.converted==='1';
    del.disabled=list.length===0;
    all.checked=boxes.length>0 && list.length===boxes.length;
    all.indeterminate=list.length>0 && list.length<boxes.length;
  }
  all?.addEventListener('change',()=>{boxes.forEach(b=>b.checked=all.checked);refresh();});
  boxes.forEach(b=>b.addEventListener('change',refresh));

  edit?.addEventListener('click',()=>{
    const list=selected(); if(list.length!==1)return;
    location.href='/admin/cotizacion_web_editar.php?id='+encodeURIComponent(list[0].value);
  });

  convert?.addEventListener('click',()=>{
    const list=selected(); if(list.length!==1 || list[0].dataset.converted==='1')return;
    const id=list[0].value;
    if(!confirm('Se creará una cotización formal usando los datos de esta solicitud. No tendrás que capturarlos nuevamente. ¿Continuar?'))return;
    const form=document.createElement('form');
    form.method='post'; form.action='/admin/cotizacion_desde_web.php';
    const csrf=document.querySelector('input[name="_csrf"]')?.value || '';
    form.innerHTML='<input type="hidden" name="_csrf"><input type="hidden" name="request_id">';
    form.querySelector('[name="_csrf"]').value=csrf;
    form.querySelector('[name="request_id"]').value=id;
    document.body.appendChild(form);
    form.submit();
  });

  del?.addEventListener('click',()=>{
    const list=selected(); if(!list.length)return;
    const locked=list.filter(b=>b.dataset.converted==='1').length;
    let msg='¿Eliminar '+list.length+' solicitud'+(list.length===1?'':'es')+' seleccionada'+(list.length===1?'':'s')+'?';
    if(locked)msg+='\\n\\n'+locked+' ya convertida(s) no se eliminarán.';
    msg+='\\n\\nLos archivos adjuntos de las solicitudes eliminables también se eliminarán.';
    if(!confirm(msg))return;
    delFields.innerHTML='';
    list.forEach(b=>{const i=document.createElement('input');i.type='hidden';i.name='ids[]';i.value=b.value;delFields.appendChild(i);});
    delForm.submit();
  });

  const focus=new URLSearchParams(location.search).get('focus');
  if(focus){
    const card=document.getElementById('cpqw3-'+focus);
    if(card){card.classList.add('focus');card.scrollIntoView({behavior:'smooth',block:'center'});setTimeout(()=>card.classList.remove('focus'),3000);}
  }
  refresh();
})();
</script>

<?php require __DIR__ . '/../includes/footer.php'; ?>
