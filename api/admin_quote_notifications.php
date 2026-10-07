<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_auth();

header('Content-Type: application/json; charset=UTF-8');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');

function cpq_notify_json(bool $ok, array $data=[], int $code=200): never {
    http_response_code($code);
    echo json_encode(array_merge(['ok'=>$ok],$data),JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);
    exit;
}

try {
    $pdo=db();
    $action=(string)($_GET['action'] ?? 'poll');

    if($action==='mark_read'){
        if($_SERVER['REQUEST_METHOD']!=='POST'){
            cpq_notify_json(false,['message'=>'Método no permitido.'],405);
        }
        if(!csrf_check($_POST['_csrf'] ?? null)){
            cpq_notify_json(false,['message'=>'Sesión expirada.'],419);
        }
        $id=(int)($_POST['id'] ?? 0);
        if($id>0){
            $st=$pdo->prepare('UPDATE cp_web_quote_notifications SET read_at=NOW() WHERE id=?');
            $st->execute([$id]);
        }
        cpq_notify_json(true);
    }

    if($action==='mark_all_read'){
        if($_SERVER['REQUEST_METHOD']!=='POST'){
            cpq_notify_json(false,['message'=>'Método no permitido.'],405);
        }
        if(!csrf_check($_POST['_csrf'] ?? null)){
            cpq_notify_json(false,['message'=>'Sesión expirada.'],419);
        }
        $pdo->exec('UPDATE cp_web_quote_notifications SET read_at=NOW() WHERE read_at IS NULL');
        cpq_notify_json(true);
    }

    $after=max(0,(int)($_GET['after'] ?? 0));
    $limit=min(20,max(1,(int)($_GET['limit'] ?? 10)));

    $sql="SELECT n.id,n.request_id,n.event_type,n.title,n.message,n.created_at,
                 r.customer_name,r.service_key,r.phone
          FROM cp_web_quote_notifications n
          INNER JOIN cp_web_quote_requests r ON r.id=n.request_id
          WHERE n.id>? ORDER BY n.id ASC LIMIT {$limit}";
    $st=$pdo->prepare($sql);
    $st->execute([$after]);
    $items=$st->fetchAll(PDO::FETCH_ASSOC);

    $unread=(int)$pdo->query('SELECT COUNT(*) FROM cp_web_quote_notifications WHERE read_at IS NULL')->fetchColumn();
    $latest=(int)$pdo->query('SELECT COALESCE(MAX(id),0) FROM cp_web_quote_notifications')->fetchColumn();

    cpq_notify_json(true,[
        'notifications'=>$items,
        'unread'=>$unread,
        'latest_id'=>$latest,
    ]);
} catch(Throwable $e) {
    // Si la migración aún no fue instalada, no rompemos el administrador.
    cpq_notify_json(true,['notifications'=>[],'unread'=>0,'latest_id'=>0,'setup_required'=>true]);
}
