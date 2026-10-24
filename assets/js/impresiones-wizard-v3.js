document.addEventListener('DOMContentLoaded', function () {
  'use strict';

  const modal = document.getElementById('printCaptureModal');
  const dialog = modal?.querySelector('.capture-modal-dialog');
  const form = document.getElementById('meterForm');
  const grid = form?.querySelector('.meter-form-grid');

  if (!modal || !dialog || !form || !grid) return;

  const byName = (name) => form.querySelector(`[name="${name}"]`);
  const num = (value) => {
    const n = parseFloat(String(value ?? '').replace(',', '.'));
    return Number.isFinite(n) ? n : 0;
  };
  const money = (value) =>
    new Intl.NumberFormat('es-MX', {
      style: 'currency',
      currency: 'MXN',
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    }).format(num(value));

  dialog.classList.add('capture-wizard-dialog');

  const native = {
    date: byName('printed_at'),
    roll: byName('roll_id'),
    job: byName('job_name'),
    lengthMm: byName('job_length_mm'),
    linearM: byName('linear_m'),
    result: byName('result_status'),
    rollName: byName('roll_name'),
    nativeSubmit: form.querySelector('.capture-submit')
  };

  if (!native.roll || !native.job || !native.linearM || !native.result) return;

  [
    native.date,
    native.roll,
    native.job,
    native.lengthMm,
    native.linearM,
    native.result
  ].forEach((input) => {
    const field = input?.closest('.field');
    if (field) field.classList.add('capture-v3-native-hidden');
  });

  form.querySelectorAll('.capture-step-label').forEach((el) => el.remove());
  form.querySelector('.roll-selection-confirm')?.classList.add('capture-v3-native-hidden');
  form.querySelector('.meter-preview')?.classList.add('capture-v3-native-hidden');
  form.querySelector('.capture-confirm-note')?.classList.add('capture-v3-native-hidden');
  native.nativeSubmit?.classList.add('capture-v3-native-hidden');

  const card = form.closest('.capture-modal-card');
  card?.querySelector('.section-heading')?.classList.add('capture-v3-native-hidden');

  grid.hidden = true;

  function hidden(name, value = '') {
    let input = byName(name);
    if (!input) {
      input = document.createElement('input');
      input.type = 'hidden';
      input.name = name;
      form.appendChild(input);
    }
    input.value = value;
    return input;
  }

  const hiddenPanels = hidden('panels', '1');
  const hiddenArea = hidden('area_m2', '0');

  const shell = document.createElement('div');
  shell.className = 'capture-wizard-shell';

  const header = document.createElement('div');
  header.className = 'capture-wizard-header';
  header.innerHTML = `
    <div>
      <div class="capture-wizard-kicker">PRONTEXP · CONTROL DE METRAJE Y COSTOS</div>
      <h3 class="capture-wizard-title">Registremos la impresión.</h3>
      <p class="capture-wizard-subtitle">Dimensiones, consumo, saldo y costo del material antes de descontar.</p>
    </div>
  `;

  const closeButton = document.createElement('button');
  closeButton.type = 'button';
  closeButton.className = 'capture-wizard-close';
  closeButton.setAttribute('aria-label', 'Cerrar captura');
  closeButton.textContent = '×';
  closeButton.addEventListener('click', () =>
    document.getElementById('closePrintCapture')?.click()
  );
  header.appendChild(closeButton);

  const progress = document.createElement('div');
  progress.className = 'capture-wizard-progress';
  progress.innerHTML = `
    <div class="capture-wizard-progress-track">
      <span class="capture-wizard-progress-fill" id="captureWizardProgressFill"></span>
      <div class="capture-wizard-progress-points">
        <div class="capture-wizard-point"><span>1</span></div>
        <div class="capture-wizard-point"><span>2</span></div>
        <div class="capture-wizard-point"><span>3</span></div>
        <div class="capture-wizard-point"><span>✓</span></div>
      </div>
    </div>
  `;

  const body = document.createElement('div');
  body.className = 'capture-wizard-body';

  const step1 = document.createElement('section');
  step1.className = 'capture-wizard-step';
  step1.dataset.step = '1';
  step1.innerHTML = `
    <div class="capture-step-kicker">01 · TRABAJO Y ROLLO</div>
    <div class="capture-step-icon">▣</div>
    <h4 class="capture-step-title">¿Qué trabajo vamos a registrar?</h4>
    <p class="capture-step-help">Selecciona el rollo correcto antes de calcular el consumo. Los datos del rollo alimentan el costo y los metros disponibles.</p>
    <div class="capture-v3-grid">
      <div class="capture-v3-field is-wide" data-slot="job"></div>
      <div class="capture-v3-field" data-slot="roll"></div>
      <div class="capture-v3-field" data-slot="date"></div>
    </div>
  `;

  const step2 = document.createElement('section');
  step2.className = 'capture-wizard-step';
  step2.dataset.step = '2';
  step2.innerHTML = `
    <div class="capture-step-kicker">02 · MEDIDAS Y COSTO</div>
    <div class="capture-step-icon">↔</div>
    <h4 class="capture-step-title">Dimensiones del trabajo</h4>
    <p class="capture-step-help">El área se calcula como ancho × largo. Los metros lineales se calculan como largo × número de paneles necesarios según el ancho del rollo.</p>

    <div class="capture-v3-grid">
      <div class="capture-v3-field">
        <label for="v3_job_width_m">Ancho del trabajo</label>
        <input id="v3_job_width_m" name="job_width_m" type="number" step="0.001" min="0.001" inputmode="decimal" placeholder="1.200" required>
        <small>Metros. Ejemplo: 1.20</small>
      </div>

      <div class="capture-v3-field">
        <label for="v3_job_length_m">Largo del trabajo</label>
        <input id="v3_job_length_m" name="job_length_m" type="number" step="0.001" min="0.001" inputmode="decimal" placeholder="8.000" required>
        <small>Metros de avance por panel.</small>
      </div>

      <div class="capture-v3-field">
        <label for="v3_roll_width_m">Ancho útil del rollo</label>
        <input id="v3_roll_width_m" name="roll_width_m" type="number" step="0.001" min="0.001" inputmode="decimal" placeholder="1.520" required>
        <small>Se precarga desde el rollo y puede corregirse.</small>
      </div>

      <div class="capture-v3-field">
        <label for="v3_cost_per_m">Costo por metro lineal</label>
        <input id="v3_cost_per_m" name="cost_per_linear_m" type="number" step="0.01" min="0" inputmode="decimal" placeholder="45.00" required>
        <small>Valor actual del material por metro lineal.</small>
      </div>
    </div>

    <div class="capture-v3-calculator">
      <div class="capture-v3-calculator-head">
        <div>
          <strong>Cálculo automático</strong>
          <span>El servidor volverá a calcularlo antes de descontar.</span>
        </div>
      </div>

      <div class="capture-v3-metrics">
        <div class="capture-v3-metric">
          <span>Área</span>
          <strong id="v3_area">0.000 m²</strong>
        </div>
        <div class="capture-v3-metric">
          <span>Paneles</span>
          <strong id="v3_panels">1</strong>
        </div>
        <div class="capture-v3-metric is-accent">
          <span>Metros lineales</span>
          <strong id="v3_linear">0.000 m</strong>
        </div>
        <div class="capture-v3-metric is-money">
          <span>Costo material</span>
          <strong id="v3_cost">$0.00</strong>
        </div>
      </div>

      <div class="capture-v3-formula" id="v3_formula">
        <b>Área:</b> ancho × largo ·
        <b>Metros lineales:</b> largo × paneles ·
        <b>Costo:</b> metros lineales × costo por metro
      </div>
    </div>
  `;

  const step3 = document.createElement('section');
  step3.className = 'capture-wizard-step';
  step3.dataset.step = '3';
  step3.innerHTML = `
    <div class="capture-step-kicker">03 · RESULTADO E INVENTARIO</div>
    <div class="capture-step-icon">✓</div>
    <h4 class="capture-step-title">¿Cómo terminó la impresión?</h4>
    <p class="capture-step-help">Verifica el saldo del rollo. Impresiones de prueba, canceladas o dañadas siguen consumiendo material y se registran como merma.</p>

    <div class="capture-v3-grid">
      <div class="capture-v3-field is-wide" data-slot="result"></div>
    </div>

    <div class="capture-v3-stock" id="v3_stock">
      <div class="capture-v3-stock-head">
        <div>
          <strong id="v3_roll_name">Selecciona un rollo</strong>
          <small id="v3_stock_message">Saldo calculado antes de confirmar.</small>
        </div>
      </div>

      <div class="capture-v3-bar">
        <span id="v3_stock_bar"></span>
      </div>

      <div class="capture-v3-stock-values">
        <div>
          <span>Disponible</span>
          <strong id="v3_before">0.000 m</strong>
        </div>
        <div>
          <span>Consumo</span>
          <strong id="v3_used">0.000 m</strong>
        </div>
        <div>
          <span>Quedará</span>
          <strong id="v3_after">0.000 m</strong>
        </div>
      </div>
    </div>
  `;

  const step4 = document.createElement('section');
  step4.className = 'capture-wizard-step';
  step4.dataset.step = '4';
  step4.innerHTML = `
    <div class="capture-step-kicker">04 · CONFIRMACIÓN</div>
    <div class="capture-step-icon">✓</div>
    <h4 class="capture-step-title">Revisa antes de descontar</h4>
    <p class="capture-step-help">Esta es la confirmación definitiva. No habrá una segunda ventana del navegador.</p>

    <div class="capture-final-card">
      <h4>Resumen del registro</h4>
      <p>Los importes se guardarán como costo histórico de este trabajo.</p>

      <div class="capture-final-summary">
        <div class="capture-final-row"><span>Trabajo</span><strong id="finalJob">—</strong></div>
        <div class="capture-final-row"><span>Rollo</span><strong id="finalRoll">—</strong></div>
        <div class="capture-final-row"><span>Medida</span><strong id="finalSize">—</strong></div>
        <div class="capture-final-row"><span>Área</span><strong id="finalArea">—</strong></div>
        <div class="capture-final-row"><span>Paneles</span><strong id="finalPanels">—</strong></div>
        <div class="capture-final-row"><span>Ancho de rollo</span><strong id="finalRollWidth">—</strong></div>
        <div class="capture-final-row"><span>Disponible antes</span><strong id="finalAvailable">—</strong></div>
        <div class="capture-final-row is-important"><span>Metros lineales</span><strong id="finalConsumption">—</strong></div>
        <div class="capture-final-row is-important"><span>Saldo después</span><strong id="finalAfter">—</strong></div>
        <div class="capture-final-row"><span>Costo / metro lineal</span><strong id="finalCostPerM">—</strong></div>
        <div class="capture-final-row is-cost"><span>Costo total de material</span><strong id="finalCost">—</strong></div>
        <div class="capture-final-row"><span>Resultado</span><strong id="finalResult">—</strong></div>
      </div>

      <div class="capture-danger-note">
        ⚠ Al confirmar, SISACT descontará los metros lineales del rollo seleccionado y guardará el costo calculado en el historial.
      </div>
    </div>
  `;

  body.append(step1, step2, step3, step4);

  const footer = document.createElement('div');
  footer.className = 'capture-wizard-footer';
  footer.innerHTML = `
    <div class="capture-wizard-footer-left">
      <button type="button" class="wizard-cancel">Cancelar</button>
      <button type="button" class="wizard-back">← Atrás</button>
    </div>
    <div class="capture-wizard-footer-right">
      <button type="button" class="wizard-next">Continuar →</button>
      <button type="button" class="wizard-submit">✓ Confirmar y descontar</button>
    </div>
  `;

  const errorBox = document.createElement('div');
  errorBox.className = 'capture-v3-error';
  errorBox.setAttribute('role', 'alert');

  step1.appendChild(errorBox);

  form.insertBefore(shell, form.firstChild);
  shell.append(header, progress, body, footer);

  function moveNative(input, slotName) {
    const slot = shell.querySelector(`[data-slot="${slotName}"]`);
    const field = input?.closest('.field');

    if (!slot || !field) return;

    field.classList.remove('capture-v3-native-hidden');
    field.style.margin = '0';
    slot.replaceWith(field);
  }

  moveNative(native.job, 'job');
  moveNative(native.roll, 'roll');
  moveNative(native.date, 'date');
  moveNative(native.result, 'result');

  native.job?.setAttribute('autocomplete', 'off');

  const jobWidth = byName('job_width_m');
  const jobLength = byName('job_length_m');
  const rollWidth = byName('roll_width_m');
  const costPerM = byName('cost_per_linear_m');

  const steps = [...body.querySelectorAll('.capture-wizard-step')];
  const points = [...progress.querySelectorAll('.capture-wizard-point')];
  const fill = progress.querySelector('#captureWizardProgressFill');
  const back = footer.querySelector('.wizard-back');
  const next = footer.querySelector('.wizard-next');
  const submit = footer.querySelector('.wizard-submit');
  const cancel = footer.querySelector('.wizard-cancel');

  let currentStep = 1;

  function selectedRoll() {
    const option = native.roll?.selectedOptions?.[0];

    return {
      id: native.roll?.value || '',
      name: (option?.dataset?.rollName || '').trim(),
      available: num(option?.dataset?.remaining),
      width: num(option?.dataset?.rollWidth),
      cost: num(option?.dataset?.costPerM),
      status: option?.dataset?.status || ''
    };
  }

  function syncRollProfile(force = false) {
    const roll = selectedRoll();

    if (native.rollName) {
      native.rollName.value = roll.name;
    }

    if (force || num(rollWidth?.value) <= 0) {
      rollWidth.value = roll.width > 0 ? roll.width.toFixed(3) : '';
    }

    if (force || String(costPerM?.value ?? '').trim() === '') {
      costPerM.value = roll.cost > 0 ? roll.cost.toFixed(2) : '0.00';
    }
  }

  function calc() {
    syncRollProfile(false);

    const roll = selectedRoll();
    const width = num(jobWidth?.value);
    const length = num(jobLength?.value);
    const rWidth = num(rollWidth?.value);
    const cost = num(costPerM?.value);

    const panels =
      width > 0 && rWidth > 0
        ? Math.max(1, Math.ceil((width / rWidth) - 0.0000001))
        : 1;

    const area = width > 0 && length > 0
      ? width * length
      : 0;

    const linear = length > 0
      ? length * panels
      : 0;

    const after = Math.max(0, roll.available - linear);
    const materialCost = linear * Math.max(0, cost);

    hiddenPanels.value = String(panels);
    hiddenArea.value = area.toFixed(3);

    if (native.lengthMm) {
      native.lengthMm.value = length > 0
        ? (length * 1000).toFixed(2)
        : '';
    }

    if (native.linearM) {
      native.linearM.value = linear > 0
        ? linear.toFixed(3)
        : '';
    }

    document.getElementById('v3_area').textContent =
      `${area.toFixed(3)} m²`;

    document.getElementById('v3_panels').textContent =
      String(panels);

    document.getElementById('v3_linear').textContent =
      `${linear.toFixed(3)} m`;

    document.getElementById('v3_cost').textContent =
      money(materialCost);

    const formula = document.getElementById('v3_formula');

    if (formula) {
      formula.innerHTML =
        `<b>Área:</b> ${width.toFixed(3)} × ${length.toFixed(3)} = ${area.toFixed(3)} m² · ` +
        `<b>Paneles:</b> ${panels} · ` +
        `<b>Metros lineales:</b> ${length.toFixed(3)} × ${panels} = ${linear.toFixed(3)} m · ` +
        `<b>Costo:</b> ${linear.toFixed(3)} × ${money(cost)} = ${money(materialCost)}`;
    }

    document.getElementById('v3_roll_name').textContent =
      roll.name || 'Selecciona un rollo';

    document.getElementById('v3_before').textContent =
      `${roll.available.toFixed(3)} m`;

    document.getElementById('v3_used').textContent =
      `${linear.toFixed(3)} m`;

    document.getElementById('v3_after').textContent =
      `${after.toFixed(3)} m`;

    const stock = document.getElementById('v3_stock');
    const stockBar = document.getElementById('v3_stock_bar');
    const stockMessage = document.getElementById('v3_stock_message');

    const remainingPct =
      roll.available > 0
        ? Math.max(0, Math.min(100, (after / roll.available) * 100))
        : 0;

    if (stockBar) {
      stockBar.style.width = `${remainingPct}%`;
    }

    stock?.classList.remove('is-danger', 'is-warning');

    if (linear > roll.available + 0.0001) {
      stock?.classList.add('is-danger');
      if (stockMessage) {
        stockMessage.textContent =
          'El consumo supera el material disponible. No se podrá confirmar.';
      }
    } else if (roll.available > 0 && remainingPct <= 20) {
      stock?.classList.add('is-warning');
      if (stockMessage) {
        stockMessage.textContent =
          'Atención: este rollo quedará por debajo del 20% de su saldo actual.';
      }
    } else if (stockMessage) {
      stockMessage.textContent =
        'Saldo calculado antes de confirmar.';
    }

    document.getElementById('finalJob').textContent =
      (native.job?.value || '').trim() || '—';

    document.getElementById('finalRoll').textContent =
      roll.name
        ? `${roll.name} (#${roll.id})`
        : '—';

    document.getElementById('finalSize').textContent =
      width > 0 && length > 0
        ? `${width.toFixed(3)} × ${length.toFixed(3)} m`
        : '—';

    document.getElementById('finalArea').textContent =
      area > 0 ? `${area.toFixed(3)} m²` : '—';

    document.getElementById('finalPanels').textContent =
      String(panels);

    document.getElementById('finalRollWidth').textContent =
      rWidth > 0 ? `${rWidth.toFixed(3)} m` : '—';

    document.getElementById('finalAvailable').textContent =
      roll.name ? `${roll.available.toFixed(3)} m` : '—';

    document.getElementById('finalConsumption').textContent =
      linear > 0 ? `${linear.toFixed(3)} m` : '—';

    document.getElementById('finalAfter').textContent =
      roll.name && linear > 0
        ? `${after.toFixed(3)} m`
        : '—';

    document.getElementById('finalCostPerM').textContent =
      money(cost);

    document.getElementById('finalCost').textContent =
      money(materialCost);

    document.getElementById('finalResult').textContent =
      native.result?.selectedOptions?.[0]?.textContent?.trim() || '—';

    return {
      roll,
      width,
      length,
      rollWidth: rWidth,
      cost,
      panels,
      area,
      linear,
      after,
      materialCost
    };
  }

  function setError(message, step = currentStep) {
    let box = steps[step - 1]?.querySelector('.capture-v3-error');

    if (!box) {
      box = document.createElement('div');
      box.className = 'capture-v3-error';
      box.setAttribute('role', 'alert');
      steps[step - 1]?.appendChild(box);
    }

    box.textContent = message || '';
    box.classList.toggle('is-visible', Boolean(message));
  }

  function clearErrors() {
    shell.querySelectorAll('.capture-v3-error').forEach((box) => {
      box.textContent = '';
      box.classList.remove('is-visible');
    });
  }

  function validate(step) {
    clearErrors();
    const state = calc();

    if (step === 1) {
      const job = (native.job?.value || '').trim();

      if (!job) {
        setError('Escribe el nombre del trabajo de Printexp.', 1);
        native.job?.focus();
        return false;
      }

      if (!state.roll.id || !state.roll.name) {
        setError('Selecciona el rollo utilizado.', 1);
        native.roll?.focus();
        return false;
      }

      if (state.roll.status && state.roll.status !== 'active') {
        setError('El rollo seleccionado no está activo.', 1);
        return false;
      }
    }

    if (step === 2) {
      if (state.width <= 0) {
        setError('Captura el ancho del trabajo en metros.', 2);
        jobWidth?.focus();
        return false;
      }

      if (state.length <= 0) {
        setError('Captura el largo del trabajo en metros.', 2);
        jobLength?.focus();
        return false;
      }

      if (state.rollWidth <= 0) {
        setError('Captura el ancho útil del rollo.', 2);
        rollWidth?.focus();
        return false;
      }

      if (state.linear <= 0) {
        setError('No se pudo calcular el consumo lineal.', 2);
        return false;
      }

      if (state.linear > state.roll.available + 0.0001) {
        setError(
          `El consumo calculado es ${state.linear.toFixed(3)} m y el rollo solo tiene ${state.roll.available.toFixed(3)} m.`,
          2
        );
        return false;
      }
    }

    if (step === 3) {
      if (!native.result?.value) {
        setError('Selecciona el resultado de la impresión.', 3);
        native.result?.focus();
        return false;
      }
    }

    if (step === 4) {
      if (state.linear <= 0 || state.linear > state.roll.available + 0.0001) {
        setError('Revisa el consumo y el saldo antes de confirmar.', 4);
        return false;
      }
    }

    return true;
  }

  function showStep(step) {
    currentStep = Math.max(1, Math.min(4, step));

    steps.forEach((el) => {
      el.classList.toggle(
        'is-active',
        Number(el.dataset.step) === currentStep
      );
    });

    points.forEach((point, index) => {
      const n = index + 1;
      point.classList.toggle('is-active', n === currentStep);
      point.classList.toggle('is-done', n < currentStep);
    });

    if (fill) {
      fill.style.width = `${((currentStep - 1) / 3) * 100}%`;
    }

    back.disabled = currentStep === 1;
    next.style.display = currentStep < 4 ? 'inline-flex' : 'none';
    submit.style.display = currentStep === 4 ? 'inline-flex' : 'none';

    calc();

    body.scrollTo({ top: 0, behavior: 'smooth' });

    requestAnimationFrame(() => {
      steps[currentStep - 1]
        ?.querySelector('input:not([type="hidden"]),select')
        ?.focus();
    });
  }

  native.roll.addEventListener('change', () => {
    syncRollProfile(true);
    calc();
  });

  [
    native.job,
    native.result,
    jobWidth,
    jobLength,
    rollWidth,
    costPerM
  ].forEach((input) => {
    input?.addEventListener('input', calc);
    input?.addEventListener('change', calc);
  });

  next.addEventListener('click', () => {
    if (validate(currentStep)) {
      showStep(currentStep + 1);
    }
  });

  back.addEventListener('click', () =>
    showStep(currentStep - 1)
  );

  cancel.addEventListener('click', () =>
    document.getElementById('closePrintCapture')?.click()
  );

  submit.addEventListener('click', () => {
    if (!validate(4)) return;

    submit.disabled = true;
    submit.textContent = 'Registrando…';

    /*
     * Envío directo:
     * evita el window.confirm() antiguo de impresiones.php.
     * El paso 4 ya es la confirmación definitiva.
     */
    HTMLFormElement.prototype.submit.call(form);
  });

  document.getElementById('openPrintCapture')?.addEventListener(
    'click',
    () => {
      setTimeout(() => {
        syncRollProfile(true);
        clearErrors();
        showStep(1);
      }, 0);
    }
  );

  syncRollProfile(true);
  calc();
  showStep(1);
});
