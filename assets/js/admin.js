(() => {
  const body = document.body;
  const sidebar = document.getElementById('adminSidebar');
  const overlay = document.getElementById('sidebarOverlay');
  const menu = document.getElementById('mobileMenuBtn');
  if (!sidebar || !overlay || !menu) return;

  const setOpen = (open) => {
    body.classList.toggle('sidebar-open', open);
    menu.setAttribute('aria-expanded', open ? 'true' : 'false');
    menu.title = open ? 'Cerrar menú' : 'Abrir menú';
  };

  menu.addEventListener('click', () => setOpen(!body.classList.contains('sidebar-open')));
  overlay.addEventListener('click', () => setOpen(false));
  sidebar.querySelectorAll('a').forEach(a => a.addEventListener('click', () => setOpen(false)));
  window.addEventListener('resize', () => { if (window.innerWidth > 900) setOpen(false); });
})();
