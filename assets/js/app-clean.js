document.addEventListener('DOMContentLoaded', () => {
  const sidebar = document.getElementById('sidebar');
  const overlay = document.getElementById('sidebarOverlay');
  const toggle = document.getElementById('sidebarToggle');
  const close = document.getElementById('sidebarClose');

  const setMenu = (open) => {
    sidebar?.classList.toggle('is-open', open);
    overlay?.classList.toggle('is-visible', open);
    if (toggle) toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
    document.body.classList.toggle('cp-menu-open', open);
  };

  toggle?.addEventListener('click', () => setMenu(!sidebar?.classList.contains('is-open')));
  close?.addEventListener('click', () => setMenu(false));
  overlay?.addEventListener('click', () => setMenu(false));
  document.querySelectorAll('.cp-nav-link').forEach(link => link.addEventListener('click', () => setMenu(false)));

  window.addEventListener('resize', () => {
    if (window.innerWidth > 960) setMenu(false);
  });

  document.querySelectorAll('[data-confirm]').forEach(form => {
    form.addEventListener('submit', event => {
      const message = form.dataset.confirm || '¿Confirmar esta acción?';
      if (!window.confirm(message)) event.preventDefault();
    });
  });

  const panel = document.getElementById('editPanel');
  const form = document.getElementById('entityForm');
  const title = document.getElementById('editTitle');
  const subtitle = document.getElementById('editSubtitle');

  const openEditor = (button) => {
    if (!panel || !form) return;
    const data = button.dataset || {};
    form.reset();
    form.querySelector('[name="id"]')?.setAttribute('value', data.id || '');
    const action = form.querySelector('[name="action"]');
    if (action) action.value = data.id ? 'update' : 'create';

    Object.entries(data).forEach(([key, value]) => {
      if (key === 'id') return;
      const field = form.querySelector(`[name="${CSS.escape(key)}"]`);
      if (!field) return;
      if (field.type === 'checkbox') field.checked = value === '1' || value === 'true';
      else field.value = value ?? '';
    });

    const country = form.querySelector('[name="country"]');
    if (country && !country.value) country.value = 'MX';

    if (title) title.textContent = data.id ? 'Editar registro' : 'Nuevo registro';
    if (subtitle) subtitle.textContent = data.id
      ? `Editando #${data.id}. Los cambios se guardan únicamente en la nueva plataforma.`
      : 'Registro nuevo de Colibrí Print.';

    panel.classList.add('is-open');
    panel.scrollIntoView({behavior: 'smooth', block: 'start'});
  };

  document.querySelectorAll('[data-edit-entity]').forEach(button => button.addEventListener('click', () => openEditor(button)));
  document.querySelectorAll('[data-new-entity]').forEach(button => button.addEventListener('click', () => openEditor(button)));
  document.querySelectorAll('[data-close-editor]').forEach(button => button.addEventListener('click', () => panel?.classList.remove('is-open')));
});
