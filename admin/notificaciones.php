<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/tracking_activity.php';
require_auth();

$title='Notificaciones';
$user=current_user();
$userId=(int)($user['id']??0);

if($_SERVER['REQUEST_METHOD']==='POST'){
    if(!csrf_check($_POST['_csrf']??null)){http_response_code(419);exit('Sesión expirada.');}
    if(($_POST['action']??'')==='mark_all'){
        tracking_activity_mark_read($userId,tracking_activity_latest_id());
        header('Location: /admin/notificaciones.php');exit;
    }
}

$ready=tracking_activity_tables_ready();
$events=$ready?tracking_activity_recent(50):[];
$unread=$ready?tracking_activity_unread_count($userId):0;
$lastRead=$ready?tracking_activity_last_read_id($userId):0;

function notification_sentence(array $e):string{
    $c=trim((string)($e['customer_name']??''))?:'Cliente';
    $o=trim((string)($e['order_number']??''))?:('Orden #'.(int)($e['order_id']??0));
    $i=trim((string)($e['invoice_number']??''));
    return match((string)($e['event_type']??'')){
        'tracking_view'=>$c.' ha revisado la orden '.$o.'.',
        'cfdi_pdf_opened'=>$c.' ha consultado la factura'.($i!==''?' '.$i:'').' de '.$o.'.',
        'cfdi_xml_downloaded'=>$c.' ha descargado el XML'.($i!==''?' '.$i:'').' de '.$o.'.',
        'payment_receipt_uploaded'=>$c.' envió un comprobante para '.$o.'.',
        default=>$c.' registró actividad en '.$o.'.',
    };
}

require __DIR__ . '/../includes/header.php';
?>
<style>
.notification-page{max-width:980px;margin:0 auto}.notification-page-top{display:flex;justify-content:space-between;align-items:center;gap:14px;margin-bottom:14px}.notification-page-top p{margin:3px 0 0}.notification-page-list{overflow:hidden}
.notification-page-item{display:grid;grid-template-columns:46px 1fr auto;gap:13px;align-items:start;padding:15px 16px;border-bottom:1px solid rgba(110,145,182,.14);text-decoration:none;color:inherit}.notification-page-item:last-child{border-bottom:0}.notification-page-item:hover{background:rgba(52,177,227,.04)}.notification-page-item.is-unread{background:rgba(26,177,232,.065)}
.notification-page-icon{width:42px;height:42px;border-radius:12px;display:flex;align-items:center;justify-content:center;background:rgba(27,181,231,.10);font-size:19px}.notification-page-copy strong{display:block}.notification-page-copy p{margin:4px 0 0;color:var(--muted);font-size:13px;line-height:1.45}.notification-page-copy small{display:block;margin-top:6px;color:var(--muted);font-size:11px}.notification-page-dot{width:8px;height:8px;border-radius:50%;background:#19bff4;margin-top:7px}.notification-page-empty{padding:35px;text-align:center;color:var(--muted)}
@media(max-width:700px){.notification-page-top{align-items:flex-start;flex-direction:column}.notification-page-item{grid-template-columns:40px 1fr}.notification-page-dot{display:none}}
</style>
<div class="notification-page">
<div class="card" style="padding:20px">
<div class="notification-page-top">
<div><span class="eyebrow">ACTIVIDAD DE CLIENTES</span><h2 style="margin:5px 0 0">Tus notificaciones</h2><p class="muted">Visitas al seguimiento, consultas de facturas y comprobantes. <?=$unread>0?e((string)$unread).' sin revisar.':'Todo revisado.'?></p></div>
<?php if($ready&&$unread>0):?><form method="post"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><button class="btn btn-secondary" type="submit" name="action" value="mark_all">Marcar todo como leído</button></form><?php endif;?>
</div>
<div class="notification-page-list">
<?php if(!$ready):?><div class="notification-page-empty">Tracking Activity no está disponible. Verifica la migración 021.</div>
<?php elseif(!$events):?><div class="notification-page-empty">Todavía no hay actividad registrada.</div>
<?php else:foreach($events as $event):$id=(int)($event['id']??0);$isUnread=$id>$lastRead;$orderId=(int)($event['order_id']??0);$date=strtotime((string)($event['created_at']??''));?>
<a class="notification-page-item<?=$isUnread?' is-unread':''?>" href="<?=$orderId>0?'/admin/orden.php?id='.$orderId:'#'?>">
<span class="notification-page-icon"><?=e((string)($event['icon']??'•'))?></span>
<span class="notification-page-copy"><strong><?=e((string)($event['label']??'Actividad del cliente'))?></strong><p><?=e(notification_sentence($event))?></p><small><?=$date?e(date('d/m/Y H:i',$date)):'—'?></small></span>
<?php if($isUnread):?><i class="notification-page-dot"></i><?php endif;?>
</a>
<?php endforeach;endif;?>
</div></div></div>
<?php require __DIR__ . '/../includes/footer.php'; ?>