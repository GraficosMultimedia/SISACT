
/* =========================================================
   COLIBRÍ PRINT · SIDEBAR STATE
   ========================================================= */
(() => {
    const STORAGE_KEY = 'colibri_admin_sidebar_groups_v2';
    const sidebar = document.getElementById('adminSidebar');
    if (!sidebar) return;

    const groups = [...sidebar.querySelectorAll('[data-sidebar-group]')];

    let state = {};
    try {
        state = JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}');
    } catch (_) {
        state = {};
    }

    function save() {
        try {
            localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
        } catch (_) {}
    }

    function setExpanded(group, expanded, persist = true) {
        const button = group.querySelector('.sidebar-group-toggle');
        if (!button) return;

        button.setAttribute('aria-expanded', expanded ? 'true' : 'false');

        if (persist) {
            state[group.dataset.sidebarGroup] = expanded;
            save();
        }
    }

    groups.forEach(group => {
        const key = group.dataset.sidebarGroup;
        const button = group.querySelector('.sidebar-group-toggle');
        const current = group.querySelector('.sidebar-link.is-current');

        if (!button) return;

        // Siempre abre el módulo actual.
        // Si no es el actual, recupera la preferencia del administrador.
        if (current) {
            setExpanded(group, true, false);
            state[key] = true;
        } else if (typeof state[key] === 'boolean') {
            setExpanded(group, state[key], false);
        } else {
            setExpanded(group, false, false);
        }

        button.addEventListener('click', () => {
            const expanded = button.getAttribute('aria-expanded') === 'true';
            setExpanded(group, !expanded, true);
        });
    });

    save();
})();
