<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
if (current_user()) redirect('/admin/dashboard.php');
$error = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) $error = 'Sesión inválida. Recarga la página.';
    else {
        try {
            $stmt = db()->prepare('SELECT u.*, r.name AS role_name FROM cp_users u INNER JOIN cp_roles r ON r.id=u.role_id WHERE u.email=? AND u.enabled=1 LIMIT 1');
            $stmt->execute([trim((string)($_POST['email'] ?? ''))]);
            $user = $stmt->fetch();
            if ($user && password_verify((string)($_POST['password'] ?? ''), $user['password_hash'])) {
                session_regenerate_id(true);
                $_SESSION['user'] = ['id'=>$user['id'],'name'=>$user['name'],'email'=>$user['email'],'role'=>$user['role_name']];
                db()->prepare('UPDATE cp_users SET last_login_at=NOW() WHERE id=?')->execute([$user['id']]);
                log_activity('login','auth','Inicio de sesión');
                redirect('/admin/dashboard.php');
            }
            $error = 'Correo o contraseña incorrectos.';
        } catch (Throwable $e) {
            $error = 'No se pudo conectar con la base de datos. Verifica que Fase 1 esté instalada.';
        }
    }
}
?><!doctype html><html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Acceso | Colibrí Print</title><link rel="stylesheet" href="/assets/css/app.css"></head><body><div style="min-height:100vh;display:grid;place-items:center;padding:20px"><form method="post" style="width:min(420px,92vw);background:#0d1c30;border:1px solid #244665;padding:30px;border-radius:20px;box-shadow:0 25px 70px #0008"><div style="font-size:42px">🐦</div><h1 style="margin:6px 0">Colibrí Print</h1><p class="muted">Centro de Operaciones · Fase 1</p><?php if($error): ?><div class="notice danger" style="margin:12px 0"><?=e($error)?></div><?php endif; ?><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><div class="field" style="margin-top:18px"><label>Correo</label><input type="email" name="email" required autofocus></div><div class="field" style="margin-top:14px"><label>Contraseña</label><input type="password" name="password" required></div><button style="width:100%;margin-top:18px">Entrar</button><a href="/" style="display:block;text-align:center;margin-top:15px;color:#84cfff;text-decoration:none">← Volver al sitio</a></form></div></body></html>
