<?php
declare(strict_types=1);
function cp_security_random_token(int $bytes=32):string{return bin2hex(random_bytes($bytes));}
function cp_security_same_origin():bool{$o=$_SERVER['HTTP_ORIGIN']??'';$h=$_SERVER['HTTP_HOST']??'';return$o===''||(parse_url($o,PHP_URL_HOST)===$h);}
function cp_security_safe_redirect(string $target,string $fallback='/'):string{return $target!==''&&str_starts_with($target,'/')&&!str_starts_with($target,'//')?$target:$fallback;}
function cp_security_headers():void{if(headers_sent())return;header('X-Content-Type-Options: nosniff');header('Referrer-Policy: strict-origin-when-cross-origin');header('Permissions-Policy: geolocation=(), microphone=(), camera=()');}
