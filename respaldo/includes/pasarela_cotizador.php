<?php
declare(strict_types=1);

/*
 * Colibrí Print México · Pasarela de cotización V2
 * Debe incluirse dentro del index público.
 */
$cpqPhone = trim((string)($phone ?? '627 147 0053'));
$cpqPhoneRaw = preg_replace('/\D+/', '', $cpqPhone);
if ($cpqPhoneRaw !== '' && !str_starts_with($cpqPhoneRaw, '52')) {
    $cpqPhoneRaw = '52' . $cpqPhoneRaw;
}
$cpqWaBase = $cpqPhoneRaw !== '' ? 'https://wa.me/' . $cpqPhoneRaw : '';
?>
<link rel="stylesheet" href="/assets/css/pasarela-archivos-v1.css?v=20260920-1">
<section class="cpq-section" id="proceso">
  <div class="cpq-bg-grid" aria-hidden="true"></div>
  <div class="cpq-glow cpq-glow-red" aria-hidden="true"></div>
  <div class="cpq-glow cpq-glow-yellow" aria-hidden="true"></div>
  <div class="cpq-shell">
    <div class="cpq-intro">
      <p class="cpq-eyebrow">DE UNA IDEA A UN GRAN RESULTADO</p>
      <h2>Tu proyecto, <strong>nuestra pasión.</strong></h2>
      <p>Cuéntanos qué necesitas y te guiamos por el material, proceso y acabado adecuados. La pasarela adapta las preguntas al servicio que eliges.</p>
      <button class="cpq-open cpq-open-primary" type="button" data-cpq-open data-cpq-step="1">Quiero cotizar <span>→</span></button>
      <div class="cpq-benefits"><span><b>01</b> Te escuchamos</span><span><b>02</b> Definimos</span><span><b>03</b> Producimos</span><span><b>04</b> Entregamos</span></div>
    </div>
    <div class="cpq-process-card" aria-label="Proceso de cotización">
      <button class="cpq-process-row is-active" type="button" data-cpq-open data-cpq-step="1"><span class="cpq-process-num">01</span><span><b>Cuéntanos</b><small>qué necesitas</small></span><i>↗</i></button>
      <button class="cpq-process-row" type="button" data-cpq-open data-cpq-step="2"><span class="cpq-process-num">02</span><span><b>Definimos</b><small>materiales y diseño</small></span><i>↗</i></button>
      <button class="cpq-process-row" type="button" data-cpq-open data-cpq-step="3"><span class="cpq-process-num">03</span><span><b>Preparamos</b><small>archivos y producción</small></span><i>↗</i></button>
      <button class="cpq-process-row" type="button" data-cpq-open data-cpq-step="4"><span class="cpq-process-num">04</span><span><b>Entregamos</b><small>o preparamos tu envío</small></span><i>↗</i></button>
    </div>
  </div>
</section>

<div class="cpq-modal" id="cpqModal" aria-hidden="true">
  <div class="cpq-backdrop" data-cpq-close></div>
  <div class="cpq-dialog" role="dialog" aria-modal="true" aria-labelledby="cpqTitle">
    <header class="cpq-dialog-head"><div><span class="cpq-mini">COTIZADOR COLIBRÍ PRINT</span><h3 id="cpqTitle">Cuéntanos tu proyecto</h3></div><button class="cpq-close" type="button" data-cpq-close aria-label="Cerrar">×</button></header>
    <div class="cpq-progress-wrap"><div class="cpq-progress-label"><span id="cpqStepTitle">Servicio</span><strong><span id="cpqStepNumber">1</span> / 5</strong></div><div class="cpq-progress"><span data-cpq-progress="1" class="is-current"></span><span data-cpq-progress="2"></span><span data-cpq-progress="3"></span><span data-cpq-progress="4"></span><span data-cpq-progress="5"></span></div></div>
    <form id="cpqForm" novalidate enctype="multipart/form-data">
      <div class="cpq-step is-visible" data-cpq-stepview="1"><div class="cpq-step-head"><span>01</span><div><p>EMPECEMOS</p><h4>¿Qué quieres producir?</h4><small>Elige una opción para que la siguiente etapa se adapte a tu proyecto.</small></div></div><div class="cpq-service-grid" id="cpqServiceGrid"></div><div class="cpq-inline-error" id="cpqServiceError" aria-live="polite"></div></div>
      <div class="cpq-step" data-cpq-stepview="2"><div class="cpq-step-head"><span>02</span><div><p>DETALLES DEL SERVICIO</p><h4 id="cpqDetailsTitle">Definamos tu proyecto</h4><small>Solo verás las preguntas que realmente aplican a lo que elegiste.</small></div></div><div id="cpqDynamicFields" class="cpq-fields"></div></div>
      <div class="cpq-step" data-cpq-stepview="3"><div class="cpq-step-head"><span>03</span><div><p>DISEÑO Y ARCHIVOS</p><h4>Preparemos la producción</h4><small>Adjunta todos los archivos necesarios para fabricar tu trabajo.</small></div></div>
        <div class="cpq-fields">
          <label class="cpq-field"><span>¿Ya tienes diseño?</span><select name="design_status"><option value="Tengo el diseño final">Tengo el diseño final</option><option value="Tengo un boceto o referencia">Tengo un boceto o referencia</option><option value="Necesito diseño">Necesito diseño</option><option value="Solo tengo la idea">Solo tengo la idea</option></select></label>
          <label class="cpq-field"><span>¿Necesitas aplicación / instalación?</span><select name="application"><option value="No aplica">No aplica</option><option value="Sí, necesito aplicación">Sí, necesito aplicación</option><option value="Sí, necesito instalación">Sí, necesito instalación</option><option value="No lo sé todavía">No lo sé todavía</option></select></label>
          <label class="cpq-field cpq-full" id="cpqLegacyAttachment"><span>Archivo o referencia visual</span><input type="file" name="attachment" accept=".jpg,.jpeg,.png,.webp,.pdf,.ai,.eps,.cdr,.svg,.psd,.zip"><small>El sistema admite múltiples archivos desde la nueva bandeja de archivos.</small></label>
          <label class="cpq-field cpq-full"><span>Cuéntanos algo más</span><textarea name="notes" rows="5" placeholder="Colores, medidas especiales, fecha del evento, uso del producto, acabado, referencia o cualquier detalle importante..."></textarea></label>
        </div>
      </div>
      <div class="cpq-step" data-cpq-stepview="4"><div class="cpq-step-head"><span>04</span><div><p>ENTREGA Y CONTACTO</p><h4>¿Dónde y cuándo lo necesitas?</h4><small>Con estos datos podemos darle seguimiento a tu solicitud.</small></div></div>
        <div class="cpq-fields"><label class="cpq-field"><span>Nombre *</span><input required name="name" autocomplete="name" placeholder="Tu nombre o empresa"></label><label class="cpq-field"><span>WhatsApp *</span><input required name="phone" autocomplete="tel" inputmode="tel" placeholder="627 147 0053"></label><label class="cpq-field"><span>Correo</span><input type="email" name="email" autocomplete="email" placeholder="correo@empresa.com"></label><label class="cpq-field"><span>Forma de entrega</span><select name="delivery_method"><option value="Recoger en sucursal">Recoger en sucursal</option><option value="Entrega local">Entrega local</option><option value="Paquetería">Paquetería</option><option value="Aún no lo sé">Aún no lo sé</option></select></label><label class="cpq-field cpq-full"><span>¿Para cuándo lo necesitas?</span><input type="date" name="desired_date"><small>No es una promesa de entrega. Nos ayuda a priorizar y confirmar tiempos.</small></label><input type="text" name="website" class="cpq-honeypot" tabindex="-1" autocomplete="off" aria-hidden="true"></div>
      </div>
      <div class="cpq-step" data-cpq-stepview="5"><div class="cpq-step-head"><span>05</span><div><p>REVISA ANTES DE ENVIAR</p><h4>Tu solicitud está casi lista.</h4><small>Confirma que los datos principales estén correctos.</small></div></div><div class="cpq-review" id="cpqReview"></div><div class="cpq-review-note"><strong>Sobre el precio</strong><p>Esta pasarela no inventa precios de servicios personalizados. La solicitud se guarda con todos los datos necesarios y Colibrí Print confirma la cotización formal según medidas, materiales, cantidad, acabados, diseño y tiempos.</p></div><div class="cpq-submit-state" id="cpqSubmitState" aria-live="polite"></div></div>
      <div class="cpq-result" id="cpqResult"><div class="cpq-result-icon">✓</div><span class="cpq-mini">SOLICITUD REGISTRADA</span><h4>Ya tenemos tu proyecto.</h4><p id="cpqResultText"></p><div class="cpq-ticket"><span>FOLIO DE SOLICITUD</span><strong id="cpqRequestId">CPQ-000000</strong><small>Guarda este folio para consultar tu solicitud por WhatsApp.</small></div><div class="cpq-result-actions"><a class="cpq-open cpq-open-primary" id="cpqResultWhatsApp" href="#" target="_blank" rel="noopener">Enviar por WhatsApp ↗</a><button class="cpq-open cpq-open-secondary" type="button" id="cpqNewRequest">Nueva cotización</button></div></div>
      <footer class="cpq-footer" id="cpqFooter"><button class="cpq-open cpq-open-secondary" type="button" id="cpqBack">← Atrás</button><div class="cpq-footer-right"><span id="cpqFooterLabel">Paso 1 de 5</span><button class="cpq-open cpq-open-primary" type="button" id="cpqNext">Continuar →</button></div></footer>
    </form>
  </div>
</div>
<script defer src="/assets/js/pasarela-archivos-v1.js?v=20260920-1"></script>
