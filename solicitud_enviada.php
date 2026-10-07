<?php
declare(strict_types=1);
require_once __DIR__ . '/config/bootstrap.php';
$id = (int)($_GET['id'] ?? 0);
?>
<!doctype html><html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Solicitud recibida · Colibrí Print</title><link rel="stylesheet" href="assets/css/colibri-print.css"></head>
<body><div class="cp-wrap" style="max-width:850px">
<div class="cp-brand">COLIBRÍ PRINT</div><div class="cp-hero"><div><h1>Solicitud recibida</h1><p>Tu solicitud quedó registrada correctamente.</p></div></div>
<div class="cp-card"><div class="cp-success"><h2 style="margin-top:0">✓ Todo listo</h2><p>Folio de solicitud: <strong>#<?=cp_e($id)?></strong></p><p>Conservamos tus archivos y la configuración seleccionada. El equipo de recepción podrá revisar el trabajo antes de iniciar producción.</p></div>
<p style="margin-top:20px"><a class="cp-btn cp-btn-primary" href="solicitar_impresion.php">Nueva solicitud →</a></p></div>
</div></body></html>
