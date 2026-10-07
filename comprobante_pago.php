<?php
declare(strict_types=1);

require_once __DIR__.'/config/runtime.php';
require_once __DIR__.'/includes/payment_receipts.php';
require_once __DIR__.'/includes/company.php';

function cppr_e($v):string{return htmlspecialchars((string)$v,ENT_QUOTES,'UTF-8');}
function cppr_money($v):string{return '$'.number_format((float)$v,2,'.',',');}
function cppr_date($v):string{if(!$v)return 'Por confirmar';$t=strtotime((string)$v);return $t?date('d/m/Y H:i',$t):'Por confirmar';}

$token=trim((string)($_GET['t']??''));
$rid=(int)($_GET['rid']??0);
$receipt=payment_receipt_public_find($rid,$token);
if(!$receipt){http_response_code(404);exit('Comprobante no disponible.');}

$docroot=rtrim((string)($_SERVER['DOCUMENT_ROOT']??__DIR__),'/');
$file=$docroot.(string)$receipt['file_path'];
if(!is_file($file)){http_response_code(404);exit('Archivo no disponible.');}

$download=($_GET['download']??'')==='1';
$mime=(string)$receipt['mime_type'];
$name=preg_replace('/[^A-Za-z0-9._-]+/','_',((string)$receipt['original_name']?:'comprobante-pago'));

if($download || ($_GET['raw']??'')==='1'){
    header('Content-Type: '.$mime);
    header('Content-Length: '.filesize($file));
    header('Content-Disposition: '.($download?'attachment':'inline').'; filename="'.$name.'"');
    header('X-Content-Type-Options: nosniff');
    header('Cache-Control: private,no-store,no-cache,must-revalidate,max-age=0');
    readfile($file);
    exit;
}

$company=company_profile();
$companyName=trim((string)($company['trade_name']??''))?:'Colibrí Print México';
?>
<!doctype html><html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="robots" content="noindex,nofollow">
<title>Comprobante de pago · <?=cppr_e($companyName)?></title>
<style>
*{box-sizing:border-box}body{margin:0;background:#eef2f6;color:#17222d;font-family:Inter,system-ui,-apple-system,Segoe UI,sans-serif}.wrap{width:min(960px,calc(100% - 18px));margin:10px auto}.head{background:#071019;color:#fff;border-radius:16px;padding:15px 16px;display:flex;justify-content:space-between;gap:10px;align-items:center}.head strong{display:block;font-size:18px}.head small{color:#aeb9c3}.badge{padding:7px 9px;border-radius:999px;background:#18cf8a;color:#042118;font-size:9px;font-weight:900;text-transform:uppercase}.card{background:#fff;border:1px solid #dce4eb;border-radius:16px;padding:15px;margin-top:10px;box-shadow:0 10px 28px rgba(20,34,48,.08)}.meta{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:8px}.meta>div{background:#f7f9fb;border:1px solid #e7edf2;border-radius:10px;padding:10px}.meta span{display:block;color:#7a8794;font-size:9px}.meta strong{display:block;margin-top:4px;font-size:12px;word-break:break-word}.viewer{margin-top:10px;background:#f5f7f9;border-radius:12px;padding:10px;text-align:center}.viewer img{max-width:100%;max-height:75vh;border-radius:9px}.viewer iframe{width:100%;height:76vh;border:0;border-radius:9px;background:#fff}.actions{display:flex;gap:8px;flex-wrap:wrap;margin-top:10px}.actions a{padding:11px 13px;border-radius:9px;text-decoration:none;font-size:11px;font-weight:900}.primary{background:#ff1751;color:#fff}.secondary{background:#e7ebef;color:#17222d}.muted{font-size:10px;color:#7a8793;line-height:1.5}@media(max-width:640px){.wrap{width:calc(100% - 12px);margin:6px auto}.meta{grid-template-columns:1fr 1fr}.meta>div:first-child{grid-column:1/-1}.actions a{width:100%;text-align:center}.viewer iframe{height:70vh}.head{border-radius:13px;padding:13px}.head strong{font-size:16px}}
</style></head><body><div class="wrap">
<header class="head"><div><strong><?=cppr_e($companyName)?></strong><small>Comprobante de pago · <?=cppr_e((string)$receipt['order_number'])?></small></div><span class="badge"><?=cppr_e((string)$receipt['status'])?></span></header>
<section class="card">
<div class="meta">
<div><span>ORDEN</span><strong><?=cppr_e($receipt['order_number'])?></strong></div>
<div><span>CLIENTE</span><strong><?=cppr_e($receipt['customer_name']??'Cliente')?></strong></div>
<div><span>RECIBIDO</span><strong><?=cppr_date($receipt['created_at'])?></strong></div>
<?php if($receipt['payment_amount']!==null): ?><div><span>PAGO VINCULADO</span><strong><?=cppr_money($receipt['payment_amount'])?></strong></div><?php endif; ?>
<?php if($receipt['payment_date']): ?><div><span>FECHA DEL PAGO</span><strong><?=cppr_date($receipt['payment_date'])?></strong></div><?php endif; ?>
<div><span>ARCHIVO</span><strong><?=cppr_e($receipt['original_name'])?></strong></div>
</div>
<?php if(trim((string)($receipt['note']??''))!==''): ?><p class="muted"><strong>Nota:</strong> <?=nl2br(cppr_e($receipt['note']))?></p><?php endif; ?>
<div class="viewer">
<?php if($mime==='application/pdf'): ?><iframe src="/comprobante_pago.php?t=<?=rawurlencode($token)?>&rid=<?=$rid?>&raw=1"></iframe>
<?php else: ?><img src="/comprobante_pago.php?t=<?=rawurlencode($token)?>&rid=<?=$rid?>&raw=1" alt="Comprobante de pago"><?php endif; ?>
</div>
<div class="actions"><a class="primary" href="/comprobante_pago.php?t=<?=rawurlencode($token)?>&rid=<?=$rid?>&download=1">📥 Descargar comprobante</a><a class="secondary" href="/seguimiento.php?t=<?=rawurlencode($token)?>">← Volver al seguimiento</a></div>
</section></div></body></html>
