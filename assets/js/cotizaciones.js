(function () {
    'use strict';

    function money(value) {
        return '$' + Number(value || 0).toLocaleString('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    }

    function value(id) {
        var el = document.getElementById(id);
        return el ? parseFloat(el.value) || 0 : 0;
    }

    function recalc() {
        var qty = Math.max(0.001, value('quoteQty'));
        var price = Math.max(0, value('quotePrice'));
        var discount = Math.max(0, value('quoteDiscount'));
        var taxPct = Math.max(0, Math.min(100, value('quoteTaxPct')));

        var subtotal = Math.round((qty * price + Number.EPSILON) * 100) / 100;
        discount = Math.min(discount, subtotal);
        var base = Math.max(0, subtotal - discount);
        var tax = Math.round((base * taxPct / 100 + Number.EPSILON) * 100) / 100;
        var total = Math.round((base + tax + Number.EPSILON) * 100) / 100;

        var fields = {
            liveSubtotal: money(subtotal),
            liveDiscount: money(discount),
            liveTax: money(tax),
            liveTotal: money(total)
        };

        Object.keys(fields).forEach(function (id) {
            var el = document.getElementById(id);
            if (el) el.textContent = fields[id];
        });

        var taxHint = document.getElementById('liveTaxHint');
        if (taxHint) taxHint.textContent = taxPct.toFixed(2) + '%';
    }

    document.addEventListener('input', function (event) {
        if (event.target && event.target.matches('#quoteQty,#quotePrice,#quoteDiscount,#quoteTaxPct')) {
            recalc();
        }
    });

    document.addEventListener('change', function (event) {
        if (event.target && event.target.matches('#quoteQty,#quotePrice,#quoteDiscount,#quoteTaxPct')) {
            recalc();
        }
    });

    document.addEventListener('DOMContentLoaded', recalc);
})();

(function () {
    'use strict';

    var search = document.getElementById('customerSearch');
    var results = document.getElementById('customerResults');
    var hidden = document.getElementById('customerId');
    var selected = document.getElementById('selectedCustomer');
    var clear = document.getElementById('customerClear');
    var timer = null;

    if (!search || !results || !hidden) return;

    function escapeHtml(value) {
        return String(value || '').replace(/[&<>'"]/g, function (ch) {
            return {'&':'&amp;','<':'&lt;','>':'&gt;',"'":'&#039;','"':'&quot;'}[ch];
        });
    }

    function render(list) {
        if (!list.length) {
            results.innerHTML = '<div class="customer-result-empty">No se encontró un cliente activo.</div>';
            results.hidden = false;
            return;
        }
        results.innerHTML = list.map(function (c) {
            var extra = [c.email, c.phone, c.tax_number].filter(Boolean).join(' · ');
            return '<button type="button" class="customer-result" data-id="' + Number(c.id) + '" data-name="' + escapeHtml(c.name) + '" data-extra="' + escapeHtml(extra) + '">' +
                '<strong>' + escapeHtml(c.name) + '</strong><small>' + escapeHtml(extra || [c.city, c.state].filter(Boolean).join(', ')) + '</small></button>';
        }).join('');
        results.hidden = false;
    }

    function searchCustomers() {
        var q = search.value.trim();
        if (q.length < 2) { results.hidden = true; results.innerHTML = ''; return; }
        fetch('/admin/cotizacion_nueva.php?customer_search=1&q=' + encodeURIComponent(q), {credentials:'same-origin', headers:{'Accept':'application/json'}})
            .then(function (response) { if (!response.ok) throw new Error('search'); return response.json(); })
            .then(render)
            .catch(function () { results.innerHTML = '<div class="customer-result-empty">No se pudo buscar. Puedes crear el cliente desde el botón.</div>'; results.hidden = false; });
    }

    search.addEventListener('input', function () {
        hidden.value = '0';
        if (selected) selected.hidden = true;
        clearTimeout(timer);
        timer = setTimeout(searchCustomers, 220);
    });

    results.addEventListener('click', function (event) {
        var btn = event.target.closest('.customer-result');
        if (!btn) return;
        hidden.value = btn.dataset.id || '0';
        search.value = btn.dataset.name || '';
        if (selected) {
            selected.hidden = false;
            selected.innerHTML = '<strong>' + escapeHtml(btn.dataset.name) + '</strong><span>' + escapeHtml(btn.dataset.extra || '') + '</span><button type="button" class="customer-clear" id="customerClear">Cambiar</button>';
            clear = document.getElementById('customerClear');
            bindClear();
        }
        results.hidden = true;
    });

    function bindClear() {
        if (!clear) return;
        clear.onclick = function () {
            hidden.value = '0';
            search.value = '';
            if (selected) { selected.hidden = true; selected.innerHTML = ''; }
            results.hidden = true;
            search.focus();
        };
    }
    bindClear();
})();
