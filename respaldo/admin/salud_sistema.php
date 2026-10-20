<?php
declare(strict_types=1);
require_once __DIR__.'/../config/runtime.php';require_once __DIR__.'/../includes/actions.php';require_auth();$pdo=db();$tables=['cp_products','cp_categories','cp_quotes','cp_orders','cp_payments','cp_promotions','cp_tracking_tokens','cp_web_checkout_sessions','cp_web_quote_requests','cp_projects'];$data=[];foreach($tables as $t){$s=$pdo->query('SELECT COUNT(*) FROM `'.$t.'`');$data[$t]=(int)$s->fetchColumn();}require __DIR__.'/../includes/header.php';
?>
<div class="card"><span class="eyebrow">FASE 30</span><h2>Salud del sistema</h2><table class="table"><thead><tr><th>Tabla</th><th>Registros</th></tr></thead><tbody><?php foreach($data as $t=>$n):?><tr><td><?=e($t)?></td><td><?=number_format($n)?></td></tr><?php endforeach;?></tbody></table></div>
