(() => {
    'use strict';

    function closeMenus(except) {
        document.querySelectorAll('.qws-menu[open]').forEach(menu => {
            if (menu !== except) menu.removeAttribute('open');
        });
    }

    document.addEventListener('click', event => {
        const menu = event.target.closest('.qws-menu');

        if (menu) {
            if (event.target.matches('summary')) closeMenus(menu);
            return;
        }

        closeMenus(null);
    });

    document.addEventListener('keydown', event => {
        if (event.key === 'Escape') closeMenus(null);

        if (
            event.key === '/'
            && !event.ctrlKey
            && !event.metaKey
            && !event.altKey
            && !/INPUT|TEXTAREA|SELECT/.test(document.activeElement?.tagName || '')
        ) {
            const search = document.getElementById('qwsSearch');

            if (search) {
                event.preventDefault();
                search.focus();
                search.select();
            }
        }
    });

    document.getElementById('qwsSearch')?.setAttribute('aria-keyshortcuts', '/');
})();
