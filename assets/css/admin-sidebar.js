/* Estado persistente del sidebar */
(() => {
    const STORAGE_KEY = 'colibri_admin_sidebar_groups';
    const groups = [...document.querySelectorAll('[data-sidebar-group]')];
    if (!groups.length) return;

    let saved = {};
    try {
        saved = JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}');
    } catch (_) {}

    const setExpanded = (group, expanded, persist = true) => {
        const button = group.querySelector('.sidebar-group-toggle');
        if (!button) return;

        button.setAttribute('aria-expanded', expanded ? 'true' : 'false');

        if (persist) {
            saved[group.dataset.sidebarGroup] = expanded;
            try {
                localStorage.setItem(STORAGE_KEY, JSON.stringify(saved));
            } catch (_) {}
        }
    };

    groups.forEach(group => {
        const key = group.dataset.sidebarGroup;
        const button = group.querySelector('.sidebar-group-toggle');
        if (!button) return;

        const hasCurrent = !!group.querySelector('.sidebar-link.is-current');

        if (hasCurrent) {
            setExpanded(group, true, false);
        } else if (typeof saved[key] === 'boolean') {
            setExpanded(group, saved[key], false);
        } else {
            setExpanded(group, false, false);
        }

        button.addEventListener('click', () => {
            const expanded = button.getAttribute('aria-expanded') === 'true';
            setExpanded(group, !expanded, true);
        });
    });
})();
