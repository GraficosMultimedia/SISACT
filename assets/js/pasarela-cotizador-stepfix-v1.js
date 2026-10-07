
/*
 * Colibrí Print · Pasarela CPQ · Step Fix V1
 *
 * Fix quirúrgico de frontend:
 * - conserva pasarela-cotizador.js;
 * - elimina únicamente los listeners originales de #cpqNext y #cpqBack;
 * - controla los 5 pasos;
 * - conserva el mismo endpoint /api/pasarela-cotizador.php;
 * - no toca base de datos ni backend.
 *
 * Debe cargarse DESPUÉS de assets/js/pasarela-cotizador.js.
 */
(() => {
  'use strict';

  function boot() {
    const modal = document.querySelector('#cpqModal');
    const form = document.querySelector('#cpqForm');
    const nextOld = document.querySelector('#cpqNext');
    const backOld = document.querySelector('#cpqBack');
    const footer = document.querySelector('#cpqFooter');
    const result = document.querySelector('#cpqResult');
    const review = document.querySelector('#cpqReview');
    const submitState = document.querySelector('#cpqSubmitState');

    if (!modal || !form || !nextOld || !backOld || !footer || !result || !review) return;
    if (modal.dataset.cpqStepfix === '1') return;
    modal.dataset.cpqStepfix = '1';

    const $ = (sel, root = document) => root.querySelector(sel);
    const $$ = (sel, root = document) => [...root.querySelectorAll(sel)];
    const esc = value => String(value ?? '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');

    let step = Number($('#cpqStepNumber')?.textContent?.match(/\d+/)?.[0]) || 1;
    let submitting = false;

    /*
     * Reemplazar los botones elimina todos los addEventListener que
     * el cotizador original ya tenía registrados.
     */
    const next = nextOld.cloneNode(true);
    const back = backOld.cloneNode(true);
    next.removeAttribute('disabled');
    back.removeAttribute('disabled');
    nextOld.replaceWith(next);
    backOld.replaceWith(back);

    function selectedService() {
      const selected = $('.cpq-service.is-selected');
      if (!selected) return null;

      return {
        key: selected.dataset.cpqService || '',
        name: $('.cpq-service-name', selected)?.textContent?.trim() || 'Servicio'
      };
    }

    function collect() {
      const data = {};
      $$('input,select,textarea', form).forEach(el => {
        if (!el.name || el.name === 'website' || el.type === 'file') return;
        data[el.name] = String(el.value ?? '').trim();
      });

      const service = selectedService();
      data.service = service?.key || '';
      data.service_name = service?.name || '';
      const file = $('input[name="attachment"]', form);
      data.attachment = file?.files?.[0] || null;

      return data;
    }

    function dynamicDetails() {
      return $$('.cpq-field', $('#cpqDynamicFields')).map(field => {
        const label = $('span', field)?.textContent?.trim() || '';
        const control = $('input,select,textarea', field);
        if (!control || control.value === '') return '';
        return `<div class="cpq-review-row"><span>${esc(label)}</span><strong>${esc(control.value)}</strong></div>`;
      }).filter(Boolean).join('');
    }

    function renderReview() {
      const data = collect();
      const service = selectedService();

      review.innerHTML = `
        <div class="cpq-review-card cpq-review-main">
          <div class="cpq-review-icon">${service ? '✦' : '⚠'}</div>
          <div>
            <span>SERVICIO</span>
            <strong>${esc(service?.name || 'Por seleccionar')}</strong>
          </div>
        </div>

        <div class="cpq-review-grid">
          <div class="cpq-review-card">
            <span>DETALLES</span>
            ${dynamicDetails() || '<p>Sin detalles adicionales.</p>'}
          </div>

          <div class="cpq-review-card">
            <span>PRODUCCIÓN Y ENTREGA</span>
            <div class="cpq-review-row"><span>Diseño</span><strong>${esc(data.design_status || 'No indicado')}</strong></div>
            <div class="cpq-review-row"><span>Aplicación / instalación</span><strong>${esc(data.application || 'No indicado')}</strong></div>
            <div class="cpq-review-row"><span>Entrega</span><strong>${esc(data.delivery_method || 'Por confirmar')}</strong></div>
            <div class="cpq-review-row"><span>Fecha solicitada</span><strong>${esc(data.desired_date || 'Por confirmar')}</strong></div>
          </div>
        </div>

        <div class="cpq-review-card cpq-review-contact">
          <span>CONTACTO</span>
          <div class="cpq-review-row"><span>Nombre</span><strong>${esc(data.name || 'Falta')}</strong></div>
          <div class="cpq-review-row"><span>WhatsApp</span><strong>${esc(data.phone || 'Falta')}</strong></div>
          ${data.email ? `<div class="cpq-review-row"><span>Correo</span><strong>${esc(data.email)}</strong></div>` : ''}
          ${data.notes ? `<div class="cpq-review-note-row"><span>Notas</span><p>${esc(data.notes)}</p></div>` : ''}
          ${data.attachment ? `<div class="cpq-review-row"><span>Archivo</span><strong>${esc(data.attachment.name)}</strong></div>` : ''}
        </div>
      `;
    }

    function validateStep() {
      if (step === 1) {
        if (!selectedService()) {
          const error = $('#cpqServiceError');
          if (error) error.textContent = 'Selecciona el servicio que más se acerque a tu proyecto.';
          return false;
        }
        return true;
      }

      if (step === 2) {
        const dynamic = $('#cpqDynamicFields');
        const required = $$('[required]', dynamic);
        for (const el of required) {
          if (!String(el.value ?? '').trim()) {
            el.focus();
            alert(`Completa el campo requerido: ${el.closest('.cpq-field')?.querySelector('span')?.textContent?.trim() || 'campo'}`);
            return false;
          }
        }
        return true;
      }

      if (step === 4) {
        const name = $('[name="name"]', form)?.value.trim() || '';
        const phone = $('[name="phone"]', form)?.value.trim() || '';
        const email = $('[name="email"]', form)?.value.trim() || '';

        if (!name || !phone) {
          alert('Completa tu nombre y WhatsApp para continuar.');
          return false;
        }

        if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
          alert('Revisa el correo electrónico.');
          return false;
        }

        return true;
      }

      if (step === 5) {
        const data = collect();
        if (!data.service || !data.name || !data.phone) {
          alert('Faltan datos obligatorios.');
          return false;
        }
        return true;
      }

      return true;
    }

    function updateProgress() {
      $$('.cpq-progress span').forEach((bar, index) => {
        bar.classList.toggle('is-current', index === step - 1);
        bar.classList.toggle('is-done', index < step - 1);
      });

      const titles = ['Servicio', 'Detalles', 'Archivos', 'Entrega', 'Revisión'];
      const title = $('#cpqStepTitle');
      const number = $('#cpqStepNumber');
      const label = $('#cpqFooterLabel');

      if (title) title.textContent = titles[step - 1] || 'Revisión';
      if (number) number.textContent = String(step);
      if (label) label.textContent = `Paso ${step} de 5`;

      back.style.visibility = step === 1 ? 'hidden' : 'visible';
      next.textContent = step === 5 ? 'Enviar solicitud →' : 'Continuar →';
      next.disabled = false;
      back.disabled = false;
    }

    function showStep(target) {
      step = Math.max(1, Math.min(5, target));

      $$('.cpq-step').forEach(panel => {
        panel.classList.toggle('is-visible', Number(panel.dataset.cpqStepview) === step);
      });

      result.classList.remove('is-visible');
      footer.style.display = 'flex';
      updateProgress();

      if (step === 5) renderReview();

      const dialog = $('.cpq-dialog');
      if (dialog) {
        try {
          if (typeof dialog.scrollTo === 'function') {
            dialog.scrollTo({ top: 0, behavior: 'smooth' });
          } else {
            dialog.scrollTop = 0;
          }
        } catch (_) {
          dialog.scrollTop = 0;
        }
      }
    }

    async function submitRequest() {
      if (submitting || !validateStep()) return;

      const service = selectedService();
      const data = collect();
      const fd = new FormData(form);

      fd.set('service', data.service);
      fd.set('service_name', data.service_name || service?.name || '');

      submitting = true;
      next.disabled = true;
      back.disabled = true;
      if (submitState) {
        submitState.classList.remove('is-error');
        submitState.textContent = 'Guardando tu solicitud...';
      }

      try {
        const response = await fetch('/api/pasarela-cotizador.php', {
          method: 'POST',
          body: fd,
          headers: { 'X-Requested-With': 'XMLHttpRequest' },
          credentials: 'same-origin'
        });

        let payload;
        try {
          payload = await response.json();
        } catch (_) {
          throw new Error(`El servidor respondió con HTTP ${response.status}.`);
        }

        if (!response.ok || !payload.ok) {
          throw new Error(payload.message || 'No se pudo registrar la solicitud.');
        }

        $('#cpqRequestId').textContent =
          payload.reference || `CPQ-${String(payload.id || '').padStart(6, '0')}`;
        $('#cpqResultText').textContent =
          payload.message || 'Tu solicitud quedó registrada correctamente.';

        const resultWa = $('#cpqResultWhatsApp');
        if (resultWa) resultWa.href = payload.whatsapp_url || '#';

        $$('.cpq-step').forEach(panel => panel.classList.remove('is-visible'));
        result.classList.add('is-visible');
        footer.style.display = 'none';
        if (submitState) submitState.textContent = '';
      } catch (error) {
        if (submitState) {
          submitState.textContent = error.message || 'No se pudo registrar la solicitud.';
          submitState.classList.add('is-error');
        }
      } finally {
        submitting = false;
        if (!result.classList.contains('is-visible')) {
          next.disabled = false;
          back.disabled = false;
        }
      }
    }

    next.addEventListener('click', event => {
      event.preventDefault();

      if (!validateStep()) return;

      if (step < 5) {
        showStep(step + 1);
      } else {
        submitRequest();
      }
    });

    back.addEventListener('click', event => {
      event.preventDefault();
      if (step > 1) showStep(step - 1);
    });

    /*
     * Mantener sincronizado el estado cuando el usuario abre la pasarela
     * desde cualquier CTA con data-cpq-open.
     */
    $$('[data-cpq-open]').forEach(button => {
      button.addEventListener('click', () => {
        setTimeout(() => {
          const n = Number($('#cpqStepNumber')?.textContent?.match(/\d+/)?.[0]);
          if (Number.isFinite(n) && n >= 1 && n <= 5) {
            step = n;
            updateProgress();
          }
        }, 30);
      });
    });

    $('#cpqNewRequest')?.addEventListener('click', () => {
      setTimeout(() => {
        step = 1;
        updateProgress();
      }, 30);
    });

    updateProgress();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot, { once: true });
  } else {
    boot();
  }
})();
