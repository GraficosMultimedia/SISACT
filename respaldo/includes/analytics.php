<?php
declare(strict_types=1);
function cp_analytics_measurement_id():string{try{$s=db()->prepare("SELECT setting_value FROM cp_settings WHERE setting_key='analytics.ga4_measurement_id' LIMIT 1");$s->execute();return trim((string)($s->fetchColumn()?:''));}catch(Throwable $e){return'';}}
function cp_analytics_head():string{$id=cp_analytics_measurement_id();if($id==='')return'';$safe=htmlspecialchars($id,ENT_QUOTES,'UTF-8');return '<script async src="https://www.googletagmanager.com/gtag/js?id='.$safe.'"></script><script>window.dataLayer=window.dataLayer||[];function gtag(){dataLayer.push(arguments)}gtag("js",new Date());gtag("config","'.$safe.'");</script>';}
function cp_analytics_event(string $n,array $p=[]):string{return '<script>window.addEventListener("load",function(){if(typeof gtag==="function")gtag("event",'.json_encode($n).','.json_encode($p,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES).')});</script>';}
