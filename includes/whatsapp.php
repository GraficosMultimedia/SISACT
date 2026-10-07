<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/company.php';
require_once __DIR__ . '/cotizaciones.php';
require_once __DIR__ . '/ordenes.php';
require_once __DIR__ . '/produccion.php';
require_once __DIR__ . '/seguimiento.php';
require_once __DIR__ . '/promociones.php';

/**
 * CENTRO DE WHATSAPP · Plantillas oficiales.
 *
 * Los mensajes de servicio y los mensajes comerciales permanecen separados.
 * Las plantillas sirven como formato base y pueden editarse desde el Centro.
 */
function whatsapp_default_templates(): array {
    return [
        'quote_sent' => [
            'name' => 'Cotización enviada',
            'category' => 'service',
            'body' => "Hola {cliente} 👋\n\nGracias por confiar en {empresa}. Te compartimos la cotización {folio}.\n\n💰 Total cotizado: {total}\n📅 Vigencia: {vigencia}\n\n📄 Ver y descargar tu cotización en PDF:\n{pdf_url}\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\n{empresa}",
        ],
        'order_confirmed' => [
            'name' => 'Pedido confirmado',
            'category' => 'service',
            'body' => "Hola {cliente} 👋\n\nTu pedido {orden} ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: {total}\n📅 Fecha compromiso: {fecha_entrega}\n\n🔎 Consulta el avance de tu pedido:\n{seguimiento}\n\nGracias por confiar en {empresa}.",
        ],
        'design_ready' => [
            'name' => 'Diseño listo',
            'category' => 'service',
            'body' => "Hola {cliente} 👋\n\n🎨 El diseño de tu pedido {orden} ya está listo para revisión.\n\nPuedes consultar el avance de tu pedido aquí:\n{seguimiento}\n\nSi necesitas algún ajuste, respóndenos por este mismo medio.\n\n{empresa}",
        ],
        'design_approval' => [
            'name' => 'Aprobación de diseño',
            'category' => 'service',
            'body' => "Hola {cliente} 👋\n\n🎨 El diseño de tu pedido {orden} está listo para aprobación.\n\nPara autorizar la producción, responde a este mensaje con *APROBADO*. Si necesitas cambios, indícanos cuáles para revisarlos contigo.\n\n🔎 Seguimiento del pedido:\n{seguimiento}\n\n{empresa}",
        ],
        'printing' => [
            'name' => 'En impresión',
            'category' => 'service',
            'body' => "Hola {cliente} 👋\n\n🖨️ Tu pedido {orden} ya se encuentra en impresión. Estamos avanzando con tu trabajo.\n\n🔎 Consulta el avance aquí:\n{seguimiento}\n\n{empresa}",
        ],
        'in_production' => [
            'name' => 'En producción',
            'category' => 'service',
            'body' => "Hola {cliente} 👋\n\n🔧 Tu pedido {orden} ya se encuentra en producción. Nuestro equipo está trabajando en los detalles de tu trabajo.\n\n🔎 Consulta el avance aquí:\n{seguimiento}\n\n{empresa}",
        ],
        'quality_review' => [
            'name' => 'Control de calidad',
            'category' => 'service',
            'body' => "Hola {cliente} 👋\n\n✅ Tu pedido {orden} está en revisión final de calidad antes de pasar a entrega.\n\n🔎 Consulta el avance aquí:\n{seguimiento}\n\nTe avisaremos en cuanto esté listo.\n\n{empresa}",
        ],
        'finished' => [
            'name' => 'Trabajo terminado',
            'category' => 'service',
            'body' => "Hola {cliente} 👋\n\n✅ Tu pedido {orden} terminó su proceso de producción.\n\nEstamos preparando la entrega y te avisaremos cuando esté listo para recoger o entregar.\n\n🔎 Seguimiento:\n{seguimiento}\n\n{empresa}",
        ],
        'ready_delivery' => [
            'name' => 'Listo para entrega',
            'category' => 'service',
            'body' => "Hola {cliente} 👋\n\n🚚 ¡Tu pedido {orden} ya está listo para entrega!\n\n📅 Fecha compromiso: {fecha_entrega}\n\n🔎 Consulta los detalles aquí:\n{seguimiento}\n\nGracias por confiar en {empresa}.",
        ],
        'delivered' => [
            'name' => 'Entregado',
            'category' => 'service',
            'body' => "Hola {cliente} 👋\n\n🎉 Tu pedido {orden} ha sido entregado correctamente.\n\nGracias por confiar en {empresa}. Esperamos seguir trabajando contigo.",
        ],
        'promotion_offer' => [
            'name' => 'Promoción comercial',
            'category' => 'commercial',
            'body' => "✨ {label}: {promotion_title}\n\n{promotion_description}\n\n💥 Precio promocional: {promo_price}\n🏷️ Precio normal: {normal_price}\n🎯 Descuento: {discount}\n📅 Vigencia: {vigencia_promocion}\n📦 Disponibilidad: {availability}\n\n🌐 {website}\n\n{empresa}",
        ],
    ];
}

function whatsapp_templates(bool $includeInactive = true): array {
    $defaults = whatsapp_default_templates();
    try {
        $sql='SELECT * FROM cp_whatsapp_templates';
        if(!$includeInactive) $sql.=' WHERE active=1';
        $sql.=' ORDER BY id';
        $rows=db()->query($sql)->fetchAll();
        $map=[];
        foreach($rows as $row) $map[(string)$row['template_key']]=$row;
        $result=[];
        foreach($defaults as $key=>$default){
            $result[]=$map[$key] ?? [
                'template_key'=>$key,
                'name'=>$default['name'],
                'category'=>$default['category'],
                'body'=>$default['body'],
                'active'=>1,
            ];
        }
        foreach($rows as $row){
            $key=(string)$row['template_key'];
            if(!isset($defaults[$key])) $result[]=$row;
        }
        if(!$includeInactive) $result=array_values(array_filter($result,static fn($r)=>(int)($r['active']??0)===1));
        return $result;
    } catch(Throwable $e) {
        return array_map(
            static fn($t,$k)=>[
                'template_key'=>$k,
                'name'=>$t['name'],
                'category'=>$t['category'],
                'body'=>$t['body'],
                'active'=>1,
            ],
            $defaults,
            array_keys($defaults)
        );
    }
}

function whatsapp_template(string $key): array {
    $defaults=whatsapp_default_templates();
    try{
        $st=db()->prepare('SELECT * FROM cp_whatsapp_templates WHERE template_key=? LIMIT 1');
        $st->execute([$key]);
        $row=$st->fetch();
        if($row) return $row;
    }catch(Throwable $e){}
    if(isset($defaults[$key])) return [
        'template_key'=>$key,
        'name'=>$defaults[$key]['name'],
        'category'=>$defaults[$key]['category'],
        'body'=>$defaults[$key]['body'],
        'active'=>1,
    ];
    throw new RuntimeException('Plantilla de WhatsApp no encontrada.');
}

function whatsapp_stage_template_key(string $stage): string {
    return [
        'pending'=>'order_confirmed',
        'design'=>'design_ready',
        'approval'=>'design_approval',
        'printing'=>'printing',
        'production'=>'in_production',
        'quality'=>'quality_review',
        'ready'=>'ready_delivery',
        'delivered'=>'delivered',
    ][$stage] ?? 'order_confirmed';
}

function whatsapp_phone(string $phone): string {
    $digits=preg_replace('/\D+/','',$phone)??'';
    if($digits==='') return '';
    if(strlen($digits)===10) return '52'.$digits;
    return ltrim($digits,'+');
}

function whatsapp_absolute_url(string $path): string {
    $c=company_profile();
    $base=rtrim((string)($c['website']?:'https://colibriprint.com.mx'),'/');
    if(preg_match('~^https?://~i',$path)) return $path;
    return $base.'/'.ltrim($path,'/');
}

function whatsapp_context_company(): array {
    $c=company_profile();
    return [
        'empresa'=>(string)($c['trade_name']?:($c['legal_name']?:'Colibrí Print México')),
        'website'=>rtrim((string)($c['website']?:'https://colibriprint.com.mx'),'/'),
        'telefono'=>(string)($c['phone']??''),
        'correo'=>(string)($c['email']??''),
    ];
}

function whatsapp_quote_public_token(int $quoteId): string {
    $st=db()->prepare('SELECT token FROM cp_quote_public_tokens WHERE quote_id=? AND active=1 LIMIT 1');
    $st->execute([$quoteId]);
    $token=$st->fetchColumn();
    if(is_string($token)&&preg_match('/^[a-f0-9]{64}$/i',$token)) return $token;
    for($i=0;$i<3;$i++){
        $token=bin2hex(random_bytes(32));
        try{
            db()->prepare('INSERT INTO cp_quote_public_tokens(quote_id,token,active,created_at) VALUES(?,?,1,NOW())')->execute([$quoteId,$token]);
            return $token;
        }catch(Throwable $e){ if($i===2) throw $e; }
    }
    throw new RuntimeException('No se pudo generar el enlace seguro del PDF.');
}

function whatsapp_quote_public_pdf_url(int $quoteId): string {
    return whatsapp_absolute_url('/cotizacion_pdf_publica.php?t='.rawurlencode(whatsapp_quote_public_token($quoteId)));
}

function whatsapp_context_for_quote(array $quote): array {
    $company=whatsapp_context_company();
    $tot=quote_totals((int)$quote['id']);
    return array_merge($company,[
        'cliente'=>trim((string)($quote['customer_name']??'')) ?: 'Cliente',
        'orden'=>'',
        'folio'=>(string)($quote['quote_number']??''),
        'total'=>quote_money((float)($tot['total']??0)),
        'fecha'=>!empty($quote['issue_date'])?date('d/m/Y',strtotime((string)$quote['issue_date'])):date('d/m/Y'),
        'vigencia'=>!empty($quote['valid_until'])?date('d/m/Y',strtotime((string)$quote['valid_until'])):'Por confirmar',
        'fecha_entrega'=>(string)($quote['delivery_time']??'Por confirmar'),
        'seguimiento'=>'',
        'pdf_url'=>whatsapp_quote_public_pdf_url((int)$quote['id']),
    ]);
}

function whatsapp_tracking_url_for_order(int $orderId): string {
    if($orderId<=0) return '';

    /*
     * The tracking URL is generated here as a hard dependency of WhatsApp.
     * This avoids a blank {seguimiento} when an older tracking helper is
     * missing/stale or when an order has not received a token yet.
     */
    try {
        $pdo=db();
        $st=$pdo->prepare('SELECT token FROM cp_tracking_tokens WHERE order_id=? AND active=1 LIMIT 1');
        $st->execute([$orderId]);
        $token=$st->fetchColumn();

        if(!is_string($token) || !preg_match('/^[a-f0-9]{64}$/i',$token)) {
            for($i=0;$i<3;$i++) {
                $candidate=bin2hex(random_bytes(32));
                try {
                    $pdo->prepare('INSERT INTO cp_tracking_tokens(order_id,token,active,created_at) VALUES(?,?,1,NOW())')
                        ->execute([$orderId,$candidate]);
                    $token=$candidate;
                    break;
                } catch(Throwable $e) {
                    /* Another request may have created the token concurrently. */
                    $st->execute([$orderId]);
                    $existing=$st->fetchColumn();
                    if(is_string($existing) && preg_match('/^[a-f0-9]{64}$/i',$existing)) {
                        $token=$existing;
                        break;
                    }
                    if($i===2) throw $e;
                }
            }
        }

        if(!is_string($token) || !preg_match('/^[a-f0-9]{64}$/i',$token)) return '';
        return whatsapp_absolute_url('/seguimiento.php?t='.rawurlencode($token));
    } catch(Throwable $e) {
        return '';
    }
}

function whatsapp_context_for_order(array $order): array {
    $company=whatsapp_context_company();
    $tracking=whatsapp_tracking_url_for_order((int)($order['id']??0));
    return array_merge($company,[
        'cliente'=>trim((string)($order['customer_name']??'')) ?: 'Cliente',
        'orden'=>(string)($order['order_number']??''),
        'folio'=>(string)($order['quote_number']??''),
        'total'=>quote_money((float)($order['total']??0)),
        'fecha'=>!empty($order['order_date'])?date('d/m/Y',strtotime((string)$order['order_date'])):date('d/m/Y'),
        'fecha_entrega'=>!empty($order['due_date'])?date('d/m/Y',strtotime((string)$order['due_date'])):'Por confirmar',
        'seguimiento'=>$tracking,
        'seguimiento_url'=>$tracking,
        'pdf_url'=>'',
        'stage'=>isset($order['status']) ? (string)$order['status'] : '',
        'stage_label'=>isset($order['status']) ? (function(string $s): string { try { return order_status_label($s); } catch(Throwable $e) { return $s; } })((string)$order['status']) : '',
    ]);
}

/**
 * Obtiene la promoción directamente de sus tablas para evitar que un cambio
 * en la capa de presentación deje vacíos los datos del mensaje.
 */
function whatsapp_promotion_record(int $promotionId): array {
    $st=db()->prepare(
        'SELECT p.id,p.title,p.label,p.description,p.promo_type,p.normal_price,p.promo_price,
                p.discount_percent,p.quantity_available,p.start_date,p.end_date,p.image_path,
                p.whatsapp_text,p.status,p.show_web,p.show_catalog,p.show_whatsapp
         FROM cp_promotions p
         WHERE p.id=?
         LIMIT 1'
    );
    $st->execute([$promotionId]);
    $row=$st->fetch();
    if(!$row) throw new RuntimeException('La promoción no existe.');
    return $row;
}

function whatsapp_context_for_promotion(array $promotion): array {
    $company=whatsapp_context_company();
    $normal=isset($promotion['normal_price'])&&$promotion['normal_price']!==null&&$promotion['normal_price']!==''
        ? promotion_format_price((float)$promotion['normal_price']) : '';
    $promo=isset($promotion['promo_price'])&&$promotion['promo_price']!==null&&$promotion['promo_price']!==''
        ? promotion_format_price((float)$promotion['promo_price']) : '';
    $discount=isset($promotion['discount_percent'])&&$promotion['discount_percent']!==null&&$promotion['discount_percent']!==''
        ? number_format((float)$promotion['discount_percent'],2,'.','').' %' : '';
    $start=!empty($promotion['start_date'])?date('d/m/Y',strtotime((string)$promotion['start_date'])):'';
    $end=!empty($promotion['end_date'])?date('d/m/Y',strtotime((string)$promotion['end_date'])):'';
    $vig=$start===''
        ? ''
        : ($end!=='' ? $start.' al '.$end : 'Desde '.$start);
    $qty=(array_key_exists('quantity_available',$promotion)&&$promotion['quantity_available']!==null&&$promotion['quantity_available']!=='')
        ? number_format((int)$promotion['quantity_available'],0,'.',',') : '';

    $context=array_merge($company,[
        'cliente'=>'','orden'=>'','folio'=>'','total'=>$promo,'fecha'=>date('d/m/Y'),
        'vigencia'=>'','fecha_entrega'=>'','seguimiento'=>'','pdf_url'=>'',
        'label'=>trim((string)($promotion['label']??'')) ?: 'OFERTA',
        'promotion_title'=>trim((string)($promotion['title']??'')) ?: 'Promoción',
        'promotion_description'=>trim((string)($promotion['description']??'')),
        'promo_price'=>$promo,
        'normal_price'=>$normal,
        'discount'=>$discount,
        'vigencia_promocion'=>$vig,
        'availability'=>$qty,
        'imagen'=>!empty($promotion['image_path']) ? whatsapp_absolute_url((string)$promotion['image_path']) : '',
    ]);

    // Alias para plantillas antiguas. Así ningún cambio previo deja campos vacíos.
    $context['precio_promocional']=$context['promo_price'];
    $context['precio_normal']=$context['normal_price'];
    $context['descuento']=$context['discount'];
    $context['vigencia']=$context['vigencia_promocion'];
    $context['disponibilidad']=$context['availability'];
    $context['titulo_promocion']=$context['promotion_title'];
    $context['descripcion_promocion']=$context['promotion_description'];

    return $context;
}

/**
 * Renderiza por líneas y elimina la línea completa cuando los placeholders
 * de esa línea están vacíos. Esto evita salidas como "Precio promocional:"
 * sin valor.
 */
function whatsapp_render(string $body,array $context): string {
    $lines=preg_split("/\r\n|\r|\n/",$body) ?: [];
    $out=[];
    foreach($lines as $line){
        preg_match_all('/\{([a-zA-Z0-9_]+)\}/',$line,$m);
        $keys=$m[1]??[];
        if($keys){
            $hasValue=false;
            foreach($keys as $key){
                if(isset($context[$key]) && trim((string)$context[$key])!=='') { $hasValue=true; break; }
            }
            if(!$hasValue) continue;
        }
        $out[]=strtr($line,array_combine(array_map(static fn($k)=>'{'.$k.'}',$keys),array_map(static fn($k)=>(string)($context[$k]??''),$keys)) ?: []);
    }
    $message=trim(implode("\n",$out));
    $message=preg_replace('/\{[a-zA-Z0-9_]+\}/','',$message)??$message;
    $message=preg_replace("/\n{3,}/","\n\n",$message)??$message;
    return trim($message);
}

function whatsapp_source(string $type,int $id): array {
    if($id<=0) throw new RuntimeException('Selecciona un registro.');
    if($type==='quote'){
        $row=quote_get($id); if(!$row) throw new RuntimeException('La cotización no existe.');
        return [
            'type'=>'quote','id'=>$id,'label'=>(string)$row['quote_number'],'record'=>$row,
            'context'=>whatsapp_context_for_quote($row),
            'phone'=>whatsapp_phone((string)($row['customer_phone']??'')),
            'customer_id'=>(int)($row['customer_id']??0),
        ];
    }
    if($type==='order'){
        $row=order_get($id); if(!$row) throw new RuntimeException('La orden no existe.');
        return [
            'type'=>'order','id'=>$id,'label'=>(string)$row['order_number'],'record'=>$row,
            'context'=>whatsapp_context_for_order($row),
            'phone'=>whatsapp_phone((string)($row['customer_phone']??'')),
            'customer_id'=>(int)($row['customer_id']??0),
        ];
    }
    if($type==='promotion'){
        $row=whatsapp_promotion_record($id);
        return [
            'type'=>'promotion','id'=>$id,'label'=>(string)$row['title'],'record'=>$row,
            'context'=>whatsapp_context_for_promotion($row),'phone'=>'','customer_id'=>0,
        ];
    }
    throw new RuntimeException('Tipo de comunicación no válido.');
}

function whatsapp_allowed_template_for_source(string $type,string $key): bool {
    try{$t=whatsapp_template($key);}catch(Throwable $e){return false;}
    if($type==='promotion') return (string)$t['category']==='commercial';
    return (string)$t['category']==='service';
}

function whatsapp_build_message(string $type,int $id,string $templateKey=''): array {
    $src=whatsapp_source($type,$id);
    if($templateKey==='') $templateKey=$type==='promotion'?'promotion_offer':($type==='order'?'order_confirmed':'quote_sent');
    if($type==='order'){
        if($templateKey==='stage_auto') $templateKey=whatsapp_stage_template_key((string)($src['record']['status']??'pending'));
    }
    if(!whatsapp_allowed_template_for_source($type,$templateKey)) throw new RuntimeException('La plantilla seleccionada no corresponde a este tipo de comunicación.');
    $template=whatsapp_template($templateKey);
    if(empty($template['active'])) throw new RuntimeException('Esta plantilla está desactivada.');

    // Si la promoción tiene un texto comercial personalizado, se respeta.
    if($type==='promotion' && trim((string)($src['record']['whatsapp_text']??''))!==''){
        $body=(string)$src['record']['whatsapp_text'];
    } else {
        $body=(string)$template['body'];
    }

    $message=whatsapp_render($body,$src['context']);
    return [
        'source'=>$src,
        'template'=>$template,
        'template_key'=>$templateKey,
        'message'=>$message,
        'url'=>whatsapp_url_for_message($src['phone'],$message),
    ];
}

function whatsapp_url_for_message(string $phone,string $message): string {
    return $phone!==''
        ? 'https://web.whatsapp.com/send?phone='.$phone.'&text='.rawurlencode($message)
        : 'https://web.whatsapp.com/send?text='.rawurlencode($message);
}

function whatsapp_log_prepared(string $templateKey,int $orderId,int $quoteId,int $customerId,string $phone,string $message): void {
    try{
        db()->prepare('INSERT INTO cp_whatsapp_log(template_key,order_id,quote_id,customer_id,phone,message,status,prepared_by,created_at) VALUES(?,?,?,?,?,?,?, ?,NOW())')
            ->execute([$templateKey,$orderId?:null,$quoteId?:null,$customerId?:null,$phone,$message,'prepared',(int)(current_user()['id']??0)?:null]);
    }catch(Throwable $e){}
}

function whatsapp_prepare_redirect(string $templateKey,int $orderId=0,int $quoteId=0): void {
    $type=$orderId>0?'order':'quote'; $id=$orderId>0?$orderId:$quoteId;
    $built=whatsapp_build_message($type,$id,$templateKey);
    $src=$built['source'];
    whatsapp_log_prepared(
        $built['template_key'],
        $orderId,
        $quoteId,
        (int)$src['customer_id'],
        (string)$src['phone'],
        (string)$built['message']
    );
    header('Location: '.$built['url'],true,302); exit;
}

function whatsapp_quote_share_data(int $quoteId): array {
    $built=whatsapp_build_message('quote',$quoteId,'quote_sent');
    return [
        'phone'=>$built['source']['phone'],
        'message'=>$built['message'],
        'whatsapp_web'=>$built['url'],
        'pdf_url'=>whatsapp_quote_public_pdf_url($quoteId),
        'file_name'=>(string)$built['source']['record']['quote_number'].'.pdf',
        'public_token'=>whatsapp_quote_public_token($quoteId),
    ];
}
