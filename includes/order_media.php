<?php
declare(strict_types=1);

function order_photos_table_ready(): bool {
    static $ready = null;
    if ($ready !== null) return $ready;
    try {
        $st = db()->query("SHOW TABLES LIKE 'cp_order_photos'");
        $ready = (bool)$st->fetchColumn();
    } catch (Throwable $e) {
        $ready = false;
    }
    return $ready;
}

function order_photos(int $orderId): array {
    if ($orderId <= 0 || !order_photos_table_ready()) return [];
    $st = db()->prepare('SELECT p.*, u.name AS created_by_name FROM cp_order_photos p LEFT JOIN cp_users u ON u.id=p.created_by WHERE p.order_id=? ORDER BY p.id DESC');
    $st->execute([$orderId]);
    return $st->fetchAll();
}

function order_photo_upload(array $file, int $orderId, int $userId, string $type, string $caption): string {
    if (!order_photos_table_ready()) throw new RuntimeException('La galería de fotos todavía no está instalada. Ejecuta la migración 018_order_photos.sql.');
    if (($file['error'] ?? UPLOAD_ERR_NO_FILE) === UPLOAD_ERR_NO_FILE) throw new RuntimeException('Selecciona una imagen.');
    if (($file['error'] ?? 0) !== UPLOAD_ERR_OK) throw new RuntimeException('No se pudo subir la imagen.');
    if ((int)($file['size'] ?? 0) > 8 * 1024 * 1024) throw new RuntimeException('La imagen supera el máximo de 8 MB.');

    $tmp = (string)($file['tmp_name'] ?? '');
    if ($tmp === '' || !is_uploaded_file($tmp)) throw new RuntimeException('Archivo de imagen no válido.');

    $finfo = new finfo(FILEINFO_MIME_TYPE);
    $mime = (string)$finfo->file($tmp);
    $allowed = [
        'image/jpeg' => 'jpg',
        'image/png' => 'png',
        'image/webp' => 'webp'
    ];
    if (!isset($allowed[$mime])) throw new RuntimeException('Formato no permitido. Usa JPG, PNG o WEBP.');
    if (@getimagesize($tmp) === false) throw new RuntimeException('El archivo no parece ser una imagen válida.');

    $validTypes = ['reference', 'design', 'production', 'delivery'];
    if (!in_array($type, $validTypes, true)) $type = 'reference';

    $dir = __DIR__ . '/../uploads/orders/' . $orderId;
    if (!is_dir($dir) && !mkdir($dir, 0755, true)) throw new RuntimeException('No se pudo crear la carpeta de fotos de la orden.');
    $name = bin2hex(random_bytes(18)) . '.' . $allowed[$mime];
    $dest = $dir . '/' . $name;
    if (!move_uploaded_file($tmp, $dest)) throw new RuntimeException('No se pudo guardar la imagen.');

    $path = '/uploads/orders/' . $orderId . '/' . $name;
    try {
        $st = db()->prepare('INSERT INTO cp_order_photos(order_id,file_path,original_name,mime_type,file_size,photo_type,caption,created_by,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?,NOW(),NOW())');
        $st->execute([$orderId, $path, (function_exists('mb_substr') ? mb_substr((string)($file['name'] ?? $name), 0, 190) : substr((string)($file['name'] ?? $name), 0, 190)), $mime, (int)$file['size'], $type, $caption !== '' ? $caption : null, $userId ?: null]);
    } catch (Throwable $e) {
        @unlink($dest);
        throw $e;
    }
    return $path;
}

function order_photo_delete(int $photoId, int $orderId): void {
    if ($photoId <= 0 || $orderId <= 0 || !order_photos_table_ready()) throw new RuntimeException('Foto no encontrada.');
    $st = db()->prepare('SELECT file_path FROM cp_order_photos WHERE id=? AND order_id=? LIMIT 1');
    $st->execute([$photoId, $orderId]);
    $path = (string)($st->fetchColumn() ?: '');
    if ($path === '') throw new RuntimeException('Foto no encontrada.');

    $base = realpath(__DIR__ . '/../uploads/orders/' . $orderId);
    $file = realpath(__DIR__ . '/..' . $path);
    if ($base && $file && str_starts_with($file, $base . DIRECTORY_SEPARATOR) && is_file($file)) @unlink($file);
    db()->prepare('DELETE FROM cp_order_photos WHERE id=? AND order_id=?')->execute([$photoId, $orderId]);
}


function order_file_types(): array {
    return [
        'reference' => 'Referencia del cliente',
        'design' => 'Diseño / aprobación',
        'production' => 'Archivo técnico / producción',
        'delivery' => 'Entrega / resultado final',
        'document' => 'Documento',
        'technical' => 'Archivo técnico',
        'client_file' => 'Archivo recibido del cliente',
        'other' => 'Otro archivo',
    ];
}

function order_file_extension(string $name): string {
    $ext=strtolower((string)pathinfo($name,PATHINFO_EXTENSION));
    return $ext!=='' ? $ext : 'archivo';
}

function order_file_is_image(array $fileOrRow): bool {
    $mime=(string)($fileOrRow['mime_type']??'');
    return str_starts_with($mime,'image/') && in_array($mime,[
        'image/jpeg','image/png','image/webp','image/gif','image/bmp','image/svg+xml'
    ],true);
}

function order_file_icon(array $fileOrRow): string {
    $mime=strtolower((string)($fileOrRow['mime_type']??''));
    $ext=order_file_extension((string)($fileOrRow['original_name']??''));
    if(str_starts_with($mime,'image/')) return '🖼️';
    if($mime==='application/pdf'||$ext==='pdf') return '📕';
    if(in_array($ext,['doc','docx','odt','rtf'],true)) return '📘';
    if(in_array($ext,['xls','xlsx','csv','ods'],true)) return '📗';
    if(in_array($ext,['ppt','pptx','odp'],true)) return '📙';
    if(in_array($ext,['zip','rar','7z','tar','gz'],true)) return '🗜️';
    if(in_array($ext,['ai','eps','psd','cdr','svg'],true)) return '🎨';
    if(in_array($ext,['dxf','dwg','stp','step','3mf','obj','stl'],true)) return '⚙️';
    if(in_array($ext,['txt','log','md'],true)) return '📄';
    return '📎';
}

function order_file_type_label(string $type): string {
    $types=order_file_types();
    return $types[$type]??'Archivo';
}

function order_file_upload(array $file,int $orderId,int $userId,string $type,string $caption): string {
    if(!order_photos_table_ready()) throw new RuntimeException('El almacenamiento de archivos de la orden no está instalado.');
    $error=(int)($file['error']??UPLOAD_ERR_NO_FILE);
    if($error===UPLOAD_ERR_NO_FILE) throw new RuntimeException('Selecciona un archivo.');
    if($error!==UPLOAD_ERR_OK) throw new RuntimeException('No se pudo recibir el archivo.');

    $size=(int)($file['size']??0);
    if($size<=0) throw new RuntimeException('El archivo está vacío.');
    if($size>25*1024*1024) throw new RuntimeException('El archivo supera el máximo de 25 MB.');

    $tmp=(string)($file['tmp_name']??'');
    if($tmp===''||!is_uploaded_file($tmp)) throw new RuntimeException('Archivo de carga no válido.');

    $original=trim((string)($file['name']??'archivo'));
    if($original==='') $original='archivo';
    if(strlen($original)>190) $original=substr($original,0,190);

    $ext=order_file_extension($original);
    $allowed=[
        'jpg'=>1,'jpeg'=>1,'png'=>1,'webp'=>1,'gif'=>1,'bmp'=>1,'svg'=>1,
        'pdf'=>1,
        'doc'=>1,'docx'=>1,'odt'=>1,'rtf'=>1,
        'xls'=>1,'xlsx'=>1,'csv'=>1,'ods'=>1,
        'ppt'=>1,'pptx'=>1,'odp'=>1,
        'txt'=>1,'log'=>1,'md'=>1,
        'zip'=>1,'rar'=>1,'7z'=>1,'tar'=>1,'gz'=>1,
        'ai'=>1,'eps'=>1,'psd'=>1,'cdr'=>1,
        'dxf'=>1,'dwg'=>1,'stp'=>1,'step'=>1,'3mf'=>1,'obj'=>1,'stl'=>1
    ];
    if(!isset($allowed[$ext])) throw new RuntimeException('Formato no permitido. Usa PDF, Word, Excel, PowerPoint, imágenes, CSV/TXT, ZIP/RAR o archivos de diseño/CAD.');

    $mime=(string)(new finfo(FILEINFO_MIME_TYPE))->file($tmp);
    $mimes=[
        'image/jpeg'=>1,'image/png'=>1,'image/webp'=>1,'image/gif'=>1,'image/bmp'=>1,'image/svg+xml'=>1,
        'application/pdf'=>1,'application/msword'=>1,
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document'=>1,
        'application/vnd.oasis.opendocument.text'=>1,'application/rtf'=>1,'text/rtf'=>1,
        'application/vnd.ms-excel'=>1,'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'=>1,
        'application/vnd.oasis.opendocument.spreadsheet'=>1,'text/csv'=>1,'text/plain'=>1,'text/markdown'=>1,
        'application/vnd.ms-powerpoint'=>1,'application/vnd.openxmlformats-officedocument.presentationml.presentation'=>1,
        'application/vnd.oasis.opendocument.presentation'=>1,
        'application/zip'=>1,'application/x-zip-compressed'=>1,'application/x-rar-compressed'=>1,
        'application/vnd.rar'=>1,'application/x-7z-compressed'=>1,'application/x-tar'=>1,'application/gzip'=>1,
        'application/postscript'=>1,'image/vnd.adobe.photoshop'=>1,'application/dxf'=>1,
        'model/stl'=>1,'model/obj'=>1,'application/octet-stream'=>1
    ];
    if(!isset($mimes[$mime]) && !in_array($ext,['txt','csv','md','log','dxf','dwg','ai','eps','psd','cdr','stp','step','3mf','obj','stl'],true)){
        throw new RuntimeException('El contenido del archivo no coincide con un formato admitido.');
    }

    $types=array_keys(order_file_types());
    if(!in_array($type,$types,true)) $type='client_file';

    if(in_array($mime,['image/jpeg','image/png','image/webp','image/gif','image/bmp'],true) && @getimagesize($tmp)===false){
        throw new RuntimeException('El archivo de imagen no es válido.');
    }

    $dir=__DIR__.'/../uploads/orders/'.$orderId;
    if(!is_dir($dir)&&!mkdir($dir,0755,true)) throw new RuntimeException('No se pudo crear la carpeta de archivos.');

    $name=bin2hex(random_bytes(18)).'.'.$ext;
    $dest=$dir.'/'.$name;
    if(!move_uploaded_file($tmp,$dest)) throw new RuntimeException('No se pudo guardar el archivo.');

    $path='/uploads/orders/'.$orderId.'/'.$name;
    try{
        $st=db()->prepare(
            'INSERT INTO cp_order_photos(order_id,file_path,original_name,mime_type,file_size,photo_type,caption,created_by,created_at,updated_at)
             VALUES(?,?,?,?,?,?,?,?,NOW(),NOW())'
        );
        $st->execute([$orderId,$path,$original,$mime,$size,$type,$caption!==''?$caption:null,$userId?:null]);
    }catch(Throwable $e){
        @unlink($dest);
        throw $e;
    }
    return $path;
}
