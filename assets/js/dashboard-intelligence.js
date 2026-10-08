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
