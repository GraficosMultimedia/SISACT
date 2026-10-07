<?php
declare(strict_types=1);
require_once __DIR__ . '/api.php';

function h(string $v): string { return htmlspecialchars($v, ENT_QUOTES, 'UTF-8'); }

$error = null;
$result = ['videos' => []];

try {
    $result = tiktok_fetch_videos(isset($_GET['refresh']) && $_GET['refresh'] === '1');
} catch (Throwable $e) {
    $error = $e->getMessage();
}
$videos = $result['videos'] ?? [];
?>
<!doctype html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>TikTok | Colibrí Print Admin</title>
<style>
:root{--bg:#071727;--panel:#0c1d2e;--panel2:#10263a;--line:#1e4968;--text:#f4f8fc;--muted:#9db3c8;--cyan:#18c5f4;--danger:#ff5f7a;--ok:#24d6a0}
*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--text);font-family:Arial,Helvetica,sans-serif}
.top{border-bottom:1px solid var(--line);background:#0a2036}.topin{max-width:1500px;margin:auto;padding:22px 28px;display:flex;justify-content:space-between;align-items:center;gap:20px}.eyebrow{color:var(--cyan);font-size:12px;letter-spacing:2px;font-weight:800}.top h1{margin:5px 0 0;font-size:28px}.actions{display:flex;gap:10px;flex-wrap:wrap}.btn{display:inline-block;text-decoration:none;border:1px solid var(--line);background:var(--panel2);color:#fff;border-radius:10px;padding:10px 15px;font-weight:700;font-size:14px}.btn.primary{background:var(--cyan);border-color:var(--cyan);color:#032033}.wrap{max-width:1500px;margin:auto;padding:25px 28px 50px}.intro{display:flex;justify-content:space-between;gap:20px;align-items:end;margin-bottom:20px}.intro h2{margin:0 0 7px}.intro p{margin:0;color:var(--muted)}.status{padding:14px 16px;border-radius:12px;margin-bottom:22px;border:1px solid var(--line);background:var(--panel)}.status.ok{border-color:#146c59;color:#8ef2d3}.status.error{border-color:#81344a;color:#ff9aad}.grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:20px}.card{background:var(--panel);border:1px solid var(--line);border-radius:16px;overflow:hidden}.cover{display:block;aspect-ratio:9/16;background:#06121e}.cover img{width:100%;height:100%;object-fit:cover;display:block}.content{padding:15px}.title{font-weight:800;line-height:1.3}.desc{font-size:13px;color:var(--muted);line-height:1.45;margin-top:8px;display:-webkit-box;-webkit-line-clamp:3;-webkit-box-orient:vertical;overflow:hidden;min-height:56px}.stats{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-top:13px;color:var(--muted);font-size:12px}.card .btn{margin-top:15px;width:100%;text-align:center}.empty{padding:35px;background:var(--panel);border:1px dashed var(--line);border-radius:16px;color:var(--muted)}
@media(max-width:1100px){.grid{grid-template-columns:repeat(3,1fr)}}@media(max-width:800px){.topin,.wrap{padding-left:16px;padding-right:16px}.intro{display:block}.actions{margin-top:15px}.grid{grid-template-columns:repeat(2,1fr)}}@media(max-width:500px){.grid{grid-template-columns:1fr}.topin{align-items:flex-start;flex-direction:column}}
</style>
</head>
<body>
<header class="top"><div class="topin">
<div><div class="eyebrow">MARKETING · REDES SOCIALES</div><h1>TikTok</h1></div>
<div class="actions"><a class="btn" href="/admin/">← Admin</a><a class="btn" href="check.php">Estado</a><a class="btn primary" href="?refresh=1">↻ Actualizar</a></div>
</div></header>
<main class="wrap">
<div class="intro"><div><h2>Biblioteca de videos</h2><p>Contenido de TikTok conectado a Colibrí Print.</p></div></div>
<?php if($error): ?>
<div class="status error"><strong>No se pudieron cargar los videos.</strong><br><?=h($error)?><br><br><a class="btn" href="/tiktok-callback/login.php">Conectar / renovar TikTok</a></div>
<?php else: ?>
<div class="status ok">✓ TikTok conectado · <?=count($videos)?> videos disponibles</div>
<?php endif; ?>
<?php if(!$videos && !$error): ?><div class="empty">No hay videos disponibles todavía. Pulsa <strong>Actualizar</strong> para consultar TikTok.</div><?php endif; ?>
<div class="grid">
<?php foreach($videos as $video):
$link=$video['embed_link']??$video['share_url']??'#'; ?>
<article class="card">
<a class="cover" href="<?=h((string)$link)?>" target="_blank" rel="noopener">
<?php if(!empty($video['cover_image_url'])): ?><img src="<?=h((string)$video['cover_image_url'])?>" alt="<?=h((string)($video['title']??'TikTok'))?>" loading="lazy"><?php endif; ?>
</a>
<div class="content">
<div class="title"><?=h((string)($video['title']??'Video TikTok'))?></div>
<div class="desc"><?=nl2br(h((string)($video['video_description']??'')))?></div>
<div class="stats">
<span>Vistas: <?=h((string)($video['view_count']??0))?></span><span>Likes: <?=h((string)($video['like_count']??0))?></span>
<span>Comentarios: <?=h((string)($video['comment_count']??0))?></span><span>Compartidos: <?=h((string)($video['share_count']??0))?></span>
</div>
<a class="btn" href="<?=h((string)$link)?>" target="_blank" rel="noopener">Ver en TikTok ↗</a>
</div></article>
<?php endforeach; ?>
</div>
</main>
</body>
</html>
