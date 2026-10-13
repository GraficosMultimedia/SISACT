<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();

$title='Centro de notificaciones · V3';
$root=dirname(__DIR__);
$headerPath=$root.'/includes/header.php';
$trackingCfdiPath=$root.'/includes/tracking_cfdi.php';
$seguimientoPath=$root.'/seguimiento.php';
$messages=[];$error=null;

function cnv3_write(string $path,string $content):void{
    $tmp=$path.'.cnv3.tmp';
    if(file_put_contents($tmp,$content,LOCK_EX)===false)throw new RuntimeException('No se pudo escribir '.basename($path));
    $perms=@fileperms($path);if($perms!==false)@chmod($tmp,$perms&0777);
    if(!rename($tmp,$path)){@unlink($tmp);throw new RuntimeException('No se pudo reemplazar '.basename($path));}
}
function cnv3_backup(string $path):void{
    $backup=$path.'.bak_notificaciones_v3';
    if(!is_file($backup)&&!copy($path,$backup))throw new RuntimeException('No se pudo respaldar '.basename($path));
}
function cnv3_patch_header(string $src):string{
    if(!str_contains($src,'SISACT_ADMIN_NOTIFICATIONS_V3_ASSETS')){
        $a='<link rel="stylesheet" href="/assets/css/admin-topnav.css">';
        if(!str_contains($src,$a))throw new RuntimeException('header.php: no se encontró admin-topnav.css.');
        $src=str_replace($a,$a."\n".'    <!-- SISACT_ADMIN_NOTIFICATIONS_V3_ASSETS -->'."\n".'    <link rel="stylesheet" href="/assets/css/admin-notifications-v1.css?v=1.0.0">',$src);
        $j='<script src="/assets/js/admin-topnav.js" defer></script>';
        if(!str_contains($src,$j))throw new RuntimeException('header.php: no se encontró admin-topnav.js.');
        $src=str_replace($j,$j."\n".'    <script src="/assets/js/admin-notifications-v1.js?v=1.0.0" defer></script>',$src);
    }
    if(!str_contains($src,'SISACT_ADMIN_NOTIFICATIONS_V3_PANEL')){
        $a='            <div class="cp-account">';
        if(!str_contains($src,$a))throw new RuntimeException('header.php: no se encontró cp-account.');
        $panel=<<<'HTML'
            <!-- SISACT_ADMIN_NOTIFICATIONS_V3_PANEL -->
            <div class="cp-notifications" data-cp-notifications>
                <button class="cp-notifications-toggle" type="button" aria-label="Notificaciones" aria-expanded="false" data-cp-notifications-toggle>
                    <span class="cp-notifications-bell" aria-hidden="true">🔔</span>
                    <span class="cp-notifications-badge" data-cp-notifications-badge hidden>0</span>
                </button>
                <div class="cp-notifications-panel" data-cp-notifications-panel hidden>
                    <div class="cp-notifications-head"><div><strong>Notificaciones</strong><span>Actividad de clientes</span></div><button class="cp-notifications-mark" type="button" data-cp-notifications-mark-all>Marcar todas</button></div>
                    <div class="cp-notifications-list" data-cp-notifications-list><div class="cp-notification-empty">Cargando actividad…</div></div>
                    <div class="cp-notifications-footer"><a href="/admin/notificaciones.php">Ver todas las notificaciones</a></div>
                </div>
            </div>

HTML;
        $src=str_replace($a,$panel.$a,$src);
    }
    return $src;
}
function cnv3_patch_tracking_cfdi(string $src):string{
    if(!str_contains($src,'tracking_activity_verified.php')){
        $a="require_once __DIR__ . '/tracking_activity.php';";
        if(!str_contains($src,$a))throw new RuntimeException('tracking_cfdi.php: falta tracking_activity.php.');
        $src=str_replace($a,$a."\n"."require_once __DIR__ . '/tracking_activity_verified.php';",$src);
    }
    $old='    tracking_activity_log_tracking_view($orderId);';
    if(str_contains($src,$old))$src=str_replace($old,'    // SISACT V3: visita registrada por beacon de navegador visible.',$src);

    $oldBlock=<<<'PHP'
    tracking_activity_log(
        $kind === 'pdf' ? 'cfdi_pdf_opened' : 'cfdi_xml_downloaded',
        (int)$doc['linked_order_id'],
        (int)($doc['customer_id'] ?? 0) ?: null,
        $documentId,
        (int)($doc['invoice_id'] ?? 0) ?: null,
        null,
        $token
    );
PHP;
    $newBlock=<<<'PHP'
    tracking_activity_log_verified(
        $kind === 'pdf' ? 'cfdi_pdf_opened' : 'cfdi_xml_downloaded',
        (int)$doc['linked_order_id'],
        (int)($doc['customer_id'] ?? 0) ?: null,
        $documentId,
        (int)($doc['invoice_id'] ?? 0) ?: null,
        null,
        $token,
        10
    );
PHP;
    if(str_contains($src,$oldBlock))$src=str_replace($oldBlock,$newBlock,$src);
    elseif(!str_contains($src,'tracking_activity_log_verified('))throw new RuntimeException('tracking_cfdi.php: no se encontró registro PDF/XML.');
    return $src;
}
function cnv3_patch_seguimiento(string $src):string{
    if(str_contains($src,'SISACT_TRACKING_VISIBLE_BEACON_V3'))return $src;
    $pos=strrpos($src,'</body>');if($pos===false)throw new RuntimeException('seguimiento.php: no se encontró </body>.');
    $script=<<<'HTML'
<?php if ($order && preg_match('/^[a-f0-9]{64}$/i', $token)): ?>
<script>
/* SISACT_TRACKING_VISIBLE_BEACON_V3 */
(() => {
  'use strict';
  let sent=false;
  function registerVisibleVisit(){
    if(sent||document.visibilityState!=='visible')return;
    sent=true;
    const body=new URLSearchParams();
    body.set('token',<?=json_encode($token,JSON_UNESCAPED_SLASHES)?>);
    fetch('/api/tracking_view_cliente.php',{
      method:'POST',credentials:'same-origin',cache:'no-store',keepalive:true,
      headers:{'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8','Accept':'application/json'},
      body:body.toString()
    }).catch(()=>{});
  }
  if(document.readyState==='loading'){
    document.addEventListener('DOMContentLoaded',()=>setTimeout(registerVisibleVisit,500),{once:true});
  }else setTimeout(registerVisibleVisit,500);
  document.addEventListener('visibilitychange',registerVisibleVisit);
})();
</script>
<?php endif; ?>

HTML;
    return substr($src,0,$pos).$script.substr($src,$pos);
}
function cnv3_table_exists(string $table):bool{
    try{$st=db()->prepare('SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name=?');$st->execute([$table]);return (int)$st->fetchColumn()>0;}catch(Throwable $e){return false;}
}
function cnv3_ensure_tables():void{
    if(!cnv3_table_exists('cp_tracking_events'))db()->exec("CREATE TABLE IF NOT EXISTS cp_tracking_events (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,order_id INT NOT NULL,customer_id INT NULL,event_type VARCHAR(40) NOT NULL,document_id INT NULL,invoice_id INT NULL,receipt_id INT NULL,visitor_hash CHAR(64) NULL,device_type VARCHAR(20) NULL,created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY(id),KEY idx_tracking_events_order_created(order_id,created_at),KEY idx_tracking_events_customer_created(customer_id,created_at),KEY idx_tracking_events_type_created(event_type,created_at),KEY idx_tracking_events_created_id(created_at,id),KEY idx_tracking_events_document(document_id),KEY idx_tracking_events_invoice(invoice_id),KEY idx_tracking_events_receipt(receipt_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    if(!cnv3_table_exists('cp_tracking_event_reads'))db()->exec("CREATE TABLE IF NOT EXISTS cp_tracking_event_reads (user_id INT NOT NULL,last_event_id BIGINT UNSIGNED NOT NULL DEFAULT 0,updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY(user_id),KEY idx_tracking_event_reads_last(last_event_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
}

if($_SERVER['REQUEST_METHOD']==='POST'){
    if(!csrf_check($_POST['_csrf']??null))$error='La sesión expiró. Recarga esta página.';
    else{
        try{
            $action=(string)($_POST['action']??'');
            if($action==='install'){
                foreach([$headerPath,$trackingCfdiPath,$seguimientoPath] as $p)if(!is_file($p))throw new RuntimeException('No se encontró '.basename($p));
                $h=(string)file_get_contents($headerPath);$c=(string)file_get_contents($trackingCfdiPath);$s=(string)file_get_contents($seguimientoPath);
                $hn=cnv3_patch_header($h);$cn=cnv3_patch_tracking_cfdi($c);$sn=cnv3_patch_seguimiento($s);
                cnv3_backup($headerPath);cnv3_backup($trackingCfdiPath);cnv3_backup($seguimientoPath);
                cnv3_write($headerPath,$hn);cnv3_write($trackingCfdiPath,$cn);cnv3_write($seguimientoPath,$sn);cnv3_ensure_tables();
                $messages[]='Centro global de notificaciones instalado.';
                $messages[]='Beacon de visita real instalado en Seguimiento.';
                $messages[]='PDF/XML ahora se registran como acciones verificadas por token.';
            }elseif($action==='revert'){
                foreach([$headerPath,$trackingCfdiPath,$seguimientoPath] as $p){$b=$p.'.bak_notificaciones_v3';if(!is_file($b))throw new RuntimeException('Falta respaldo de '.basename($p));if(!copy($b,$p))throw new RuntimeException('No se pudo restaurar '.basename($p));}
                $messages[]='Archivos principales restaurados.';
            }
        }catch(Throwable $e){$error=$e->getMessage();}
    }
}
$ready=cnv3_table_exists('cp_tracking_events')&&cnv3_table_exists('cp_tracking_event_reads');
$count=0;if($ready){try{$count=(int)(db()->query('SELECT COUNT(*) FROM cp_tracking_events')->fetchColumn()?:0);}catch(Throwable $e){}}
require __DIR__ . '/../includes/header.php';
?>
<div class="card" style="max-width:950px;margin:20px auto;padding:22px">
<span class="eyebrow">CENTRO DE NOTIFICACIONES</span><h2>Actividad de clientes · V3</h2>
<p class="muted">V3 agrega una campana global y registra la visita cuando Seguimiento realmente se vuelve visible en el navegador.</p>
<?php if($error):?><div class="notice danger"><?=e($error)?></div><?php endif;?>
<?php foreach($messages as $m):?><div class="notice"><?=e($m)?></div><?php endforeach;?>
<div style="display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:10px;margin:18px 0">
<div class="card" style="padding:14px"><small class="muted">Tracking Activity</small><strong style="display:block;margin-top:4px"><?=$ready?'✓ Tablas listas':'Faltan tablas'?></strong></div>
<div class="card" style="padding:14px"><small class="muted">Eventos actuales</small><strong style="display:block;margin-top:4px"><?=$count?></strong></div>
<div class="card" style="padding:14px"><small class="muted">Centro</small><strong style="display:block;margin-top:4px">Campana global</strong></div>
</div>
<form method="post" style="display:flex;gap:10px;flex-wrap:wrap"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
<button class="btn btn-primary" type="submit" name="action" value="install">Instalar Centro V3</button>
<a class="btn btn-secondary" href="/admin/notificaciones.php">Abrir notificaciones</a>
<button class="btn btn-secondary" type="submit" name="action" value="revert" onclick="return confirm('¿Restaurar los archivos anteriores?');">Revertir V3</button>
</form>
</div>
<?php require __DIR__ . '/../includes/footer.php'; ?>