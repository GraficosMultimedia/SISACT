<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';

header('Content-Type: application/json; charset=UTF-8');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');

function cpq_json(bool $ok, array $data = [], int $code = 200): never {
    http_response_code($code);
    echo json_encode(array_merge(['ok'=>$ok], $data), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}
function cpq_clean(string $value, int $max=5000): string {
    $value = trim($value);
    if (strlen($value) > $max) $value = substr($value, 0, $max);
    return $value;
}
function cpq_phone(string $value): string {
    return preg_replace('/[^0-9+ ()-]/', '', trim($value)) ?: '';
}
function cpq_rate_limit(): void {
    $key = hash('sha256', ($_SERVER['REMOTE_ADDR'] ?? '0.0.0.0') . '|cpq');
    $dir = sys_get_temp_dir() . '/cpq_rate';
    if (!is_dir($dir)) @mkdir($dir, 0700, true);
    $file = $dir . '/' . $key;
    $now = time();
    if (is_file($file)) {
        $last = (int)@file_get_contents($file);
        if ($last > 0 && ($now - $last) < 20) {
            cpq_json(false, ['message'=>'Espera unos segundos antes de enviar otra solicitud.'], 429);
        }
    }
    @file_put_contents($file, (string)$now, LOCK_EX);
}
function cpq_services(): array {
    return [
        'playeras'=>'Playeras personalizadas','bordado'=>'Bordado','sublimacion'=>'Sublimación','dtf'=>'DTF',
        'impresion'=>'Impresión','gran_formato'=>'Gran formato','etiquetas'=>'Etiquetas y stickers',
        'sellos'=>'Sellos personalizados','laser'=>'Grabado láser','cnc'=>'Corte CNC',
        'corporea'=>'Letras corpóreas','diseno'=>'Diseño gráfico','comestible'=>'Impresión comestible',
        'promo'=>'Artículos promocionales','vinil'=>'Vinil de corte','invitaciones'=>'Invitaciones especiales',
        'otro'=>'Otro proyecto'
    ];
}
function cpq_extension(string $name): string {
    return strtolower(pathinfo($name, PATHINFO_EXTENSION));
}
function cpq_upload(array $file, string $token): ?array {
    if (($file['error'] ?? UPLOAD_ERR_NO_FILE) === UPLOAD_ERR_NO_FILE) return null;
    if (($file['error'] ?? 0) !== UPLOAD_ERR_OK) throw new RuntimeException('No se pudo recibir el archivo.');
    $size = (int)($file['size'] ?? 0);
    if ($size <= 0 || $size > 10 * 1024 * 1024) throw new RuntimeException('Cada archivo debe pesar máximo 10 MB.');

    $original = basename((string)($file['name'] ?? 'archivo'));
    $ext = cpq_extension($original);

    $allowedExtensions = [
        'jpg','jpeg','png','webp','gif','bmp','svg',
        'pdf','doc','docx','odt','rtf','xls','xlsx','ods','csv','ppt','pptx','odp',
        'txt','md',
        'zip','rar','7z',
        'ai','eps','psd','cdr',
        'dxf','dwg','stp','step','3mf','obj','stl'
    ];
    if (!in_array($ext,$allowedExtensions,true)) {
        throw new RuntimeException('Formato no permitido: .' . ($ext ?: 'desconocido'));
    }

    $tmp=(string)$file['tmp_name'];
    $mime='';
    try { $mime=(string)(new finfo(FILEINFO_MIME_TYPE))->file($tmp); } catch(Throwable $ignore) {}

    $blockedMimes=[
        'application/x-php','text/x-php','application/x-httpd-php',
        'application/x-sh','text/x-shellscript','application/javascript','text/javascript'
    ];
    if (in_array($mime,$blockedMimes,true)) throw new RuntimeException('Ese tipo de archivo no puede subirse.');

    $dir=__DIR__ . '/../uploads/cotizador/' . $token;
    if(!is_dir($dir) && !mkdir($dir,0755,true)) throw new RuntimeException('No se pudo crear el almacenamiento del archivo.');

    $filename=bin2hex(random_bytes(16)) . '.' . $ext;
    $dest=$dir . '/' . $filename;
    if(!move_uploaded_file($tmp,$dest)) throw new RuntimeException('No se pudo guardar el archivo.');

    return [
        'original_name'=>$original,
        'relative_path'=>'/uploads/cotizador/' . $token . '/' . $filename,
        'mime'=>$mime ?: 'application/octet-stream',
        'size'=>$size,
        'extension'=>$ext,
        'sha256'=>hash_file('sha256',$dest) ?: null,
    ];
}
function cpq_files_from_request(string $field='attachments'): array {
    $files=[];
    if(empty($_FILES[$field]) || !is_array($_FILES[$field]['name'] ?? null)) return $files;
    $names=$_FILES[$field]['name'];
    foreach($names as $i=>$name){
        $files[]=[
            'name'=>$name,
            'type'=>$_FILES[$field]['type'][$i] ?? '',
            'tmp_name'=>$_FILES[$field]['tmp_name'][$i] ?? '',
            'error'=>(int)($_FILES[$field]['error'][$i] ?? UPLOAD_ERR_NO_FILE),
            'size'=>(int)($_FILES[$field]['size'][$i] ?? 0),
        ];
    }
    return $files;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') cpq_json(false,['message'=>'Método no permitido.'],405);
cpq_rate_limit();
if (!empty($_POST['website'] ?? '')) cpq_json(false,['message'=>'Solicitud rechazada.'],400);

$serviceKey=cpq_clean((string)($_POST['service'] ?? ''),80);
$services=cpq_services();
if(!isset($services[$serviceKey])) cpq_json(false,['message'=>'Selecciona un servicio válido.'],422);

$name=cpq_clean((string)($_POST['name'] ?? ''),190);
$phone=cpq_phone((string)($_POST['phone'] ?? ''));
$email=cpq_clean((string)($_POST['email'] ?? ''),190);
$desiredDate=trim((string)($_POST['desired_date'] ?? ''));
$delivery=cpq_clean((string)($_POST['delivery_method'] ?? ''),100);
$design=cpq_clean((string)($_POST['design_status'] ?? ''),100);
$application=cpq_clean((string)($_POST['application'] ?? ''),120);
$notes=cpq_clean((string)($_POST['notes'] ?? ''),4000);

if($name===''||$phone==='') cpq_json(false,['message'=>'Nombre y WhatsApp son obligatorios.'],422);
if($email!==''&&!filter_var($email,FILTER_VALIDATE_EMAIL)) cpq_json(false,['message'=>'El correo electrónico no es válido.'],422);
if($desiredDate!==''&&!preg_match('/^\d{4}-\d{2}-\d{2}$/',$desiredDate)) cpq_json(false,['message'=>'La fecha solicitada no es válida.'],422);

$serviceName=$services[$serviceKey];
$dynamic=[];
foreach($_POST as $key=>$value){
    if(!is_string($value)) continue;
    if(in_array($key,['service','service_name','name','phone','email','desired_date','delivery_method','design_status','application','notes','website'],true)) continue;
    $dynamic[$key]=cpq_clean($value,600);
}
$requestToken=bin2hex(random_bytes(32));
$storedFiles=[];

try{
    # Backward-compatible single input plus new multiple input.
    if(!empty($_FILES['attachment']) && is_array($_FILES['attachment']) && ($_FILES['attachment']['error'] ?? UPLOAD_ERR_NO_FILE)!==UPLOAD_ERR_NO_FILE){
        $one=cpq_upload($_FILES['attachment'],$requestToken);
        if($one)$storedFiles[]=$one;
    }
    foreach(cpq_files_from_request('attachments') as $f){
        $uploaded=cpq_upload($f,$requestToken);
        if($uploaded)$storedFiles[]=$uploaded;
    }
    if(count($storedFiles)>5) throw new RuntimeException('Puedes enviar hasta 5 archivos por solicitud.');
    $totalSize=array_sum(array_map(static fn($f)=>(int)$f['size'],$storedFiles));
    if($totalSize>50*1024*1024) throw new RuntimeException('El total de archivos no puede superar 50 MB.');

    $payload=[
        'version'=>3,
        'service'=>['key'=>$serviceKey,'name'=>$serviceName],
        'details'=>$dynamic,
        'production'=>['design_status'=>$design,'application'=>$application,'notes'=>$notes],
        'delivery'=>['method'=>$delivery,'desired_date'=>$desiredDate],
        'attachments'=>$storedFiles,
        'attachment'=>($storedFiles[0] ?? null),
        'submitted_at'=>date('c'),
        'source'=>'public_quote_wizard',
        'ip_hash'=>hash('sha256',(string)($_SERVER['REMOTE_ADDR'] ?? '')),
    ];

    $summary="Servicio: {$serviceName}\n";
    foreach($dynamic as $key=>$value) $summary.=$key.': '.$value."\n";
    $summary.="Diseño: {$design}\n";
    $summary.="Aplicación/instalación: {$application}\n";
    $summary.="Entrega: {$delivery}\n";
    $summary.="Fecha solicitada: ".($desiredDate!==''?$desiredDate:'Por confirmar')."\n";
    if($notes!=='')$summary.="Notas: {$notes}\n";
    if($storedFiles)$summary.="Archivos recibidos: ".count($storedFiles)."\n";
    $summary.="\n[CPQ_JSON]\n".json_encode($payload,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);

    $pdo=db();
    $st=$pdo->prepare(
      'INSERT INTO cp_web_quote_requests
      (request_token,customer_id,service_key,customer_name,email,phone,request_text,quantity,desired_date,attachment_name,status,created_at,updated_at)
      VALUES(?,NULL,?,?,?,?,?,?,?,?,?,NOW(),NOW())'
    );
    $quantity=isset($dynamic['quantity'])?(string)$dynamic['quantity']:null;
    $firstAttachmentName=$storedFiles[0]['original_name']??null;
    $st->execute([
        $requestToken,$serviceKey,$name,$email!==''?$email:null,$phone!==''?$phone:null,
        $summary,$quantity,$desiredDate!==''?$desiredDate:null,$firstAttachmentName,'new'
    ]);
    $id=(int)$pdo->lastInsertId();
    $reference='CPQ-'.str_pad((string)$id,6,'0',STR_PAD_LEFT);

    # Child file registry. Keeps one row per uploaded file.
    if($storedFiles){
        $fst=$pdo->prepare(
          'INSERT INTO cp_web_quote_files
          (request_id,original_name,stored_path,mime_type,extension,size_bytes,sha256,source,description,created_at)
          VALUES(?,?,?,?,?,?,?,?,?,NOW())'
        );
        foreach($storedFiles as $file){
            $fst->execute([
                $id,$file['original_name'],$file['relative_path'],$file['mime'],
                $file['extension'],(int)$file['size'],$file['sha256'],'public',null
            ]);
        }
    }

    try{
        $nst=$pdo->prepare(
          'INSERT INTO cp_web_quote_notifications
          (request_id,event_type,title,message,read_at,created_at)
          VALUES(?,?,?,?,NULL,NOW())'
        );
        $nst->execute([
            $id,'new_request',
            $reference.' · '.$name,
            $serviceName.' · '.$phone.($storedFiles ? ' · '.count($storedFiles).' archivo(s)' : '')
        ]);
    }catch(Throwable $ignore){}

    $message="Hola Colibrí Print México.\nQuiero dar seguimiento a la solicitud {$reference}.\n\nServicio: {$serviceName}\nNombre: {$name}\nWhatsApp: {$phone}\nEntrega: ".($delivery?:'Por confirmar')."\nFecha solicitada: ".($desiredDate?:'Por confirmar');
    $phoneDigits=preg_replace('/\D+/','',$phone);
    if($phoneDigits!==''&&!str_starts_with($phoneDigits,'52'))$phoneDigits='52'.$phoneDigits;
    if(strlen($phoneDigits)<10)$phoneDigits='526271470053';
    $waUrl='https://wa.me/526271470053?text='.rawurlencode($message);

    cpq_json(true,[
      'id'=>$id,'reference'=>$reference,'request_token'=>$requestToken,
      'message'=>'Tu solicitud quedó registrada. El equipo de Colibrí Print revisará los detalles y confirmará la cotización formal.',
      'whatsapp_url'=>$waUrl,'files_count'=>count($storedFiles)
    ],201);

}catch(Throwable $e){
    foreach($storedFiles as $file){
        if(!empty($file['relative_path'])){
            $absolute=__DIR__.'/..'.$file['relative_path'];
            if(is_file($absolute))@unlink($absolute);
        }
    }
    $message=$e instanceof RuntimeException ? $e->getMessage() : 'No se pudo registrar la solicitud. Intenta nuevamente.';
    cpq_json(false,['message'=>$message],500);
}
?>
