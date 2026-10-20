<?php
declare(strict_types=1);
require_once __DIR__.'/../config/runtime.php';require_once __DIR__.'/../includes/actions.php';require_once __DIR__.'/../includes/integration_health.php';require_auth();$h=cp_integration_health(db());require __DIR__.'/../includes/header.php';
?>
<div class="card"><span class="eyebrow">FASE 27</span><h2>Estado de integración</h2><table class="table"><thead><tr><th>Tabla</th><th>Estado</th></tr></thead><tbody><?php foreach($h as $t=>$ok):?><tr><td><?=e($t)?></td><td><?=$ok?'✅ Disponible':'⚠️ Falta instalar'?></td></tr><?php endforeach;?></tbody></table></div>
