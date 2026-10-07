(() => {
    'use strict';

    const form = document.getElementById('loginForm');
    const button = document.getElementById('loginButton');
    const password = document.getElementById('password');
    const toggle = document.getElementById('passwordToggle');
    const remember = document.querySelector('input[name="remember_ui"]');
    const email = document.getElementById('email');

    if (toggle && password) {
        toggle.addEventListener('click', () => {
            const currentlyVisible = password.type === 'text';

            password.type = currentlyVisible ? 'password' : 'text';
            toggle.classList.toggle('is-visible', !currentlyVisible);

            toggle.setAttribute('aria-pressed', String(!currentlyVisible));
            toggle.setAttribute(
                'aria-label',
                currentlyVisible ? 'Mostrar contraseña' : 'Ocultar contraseña'
            );

            password.focus({ preventScroll: true });
        });
    }

    /*
     * "Recordarme" guarda únicamente el correo electrónico en
     * localStorage. Nunca guarda la contraseña ni modifica la sesión.
     */
    const storageKey = 'sisact_login_email';

    try {
        const savedEmail = localStorage.getItem(storageKey);

        if (savedEmail && email && !email.value) {
            email.value = savedEmail;

            if (remember) {
                remember.checked = true;
            }

            if (password) {
                password.focus();
            }
        }
    } catch (_) {
        // Si el navegador bloquea localStorage, el login sigue funcionando.
    }

    if (form) {
        form.addEventListener('submit', () => {
            try {
                if (remember?.checked && email?.value) {
                    localStorage.setItem(storageKey, email.value.trim());
                } else {
                    localStorage.removeItem(storageKey);
                }
            } catch (_) {}

            if (button) {
                button.disabled = true;
                button.classList.add('is-loading');

                const text = button.querySelector('.cp-button-text');
                if (text) {
                    text.textContent = 'Ingresando…';
                }
            }
        });
    }
})();
