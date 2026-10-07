<?php
declare(strict_types=1);
require_once __DIR__ . '/api.php';
function h(string $v): string { return htmlspecialchars($v, ENT_QUOTES, 'UTF-8'); }

$tokenFile = defined('TIKTOK_TOKEN_FILE') ? TIKTOK_TOKEN_FILE : '';
$exists = $tokenFile !== '' && is_file($tokenFile);
$token = $exists ? json_decode((string)file_get_contents($tokenFile), true) : null;
$valid = is_array($token) && !empty($token['access_token']);
?>
<!doctype html><html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Estado TikTok | Colibrí Print</title>
<style>body{margin:0;background:#071727;color:#fff;font-family:Arial;padding:30px}.card{max-width:800px;margin:auto;background:#0c1d2e;border:1px solid #1e4968;border-radius:16px;padding:25px}.ok{color:#24d6a0}.bad{color:#ff7188}.btn{display:inline-block;background:#18c5f4;color:#032033;padding:11px 15px;border-radius:9px;text-decoration:none;font-weight:700;margin-right:8px}</style></head>
<body><div class="card"><h1>Estado de TikTok</h1>
<p class="<?= $valid?'ok':'bad'?>"><?= $valid?'✓ Access token encontrado':'✕ Access token no encontrado' ?></p>
<?php if($valid): ?><p>Open ID: <?=h((string)($token['open_id']??''))?></p><p>Refresh token: <?=!empty($token['refresh_token'])?'guardado':'no disponible'?></p><?php endif; ?>
<p><a class="btn" href="index.php">← Volver a videos</a><a class="btn" href="/tiktok-callback/login.php">Conectar TikTok</a></p>
</div></body></html>
