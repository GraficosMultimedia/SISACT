<?php
declare(strict_types=1);

function payment_receipts_table_ready(): bool {
    static $ready=null;
    if($ready!==null)return $ready;
    try{
        $st=db()->query("SHOW TABLES LIKE 'cp_payment_receipts'");
        $ready=(bool)$st->fetchColumn();
    }catch(Throwable $e){$ready=false;}
    return $ready;
}

function payment_receipts_generate_token(): string {
    return bin2hex(random_bytes(32));
}

function payment_receipts_for_order(int $orderId): array {
    if($orderId<=0 || !payment_receipts_table_ready())return [];
    $st=db()->prepare(
        'SELECT r.*,p.amount AS payment_amount,p.payment_date,p.method,p.reference,
                u.name AS reviewed_by_name
         FROM cp_payment_receipts r
         LEFT JOIN cp_payments p ON p.id=r.payment_id
         LEFT JOIN cp_users u ON u.id=r.reviewed_by
         WHERE r.order_id=?
         ORDER BY r.created_at DESC,r.id DESC'
    );
    $st->execute([$orderId]);
    return $st->fetchAll();
}

function payment_receipt_public_find(int $receiptId,string $trackingToken): ?array {
    if($receiptId<=0 || !preg_match('/^[a-f0-9]{64}$/i',$trackingToken) || !payment_receipts_table_ready())return null;
    $st=db()->prepare(
      'SELECT r.*,o.order_number,c.name AS customer_name,p.amount AS payment_amount,p.payment_date,p.method,p.reference
       FROM cp_payment_receipts r
       INNER JOIN cp_orders o ON o.id=r.order_id
       LEFT JOIN cp_customers c ON c.id=o.customer_id
       LEFT JOIN cp_payments p ON p.id=r.payment_id
       INNER JOIN cp_tracking_tokens tt ON tt.order_id=r.order_id AND tt.token=? AND tt.active=1
       WHERE r.id=? LIMIT 1'
    );
    $st->execute([$trackingToken,$receiptId]);
    return $st->fetch() ?: null;
}

function payment_receipt_upload(int $orderId,array $file,string $note=''): array {
    if(!payment_receipts_table_ready())throw new RuntimeException('La tabla de comprobantes no está instalada.');
    $error=(int)($file['error']??UPLOAD_ERR_NO_FILE);
    if($error===UPLOAD_ERR_NO_FILE)throw new RuntimeException('Selecciona un comprobante.');
    if($error!==UPLOAD_ERR_OK)throw new RuntimeException('No se pudo recibir el comprobante.');
    $size=(int)($file['size']??0);
    if($size<=0 || $size>10*1024*1024)throw new RuntimeException('El comprobante debe pesar máximo 10 MB.');

    $tmp=(string)($file['tmp_name']??'');
    $mime=(new finfo(FILEINFO_MIME_TYPE))->file($tmp);
    $allowed=['image/jpeg'=>'jpg','image/png'=>'png','image/webp'=>'webp','application/pdf'=>'pdf'];
    if(!isset($allowed[$mime]))throw new RuntimeException('Solo se permiten JPG, PNG, WEBP o PDF.');

    $token=payment_receipts_generate_token();
    $dir=__DIR__.'/../uploads/payment-receipts/'.$orderId;
    if(!is_dir($dir) && !mkdir($dir,0755,true))throw new RuntimeException('No se pudo crear el almacenamiento del comprobante.');

    $name=$token.'.'.$allowed[$mime];
    $dest=$dir.'/'.$name;
    if(!move_uploaded_file($tmp,$dest))throw new RuntimeException('No se pudo guardar el comprobante.');

    $original=trim((string)($file['name']??$name));
    if(strlen($original)>190)$original=substr($original,0,190);
    $relative='/uploads/payment-receipts/'.$orderId.'/'.$name;

    try{
        $st=db()->prepare(
          'INSERT INTO cp_payment_receipts
           (order_id,access_token,original_name,file_path,mime_type,file_size,status,note,created_at,updated_at)
           VALUES(?,?,?,?,?,?,?,?,NOW(),NOW())'
        );
        $st->execute([$orderId,$token,$original,$relative,$mime,$size,'pending',substr(trim($note),0,4000)]);
    }catch(Throwable $e){
        @unlink($dest); throw $e;
    }
    return ['id'=>(int)db()->lastInsertId(),'token'=>$token,'file_path'=>$relative,'original_name'=>$original,'status'=>'pending'];
}

function payment_receipt_review(int $receiptId,int $reviewerId,string $status,?int $paymentId=null,string $note=''): void {
    if(!payment_receipts_table_ready())throw new RuntimeException('La tabla de comprobantes no está instalada.');
    if(!in_array($status,['pending','reviewing','confirmed','rejected'],true))throw new RuntimeException('Estado inválido.');

    $pdo=db();
    $st=$pdo->prepare('SELECT order_id FROM cp_payment_receipts WHERE id=? LIMIT 1');
    $st->execute([$receiptId]);
    $receiptOrderId=(int)$st->fetchColumn();
    if(!$receiptOrderId)throw new RuntimeException('Comprobante no encontrado.');

    if($paymentId!==null){
        $st=$pdo->prepare('SELECT order_id FROM cp_payments WHERE id=? LIMIT 1');
        $st->execute([$paymentId]);
        $payment=$st->fetch();
        if(!$payment || (int)$payment['order_id']!==$receiptOrderId)throw new RuntimeException('El pago seleccionado no pertenece a esta orden.');
    }

    $st=$pdo->prepare(
      'UPDATE cp_payment_receipts SET status=?,payment_id=?,note=?,reviewed_by=?,reviewed_at=NOW(),updated_at=NOW() WHERE id=?'
    );
    $st->execute([$status,$paymentId,$note!==''?substr($note,0,4000):null,$reviewerId?:null,$receiptId]);
}
