<?php
declare(strict_types=1);
require_once __DIR__ . '/config/public.php';
?>
<!doctype html>
<html lang="es-MX">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="robots" content="noindex,nofollow,noarchive">
<title>Colibrí Print · Design System V1</title>
<link rel="stylesheet" href="<?= htmlspecialchars(cp_public_asset('assets/css/colibri-design-system.css'), ENT_QUOTES, 'UTF-8') ?>">
</head>
<body class="cp-ds-page">
<div class="cp-topbar">COLIBRÍ PRINT · DESIGN SYSTEM · PRUEBA VISUAL</div>
<header class="cp-surface-light">
  <div class="cp-container cp-nav">
    <a class="cp-brand" href="#">
      <span class="cp-brand__mark">CP</span>
      <span><span class="cp-brand__name">Colibrí Print</span><small class="cp-brand__sub">MÉXICO · IMPRESIÓN & PERSONALIZACIÓN</small></span>
    </a>
    <div class="cp-row">
      <button class="cp-btn cp-btn--outline cp-btn--sm">Ayuda</button>
      <button class="cp-btn cp-btn--primary cp-btn--sm">Cotizar</button>
    </div>
  </div>
</header>

<main>
<section class="cp-section cp-surface-dark">
  <div class="cp-container">
    <div class="cp-grid" style="grid-template-columns:minmax(0,1.15fr) minmax(240px,.85fr);align-items:center">
      <div class="cp-stack--lg">
        <div>
          <span class="cp-eyebrow">Sistema visual Colibrí</span>
          <h1 class="cp-title cp-title--hero">Imprimimos tus ideas.<br><span style="color:var(--cp-mango)">Le damos color a tus proyectos.</span></h1>
          <p class="cp-lead" style="color:rgba(255,255,255,.72)">Rojo y negro como protagonistas. Mango para llamar la atención. Azul, verde y morado como acentos de interacción.</p>
        </div>
        <div class="cp-row cp-row--wrap">
          <button class="cp-btn cp-btn--primary">Explorar catálogo</button>
          <button class="cp-btn cp-btn--mango">Ver promociones</button>
          <button class="cp-btn cp-btn--purple">Necesito ayuda</button>
        </div>
      </div>
      <div class="cp-center">
        <div class="cp-orbit" aria-hidden="true" style="margin-inline:auto"></div>
      </div>
    </div>
  </div>
</section>

<section class="cp-section">
  <div class="cp-container cp-stack--lg">
    <div>
      <span class="cp-eyebrow">Componentes</span>
      <h2 class="cp-title">Botones, badges y chips</h2>
    </div>
    <div class="cp-card" style="padding:24px">
      <div class="cp-row cp-row--wrap">
        <button class="cp-btn cp-btn--primary">Principal</button>
        <button class="cp-btn cp-btn--dark">Negro</button>
        <button class="cp-btn cp-btn--mango">Mango</button>
        <button class="cp-btn cp-btn--purple">Morado</button>
        <button class="cp-btn cp-btn--outline">Contorno</button>
        <button class="cp-btn cp-btn--ghost">Ghost</button>
      </div>
      <hr style="border:0;border-top:1px solid var(--cp-line);margin:22px 0">
      <div class="cp-chip-row">
        <span class="cp-badge cp-badge--red">OFERTA</span>
        <span class="cp-badge cp-badge--mango">NUEVO</span>
        <span class="cp-badge cp-badge--blue">WEB</span>
        <span class="cp-badge cp-badge--green">DISPONIBLE</span>
        <span class="cp-badge cp-badge--purple">DESTACADO</span>
        <a class="cp-chip is-active" href="#">Playeras</a>
        <a class="cp-chip" href="#">Tazas</a>
        <a class="cp-chip" href="#">Grabado láser</a>
        <a class="cp-chip" href="#">Impresión</a>
      </div>
    </div>
  </div>
</section>

<section class="cp-section cp-surface-light">
  <div class="cp-container cp-stack--lg">
    <div>
      <span class="cp-eyebrow">Catálogo</span>
      <h2 class="cp-title">Tarjetas de producto</h2>
    </div>
    <div class="cp-grid cp-grid--3">
      <article class="cp-card cp-card--lift cp-product-card">
        <div class="cp-product-card__flags"><span class="cp-badge cp-badge--mango">OFERTA</span><span class="cp-badge cp-badge--dark">WEB</span></div>
        <div class="cp-card__media" style="display:grid;place-items:center;background:linear-gradient(145deg,#14171d,#ef164f);color:#fff;font-size:3rem;font-weight:950">POLO</div>
        <div class="cp-card__body">
          <span class="cp-eyebrow" style="color:var(--cp-purple)">PLAYERAS</span>
          <h3 class="cp-card__title" style="margin-top:.45rem">Playera tipo polo, negra</h3>
          <p class="cp-card__text">Producto personalizable con precio administrado desde el catálogo.</p>
          <div class="cp-product-card__price"><span class="cp-price">$290.00</span><span class="cp-price--old">$340.00</span></div>
          <div class="cp-product-card__actions"><button class="cp-btn cp-btn--primary">Ver producto</button><button class="cp-btn cp-btn--outline">♡</button></div>
        </div>
      </article>
      <article class="cp-card cp-card--lift cp-product-card">
        <div class="cp-card__media" style="display:grid;place-items:center;background:linear-gradient(145deg,#fff3c4,#159be8);color:#fff;font-size:2.6rem;font-weight:950">TAZA</div>
        <div class="cp-card__body">
          <span class="cp-eyebrow" style="color:var(--cp-blue)">TAZAS</span>
          <h3 class="cp-card__title" style="margin-top:.45rem">Taza 11oz personalizada</h3>
          <p class="cp-card__text">Base para personalización. Precio y condiciones provienen del motor del sistema.</p>
          <div class="cp-product-card__price"><span class="cp-price">$100.00</span></div>
          <div class="cp-product-card__actions"><button class="cp-btn cp-btn--dark">Ver producto</button><button class="cp-btn cp-btn--outline">♡</button></div>
        </div>
      </article>
      <article class="cp-card cp-card--lift">
        <div class="cp-card__body" style="min-height:100%">
          <span class="cp-eyebrow" style="color:var(--cp-green)">SERVICIO</span>
          <h3 class="cp-card__title" style="font-size:1.5rem;margin-top:.6rem">Grabado láser de alta precisión</h3>
          <p class="cp-card__text">Los servicios personalizados deberán llevar a cotización cuando el precio dependa de especificaciones del proyecto.</p>
          <div class="cp-stack" style="margin-top:1.2rem">
            <span class="cp-badge cp-badge--green">Cotizable</span>
            <button class="cp-btn cp-btn--mango cp-btn--block">Solicitar cotización</button>
          </div>
        </div>
      </article>
    </div>
  </div>
</section>

<section class="cp-section">
  <div class="cp-container cp-stack--lg">
    <div>
      <span class="cp-eyebrow">Promoción</span>
      <h2 class="cp-title">Componente publicitario</h2>
    </div>
    <div class="cp-promo">
      <div class="cp-promo__value">-31%</div>
      <div class="cp-promo__label">Color que llama la atención</div>
      <h3 style="font-size:clamp(1.6rem,3vw,2.6rem);margin:.6rem 0 0;font-weight:950">Una promo no debe verse como un bloque de inventario.</h3>
      <p style="max-width:52ch;color:rgba(255,255,255,.78)">El sistema visual reserva colores de alto contraste para ofertas, acciones y momentos donde necesitamos que el ojo se detenga.</p>
      <button class="cp-btn cp-btn--mango">Ver oferta</button>
    </div>
  </div>
</section>

<section class="cp-section cp-surface-dark">
  <div class="cp-container cp-stack--lg">
    <div>
      <span class="cp-eyebrow" style="color:var(--cp-mango)">Formularios</span>
      <h2 class="cp-title" style="color:#fff">Campos y mensajes</h2>
    </div>
    <div class="cp-grid cp-grid--2">
      <form class="cp-card" style="padding:24px" action="#">
        <div class="cp-grid cp-grid--2">
          <label class="cp-field"><span class="cp-label">Nombre</span><input class="cp-input" type="text" placeholder="Tu nombre"></label>
          <label class="cp-field"><span class="cp-label">Correo</span><input class="cp-input" type="email" placeholder="correo@ejemplo.com"></label>
        </div>
        <label class="cp-field" style="margin-top:16px"><span class="cp-label">Proyecto</span><textarea class="cp-textarea" placeholder="Cuéntanos qué quieres imprimir, personalizar o producir..."></textarea></label>
        <div style="margin-top:16px"><button class="cp-btn cp-btn--primary">Enviar solicitud</button></div>
      </form>
      <div class="cp-stack">
        <div class="cp-alert cp-alert--mango"><div class="cp-badge cp-badge--mango">!</div><div><div class="cp-alert__title">Mango = atención</div><div class="cp-alert__text">Se reserva para advertencias suaves, novedades y CTA secundarios.</div></div></div>
        <div class="cp-alert cp-alert--purple"><div class="cp-badge cp-badge--purple">✦</div><div><div class="cp-alert__title">Morado = interacción</div><div class="cp-alert__text">Especialmente útil para popups, ayuda contextual y elementos dinámicos.</div></div></div>
        <div class="cp-alert cp-alert--green"><div class="cp-badge cp-badge--green">✓</div><div><div class="cp-alert__title">Verde = disponible</div><div class="cp-alert__text">Indicará disponibilidad o estados positivos sin competir con el rojo de marca.</div></div></div>
      </div>
    </div>
  </div>
</section>
</main>
<footer class="cp-surface-light" style="padding:28px 0">
  <div class="cp-container cp-row cp-row--between cp-row--wrap"><strong>Colibrí Print México</strong><span class="cp-muted">FASE 02 · Design System</span></div>
</footer>
</body>
</html>
