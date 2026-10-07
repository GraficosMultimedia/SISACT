document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('[data-confirm]').forEach((el) => {
    el.addEventListener('click', (event) => {
      const message = el.getAttribute('data-confirm') || '¿Deseas continuar?';
      if (!window.confirm(message)) event.preventDefault();
    });
  });

  document.querySelectorAll('[data-auto-focus]').forEach((el) => el.focus());
});
