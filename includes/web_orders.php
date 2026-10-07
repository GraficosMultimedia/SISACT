<?php
declare(strict_types=1);
require_once __DIR__.'/web_common.php';
function cp_web_checkout_with_order(PDO $pdo,string $token):?array{$s=$pdo->prepare("SELECT w.*,q.quote_number,q.status quote_status,o.id order_id,o.order_number,o.status order_status,o.due_date,os.stage tracking_stage,tt.token tracking_token FROM cp_web_checkout_sessions w LEFT JOIN cp_quotes q ON q.id=w.quote_id LEFT JOIN cp_orders o ON o.quote_id=q.id LEFT JOIN cp_order_status os ON os.order_id=o.id LEFT JOIN cp_tracking_tokens tt ON tt.order_id=o.id AND tt.active=1 WHERE w.session_token=? LIMIT 1");$s->execute([$token]);$r=$s->fetch(PDO::FETCH_ASSOC);return$r?:null;}
function cp_web_tracking_url(string $token):string{return cp_web_absolute('/seguimiento-publico.php',['token'=>$token]);}
