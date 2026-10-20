<?php
declare(strict_types=1);
require_once __DIR__.'/web_common.php';
function cp_seo_meta(array $d=[]):array{$c=cp_web_company();$b=$c['trade_name']?:$c['legal_name'];return['title'=>(string)($d['title']??$b),'description'=>cp_web_sanitize_text((string)($d['description']??'Soluciones gráficas, impresión y personalización en Colibrí Print México.'),160),'canonical'=>(string)($d['canonical']??cp_web_absolute('/')),'image'=>cp_web_image((string)($d['image']??($c['logo_path']??'')))];}
function cp_seo_head(array $m):string{$t=cp_web_h($m['title']);$d=cp_web_h($m['description']);$u=cp_web_h($m['canonical']);$i=cp_web_h($m['image']);return '<title>'.$t.'</title><meta name="description" content="'.$d.'"><link rel="canonical" href="'.$u.'"><meta property="og:title" content="'.$t.'"><meta property="og:description" content="'.$d.'"><meta property="og:url" content="'.$u.'"><meta property="og:type" content="website">'.($i?'<meta property="og:image" content="'.$i.'">':'');}
