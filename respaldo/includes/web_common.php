<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/company.php';

if (!function_exists('cp_web_h')) {
  function cp_web_h(?string $v): string { return htmlspecialchars((string)$v,ENT_QUOTES,'UTF-8'); }
}
if (!function_exists('cp_web_company')) {
  function cp_web_company(): array { return company_profile(); }
}
if (!function_exists('cp_web_phone_digits')) {
  function cp_web_phone_digits(array $company): string {
    $d=preg_replace('/\D+/','',(string)($company['phone']??''));
    if($d!==''&&!str_starts_with($d,'52'))$d='52'.$d;
    return $d;
  }
}
if (!function_exists('cp_web_wa')) {
  function cp_web_wa(array $company,string $text=''): string {
    $d=cp_web_phone_digits($company);
    return $d===''?'#':'https://wa.me/'.$d.($text!==''?'?text='.rawurlencode($text):'');
  }
}
if (!function_exists('cp_web_image')) {
  function cp_web_image(?string $path): string {
    $p=trim((string)$path);
    if($p==='')return '';
    if(preg_match('#^https?://#i',$p))return $p;
    return '/'.ltrim($p,'/');
  }
}
if (!function_exists('cp_web_money')) {
  function cp_web_money($v): string { return is_numeric($v)?'$'.number_format((float)$v,2,'.',','):''; }
}
if (!function_exists('cp_web_route')) {
  function cp_web_route(string $path,array $query=[]): string {
    $base=dirname($_SERVER['SCRIPT_NAME']??''); if($base==='/'||$base==='.')$base='';
    $url=rtrim(str_replace('\\','/',$base),'/').'/'.ltrim($path,'/');
    if($query)$url.='?'.http_build_query($query);
    return $url?:'/';
  }
}
if (!function_exists('cp_web_absolute')) {
  function cp_web_absolute(string $path,array $query=[]): string {
    $c=cp_web_company();$site=rtrim((string)($c['website']??''),'/');
    if($site==='')$site=(((!empty($_SERVER['HTTPS'])&&$_SERVER['HTTPS']!=='off')?'https':'http').'://'.($_SERVER['HTTP_HOST']??'localhost'));
    $rel=cp_web_route($path,$query); return $site.($rel==='/'?'':'/'.ltrim($rel,'/'));
  }
}
if (!function_exists('cp_web_sanitize_text')) {
  function cp_web_sanitize_text(string $v,int $max=500): string {
    $v=trim(preg_replace('/\s+/u',' ',strip_tags($v))??'');return mb_substr($v,0,$max);
  }
}
