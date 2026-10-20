<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';

if (current_user()) redirect('/admin/dashboard.php');

$error = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'Sesión inválida. Recarga la página.';
    } else {
        try {
            $stmt = db()->prepare(
                'SELECT u.*, r.name AS role_name
                 FROM cp_users u
                 INNER JOIN cp_roles r ON r.id=u.role_id
                 WHERE u.email=? AND u.enabled=1
                 LIMIT 1'
            );
            $stmt->execute([trim((string)($_POST['email'] ?? ''))]);
            $user = $stmt->fetch();

            if ($user && password_verify((string)($_POST['password'] ?? ''), $user['password_hash'])) {
                session_regenerate_id(true);

                $_SESSION['user'] = [
                    'id'    => $user['id'],
                    'name'  => $user['name'],
                    'email' => $user['email'],
                    'role'  => $user['role_name']
                ];

                db()->prepare('UPDATE cp_users SET last_login_at=NOW() WHERE id=?')
                    ->execute([$user['id']]);

                log_activity('login', 'auth', 'Inicio de sesión');
                redirect('/admin/dashboard.php');
            }

            $error = 'Correo o contraseña incorrectos.';
        } catch (Throwable $e) {
            $error = 'No se pudo conectar con la base de datos. Intenta nuevamente.';
        }
    }
}
?>
<!doctype html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <meta name="theme-color" content="#031126">
    <meta name="robots" content="noindex,nofollow">
    <title>Acceso | Colibrí Print México</title>

    <link rel="stylesheet" href="/assets/css/app.css">
    <link rel="stylesheet" href="/assets/css/login-colibri.css?v=2.0.0">
</head>
<body class="cp-login-page">
    <div class="cp-decor cp-decor-left" aria-hidden="true"></div>
    <div class="cp-decor cp-decor-right" aria-hidden="true"></div>

    <main class="cp-login-shell">
        <section class="cp-brand-panel" aria-label="Colibrí Print México">
            <div class="cp-brand-content">
                <img
                    class="cp-logo"
                    src="/assets/img/colibri-print-logo-dark.png"
                    alt="Colibrí Print México - Ideas que impresionan"
                    width="1959"
                    height="803"
                >

                <div class="cp-system-title">
                    <h1>Sistema <span>Administrativo</span></h1>

                    <p class="cp-kicker">CENTRO DE OPERACIONES</p>

                    <div class="cp-cmyk-line" aria-hidden="true">
                        <i></i><i></i><i></i>
                    </div>

                    <p class="cp-authorized">
                        Acceso exclusivo para personal autorizado
                    </p>
                </div>

                <div class="cp-features" aria-label="Funciones del sistema">
                    <div class="cp-feature">
                        <svg viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M6 9V3h12v6M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2M6 14h12v7H6z"/>
                        </svg>
                        <span>GESTIÓN<br>DE PEDIDOS</span>
                    </div>

                    <div class="cp-feature">
                        <svg viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M4 20V10h4v10M10 20V4h4v16M16 20v-7h4v7M2 20h20"/>
                        </svg>
                        <span>CONTROL<br>DE PRODUCCIÓN</span>
                    </div>

                    <div class="cp-feature">
                        <svg viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>
                        </svg>
                        <span>ADMINISTRACIÓN<br>DEL EQUIPO</span>
                    </div>
                </div>

                <div class="cp-brand-signature">
                    <span>Ideas que impresionan</span>
                    <div class="cp-signature-line" aria-hidden="true"></div>
                </div>
            </div>
        </section>

        <section class="cp-form-panel">
            <div class="cp-login-card">
                <header class="cp-card-header">
                    <div class="cp-mobile-logo">
                        <img
                            src="/assets/img/colibri-print-logo-dark.png"
                            alt="Colibrí Print México"
                        >
                    </div>

                    <h2>Iniciar sesión</h2>
                    <p>Bienvenido al sistema interno de<br>Colibrí Print México.</p>
                </header>

                <?php if ($error): ?>
                    <div class="cp-alert" role="alert">
                        <svg viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M12 9v4M12 17h.01M10.3 3.7 2.4 17.4A2 2 0 0 0 4.1 20h15.8a2 2 0 0 0 1.7-2.6L13.7 3.7a2 2 0 0 0-3.4 0Z"/>
                        </svg>
                        <span><?=e($error)?></span>
                    </div>
                <?php endif; ?>

                <form method="post" class="cp-login-form" id="loginForm">
                    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">

                    <div class="cp-field">
                        <label for="email">Correo electrónico</label>
                        <div class="cp-input-wrap">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M4 4h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2Z"/>
                                <path d="m22 6-10 7L2 6"/>
                            </svg>

                            <input
                                id="email"
                                type="email"
                                name="email"
                                placeholder="tu@empresa.com"
                                autocomplete="email"
                                inputmode="email"
                                required
                                autofocus
                                value="<?=e((string)($_POST['email'] ?? ''))?>"
                            >
                        </div>
                    </div>

                    <div class="cp-field">
                        <label for="password">Contraseña</label>

                        <div class="cp-input-wrap">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <rect x="3" y="11" width="18" height="10" rx="2"/>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                            </svg>

                            <input
                                id="password"
                                type="password"
                                name="password"
                                placeholder="••••••••••"
                                autocomplete="current-password"
                                required
                            >

                            <button
                                class="cp-password-toggle"
                                type="button"
                                id="passwordToggle"
                                aria-label="Mostrar contraseña"
                                aria-pressed="false"
                            >
                                <svg class="eye-open" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z"/>
                                    <circle cx="12" cy="12" r="3"/>
                                </svg>

                                <svg class="eye-closed" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="m3 3 18 18M10.6 10.6a2 2 0 0 0 2.8 2.8M9.9 4.2A10.8 10.8 0 0 1 12 4c6.5 0 10 8 10 8a18 18 0 0 1-2 3M6.6 6.6C3.6 8.6 2 12 2 12s3.5 8 10 8a10 10 0 0 0 4.1-.9"/>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <label class="cp-remember">
                        <input type="checkbox" name="remember_ui" value="1">
                        <span class="cp-checkmark">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="m5 12 4 4L19 6"/>
                            </svg>
                        </span>
                        <span>Recordarme</span>
                    </label>

                    <button class="cp-submit" type="submit" id="loginButton">
                        <span class="cp-button-text">Ingresar</span>
                        <span class="cp-spinner" aria-hidden="true"></span>
                        <svg class="cp-arrow" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M5 12h14M13 6l6 6-6 6"/>
                        </svg>
                    </button>

                    <p class="cp-security-note">
                        <svg viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10Z"/>
                            <path d="m9 12 2 2 4-4"/>
                        </svg>
                        Conexión segura · Personal autorizado
                    </p>
                </form>
            </div>
        </section>
    </main>

    <script src="/assets/js/login-colibri.js?v=2.0.0" defer></script>
</body>
</html>
