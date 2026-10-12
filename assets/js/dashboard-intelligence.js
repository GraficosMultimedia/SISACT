(() => {
    'use strict';

    const target = document.getElementById('di-cash-chart');
    const dataNode = document.getElementById('di-chart-data');
    if (!target || !dataNode) return;

    let payload;
    try {
        payload = JSON.parse(dataNode.textContent || '{}');
    } catch (_) {
        return;
    }

    const rows = Array.isArray(payload.rows) ? payload.rows : [];
    const expensesEnabled = Boolean(payload.expensesEnabled);

    function money(value) {
        return new Intl.NumberFormat('es-MX', {
            style: 'currency',
            currency: 'MXN',
            maximumFractionDigits: 0
        }).format(Number(value || 0));
    }

    function compact(value) {
        const n = Number(value || 0);
        if (Math.abs(n) >= 1000000) return (n / 1000000).toFixed(1).replace('.0','') + 'M';
        if (Math.abs(n) >= 1000) return (n / 1000).toFixed(0) + 'k';
        return Math.round(n).toString();
    }

    function svgEl(name, attrs = {}) {
        const el = document.createElementNS('http://www.w3.org/2000/svg', name);
        Object.entries(attrs).forEach(([key, value]) => el.setAttribute(key, String(value)));
        return el;
    }

    function render() {
        target.innerHTML = '';

        if (!rows.length) {
            const empty = document.createElement('div');
            empty.className = 'di-chart-empty';
            empty.textContent = 'No hay movimientos para el periodo seleccionado.';
            target.appendChild(empty);
            return;
        }

        const width = Math.max(560, target.clientWidth || 760);
        const height = target.clientWidth < 600 ? 270 : 320;
        const pad = { left: 58, right: 18, top: 20, bottom: 42 };
        const innerW = width - pad.left - pad.right;
        const innerH = height - pad.top - pad.bottom;

        const series = [
            { key: 'sales', cls: 'sales', label: 'Ventas' },
            { key: 'income', cls: 'income', label: 'Ingresos' },
        ];
        if (expensesEnabled) {
            series.push({ key: 'expense', cls: 'expense', label: 'Egresos' });
        }

        let max = 0;
        rows.forEach(row => {
            series.forEach(s => {
                max = Math.max(max, Number(row[s.key] || 0));
            });
        });
        if (max <= 0) max = 1;
        max *= 1.12;

        const x = i => rows.length === 1
            ? pad.left + innerW / 2
            : pad.left + (i / (rows.length - 1)) * innerW;
        const y = value => pad.top + innerH - (Number(value || 0) / max) * innerH;

        const svg = svgEl('svg', {
            viewBox: `0 0 ${width} ${height}`,
            role: 'img',
            'aria-label': 'Tendencia financiera'
        });

        for (let i = 0; i <= 4; i++) {
            const gy = pad.top + (i / 4) * innerH;
            const value = max - (i / 4) * max;

            svg.appendChild(svgEl('line', {
                x1: pad.left,
                y1: gy,
                x2: width - pad.right,
                y2: gy,
                class: 'di-chart-grid'
            }));

            const label = svgEl('text', {
                x: pad.left - 8,
                y: gy + 4,
                'text-anchor': 'end',
                class: 'di-chart-axis-label'
            });
            label.textContent = compact(value);
            svg.appendChild(label);
        }

        const labelEvery = Math.max(1, Math.ceil(rows.length / 7));
        rows.forEach((row, i) => {
            if (i % labelEvery !== 0 && i !== rows.length - 1) return;
            const t = svgEl('text', {
                x: x(i),
                y: height - 13,
                'text-anchor': i === 0 ? 'start' : (i === rows.length - 1 ? 'end' : 'middle'),
                class: 'di-chart-axis-label'
            });
            t.textContent = String(row.label || '');
            svg.appendChild(t);
        });

        series.forEach(s => {
            const points = rows.map((row, i) => `${x(i)},${y(row[s.key])}`).join(' ');

            const polyline = svgEl('polyline', {
                points,
                class: `di-chart-path ${s.cls}`
            });
            svg.appendChild(polyline);

            rows.forEach((row, i) => {
                if (rows.length > 40 && i % 2 !== 0) return;

                const circle = svgEl('circle', {
                    cx: x(i),
                    cy: y(row[s.key]),
                    r: rows.length > 25 ? 2.2 : 3.2,
                    class: `di-chart-point ${s.cls}`
                });

                const title = svgEl('title');
                title.textContent = `${row.label} · ${s.label}: ${money(row[s.key])}`;
                circle.appendChild(title);
                svg.appendChild(circle);
            });
        });

        target.appendChild(svg);
    }

    render();

    let resizeTimer = null;
    window.addEventListener('resize', () => {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(render, 120);
    }, { passive: true });
})();
/* ============================================================
   Tracking Activity V1 · Dashboard Intelligence
   ============================================================ */
(() => {
    'use strict';

    const ENDPOINT = '/admin/tracking_activity_feed.php';
    const CSS_HREF = '/assets/css/tracking-activity-dashboard-v1.css?v=1.0.0';
    const POLL_MS = 30000;

    let lastObservedId = null;
    let csrfToken = '';
    let latestEventId = 0;
    let timer = null;

    function loadCss() {
        if (document.querySelector('link[data-tracking-activity-css]')) return;
        const link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = CSS_HREF;
        link.dataset.trackingActivityCss = '1';
        document.head.appendChild(link);
    }

    function escapeHtml(value) {
        return String(value ?? '')
            .replaceAll('&', '&amp;')
            .replaceAll('<', '&lt;')
            .replaceAll('>', '&gt;')
            .replaceAll('"', '&quot;')
            .replaceAll("'", '&#039;');
    }

    function formatWhen(iso) {
        if (!iso) return '';
        const date = new Date(iso);
        if (Number.isNaN(date.getTime())) return '';

        const diff = Math.max(0, Date.now() - date.getTime());
        const sec = Math.floor(diff / 1000);
        if (sec < 60) return 'ahora';
        const min = Math.floor(sec / 60);
        if (min < 60) return `hace ${min} min`;
        const hr = Math.floor(min / 60);
        if (hr < 24) return `hace ${hr} h`;

        return new Intl.DateTimeFormat('es-MX', {
            day: '2-digit',
            month: 'short',
            hour: '2-digit',
            minute: '2-digit'
        }).format(date);
    }

    function detailText(event) {
        const parts = [];
        if (event.order_number) parts.push(event.order_number);
        if (event.invoice_number &&
            (event.event_type === 'cfdi_pdf_opened' || event.event_type === 'cfdi_xml_downloaded')) {
            parts.push(`Factura ${event.invoice_number}`);
        }
        if (event.device_type && event.device_type !== 'unknown') {
            const labels = { mobile:'Móvil', tablet:'Tablet', desktop:'PC' };
            parts.push(labels[event.device_type] || event.device_type);
        }
        return parts.join(' · ');
    }

    function findAlertList() {
        const heads = Array.from(document.querySelectorAll('.di-section-head h3'));
        const title = heads.find(el => el.textContent.trim() === 'Centro de alertas');
        if (!title) return null;
        const card = title.closest('.di-card');
        return card?.querySelector('.di-alert-list') || null;
    }

    function ensurePanel() {
        const alertList = findAlertList();
        if (!alertList) return null;

        let panel = document.getElementById('taDashboardPanel');
        if (panel) return panel;

        panel = document.createElement('section');
        panel.id = 'taDashboardPanel';
        panel.className = 'ta-dashboard-panel';
        panel.innerHTML = `
            <div class="ta-head">
                <div>
                    <span>ACTIVIDAD DE CLIENTES</span>
                    <strong>Seguimiento y CFDI</strong>
                </div>
                <div class="ta-head-actions">
                    <b id="taUnreadBadge" hidden>0 nuevas</b>
                    <button type="button" id="taMarkRead">Marcar revisado</button>
                </div>
            </div>
            <div class="ta-list" id="taActivityList">
                <div class="ta-empty">Cargando actividad…</div>
            </div>
        `;

        alertList.prepend(panel);

        panel.querySelector('#taMarkRead')?.addEventListener('click', markRead);
        return panel;
    }

    function render(data) {
        const panel = ensurePanel();
        if (!panel) return;

        csrfToken = data.csrf || csrfToken;
        latestEventId = Number(data.latest_event_id || 0);

        const badge = panel.querySelector('#taUnreadBadge');
        const button = panel.querySelector('#taMarkRead');
        const list = panel.querySelector('#taActivityList');

        if (!data.ready) {
            if (badge) badge.hidden = true;
            if (button) button.hidden = true;
            if (list) {
                list.innerHTML = '<div class="ta-empty">Activa la migración de Tracking Activity para comenzar a registrar visitas.</div>';
            }
            return;
        }

        const unread = Number(data.unread || 0);
        if (badge) {
            badge.hidden = unread <= 0;
            badge.textContent = `${unread} ${unread === 1 ? 'nueva' : 'nuevas'}`;
        }
        if (button) button.hidden = unread <= 0;

        const events = Array.isArray(data.events) ? data.events : [];
        if (!list) return;

        if (!events.length) {
            list.innerHTML = '<div class="ta-empty">Todavía no hay actividad de clientes registrada.</div>';
            return;
        }

        list.innerHTML = events.slice(0, 8).map(event => {
            const customer = escapeHtml(event.customer_name || 'Cliente');
            const label = escapeHtml(event.label || 'Actividad');
            const icon = escapeHtml(event.icon || '•');
            const detail = escapeHtml(detailText(event));
            const when = escapeHtml(formatWhen(event.created_at_iso));
            const href = `/admin/orden.php?id=${encodeURIComponent(event.order_id)}`;

            return `
                <a class="ta-event" href="${href}">
                    <span class="ta-icon">${icon}</span>
                    <span class="ta-event-body">
                        <strong>${customer}</strong>
                        <span>${label}</span>
                        <small>${detail}${detail && when ? ' · ' : ''}${when}</small>
                    </span>
                    <b>→</b>
                </a>
            `;
        }).join('');
    }

    function showToast(event) {
        let stack = document.getElementById('taToastStack');
        if (!stack) {
            stack = document.createElement('div');
            stack.id = 'taToastStack';
            stack.className = 'ta-toast-stack';
            document.body.appendChild(stack);
        }

        const toast = document.createElement('a');
        toast.className = 'ta-toast';
        toast.href = `/admin/orden.php?id=${encodeURIComponent(event.order_id)}`;
        toast.innerHTML = `
            <span class="ta-toast-icon">${escapeHtml(event.icon || '•')}</span>
            <span>
                <strong>${escapeHtml(event.customer_name || 'Cliente')}</strong>
                <b>${escapeHtml(event.label || 'Actividad')}</b>
                <small>${escapeHtml(detailText(event))}</small>
            </span>
        `;
        stack.appendChild(toast);

        window.setTimeout(() => {
            toast.classList.add('is-leaving');
            window.setTimeout(() => toast.remove(), 350);
        }, 7000);
    }

    function notifyNew(data) {
        const currentLatest = Number(data.latest_event_id || 0);
        const events = Array.isArray(data.events) ? data.events : [];

        if (lastObservedId === null) {
            lastObservedId = currentLatest;
            return;
        }

        if (currentLatest <= lastObservedId) return;

        const newer = events
            .filter(event => Number(event.id || 0) > lastObservedId)
            .sort((a,b) => Number(a.id) - Number(b.id))
            .slice(-3);

        newer.forEach(showToast);
        lastObservedId = currentLatest;
    }

    async function fetchFeed() {
        if (document.hidden) return;

        try {
            const response = await fetch(`${ENDPOINT}?limit=10&_=${Date.now()}`, {
                credentials: 'same-origin',
                cache: 'no-store',
                headers: { 'Accept': 'application/json' }
            });
            if (!response.ok) return;

            const data = await response.json();
            if (!data || data.ok !== true) return;

            notifyNew(data);
            render(data);
        } catch (_) {
            // El dashboard financiero sigue operativo aunque falle este feed.
        }
    }

    async function markRead() {
        if (!csrfToken || latestEventId <= 0) return;

        const body = new URLSearchParams();
        body.set('action', 'mark_read');
        body.set('_csrf', csrfToken);
        body.set('last_event_id', String(latestEventId));

        try {
            const response = await fetch(ENDPOINT, {
                method: 'POST',
                credentials: 'same-origin',
                cache: 'no-store',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                },
                body: body.toString()
            });
            if (response.ok) await fetchFeed();
        } catch (_) {}
    }

    loadCss();
    ensurePanel();
    fetchFeed();

    timer = window.setInterval(fetchFeed, POLL_MS);

    document.addEventListener('visibilitychange', () => {
        if (!document.hidden) fetchFeed();
    });

    window.addEventListener('beforeunload', () => {
        if (timer) window.clearInterval(timer);
    }, { once: true });
})();
