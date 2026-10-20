<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();

$pdo=db();
$id=(int)($_GET['id'] ?? $_POST['id'] ?? 0);
if($id<=0) redirect('/admin/cotizaciones_web.php');

function ewe($v): string{return htmlspecialchars((string)$v,ENT_QUOTES,'UTF-8');}
function ewe_services():array{
 return [
 'playeras'=>'Playeras personalizadas','bordado'=>'Bordado','sublimacion'=>'Sublimación','dtf'=>'DTF',
 'impresion'=>'Impresión','gran_formato'=>'Gran formato','etiquetas'=>'Etiquetas y stickers','sellos'=>'Sellos personalizados',
 'laser'=>'Grabado láser','cnc'=>'Corte CNC','corporea'=>'Letras corpóreas','diseno'=>'Diseño gráfico',
 'comestible'=>'Impresión comestible','promo'=>'Artículos promocionales','vinil'=>'Vinil de corte',
 'invitaciones'=>'Invitaciones especiales','otro'=>'Otro proyecto'
 ];
}
function ewe_payload(string $text):array{
 $pos=strpos($text,'[CPQ_JSON]');
 if($pos===false)return[];
 $d=json_decode(trim(substr($text,$pos+strlen('[CPQ_JSON]'))),true);
 return is_array($d)?$d:[];
}
function ewe_summary(array $payload,string $name,string $phone,string $email):string{
 $service=(string)($payload['service']['name']??'Solicitud web');
 $details=is_array($payload['details']??null)?$payload['details']:[];
 $production=is_array($payload['production']??null)?$payload['production']:[];
 $delivery=is_array($payload['delivery']??null)?$payload['delivery']:[];
 $attachment=is_array($payload['attachment']??null)?$payload['attachment']:[];
 $out="Servicio: {$service}\n";
 foreach($details as $k=>$v){if(is_scalar($v)&&trim((string)$v)!=='')$out.=$k.': '.trim((string)$v)."\n";}
 $out.="Diseño: ".(string)($production['design_status']??'')."\n";
 $out.="Aplicación/instalación: ".(string)($production['application']??'')."\n";
 $out.="Entrega: ".(string)($delivery['method']??'')."\n";
 $out.="Fecha solicitada: ".((string)($delivery['desired_date']??'')?:'Por confirmar')."\n";
 if(!empty($production['notes']))$out.="Notas: ".trim((string)$production['notes'])."\n";
 if($attachment && !empty($attachment['original_name']))$out.="Archivo: ".(string)$attachment['original_name']."\n";
 $out.="\n[CPQ_JSON]\n".json_encode($payload,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);
 return $out;
}

$st=$pdo->prepare('SELECT * FROM cp_web_quote_requests WHERE id=? LIMIT 1');
$st->execute([$id]);
$row=$st->fetch(PDO::FETCH_ASSOC);
if(!$row) redirect('/admin/cotizaciones_web.php');

$payload=ewe_payload((string)$row['request_text']);
$serviceMap=ewe_services();

if($_SERVER['REQUEST_METHOD']==='POST'){
 if(!csrf_check($_POST['_csrf']??null)){
  $error='La sesión del formulario expiró. Recarga la página.';
 }else{
  try{
   $serviceKey=(string)($_POST['service_key']??$row['service_key']);
   if(!isset($serviceMap[$serviceKey]))throw new RuntimeException('Servicio inválido.');
   $name=trim((string)($_POST['customer_name']??''));
   $phone=trim((string)($_POST['phone']??''));
   $email=trim((string)($_POST['email']??''));
   $quantity=trim((string)($_POST['quantity']??''));
   $desiredDate=trim((string)($_POST['desired_date']??''));
   if($name===''||$phone==='')throw new RuntimeException('Nombre y WhatsApp son obligatorios.');
   if($email!==''&&!filter_var($email,FILTER_VALIDATE_EMAIL))throw new RuntimeException('El correo no es válido.');

   $payload['version']=$payload['version']??2;
   $payload['service']=['key'=>$serviceKey,'name'=>$serviceMap[$serviceKey]];
   $payload['details']=is_array($payload['details']??null)?$payload['details']:[];
   $payload['details']['quantity']=$quantity;
   $payload['production']=is_array($payload['production']??null)?$payload['production']:[];
   $payload['production']['design_status']=trim((string)($_POST['design_status']??''));
   $payload['production']['application']=trim((string)($_POST['application']??''));
   $payload['production']['notes']=trim((string)($_POST['notes']??''));
   $payload['delivery']=['method'=>trim((string)($_POST['delivery_method']??'')),'desired_date'=>$desiredDate];
   $payload['submitted_at']=$payload['submitted_at']??date('c');

   $st=$pdo->prepare('UPDATE cp_web_quote_requests
       SET service_key=?,customer_name=?,email=?,phone=?,request_text=?,quantity=?,desired_date=?,updated_at=NOW()
       WHERE id=?');
   $st->execute([
    $serviceKey,$name,$email!==''?$email:null,$phone!==''?$phone:null,
    ewe_summary($payload,$name,$phone,$email),
    $quantity!==''?$quantity:null,$desiredDate!==''?$desiredDate:null,$id
   ]);
   redirect('/admin/cotizaciones_web.php?edited=1&focus='.$id);
  }catch(Throwable $e){$error=$e->getMessage();}
 }
}

$title='Editar solicitud CPQ-'.$id;
require __DIR__ . '/../includes/header.php';
?>
<style>
.cpqwe{max-width:1000px;margin:0 auto}.cpqwe-head{display:flex;justify-content:space-between;gap:20px;align-items:end;margin-bottom:22px}.cpqwe-card{background:#0e1822;border:1px solid rgba(255,255,255,.10);border-radius:16px;padding:22px}.cpqwe-grid{display:grid;grid-template-columns:1fr 1fr;gap:15px}.cpqwe-field{display:grid;gap:7px}.cpqwe-field.full{grid-column:1/-1}.cpqwe-field label{font-size:12px;font-weight:800;color:#b6c1cc}.cpqwe-field input,.cpqwe-field select,.cpqwe-field textarea{width:100%;box-sizing:border-box;background:#09131d;color:#fff;border:1px solid #24465f;border-radius:10px;padding:12px;font:inherit}.cpqwe-payload{margin-top:18px;background:#07111a;border:1px solid rgba(255,255,255,.08);border-radius:12px;padding:14px}.cpqwe-kv{display:grid;grid-template-columns:180px 1fr;padding:8px 0;border-bottom:1px solid rgba(255,255,255,.06);font-size:12px}.cpqwe-kv:last-child{border-bottom:0}.cpqwe-kv span{color:#7591a2}.cpqwe-kv strong{overflow-wrap:anywhere}.cpqwe-actions{display:flex;justify-content:flex-end;gap:10px;margin-top:18px}@media(max-width:700px){.cpqwe-head{align-items:start;flex-direction:column}.cpqwe-grid{grid-template-columns:1fr}.cpqwe-field.full{grid-column:auto}.cpqwe-kv{grid-template-columns:1fr;gap:3px}.cpqwe-actions{flex-direction:column}.cpqwe-actions .btn{width:100%;text-align:center;min-height:44px}}
</style>
<div class="cpqwe">
 <header class="cpqwe-head">
  <div><span class="eyebrow">SOLICITUD WEB</span><h2>Editar CPQ-<?=str_pad((string)$id,6,'0',STR_PAD_LEFT)?></h2><p class="muted">Edita los datos de la solicitud existente. El archivo recibido no se reemplaza desde aquí.</p></div>
  <a class="btn btn-secondary" href="/admin/cotizaciones_web.php">← Volver</a>
 </header>
 <?php if(!empty($error)):?><div class="notice danger"><?=ewe($error)?></div><?php endif;?>
 <form method="post" class="card cpqwe-card">
  <input type="hidden" name="_csrf" value="<?=ewe(csrf_token())?>">
  <input type="hidden" name="id" value="<?=$id?>">
  <div class="cpqwe-grid">
   <div class="cpqwe-field"><label>Nombre / empresa</label><input name="customer_name" value="<?=ewe($row['customer_name'])?>" required></div>
   <div class="cpqwe-field"><label>WhatsApp</label><input name="phone" value="<?=ewe($row['phone'])?>" required></div>
   <div class="cpqwe-field"><label>Correo</label><input type="email" name="email" value="<?=ewe($row['email'])?>"></div>
   <div class="cpqwe-field"><label>Servicio</label><select name="service_key"><?php foreach($serviceMap as $key=>$label):?><option value="<?=ewe($key)?>" <?=$row['service_key']===$key?'selected':''?>><?=ewe($label)?></option><?php endforeach;?></select></div>
   <div class="cpqwe-field"><label>Cantidad</label><input name="quantity" value="<?=ewe((string)$row['quantity'])?>" inputmode="decimal"></div>
   <div class="cpqwe-field"><label>Fecha solicitada</label><input type="date" name="desired_date" value="<?=ewe((string)$row['desired_date'])?>"></div>
   <div class="cpqwe-field"><label>Estado del diseño</label><select name="design_status"><?php foreach(['Tengo el diseño final','Tengo un boceto o referencia','Necesito diseño','Solo tengo la idea'] as $v):?><option <?=$payload['production']['design_status']??''===$v?'selected':''?>><?=ewe($v)?></option><?php endforeach;?></select></div>
   <div class="cpqwe-field"><label>Aplicación / instalación</label><select name="application"><?php foreach(['No aplica','Sí, necesito aplicación','Sí, necesito instalación','No lo sé todavía'] as $v):?><option <?=$payload['production']['application']??''===$v?'selected':''?>><?=ewe($v)?></option><?php endforeach;?></select></div>
   <div class="cpqwe-field"><label>Forma de entrega</label><select name="delivery_method"><?php foreach(['Recoger en sucursal','Entrega local','Paquetería','Aún no lo sé'] as $v):?><option <?=$payload['delivery']['method']??''===$v?'selected':''?>><?=ewe($v)?></option><?php endforeach;?></select></div>
   <div class="cpqwe-field full"><label>Notas</label><textarea name="notes" rows="5"><?=ewe((string)($payload['production']['notes']??''))?></textarea></div>
  </div>

  <div class="cpqwe-payload">
   <span class="eyebrow">DETALLES CONSERVADOS</span>
   <?php $details=is_array($payload['details']??null)?$payload['details']:[]; if($details): foreach($details as $k=>$v):?>
    <?php if(is_scalar($v)&&trim((string)$v)!==''):?><div class="cpqwe-kv"><span><?=ewe(ucwords(str_replace(['_','-'],' ',(string)$k)))?></span><strong><?=ewe((string)$v)?></strong></div><?php endif;?>
   <?php endforeach; else:?><p class="muted">No hay detalles técnicos adicionales.</p><?php endif;?>
   <?php if(!empty($payload['attachment']['original_name'])):?><div class="cpqwe-kv"><span>Archivo</span><strong>📎 <?=ewe($payload['attachment']['original_name'])?></strong></div><?php endif;?>
  </div>

  <div class="cpqwe-actions">
   <a class="btn btn-secondary" href="/admin/cotizaciones_web.php">Cancelar</a>
   <button class="btn btn-primary" type="submit">Guardar cambios</button>
  </div>
 </form>
</div>
<?php require __DIR__ . '/../includes/footer.php'; ?>
