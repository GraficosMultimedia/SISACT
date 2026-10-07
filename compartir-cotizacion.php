<?php
declare(strict_types=1);
require_once __DIR__.'/includes/public_quote_links.php';
$q=cp_quote_public_row(db(),trim((string)($_GET['token']??'')));if(!$q){http_response_code(404);exit('Cotización no disponible.');}$pdf=cp_quote_pdf_url((string)$q['token']);$wa=cp_quote_whatsapp_url(cp_web_company(),$q);
?>
<!doctype html><html lang="es-MX"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Cotización <?=cp_web_h((string)$q['quote_number'])?></title><link rel="stylesheet" href="<?=cp_web_h(cp_web_route('/assets/css/share-quote-v1.css'))?>"></head><body><main class="sq-wrap"><p class="sq-kicker">COLIBRÍ PRINT MÉXICO</p><h1>Tu cotización<br>está lista.</h1><section class="sq-card"><span>COTIZACIÓN</span><strong><?=cp_web_h((string)$q['quote_number'])?></strong><span>TOTAL</span><b><?=cp_web_h(cp_web_money($q['total']))?></b><div class="sq-actions"><a href="<?=cp_web_h($pdf)?>" target="_blank" rel="noopener">Ver PDF →</a><a href="<?=cp_web_h($wa)?>" target="_blank" rel="noopener">Enviar por WhatsApp ↗</a></div></section></main></body></html>
