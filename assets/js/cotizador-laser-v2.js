(() => {
  'use strict';
  const root = document.getElementById('cp-laser-app');
  if (!root) return;
  document.body.classList.add('cp-laser-module');
  const $ = id => document.getElementById('cp-laser-' + id);
  const nativeNav = document.querySelector('.cp-dropdown-link[href="/admin/cotizadores.php"]');
  if (nativeNav) {
    nativeNav.classList.add('is-active');
    const group = nativeNav.closest('.cp-nav-group');
    if (group) group.classList.add('is-active');
  }
  const businessName = root.dataset.businessName || 'Colibrí Print México';
  const form = $('quote-form'), settingsForm = $('settings-form');
  const KEY = root.dataset.storageKey;
  if (!KEY) return;
  const boot = JSON.parse($('bootstrap').textContent);
  const MATERIALS = ['MDF', 'Acrílico', 'Triplay', 'Otro'];
  const PROFILE_FIELDS = ['thickness', 'sheetWidth', 'sheetHeight', 'sheetPrice'];
  const FIELDS = ['title', 'client', 'material', 'materialId', 'customMaterial', 'thickness', 'width', 'height', 'quantity', 'supply', 'sheetWidth', 'sheetHeight', 'sheetPrice', 'chargeMode', 'waste', 'cutMinutes', 'engraveMinutes', 'timeBasis', 'rate', 'design', 'finishing', 'profitMode', 'profit', 'minimum', 'discount', 'tax', 'notes'];
  const currency = n => new Intl.NumberFormat('es-MX', { style: 'currency', currency: 'MXN', minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(n);
  const decimal = n => new Intl.NumberFormat('es-MX', { maximumFractionDigits: 2 }).format(n);
  const escape = value => String(value ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  const icon = (id, label = '') => `<svg ${label ? `aria-label="${escape(label)}"` : 'aria-hidden="true"'}><use href="#cp-laser-i-${id}"/></svg>`;
  const dateLabel = iso => new Intl.DateTimeFormat('es-MX', { day: 'numeric', month: 'short', year: 'numeric', timeZone: 'America/Mexico_City' }).format(new Date(iso));
  const now = () => new Date().toISOString();
  const defaultSettings = () => ({ machine: { width: 90, height: 60, power: 100 }, defaults: { rate: '', profit: '', profitMode: 'markup', minimum: '', waste: '', tax: '' }, profiles: Object.fromEntries(MATERIALS.map(m => [m, Object.fromEntries(PROFILE_FIELDS.map(f => [f, '']))])) });
  let settings = validateSettings(boot.state), materials = validateMaterials(boot.state.materials);
  let records = [], sequence = {}, draft = null, legacySettings = null;
  let sharedVersion = boot.version, sharedDirty = false, sharedBusy = false, usingLegacy = false;
  const selectedMaterials = new Set(), selectedHistory = new Set();
  let confirmAction = null;
  let storageProblem = false;
  try {
    const raw = localStorage.getItem(KEY);
    if (raw) {
      const data = JSON.parse(raw);
      if (![1,2].includes(data.schema)) throw new Error('Versión de datos no compatible');
      if (data.schema === 1 && data.settings) legacySettings = validateSettings(data.settings);
      else if (data.legacySettings) legacySettings = validateSettings(data.legacySettings);
      records = validateRecords(data.records || []);
      sequence = data.sequence && typeof data.sequence === 'object' ? data.sequence : {};
      draft = data.draft;
    }
  } catch (_) { storageProblem = true; }

  function sanitizeJob(input) {
    if (!input || typeof input !== 'object' || Array.isArray(input)) throw new Error('Cotización no válida.');
    const job = Object.fromEntries(FIELDS.map(k => [k, typeof input[k] === 'string' || typeof input[k] === 'number' ? String(input[k]).slice(0, k === 'notes' ? 2000 : 150) : '']));
    if (!MATERIALS.includes(job.material)) job.material = 'MDF';
    if (!['shop', 'customer'].includes(job.supply)) job.supply = 'shop';
    if (!['area', 'sheets'].includes(job.chargeMode)) job.chargeMode = 'area';
    if (!['batch', 'unit'].includes(job.timeBasis)) job.timeBasis = 'batch';
    if (!['markup', 'margin'].includes(job.profitMode)) job.profitMode = 'markup';
    return job;
  }
  function validateSettings(input) {
    if (!input || typeof input !== 'object') throw new Error('Faltan ajustes válidos.');
    const output = defaultSettings();
    for (const key of ['width', 'height', 'power']) {
      const n = Number(input.machine?.[key]);
      if (!Number.isFinite(n) || n <= 0 || n > 10000) throw new Error('Revisa potencia y área de trabajo.');
      output.machine[key] = n;
    }
    output.defaults.profitMode = input.defaults?.profitMode === 'margin' ? 'margin' : 'markup';
    for (const key of ['rate', 'profit', 'minimum', 'waste', 'tax']) {
      const raw = input.defaults?.[key];
      const value = raw === '' || raw === null || raw === undefined ? '' : Number(raw);
      const max = key === 'profit' ? (output.defaults.profitMode === 'margin' ? 99.99 : 10000) : ['tax', 'waste'].includes(key) ? 100 : 1e9;
      if (value !== '' && (!Number.isFinite(value) || value < (key === 'rate' ? 0.01 : 0) || value > max)) throw new Error('Revisa los valores iniciales. El margen debe ser menor a 100%.');
      output.defaults[key] = value === '' ? '' : String(value);
    }
    for (const material of MATERIALS) for (const key of PROFILE_FIELDS) {
      const raw = input.profiles?.[material]?.[key];
      const value = raw === '' || raw === null || raw === undefined ? '' : Number(raw);
      const max = key === 'thickness' ? 1000 : key === 'sheetPrice' ? 1e9 : 100000;
      if (value !== '' && (!Number.isFinite(value) || value < (key === 'thickness' ? 0 : 0.01) || value > max)) throw new Error('Revisa los datos del material ' + material + '.');
      output.profiles[material][key] = value === '' ? '' : String(value);
    }
    return output;
  }
  function validateMaterials(input) {
    if (!Array.isArray(input) || input.length > 150) throw new Error('El catálogo admite hasta 150 materiales y espesores.');
    const ids = new Set(), names = new Set();
    return input.map(row => {
      if (!row || typeof row !== 'object') throw new Error('Revisa los registros del catálogo.');
      const id = String(row.id || ''), name = String(row.name || '').trim();
      if (!/^[A-Za-z0-9_-]{1,60}$/.test(id) || ids.has(id)) throw new Error('Hay identificadores de material repetidos o no válidos.');
      if (!name || [...name].length > 80) throw new Error('Captura un nombre de material de hasta 80 caracteres.');
      const read = (key, optional, max) => {
        const v = row[key];
        if ((v === '' || v === null || v === undefined) && optional) return null;
        if (!['string','number'].includes(typeof v)) throw new Error('Revisa el dato de ' + name + '.');
        const n = Number(v);
        if (!Number.isFinite(n) || n < (key === 'thickness' ? .001 : .01) || n > max) throw new Error('Revisa espesor, dimensiones y costo de ' + name + '.');
        return n;
      };
      const thickness = read('thickness', false, 1000);
      const pair = name.replace(/\s+/g, ' ').toLocaleLowerCase('es') + ':' + thickness.toFixed(4);
      if (names.has(pair)) throw new Error(`Ya existe ${name} de ${thickness} mm. Edita ese registro.`);
      ids.add(id); names.add(pair);
      return { id, name, thickness, sheetWidth:read('sheetWidth',true,100000), sheetHeight:read('sheetHeight',true,100000), sheetPrice:read('sheetPrice',true,1e9) };
    });
  }
  function validMachine(input) {
    const m = input || settings.machine;
    if (!m || !['width', 'height', 'power'].every(k => Number.isFinite(Number(m[k])) && Number(m[k]) > 0 && Number(m[k]) <= 10000)) throw new Error('Máquina no válida en una cotización.');
    return { width: Number(m.width), height: Number(m.height), power: Number(m.power) };
  }
  function validateRecords(input) {
    if (!Array.isArray(input) || input.length > 100) throw new Error('El respaldo admite hasta 100 cotizaciones.');
    const ids = new Set();
    return input.map(item => {
      if (!item || typeof item.id !== 'string' || !item.id || item.id.length > 150 || ids.has(item.id)) throw new Error('Hay identificadores de cotización no válidos o repetidos.');
      ids.add(item.id);
      if (typeof item.folio !== 'string' || !item.folio || item.folio.length > 60 || !Number.isFinite(Date.parse(item.createdAt)) || !Number.isFinite(Date.parse(item.updatedAt))) throw new Error('Hay cotizaciones incompletas en el respaldo.');
      const job = sanitizeJob(item.job), machine = validMachine(item.machine);
      if (!CpLaserMath.calculate(job, machine).valid) throw new Error('Una cotización del respaldo contiene datos de cálculo no válidos.');
      return { id: item.id, folio: item.folio, createdAt: item.createdAt, updatedAt: item.updatedAt, job, machine };
    });
  }
  function initialJob() {
    const d = settings.defaults;
    const m = materials[0];
    return { title:'',client:'',material:m && MATERIALS.includes(m.name) ? m.name : 'Otro',materialId:m?.id || 'custom',customMaterial:m?.name || '',thickness:m ? String(m.thickness) : '',width:'',height:'',quantity:'1',supply:'shop',sheetWidth:m?.sheetWidth == null ? '' : String(m.sheetWidth),sheetHeight:m?.sheetHeight == null ? '' : String(m.sheetHeight),sheetPrice:m?.sheetPrice == null ? '' : String(m.sheetPrice),chargeMode:'area',waste:d.waste,cutMinutes:'',engraveMinutes:'',timeBasis:'batch',rate:d.rate,design:'',finishing:'',profitMode:d.profitMode,profit:d.profit,minimum:d.minimum,discount:'',tax:d.tax,notes:'' };
  }

  let job = initialJob(), activeMachine = { ...settings.machine }, activeId = null, currentResult = null;
  let touched = new Set(), hasInteracted = false, page = 'quote', pendingImport = null, saveTimer = null, toastTimer = null;
  if (draft?.job) {
    try {
      job = sanitizeJob(draft.job);
      if (!job.materialId) job.materialId = materials.find(m => m.name.toLocaleLowerCase('es') === materialName(job).toLocaleLowerCase('es') && m.thickness === Number(job.thickness))?.id || 'custom';
      activeMachine = validMachine(draft.machine);
      activeId = records.some(r => r.id === draft.activeId) ? draft.activeId : null;
      hasInteracted = Boolean(job.width || job.height || job.title || job.cutMinutes || job.engraveMinutes);
    } catch (_) { job = initialJob(); }
  }
  function toast(message) {
    $('toast').textContent = message;
    $('toast').classList.add('visible');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => $('toast').classList.remove('visible'), 4400);
  }
  function snapshot() {
    return { schema:2, settings, catalog:materials, legacySettings, records, sequence, draft:{job,machine:activeMachine,activeId} };
  }
  function persist() {
    clearTimeout(saveTimer);
    try {
      localStorage.setItem(KEY, JSON.stringify(snapshot()));
      root.querySelector('.form-footer>span').textContent = 'El borrador se guarda en este navegador para tu usuario.';
      root.querySelector('.summary-local').innerHTML = '<span></span> Local · Este navegador y usuario';
      return true;
    } catch (_) {
      root.querySelector('.form-footer>span').textContent = 'No se pudo guardar el borrador. Exporta un respaldo.';
      root.querySelector('.summary-local').textContent = 'No se pudo guardar · Exporta un respaldo';
      toast('No se pudo guardar en este navegador. Puedes exportar un respaldo desde Ajustes.');
      return false;
    }
  }
  function readForm() {
    job = sanitizeJob(Object.fromEntries(new FormData(form)));
  }
  function fillForm() {
    renderMaterialChoice();
    for (const key of FIELDS) {
      const field = form.elements.namedItem(key);
      if (field) field.value = job[key] ?? '';
    }
    if (Number(job.design) || Number(job.finishing)) form.querySelector('.extra-details').open = true;
  }
  function materialName(j = job) { return j.material === 'Otro' ? j.customMaterial.trim() || 'Otro material' : j.material; }
  function title(j = job) { return j.title.trim() || `Corte y grabado en ${materialName(j)}`; }
  function renderMachine() {
    $('machine-label').textContent = `Láser CO₂ · ${decimal(activeMachine.power)} W`;
    $('machine-area').textContent = `Área de trabajo ${decimal(activeMachine.width)} × ${decimal(activeMachine.height)} cm`;
    $('bed-note').textContent = `Área de máquina: ${decimal(activeMachine.width)} × ${decimal(activeMachine.height)} cm · giro permitido`;
  }
  function renderPreview() {
    const w = Number(job.width), h = Number(job.height), q = Number(job.quantity);
    const valid = Number.isFinite(w) && Number.isFinite(h) && w > 0 && h > 0;
    if (valid) {
      const scale = Math.min(106 / w, 58 / h), rw = w * scale, rh = h * scale;
      const color = { MDF: '#e1c3a4', Acrílico: '#cde4e0', Triplay: '#e5cc9f', Otro: '#d9ded4' }[job.material];
      $('piece-svg').innerHTML = `<rect x="${(150 - rw) / 2}" y="${(88 - rh) / 2}" width="${rw}" height="${rh}" rx="1" fill="${color}" stroke="#ac9477" stroke-width="1.2"/><path d="M${(150 - rw) / 2} 81h${rw}" stroke="#aeb69e" stroke-width=".6"/>`;
      $('piece-svg').setAttribute('aria-label', `Pieza rectangular de ${decimal(w)} por ${decimal(h)} centímetros`);
      $('piece-size').textContent = `${decimal(w)} × ${decimal(h)} cm · ${materialName()}`;
      $('piece-area').textContent = `${decimal(w * h)} cm² por pieza${q > 0 && Number.isInteger(q) ? ` · ${decimal(w * h * q / 10000)} m² por lote` : ''}`;
    } else {
      $('piece-svg').innerHTML = '<rect x="33" y="13" width="84" height="62" rx="2" fill="#efc7a5" stroke="#bd8b61" stroke-width="1.5" stroke-dasharray="3 3"/>';
      $('piece-size').textContent = 'Tu pieza, a escala';
      $('piece-area').textContent = 'Captura ancho y alto para visualizarla.';
    }
  }
  function renderQuote() {
    currentResult = CpLaserMath.calculate(job, activeMachine);
    const badInputs = [...form.querySelectorAll('input[type="number"]')].filter(el => el.validity.badInput && !(job.supply === 'customer' && ['sheetWidth', 'sheetHeight', 'sheetPrice', 'waste'].includes(el.name)));
    if (badInputs.length) {
      currentResult.valid = false;
      currentResult.errors = [...badInputs.map(el => ({ field: el.name, message: 'Completa el número que estás capturando.' })), ...currentResult.errors];
    }
    const r = currentResult;
    $('other-material').hidden = job.materialId !== 'custom';
    form.elements.thickness.readOnly = job.materialId !== 'custom';
    const shop = job.supply === 'shop';
    $('material-cost-fields').hidden = !shop;
    $('customer-material-note').hidden = shop;
    $('material-method-note').textContent = job.chargeMode === 'sheets'
      ? `Se cobra cada hoja completa. Acomodo estimado en retícula${r.perSheet ? `: ${decimal(r.perSheet)} piezas por hoja` : ''}. La merma aumenta la cantidad a cubrir; confirma separación y acomodo en tu software.`
      : 'Se prorratea el costo de la hoja según el rectángulo de cada pieza y la merma que indiques.';
    $('profit-note').textContent = job.profitMode === 'margin'
      ? 'Margen: el porcentaje de utilidad se calcula sobre la venta antes del descuento. Debe ser menor a 100%.'
      : 'Recargo: el porcentaje se suma a tu costo. Si lo dejas vacío, el recargo es 0%.';
    form.elements.profit.max = job.profitMode === 'margin' ? '99.99' : '10000';
    renderPreview();
    renderMachine();
    const record = records.find(x => x.id === activeId);
    $('quote-folio').textContent = record ? record.folio : 'Nueva cotización';
    $('quote-date').textContent = dateLabel(record?.createdAt || now());
    $('quote-state').textContent = record ? (JSON.stringify(record.job) === JSON.stringify(job) && JSON.stringify(record.machine) === JSON.stringify(activeMachine) ? 'Guardada' : 'Cambios sin guardar') : 'Borrador';
    const fields = { material: 'materialCost', machine: 'machineCost', design: 'design', finishing: 'finishing', cost: 'cost', base: 'base', discount: 'discount', subtotal: 'subtotal', tax: 'tax', profit: 'profit' };
    for (const [key, value] of Object.entries(fields)) $('sum-' + key).textContent = r.valid ? (key === 'discount' && r[value] > 0 ? '−' : '') + currency(r[value]) : '—';
    $('sum-design').parentElement.hidden = !(Number(job.design) > 0);
    $('sum-finishing').parentElement.hidden = !(Number(job.finishing) > 0);
    $('summary-total').innerHTML = `${r.valid ? escape(currency(r.total)) : '$—'}<span>MXN</span>`;
    $('summary-unit').textContent = r.valid ? currency(r.unit) : '$—';
    $('sum-minutes').textContent = r.valid ? `(${decimal(r.minutes)} min)` : '';
    $('sum-discount-percent').textContent = r.valid ? `${decimal(r.discountPercent)}%` : '';
    $('sum-tax-percent').textContent = r.valid ? `${decimal(r.taxPercent)}%` : '';
    $('summary-status').textContent = r.valid ? 'Calculada' : 'Por completar';
    $('summary-status').classList.toggle('ready', r.valid);
    root.querySelector('.profit-box').classList.toggle('loss', r.valid && r.profit < 0);
    $('sum-profit-note').textContent = r.valid ? `${decimal(r.profitPercent)}% de la venta · antes de impuestos` : 'Después del descuento, antes de impuestos.';
    for (const id of ['save-quote','quick-save','use-result','quick-use','print-quote','copy-quote']) $(id).disabled = !r.valid;
    $('use-result-note').textContent = r.valid ? `Lleva 1 lote de ${decimal(r.quantity)} piezas a Cotización nueva, con descuento e impuesto. Selecciona el cliente y guarda la cotización formal.` : 'Abre Cotización nueva con este lote, su descuento e impuesto. Selecciona el cliente y guarda la cotización formal.';
    $('save-quote').innerHTML = `${icon('check')}${record ? 'Actualizar cálculo' : 'Guardar cálculo láser'}`;
    for (const field of form.querySelectorAll('[aria-invalid]')) field.removeAttribute('aria-invalid');
    for (const err of r.errors) {
      const el = form.elements.namedItem(err.field);
      if (el instanceof HTMLElement && touched.has(err.field)) el.setAttribute('aria-invalid', 'true');
    }
    if (r.valid) {
      let note = 'El precio incluye ' + decimal(r.quantity) + (r.quantity === 1 ? ' pieza.' : ' piezas.');
      if (r.minimumAdjustment > 0) note += ' Se aplicó tu venta mínima del lote.';
      if (job.supply === 'shop' && job.chargeMode === 'sheets') note += ` Material: ${decimal(r.sheets)} ${r.sheets === 1 ? 'hoja completa' : 'hojas completas'}.`;
      if (r.profit < 0) note += ' El descuento deja tu venta por debajo del costo.';
      else if (r.profit === 0) note += ' La cotización no agrega utilidad.';
      if (Math.abs(CpLaserMath.money(r.unit * r.quantity) - r.total) > 0.001) note += ' El precio por pieza es un promedio redondeado; el total del lote prevalece.';
      $('summary-validation').innerHTML = `<strong>${r.profit < 0 ? 'Revisa tu utilidad' : 'Tus números están listos'}</strong><p>${escape(note)}</p>`;
    } else if (hasInteracted) {
      $('summary-validation').innerHTML = '<strong>Falta completar</strong><ul>' + r.errors.slice(0, 5).map(e => `<li><button type="button" data-focus="${escape(e.field)}">${escape(e.message)}</button></li>`).join('') + '</ul>' + (r.errors.length > 5 ? `<p>Y ${r.errors.length - 5} datos más.</p>` : '');
    } else {
      $('summary-validation').innerHTML = '<strong>Listo cuando tú lo estés</strong><p>Completa medidas, material y tiempo para calcular con tus costos reales.</p>';
    }
  }
  form.addEventListener('submit', e => e.preventDefault());
  form.addEventListener('input', e => {
    readForm(); hasInteracted = true; touched.add(e.target.name);
    if (e.target.name === 'materialId') {
      const m = materials.find(row => row.id === job.materialId);
      if (m) {
        job.material = MATERIALS.includes(m.name) ? m.name : 'Otro';
        job.customMaterial = m.name;
        for (const key of PROFILE_FIELDS) job[key] = m[key] == null ? '' : String(m[key]);
      } else {
        job.material = 'Otro'; job.customMaterial = ''; job.thickness = '';
        job.sheetWidth = ''; job.sheetHeight = ''; job.sheetPrice = '';
      }
      fillForm();
    }
    renderQuote();
    clearTimeout(saveTimer); saveTimer = setTimeout(persist, 220);
  });
  $('summary-validation').addEventListener('click', e => {
    const target = e.target.closest('[data-focus]');
    if (!target) return;
    if (target.dataset.focus === 'machine') { showPage('settings'); return; }
    const field = form.elements.namedItem(target.dataset.focus);
    if (field instanceof HTMLElement) { field.scrollIntoView({ block: 'center', behavior: 'smooth' }); field.focus({ preventScroll: true }); }
  });
  function showPage(next) {
    page = next;
    for (const name of ['quote','materials','history','settings']) $('page-' + name).hidden = name !== next;
    for (const el of root.querySelectorAll('[data-page]')) {
      const active = el.dataset.page === next;
      el.classList.toggle('active', active);
      if (active) el.setAttribute('aria-current', 'page'); else el.removeAttribute('aria-current');
    }
    if (next === 'history') renderHistory();
    if (next === 'materials') renderMaterials();
    if (next === 'settings' && !sharedDirty) fillSettings();
    window.scrollTo({ top: 0, behavior: 'auto' });
  }
  root.querySelectorAll('[data-page]').forEach(b => b.addEventListener('click', () => showPage(b.dataset.page)));
  function newQuote() {
    job = initialJob(); activeMachine = { ...settings.machine }; activeId = null; touched.clear(); hasInteracted = false;
    form.querySelector('.extra-details').open = false;
    fillForm(); renderQuote(); persist(); showPage('quote'); form.elements.title.focus({ preventScroll: true });
  }
  $('new-quote').addEventListener('click', newQuote);
  $('history-new').addEventListener('click', newQuote);
  $('calculate-focus').addEventListener('click', () => $('summary-card').scrollIntoView({ behavior: 'smooth', block: 'start' }));
  $('save-quote').addEventListener('click', () => {
    readForm(); renderQuote(); if (!currentResult.valid) return;
    const old = records.find(r => r.id === activeId);
    if (!old && records.length >= 100) { toast('El historial está lleno. Exporta un respaldo y elimina una cotización para guardar otra.'); return; }
    const before = { records: [...records], sequence: { ...sequence }, activeId };
    const timestamp = now();
    const year = new Intl.DateTimeFormat('en', { year: 'numeric', timeZone: 'America/Mexico_City' }).format(new Date(timestamp));
    const nextNumber = Math.max(0, Number(sequence[year]) || 0, ...records.map(r => r.folio.startsWith('CL-' + year + '-') ? Number(r.folio.split('-').at(-1)) || 0 : 0)) + 1;
    const record = { id: old?.id || (crypto.randomUUID ? crypto.randomUUID() : String(Date.now()) + Math.random().toString(16).slice(2)), folio: old?.folio || `CL-${year}-${String(nextNumber).padStart(3, '0')}`, createdAt: old?.createdAt || timestamp, updatedAt: timestamp, job: { ...job }, machine: { ...activeMachine } };
    if (!old) sequence[year] = nextNumber;
    activeId = record.id;
    records = old ? records.map(r => r.id === old.id ? record : r) : [record, ...records];
    if (!persist()) { records = before.records; sequence = before.sequence; activeId = before.activeId; renderQuote(); return; }
    renderQuote(); renderHistory(); toast(`${record.folio} ${old ? 'actualizada' : 'guardada'} en este navegador.`);
  });
  function renderHistory() {
    $('history-count').textContent = String(records.length);
    const query = $('history-search').value.toLocaleLowerCase('es');
    const visible = records.filter(r => `${r.folio} ${r.job.title} ${r.job.client} ${materialName(r.job)}`.toLocaleLowerCase('es').includes(query)).sort((a, b) => Date.parse(b.updatedAt) - Date.parse(a.updatedAt));
    $('history-info').textContent = `${visible.length} ${visible.length === 1 ? 'cotización' : 'cotizaciones'}`;
    if (!visible.length) {
      $('history-list').innerHTML = `<div class="empty-history">${icon('file')}<h2>${query ? 'No se encontraron cotizaciones' : 'Aquí empieza tu próximo trabajo'}</h2><p>${query ? 'Prueba otro cliente, trabajo o folio.' : 'Guarda tu primera cotización para recuperarla y ajustarla después.'}</p></div>`;
      return;
    }
    $('history-list').innerHTML = '<table class="history-table"><thead><tr><th><span class="sr-only">Seleccionar</span></th><th>TRABAJO / CLIENTE</th><th class="hide-tablet">FECHA</th><th>TOTAL MXN</th><th><span class="sr-only">Acciones</span></th></tr></thead><tbody>' + visible.map(r => {
      const result = CpLaserMath.calculate(r.job, r.machine);
      return `<tr><td><input type="checkbox" data-history-check="${escape(r.id)}" aria-label="Seleccionar ${escape(r.folio)}" ${selectedHistory.has(r.id)?'checked':''}></td><td><strong>${escape(title(r.job))}</strong><small>${escape(r.folio)}${r.job.client ? ' · ' + escape(r.job.client) : ''}</small></td><td class="hide-tablet">${escape(dateLabel(r.updatedAt))}</td><td class="money">${result.valid ? escape(currency(result.total)) : 'Revisar datos'}</td><td><div class="row-actions"><button class="button edit" data-open="${escape(r.id)}">Editar</button><button class="button danger icon-button" data-delete="${escape(r.id)}" aria-label="Eliminar ${escape(r.folio)}">${icon('trash')}</button></div></td></tr>`;
    }).join('') + '</tbody></table>';
    syncHistorySelection();
  }
  $('history-search').addEventListener('input', () => {selectedHistory.clear();renderHistory();syncHistorySelection();});
  $('history-list').addEventListener('click', e => {
    const open = e.target.closest('[data-open]'), del = e.target.closest('[data-delete]');
    if (open) {
      const record = records.find(r => r.id === open.dataset.open); if (!record) return;
      openRecord(record); return;
    }
    if (del) {
      const record = records.find(r => r.id === del.dataset.delete); if (!record) return;
      confirmDelete('Borrar cálculo', `Se borrará ${record.folio} del historial de este navegador.`, () => deleteHistory([record.id]));
    }
  });

  function fillSettings() {
    const m = settings.machine, d = settings.defaults;
    const map = { power: m.power, bedWidth: m.width, bedHeight: m.height, defaultRate: d.rate, defaultProfit: d.profit, defaultProfitMode: d.profitMode, defaultMinimum: d.minimum, defaultWaste: d.waste, defaultTax: d.tax };
    for (const [key, value] of Object.entries(map)) settingsForm.elements[key].value = value;
    $('settings-error').textContent = '';
    settingsForm.elements.defaultProfit.max = d.profitMode === 'margin' ? '99.99' : '10000';
  }
  settingsForm.elements.defaultProfitMode.addEventListener('change', () => { settingsForm.elements.defaultProfit.max = settingsForm.elements.defaultProfitMode.value === 'margin' ? '99.99' : '10000'; });
  settingsForm.addEventListener('input', () => markSharedDirty());
  settingsForm.addEventListener('submit', e => {e.preventDefault(); saveShared();});

  function customerText() {
    const r = currentResult, record = records.find(x => x.id === activeId);
    return [ businessName.toLocaleUpperCase('es'), 'Cotización de corte y grabado láser', record ? record.folio : 'Borrador', '', title(), job.client ? `Cliente: ${job.client}` : '', `Material: ${materialName()}${Number(job.thickness) > 0 ? ' · ' + decimal(Number(job.thickness)) + ' mm' : ''}`, `Pieza: ${decimal(r.width)} × ${decimal(r.height)} cm`, `Cantidad: ${decimal(r.quantity)}`, job.supply === 'customer' ? 'Material proporcionado por el cliente.' : '', '', `Venta antes de descuento: ${currency(r.base)}`, `Descuento (${decimal(r.discountPercent)}%): ${currency(r.discount)}`, `Subtotal: ${currency(r.subtotal)}`, `Impuesto (${decimal(r.taxPercent)}%): ${currency(r.tax)}`, `TOTAL: ${currency(r.total)} MXN`, `Precio por pieza: ${currency(r.unit)} MXN`, job.notes ? '\nNotas: ' + job.notes : '' ].filter(Boolean).join('\n');
  }
  $('copy-quote').addEventListener('click', async () => {
    readForm(); renderQuote(); if (!currentResult.valid) return;
    const text = customerText();
    try {
      if (navigator.clipboard?.writeText) await navigator.clipboard.writeText(text);
      else {
        const el = document.createElement('textarea'); el.value = text; el.style.position = 'fixed'; el.style.top = '-9999px'; document.body.append(el); el.select();
        const copied = document.execCommand('copy'); el.remove(); if (!copied) throw new Error();
      }
      toast('Resumen para el cliente copiado.');
    } catch (_) { toast('No se pudo copiar. Usa Imprimir / PDF para obtener la cotización.'); }
  });
  function renderPrint() {
    if (!currentResult?.valid) { $('print-sheet').innerHTML = '<p>Completa los datos del cotizador para imprimir tu cotización.</p>'; return; }
    const r = currentResult, record = records.find(x => x.id === activeId);
    $('print-sheet').innerHTML = `<header class="print-header"><div class="print-brand">${escape(businessName)}<small>MÉXICO · CORTE Y GRABADO LÁSER</small></div><div class="print-meta"><strong>${escape(record?.folio || 'BORRADOR')}</strong>${escape(dateLabel(record?.createdAt || now()))}<br>Moneda: pesos mexicanos (MXN)</div></header><h1>Cotización</h1><div class="print-client"><span>PREPARADA PARA</span><h2>${escape(job.client.trim() || 'Cliente general')}</h2></div><table class="print-table"><thead><tr><th>DESCRIPCIÓN</th><th class="right">CANTIDAD</th><th class="right">IMPORTE</th></tr></thead><tbody><tr><td><strong>${escape(title())}</strong><small>${escape(materialName())}${Number(job.thickness) > 0 ? ' · ' + escape(decimal(Number(job.thickness))) + ' mm' : ''} · ${escape(decimal(r.width))} × ${escape(decimal(r.height))} cm por pieza<br>${job.supply === 'customer' ? 'Material proporcionado por el cliente.' : 'Incluye material.'}</small></td><td class="right">${escape(decimal(r.quantity))}</td><td class="right">${escape(currency(r.base))}</td></tr></tbody></table><div class="print-totals"><div><span>Venta antes de descuento</span><strong>${escape(currency(r.base))}</strong></div><div><span>Descuento (${escape(decimal(r.discountPercent))}%)</span><strong>−${escape(currency(r.discount))}</strong></div><div><span>Subtotal</span><strong>${escape(currency(r.subtotal))}</strong></div><div><span>Impuesto (${escape(decimal(r.taxPercent))}%)</span><strong>${escape(currency(r.tax))}</strong></div><div class="grand-total"><span>Total MXN</span><strong>${escape(currency(r.total))}</strong></div><div><span>Precio final por pieza</span><strong>${escape(currency(r.unit))} MXN</strong></div></div>${job.notes.trim() ? `<div class="print-notes"><strong>NOTAS Y ESPECIFICACIONES</strong>${escape(job.notes)}</div>` : ''}<footer class="print-footer"><span>${escape(businessName.toLocaleUpperCase('es'))}</span><span>Gracias por confiar en nuestro trabajo.</span></footer>`;
  }
  $('print-quote').addEventListener('click', () => {
    readForm(); renderQuote(); if (!currentResult.valid) return;
    renderPrint(); window.print();
  });
  window.addEventListener('beforeprint', renderPrint);

  function help() { $('help-dialog').showModal(); }
  $('help-button').addEventListener('click', help);
  $('settings-help').addEventListener('click', help);
  $('close-help').addEventListener('click', () => $('help-dialog').close());
  $('understood').addEventListener('click', () => $('help-dialog').close());
  $('help-dialog').addEventListener('click', e => { if (e.target === $('help-dialog')) { const rect = e.target.getBoundingClientRect(); if (e.clientX < rect.left || e.clientX > rect.right || e.clientY < rect.top || e.clientY > rect.bottom) e.target.close(); } });
  $('export-data').addEventListener('click', () => {
    readForm();
    const blob = new Blob([JSON.stringify({ ...snapshot(), exportedAt: now() }, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob), link = document.createElement('a');
    link.href = url; link.download = 'Colibri_Cotizador_Laser_Respaldo_' + now().slice(0, 10) + '.json';
    document.body.append(link); link.click(); link.remove(); setTimeout(() => URL.revokeObjectURL(url), 1000);
    toast('Respaldo preparado para descargar.');
  });
  $('import-data').addEventListener('change', async e => {
    const file = e.target.files[0]; if (!file) return;
    try {
      if (file.size > 5 * 1024 * 1024) throw new Error('El respaldo excede 5 MB.');
      const data = JSON.parse(await file.text());
      if (![1,2].includes(data.schema)) throw new Error('Este archivo no es un respaldo compatible del cotizador.');
      const checkedSettings = validateSettings(data.settings);
      const checkedRecords = validateRecords(data.records || []);
      const merged = new Map(records.map(r => [r.id, r]));
      checkedRecords.forEach(r => merged.set(r.id, r));
      if (merged.size > 100) throw new Error('La combinación excede 100 cotizaciones. Exporta tu historial y libera espacio antes de importar.');
      const importedCatalog = data.schema === 2 ? validateMaterials(data.catalog || []) : mergeLegacyMaterials(checkedSettings, materials);
      pendingImport = {settings:checkedSettings,materials:importedCatalog,records:[...merged.values()]};
      $('import-description').textContent = `Se combinarán ${checkedRecords.length} cálculos con tu historial local y se cargarán las tarifas y materiales del respaldo para revisión. Pulsa Guardar cambios para compartir las tarifas y el catálogo en SISACT. El borrador actual se conservará.`;
      $('import-dialog').showModal();
    } catch (error) { toast(error instanceof SyntaxError ? 'El archivo no contiene JSON válido.' : error.message); }
    e.target.value = '';
  });
  $('cancel-import').addEventListener('click', () => { pendingImport = null; $('import-dialog').close(); });
  $('confirm-import').addEventListener('click', () => {
    if (!pendingImport) return;
    const oldSettings=settings,oldRecords=records,oldMaterials=materials;
    settings=pendingImport.settings;records=pendingImport.records;materials=pendingImport.materials;
    if(!persist()){settings=oldSettings;records=oldRecords;materials=oldMaterials;return;}
    pendingImport=null;$('import-dialog').close();fillSettings();renderMaterials();renderMaterialChoice();renderHistory();renderQuote();markSharedDirty();toast('Respaldo cargado para revisión. Guarda los cambios para compartir el catálogo en SISACT.');
  });
  window.addEventListener('pagehide', () => { if (saveTimer) persist(); });

  function renderMaterialChoice() {
    if (!job.materialId) job.materialId = materials.find(m => m.name.toLocaleLowerCase('es') === materialName(job).toLocaleLowerCase('es') && m.thickness === Number(job.thickness))?.id || 'custom';
    const found=materials.some(m=>m.id===job.materialId);
    $('material-choice').innerHTML = materials.map(m=>`<option value="${escape(m.id)}">${escape(m.name)} · ${escape(String(m.thickness))} mm${m.sheetPrice==null?' · costo pendiente':''}</option>`).join('') + (!found && job.materialId!=='custom' ? `<option value="${escape(job.materialId)}">${escape(materialName(job))} · ${escape(job.thickness)} mm · cálculo guardado</option>`:'') + '<option value="custom">Material a medida / fuera del catálogo</option>';
    $('material-choice').value=job.materialId;
    const m=materials.find(row=>row.id===job.materialId);
    $('material-selection-note').textContent = m ? (m.sheetPrice==null||m.sheetWidth==null||m.sheetHeight==null ? 'Completa el tamaño y costo de esta hoja en Materiales o ajusta los datos de este cálculo.' : `Hoja ${decimal(m.sheetWidth)} × ${decimal(m.sheetHeight)} cm · ${currency(m.sheetPrice)} · costo del catálogo de SISACT.`) : 'Los datos del material de este cálculo se conservan. Puedes seleccionar otro registro del catálogo.';
  }
  function captureSettings() {
    const data=Object.fromEntries(new FormData(settingsForm));
    return validateSettings({machine:{width:data.bedWidth,height:data.bedHeight,power:data.power},defaults:{rate:data.defaultRate,profitMode:data.defaultProfitMode,profit:data.defaultProfit,minimum:data.defaultMinimum,waste:data.defaultWaste,tax:data.defaultTax}});
  }
  function syncSharedStatus() {
    $('shared-state').textContent = boot.error || (sharedBusy ? 'Guardando en SISACT…' : sharedDirty ? 'Hay cambios por guardar' : boot.exists ? 'Catálogo y tarifas guardados en SISACT' : 'Configura tus tarifas y costos');
    for (const id of ['shared-save','material-save']) $(id).disabled=sharedBusy || !sharedDirty;
    for (const el of settingsForm.querySelectorAll('input,select,button')) el.disabled=sharedBusy;
    for (const id of ['material-new','material-reload']) $(id).disabled=sharedBusy;
    for (const el of $('material-list').querySelectorAll('input,button')) el.disabled=sharedBusy;
    $('material-select-all').disabled=sharedBusy;
    $('material-edit').disabled=sharedBusy||selectedMaterials.size!==1;
    $('material-delete').disabled=sharedBusy||!selectedMaterials.size;
    root.classList.toggle('shared-unsaved',sharedDirty);
    $('migrate-v1').hidden=!legacySettings;
    $('material-count').textContent=materials.length;
  }
  function markSharedDirty() {sharedDirty=true;syncSharedStatus();}
  async function saveShared() {
    if(sharedBusy)return;
    try {
      const proposed=captureSettings(), catalog=validateMaterials(materials);
      sharedBusy=true;syncSharedStatus();
      const payload=new URLSearchParams({action:'save_configuration',_csrf:boot.csrf,payload:JSON.stringify({version:sharedVersion,state:{schema:2,machine:proposed.machine,defaults:proposed.defaults,materials:catalog}})});
      const response=await fetch('/admin/cotizador_laser.php?api=1',{method:'POST',credentials:'same-origin',body:payload});
      if(!response.headers.get('content-type')?.includes('application/json'))throw new Error('Tu sesión expiró. Vuelve a iniciar sesión en SISACT.');
      const data=await response.json();if(!response.ok||!data.ok)throw new Error(data.message||'No se pudo guardar el catálogo.');
      settings=validateSettings(data.state);materials=validateMaterials(data.state.materials);sharedVersion=data.version;boot.error='';boot.exists=true;sharedDirty=false;
      if(usingLegacy){legacySettings=null;usingLegacy=false;}
      if(!activeId){activeMachine={...settings.machine};for(const key of ['rate','profit','minimum','waste','tax'])if(job[key]==='')job[key]=settings.defaults[key];if(job.profit===settings.defaults.profit)job.profitMode=settings.defaults.profitMode;const profile=materials.find(m=>m.id===job.materialId);if(profile)for(const key of PROFILE_FIELDS)if(job[key]===''&&profile[key]!=null)job[key]=String(profile[key]);}
      fillForm();fillSettings();renderMaterials();renderQuote();persist();toast('Catálogo y tarifas guardados en SISACT.');
    } catch(error){$('settings-error').textContent=error.message;toast(error.message);}
    finally{sharedBusy=false;syncSharedStatus();}
  }
  function showMaterialForm(id) {
    if(sharedBusy)return;
    const row=materials.find(m=>m.id===id)||{id:'',name:'',thickness:'',sheetWidth:'',sheetHeight:'',sheetPrice:''};
    const f=$('material-form');for(const key of ['id','name','thickness','sheetWidth','sheetHeight','sheetPrice'])f.elements[key].value=row[key]??'';
    $('material-dialog-title').textContent=row.id?'Editar material':'Nuevo material';$('material-error').textContent='';$('material-dialog').showModal();f.elements.name.focus();
  }
  function visibleMaterials(){const term=$('material-search').value.toLocaleLowerCase('es');return materials.filter(m=>(m.name+' '+m.thickness+' mm').toLocaleLowerCase('es').includes(term));}
  function renderMaterials(){
    const visible=visibleMaterials();$('material-info').textContent=`${visible.length} registros`;
    $('material-list').innerHTML=visible.length?'<table class="material-table"><thead><tr><th><span class="sr-only">Seleccionar</span></th><th>Material</th><th>Espesor</th><th>Hoja (cm)</th><th>Costo de hoja</th><th>Acciones</th></tr></thead><tbody>'+visible.map(m=>`<tr><td><input type="checkbox" data-material-check="${escape(m.id)}" aria-label="Seleccionar ${escape(m.name)} ${escape(m.thickness)} mm" ${selectedMaterials.has(m.id)?'checked':''}></td><td><strong>${escape(m.name)}</strong></td><td><span class="thickness-pill">${escape(m.thickness)} mm</span></td><td>${m.sheetWidth==null||m.sheetHeight==null?'<span class="pending-text">Pendiente</span>':escape(decimal(m.sheetWidth)+' × '+decimal(m.sheetHeight))}</td><td>${m.sheetPrice==null?'<span class="pending-text">Sin costo</span>':escape(currency(m.sheetPrice))}</td><td><div class="row-actions"><button class="button edit" type="button" data-material-edit="${escape(m.id)}">Editar</button><button class="button danger icon-button" type="button" data-material-delete="${escape(m.id)}" aria-label="Borrar ${escape(m.name)} ${escape(m.thickness)} mm">${icon('trash')}</button></div></td></tr>`).join('')+'</tbody></table>':'<div class="empty-history"><h2>No hay materiales en esta vista</h2><p>Agrega un material nuevo o cambia la búsqueda.</p></div>';
    syncMaterialSelection();syncSharedStatus();
  }
  function syncMaterialSelection(){
    const ids=new Set(materials.map(m=>m.id));for(const id of selectedMaterials)if(!ids.has(id))selectedMaterials.delete(id);
    $('material-selected').textContent=`${selectedMaterials.size} seleccionados`;$('material-edit').disabled=selectedMaterials.size!==1||sharedBusy;$('material-delete').disabled=!selectedMaterials.size||sharedBusy;
    const visible=visibleMaterials(),checked=visible.filter(m=>selectedMaterials.has(m.id)).length;$('material-select-all').checked=!!visible.length&&checked===visible.length;$('material-select-all').indeterminate=checked>0&&checked<visible.length;
  }
  function confirmDelete(title,text,action){$('confirm-title').textContent=title;$('confirm-text').textContent=text;confirmAction=action;$('confirm-dialog').showModal();}
  function deleteMaterials(ids){if(sharedBusy)return;materials=materials.filter(m=>!ids.includes(m.id));ids.forEach(id=>selectedMaterials.delete(id));markSharedDirty();renderMaterials();renderMaterialChoice();toast('Materiales retirados del borrador. Pulsa Guardar cambios para aplicar.');}
  $('material-form').addEventListener('submit',e=>{e.preventDefault();if(sharedBusy)return;try{const value=Object.fromEntries(new FormData(e.target));if(!value.id)value.id='mat-'+(crypto.randomUUID?crypto.randomUUID():Date.now().toString(36)+Math.random().toString(36).slice(2));const row=validateMaterials([value])[0];const next=materials.some(m=>m.id===row.id)?materials.map(m=>m.id===row.id?row:m):[...materials,row];materials=validateMaterials(next);$('material-dialog').close();markSharedDirty();renderMaterials();renderMaterialChoice();toast('Material aplicado al catálogo. Guarda los cambios para compartirlo.');}catch(error){$('material-error').textContent=error.message;}});
  for(const id of ['material-close','material-cancel'])$(id).addEventListener('click',()=>$('material-dialog').close());
  $('material-new').addEventListener('click',()=>showMaterialForm());
  $('material-edit').addEventListener('click',()=>{if(selectedMaterials.size===1)showMaterialForm([...selectedMaterials][0]);});
  $('material-delete').addEventListener('click',()=>{const ids=[...selectedMaterials];if(ids.length)confirmDelete('Borrar materiales',`Se retirarán ${ids.length} registros del catálogo al guardar los cambios. Los cálculos guardados conservarán sus datos.`,()=>deleteMaterials(ids));});
  $('material-list').addEventListener('click',e=>{const edit=e.target.closest('[data-material-edit]'),del=e.target.closest('[data-material-delete]');if(edit)showMaterialForm(edit.dataset.materialEdit);if(del){const id=del.dataset.materialDelete;confirmDelete('Borrar material','Se retirará este material del catálogo al guardar los cambios.',()=>deleteMaterials([id]));}});
  $('material-list').addEventListener('change',e=>{const id=e.target.dataset.materialCheck;if(!id)return;if(e.target.checked)selectedMaterials.add(id);else selectedMaterials.delete(id);syncMaterialSelection();});
  $('material-select-all').addEventListener('change',e=>{visibleMaterials().forEach(m=>e.target.checked?selectedMaterials.add(m.id):selectedMaterials.delete(m.id));renderMaterials();});
  $('material-search').addEventListener('input',()=>{selectedMaterials.clear();renderMaterials();});
  for(const id of ['shared-save','material-save'])$(id).addEventListener('click',saveShared);
  $('material-reload').addEventListener('click',()=>{const reload=async()=>{if(sharedBusy)return;try{const r=await fetch('/admin/cotizador_laser.php?api=1',{credentials:'same-origin',cache:'no-store'});const data=await r.json();if(!r.ok||!data.ok)throw new Error(data.message||'No se pudo recargar.');settings=validateSettings(data.state);materials=validateMaterials(data.state.materials);sharedVersion=data.version;boot.error='';boot.exists=data.exists;sharedDirty=false;selectedMaterials.clear();fillSettings();renderMaterials();renderMaterialChoice();syncSharedStatus();toast('Catálogo actualizado desde SISACT.');}catch(error){toast(error.message);}};if(sharedDirty)confirmDelete('Recargar catálogo','Se descartarán los cambios de catálogo y tarifas que aún no guardaste.',reload);else reload();});
  $('confirm-cancel').addEventListener('click',()=>{confirmAction=null;$('confirm-dialog').close();});
  $('confirm-ok').addEventListener('click',()=>{const action=confirmAction;confirmAction=null;$('confirm-dialog').close();if(action)action();});
  function mergeLegacyMaterials(legacy,base){const next=base.map(m=>({...m}));for(const name of MATERIALS){const p=legacy.profiles[name];if(!p||!Number(p.thickness))continue;if(!p.sheetWidth&&!p.sheetHeight&&!p.sheetPrice)continue;const old=next.find(m=>m.name.toLocaleLowerCase('es')===name.toLocaleLowerCase('es')&&m.thickness===Number(p.thickness));const row={id:old?.id||'legacy-'+name.normalize('NFD').replace(/[\u0300-\u036f]/g,'').toLowerCase()+'-'+String(p.thickness).replace('.','_'),name,thickness:p.thickness,sheetWidth:p.sheetWidth,sheetHeight:p.sheetHeight,sheetPrice:p.sheetPrice};if(old)Object.assign(old,row);else next.push(row);}return validateMaterials(next);}
  $('migrate-v1').addEventListener('click',()=>{if(!legacySettings)return;try{materials=mergeLegacyMaterials(legacySettings,materials);settings=validateSettings(legacySettings);usingLegacy=true;markSharedDirty();fillSettings();renderMaterials();showPage('materials');toast('Tarifas V1 cargadas para revisión. Guarda los cambios para compartirlas en SISACT.');}catch(error){toast(error.message);}});
  function openRecord(record){job={...record.job};activeMachine={...record.machine};activeId=record.id;hasInteracted=true;touched.clear();fillForm();renderQuote();persist();showPage('quote');}
  function syncHistorySelection(){const ids=new Set(records.map(r=>r.id));for(const id of selectedHistory)if(!ids.has(id))selectedHistory.delete(id);$('history-selected').textContent=`${selectedHistory.size} seleccionados`;$('history-edit').disabled=selectedHistory.size!==1;$('history-delete').disabled=!selectedHistory.size;const checkboxes=[...$('history-list').querySelectorAll('[data-history-check]')],count=checkboxes.filter(c=>selectedHistory.has(c.dataset.historyCheck)).length;$('history-select-all').checked=!!checkboxes.length&&count===checkboxes.length;$('history-select-all').indeterminate=count>0&&count<checkboxes.length;}
  function deleteHistory(ids){const old=records,oldId=activeId;records=records.filter(r=>!ids.includes(r.id));if(ids.includes(activeId))activeId=null;if(!persist()){records=old;activeId=oldId;return;}ids.forEach(id=>selectedHistory.delete(id));renderHistory();syncHistorySelection();renderQuote();toast('Cálculos borrados del historial local.');}
  $('history-list').addEventListener('change',e=>{const id=e.target.dataset.historyCheck;if(!id)return;e.target.checked?selectedHistory.add(id):selectedHistory.delete(id);syncHistorySelection();});
  $('history-select-all').addEventListener('change',e=>{for(const c of $('history-list').querySelectorAll('[data-history-check]'))e.target.checked?selectedHistory.add(c.dataset.historyCheck):selectedHistory.delete(c.dataset.historyCheck);renderHistory();syncHistorySelection();});
  $('history-edit').addEventListener('click',()=>{const r=records.find(r=>selectedHistory.has(r.id));if(r&&selectedHistory.size===1)openRecord(r);});
  $('history-delete').addEventListener('click',()=>{const ids=[...selectedHistory];if(ids.length)confirmDelete('Borrar cálculos',`Se borrarán ${ids.length} cálculos de este navegador. Las cotizaciones formales de SISACT se conservan.`,()=>deleteHistory(ids));});
  $('quick-save').addEventListener('click',()=>$('save-quote').click());
  for(const id of ['use-result','quick-use'])$(id).addEventListener('click',()=>{readForm();renderQuote();if(!currentResult.valid)return;persist();$('use-result-payload').value=JSON.stringify({job,machine:activeMachine});$('use-result-form').submit();});
  $('manage-materials').addEventListener('click',()=>showPage('materials'));
  window.addEventListener('beforeunload',e=>{if(sharedDirty||sharedBusy){e.preventDefault();e.returnValue='';}});
  fillForm(); fillSettings(); renderQuote(); renderHistory(); renderMaterials(); syncHistorySelection();syncSharedStatus();
  if (location.hash === '#tarifas') showPage('settings');
  else if (location.hash === '#materiales') showPage('materials');
  else if (location.hash === '#historial') showPage('history');
  if (storageProblem) toast('No se pudieron recuperar los datos guardados. Importa un respaldo si lo tienes.');
  if(boot.error)toast(boot.error);
})();
