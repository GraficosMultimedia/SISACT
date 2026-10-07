<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();
$title = 'Cotizadores';
require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/cotizadores.css?v=4.2">
<div class="calc-hero">
  <div class="calc-hero-inner">
    <span class="calc-kicker">PLATAFORMA · FASE 4</span>
    <div class="calc-title-row">
      <div class="calc-title-icon">▦</div>
      <div>
        <h2>Cotizadores</h2>
        <p class="hero-sub">Calcula costos internos, utilidad y precio de venta con herramientas diseñadas para los trabajos de Colibrí Print.</p>
      </div>
    </div>
    <div class="calc-toolbar">
      <button type="button" class="calc-tool primary js-help-open" data-help-context="landing">
        <span class="calc-tool-icon">?</span><span><strong>Guía rápida</strong><small>Conoce cómo usar los cotizadores</small></span>
      </button>
      <a class="calc-tool" href="/admin/cotizadores_config.php">
        <span class="calc-tool-icon">⚙</span><span><strong>Configurar tarifas</strong><small>Ajusta costos y márgenes internos</small></span>
      </a>
    </div>
  </div>
</div>

<div class="calc-grid">
  <a class="calc-card" href="/admin/cotizador_bastidor.php">
    <div class="calc-card-head"><span class="calc-badge">Cotizador 01</span><span class="calc-card-icon">▣</span></div>
    <h3>Bastidor + Lona</h3>
    <p>Calcula estructura, lona, impresión, mano de obra, desperdicio y margen para trabajos de gran formato.</p>
    <div class="calc-feature-list">
      <span class="calc-feature"><i>◈</i> Medidas personalizadas</span>
      <span class="calc-feature"><i>◈</i> Materiales y consumo</span>
      <span class="calc-feature"><i>◈</i> Costos internos</span>
      <span class="calc-feature"><i>◈</i> Precio de venta</span>
    </div>
    <span class="calc-link">Abrir cotizador <span>→</span></span>
  </a>

  <a class="calc-card cnc" href="/admin/cotizador_cnc.php">
    <div class="calc-card-head"><span class="calc-badge">Cotizador 02</span><span class="calc-card-icon">⌁</span></div>
    <h3>Corte CNC</h3>
    <p>Calcula material, consumo, preparación, tiempo de máquina, mano de obra y margen para piezas CNC.</p>
    <div class="calc-feature-list">
      <span class="calc-feature"><i>◈</i> Material y espesor</span>
      <span class="calc-feature"><i>◈</i> Tiempo de máquina</span>
      <span class="calc-feature"><i>◈</i> Preparación</span>
      <span class="calc-feature"><i>◈</i> Precio unitario</span>
    </div>
    <span class="calc-link">Abrir cotizador <span>→</span></span>
  </a>
</div>

<div class="card calc-note">
  <div class="calc-note-icon">💡</div>
  <div class="calc-note-text"><strong>Regla comercial</strong><br>El margen se interpreta como <b>margen sobre el precio de venta</b>. Por ejemplo, un costo de $100 con 35% de margen genera un precio de $153.85.</div>
</div>
<script src="/assets/js/cotizadores.js?v=4.2" defer></script>
<?php require __DIR__ . '/../includes/footer.php'; ?>
