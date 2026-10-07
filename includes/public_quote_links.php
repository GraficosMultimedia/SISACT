<?php
declare(strict_types=1);
require_once __DIR__.'/web_common.php';

function cp_quote_public_row(PDO $pdo,string $token):?array{
    $s=$pdo->prepare("SELECT q.id,q.quote_number,q.status,q.valid_until,c.name customer_name,qt.total,t.token FROM cp_quote_public_tokens t INNER JOIN cp_quotes q ON q.id=t.quote_id LEFT JOIN cp_customers c ON c.id=q.customer_id LEFT JOIN cp_quote_totals qt ON qt.quote_id=q.id WHERE t.token=? AND t.active=1 LIMIT 1");
    $s->execute([$token]); $r=$s->fetch(PDO::FETCH_ASSOC); return$r?:null;
}
function cp_ensure_quote_public_token(PDO $pdo,int $quoteId):string{
    $s=$pdo->prepare('SELECT token FROM cp_quote_public_tokens WHERE quote_id=? AND active=1 LIMIT 1');
    $s->execute([$quoteId]); $token=$s->fetchColumn();
    if(is_string($token) && preg_match('/^[a-f0-9]{64}$/i',$token)) return $token;
    for($i=0;$i<5;$i++){
        $token=bin2hex(random_bytes(32));
        try{$pdo->prepare('INSERT INTO cp_quote_public_tokens(quote_id,token,active,created_at) VALUES(?,?,1,NOW())')->execute([$quoteId,$token]); return $token;}
        catch(Throwable $e){if($i===4) throw $e;}
    }
    throw new RuntimeException('No se pudo generar el enlace público de la cotización.');
}
function cp_quote_pdf_url(string $token):string{return cp_web_absolute('/cotizacion_pdf_publica.php',['token'=>$token]);}
function cp_quote_public_url(string $token):string{return cp_web_absolute('/seguimiento.php',['t'=>$token]);}
function cp_quote_whatsapp_url(array $company,array $quote):string{$text="Hola ".($quote['customer_name']??'')." 👋\n\nTe compartimos la cotización ".($quote['quote_number']??'').".\n\n💰 Total: ".cp_web_money($quote['total']??0)."\n\n📄 Ver PDF:\n".cp_quote_pdf_url((string)$quote['token'])."\n\nColibrí Print México";return cp_web_wa($company,$text);}
