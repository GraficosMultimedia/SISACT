document.addEventListener('DOMContentLoaded', () => {
  const topnav = document.querySelector('[data-cp-topnav]');
  if (!topnav) return;

  const menuToggle = topnav.querySelector('[data-cp-menu-toggle]');
  const menu = topnav.querySelector('#cp-main-menu');
  const backdrop = document.querySelector('[data-cp-backdrop]');
  const groups = [...topnav.querySelectorAll('[data-cp-group]')];

  const setMenu = (open) => {
    if (!menu || !menuToggle) return;
    menu.classList.toggle('is-open', open);
    menuToggle.setAttribute('aria-expanded', open ? 'true' : 'false');
    if (backdrop) {
      backdrop.hidden = !open;
      backdrop.classList.toggle('is-visible', open);
    }
  };

  const closeGroups = (except = null) => {
    groups.forEach((group) => {
      if (group === except) return;
      group.classList.remove('is-open');
      const trigger = group.querySelector('[data-cp-group-toggle]');
      if (trigger) trigger.setAttribute('aria-expanded', 'false');
    });
  };

  menuToggle?.addEventListener('click', () => {
    setMenu(!menu.classList.contains('is-open'));
  });

  groups.forEach((group) => {
    const trigger = group.querySelector('[data-cp-group-toggle]');
    if (!trigger) return;
    trigger.addEventListener('click', (event) => {
      event.preventDefault();
      const isOpen = group.classList.contains('is-open');
      closeGroups(group);
      group.classList.toggle('is-open', !isOpen);
      trigger.setAttribute('aria-expanded', !isOpen ? 'true' : 'false');
    });
  });

  backdrop?.addEventListener('click', () => {
    closeGroups();
    setMenu(false);
  });

  menu?.querySelectorAll('a').forEach((link) => {
    link.addEventListener('click', () => {
      closeGroups();
      setMenu(false);
    });
  });

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      closeGroups();
      setMenu(false);
      menuToggle?.focus();
    }
  });

  window.addEventListener('resize', () => {
    if (window.innerWidth > 1060) {
      setMenu(false);
    }
  });
});
