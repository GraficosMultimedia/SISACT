(() => {
    'use strict';

    const mobile = window.matchMedia('(max-width: 820px)');
    const sections = Array.from(document.querySelectorAll('[data-qe-section]'));
    const summary = document.getElementById('qeSummary');
    const openButtons = [
        document.getElementById('qeOpenSummary'),
        document.getElementById('qeMobileSummaryToggle')
    ].filter(Boolean);
    const closeButton = document.getElementById('qeSummaryClose');
    const liveTotal = document.getElementById('liveTotal');
    const mobileTotal = document.getElementById('qeMobileLiveTotal');
    const form = document.getElementById('quoteForm');
    const items = document.getElementById('quoteItems');
    const submitAction = document.getElementById('qeSubmitAction');

    function syncSectionState(section) {
        const toggle = section.querySelector('[data-qe-toggle]');
        if (!toggle) return;

        const collapsed = section.classList.contains('is-collapsed');
        toggle.setAttribute('aria-expanded', String(!collapsed));
        toggle.textContent = collapsed ? 'Mostrar' : 'Ocultar';
    }

    function prepareSections() {
        sections.forEach(section => {
            if (mobile.matches) {
                if (section.dataset.mobileCollapsed === 'true' && !section.dataset.mobilePrepared) {
                    section.classList.add('is-collapsed');
                }
            } else {
                section.classList.remove('is-collapsed');
            }

            section.dataset.mobilePrepared = '1';
            syncSectionState(section);
        });
    }

    sections.forEach(section => {
        const toggle = section.querySelector('[data-qe-toggle]');
        if (!toggle) return;

        toggle.addEventListener('click', () => {
            section.classList.toggle('is-collapsed');
            syncSectionState(section);
        });
    });

    function renumberItems() {
        if (!items) return;

        items.querySelectorAll('[data-row]').forEach((row, index) => {
            row.dataset.itemIndex = String(index + 1);

            row.querySelectorAll('.js-qty,.js-price').forEach(input => {
                input.setAttribute('inputmode', 'decimal');
            });
        });
    }

    if (items) {
        renumberItems();

        new MutationObserver(renumberItems).observe(items, {
            childList: true,
            subtree: false
        });
    }

    function mirrorTotal() {
        if (mobileTotal && liveTotal) {
            mobileTotal.textContent = liveTotal.textContent || '$0.00';
        }
    }

    if (liveTotal) {
        mirrorTotal();

        new MutationObserver(mirrorTotal).observe(liveTotal, {
            childList: true,
            characterData: true,
            subtree: true
        });
    }

    function openSummary() {
        if (!summary) return;

        if (!mobile.matches) {
            summary.scrollIntoView({ behavior: 'smooth', block: 'start' });
            return;
        }

        summary.classList.add('is-mobile-open');
        document.body.classList.add('qe-summary-open');
    }

    function closeSummary() {
        summary?.classList.remove('is-mobile-open');
        document.body.classList.remove('qe-summary-open');
    }

    openButtons.forEach(button => button.addEventListener('click', openSummary));
    closeButton?.addEventListener('click', closeSummary);

    document.addEventListener('keydown', event => {
        if (event.key === 'Escape') closeSummary();
    });

    document.addEventListener('click', event => {
        if (!document.body.classList.contains('qe-summary-open')) return;
        if (summary?.contains(event.target)) return;
        if (openButtons.some(button => button.contains(event.target))) return;
        closeSummary();
    });

    document.querySelectorAll('.qe-progress a[href^="#"]').forEach(link => {
        link.addEventListener('click', () => {
            const target = document.querySelector(link.getAttribute('href') || '');
            if (!target) return;

            if (target.classList.contains('is-collapsed')) {
                target.classList.remove('is-collapsed');
                syncSectionState(target);
            }
        });
    });

    /*
     * El modo de guardado se persiste en un hidden antes del submit.
     * Esto evita que al deshabilitar el botón durante "Guardando…" el
     * navegador pierda el name/value del botón que inició la acción.
     */
    document.querySelectorAll(
        '#quoteForm button[type="submit"], button[type="submit"][form="quoteForm"]'
    ).forEach(button => {
        button.addEventListener('click', () => {
            if (!submitAction) return;
            submitAction.value = button.dataset.qeSubmitAction || 'save';
        });
    });

    form?.addEventListener('submit', () => {
        const mode = submitAction?.value || 'save';

        document.querySelectorAll(
            '.qe-mobile-save, .qe-mobile-whatsapp, .qe-summary button[type="submit"], .qe-summary .btn-primary'
        ).forEach(button => {
            button.disabled = true;

            if (button.classList.contains('qe-mobile-save')) {
                button.textContent = 'Guardando…';
            }

            if (button.classList.contains('qe-mobile-whatsapp') && mode === 'save_whatsapp') {
                button.textContent = 'Abriendo…';
            }

            if (button.classList.contains('qe-whatsapp-save') && mode === 'save_whatsapp') {
                button.textContent = '💬 Guardando y preparando WhatsApp…';
            }
        });
    });

    mobile.addEventListener?.('change', () => {
        prepareSections();
        if (!mobile.matches) closeSummary();
    });

    prepareSections();
})();
