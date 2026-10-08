(() => {
  const form = document.getElementById('orderEditForm');
  const items = document.getElementById('oeItems');
  const add = document.getElementById('oeAddItem');
  const template = document.getElementById('oeItemTemplate');
  const total = document.getElementById('oeTotal');
  const mobileTotal = document.getElementById('oeMobileTotal');
  if (!form || !items) return;

  const money = new Intl.NumberFormat('es-MX', {
    style: 'currency',
    currency: 'MXN',
    minimumFractionDigits: 2
  });

  function numeric(value) {
    const n = Number.parseFloat(String(value || '').replace(/,/g, ''));
    return Number.isFinite(n) ? n : 0;
  }

  function renumber() {
    items.querySelectorAll('[data-oe-item]').forEach((row, index) => {
      const target = row.querySelector('[data-oe-number]');
      if (target) target.textContent = String(index + 1);
    });
  }

  function recalc() {
    let sum = 0;
    items.querySelectorAll('[data-oe-item]').forEach(row => {
      const qty = numeric(row.querySelector('[data-oe-qty]')?.value);
      const price = numeric(row.querySelector('[data-oe-price]')?.value);
      const subtotal = Math.round((qty * price + Number.EPSILON) * 100) / 100;
      sum += subtotal;
      const target = row.querySelector('[data-oe-subtotal]');
      if (target) target.textContent = money.format(subtotal);
    });
    sum = Math.round((sum + Number.EPSILON) * 100) / 100;
    if (total) total.textContent = money.format(sum);
    if (mobileTotal) mobileTotal.textContent = money.format(sum);
  }

  items.addEventListener('input', event => {
    if (event.target.matches('[data-oe-qty],[data-oe-price]')) recalc();
  });

  items.addEventListener('click', event => {
    const button = event.target.closest('[data-oe-remove]');
    if (!button) return;
    const rows = items.querySelectorAll('[data-oe-item]');
    if (rows.length <= 1) {
      alert('La orden debe conservar al menos un concepto.');
      return;
    }
    button.closest('[data-oe-item]')?.remove();
    renumber();
    recalc();
  });

  add?.addEventListener('click', () => {
    const node = template?.content?.firstElementChild?.cloneNode(true);
    if (!node) return;
    items.appendChild(node);
    renumber();
    recalc();
    node.querySelector('textarea[name="description[]"]')?.focus();
  });

  form.addEventListener('submit', event => {
    if (!items.querySelector('[data-oe-item]')) {
      event.preventDefault();
      alert('Agrega al menos un concepto.');
      return;
    }
    const buttons = form.querySelectorAll('button[type="submit"]');
    buttons.forEach(button => {
      button.disabled = true;
      button.textContent = 'Guardando…';
    });
  });

  renumber();
  recalc();
})();
