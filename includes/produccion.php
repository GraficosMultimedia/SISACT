<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/ordenes.php';

function production_stages(): array {
    return [
        'pending' => ['label'=>'Pendiente','icon'=>'📥'],
        'design' => ['label'=>'Diseño','icon'=>'🎨'],
        'approval' => ['label'=>'Aprobación','icon'=>'✅'],
        'printing' => ['label'=>'Impresión','icon'=>'🖨️'],
        'production' => ['label'=>'Producción','icon'=>'🔧'],
        'quality' => ['label'=>'Calidad','icon'=>'🔍'],
        'ready' => ['label'=>'Listo','icon'=>'📦'],
        'delivered' => ['label'=>'Entregado','icon'=>'🚚'],
        'cancelled' => ['label'=>'Cancelado','icon'=>'⛔'],
    ];
}
function production_stage_label(string $stage): string {
    $all=production_stages(); return $all[$stage]['label'] ?? 'Sin estado';
}
function production_stage_icon(string $stage): string {
    $all=production_stages(); return $all[$stage]['icon'] ?? '•';
}
function production_get_stage(int $orderId): string {
    $st=db()->prepare('SELECT stage FROM cp_order_status WHERE order_id=? LIMIT 1');
    $st->execute([$orderId]);
    $stage=(string)($st->fetchColumn() ?: 'pending');
    return array_key_exists($stage,production_stages()) ? $stage : 'pending';
}
function production_set_stage(int $orderId,string $newStage,string $note=''): void {
    if(!array_key_exists($newStage,production_stages())) throw new RuntimeException('Etapa de producción no válida.');
    $pdo=db();
    $uid=(int)(current_user()['id'] ?? 0);
    $old=production_get_stage($orderId);
    $cleanNote=trim($note);

    // La etapa operativa es la fuente de verdad para producción y debe
    // mantener sincronizado el estado general de la orden.
    $orderStatusMap=[
        'pending'=>'pending',
        'design'=>'in_progress',
        'approval'=>'in_progress',
        'printing'=>'in_progress',
        'production'=>'in_progress',
        'quality'=>'in_progress',
        'ready'=>'in_progress',
        'delivered'=>'delivered',
        'cancelled'=>'cancelled',
    ];
    $syncedStatus=$orderStatusMap[$newStage];

    $pdo->beginTransaction();
    try {
        $exists=$pdo->prepare('SELECT id FROM cp_order_status WHERE order_id=? LIMIT 1');
        $exists->execute([$orderId]);
        if($exists->fetchColumn()) {
            $pdo->prepare('UPDATE cp_order_status SET stage=?,note=?,updated_by=?,updated_at=NOW() WHERE order_id=?')
                ->execute([$newStage,$cleanNote,$uid?:null,$orderId]);
        } else {
            $pdo->prepare('INSERT INTO cp_order_status(order_id,stage,note,updated_by,created_at,updated_at) VALUES(?,?,?,?,NOW(),NOW())')
                ->execute([$orderId,$newStage,$cleanNote,$uid?:null]);
        }

        // Solo generamos un movimiento cuando realmente cambió la etapa
        // o cuando el operador dejó una nota nueva.
        if($old!==$newStage || $cleanNote!=='') {
            $pdo->prepare('INSERT INTO cp_order_history(order_id,old_status,new_status,note,changed_by,created_at) VALUES(?,?,?,?,?,NOW())')
                ->execute([$orderId,$old,$newStage,$cleanNote,$uid?:null]);
        }

        $pdo->prepare('UPDATE cp_orders SET status=?,updated_by=?,updated_at=NOW() WHERE id=?')
            ->execute([$syncedStatus,$uid?:null,$orderId]);

        $pdo->commit();
    } catch(Throwable $e) {
        if($pdo->inTransaction()) $pdo->rollBack();
        throw $e;
    }
}
function production_orders(string $search='',string $stage=''): array {
    $sql="SELECT o.id,o.order_number,o.order_date,o.due_date,o.total,o.quote_id,
                 q.quote_number,c.name AS customer_name,u.name AS responsible_name,
                 COALESCE(s.stage,'pending') AS production_stage,
                 COALESCE(s.updated_at,o.updated_at) AS stage_updated_at
          FROM cp_orders o
          LEFT JOIN cp_quotes q ON q.id=o.quote_id
          LEFT JOIN cp_customers c ON c.id=o.customer_id
          LEFT JOIN cp_users u ON u.id=o.responsible_user_id
          LEFT JOIN cp_order_status s ON s.order_id=o.id
          WHERE o.status NOT IN ('cancelled','delivered') AND COALESCE(s.stage,'pending')<>'delivered'";
    $params=[];
    if($search!=='') {
        $sql.=' AND (o.order_number LIKE ? OR q.quote_number LIKE ? OR c.name LIKE ?)';
        $like='%'.$search.'%'; $params=[$like,$like,$like];
    }
    if($stage!=='' && array_key_exists($stage,production_stages())) { $sql.=" AND COALESCE(s.stage,'pending')=?"; $params[]=$stage; }
    $sql.=' ORDER BY CASE WHEN o.due_date IS NULL THEN 1 ELSE 0 END, o.due_date ASC, o.id DESC LIMIT 300';
    $st=db()->prepare($sql);$st->execute($params);return $st->fetchAll();
}
function production_history(int $orderId): array {
    $st=db()->prepare('SELECT h.*,u.name AS user_name FROM cp_order_history h LEFT JOIN cp_users u ON u.id=h.changed_by WHERE h.order_id=? ORDER BY h.id DESC');
    $st->execute([$orderId]); return $st->fetchAll();
}
