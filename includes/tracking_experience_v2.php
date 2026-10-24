<?php
declare(strict_types=1);

/**
 * SISACT · Seguimiento Visual + Ofertas V2 Premium
 *
 * Capa visual sobre V1.1.
 * No modifica estados, pagos, CFDI, Kanban ni base de datos.
 */

function trackexp_v2_meta(string $key): array
{
    $map = [
        'pending' => ['label'=>'Pendiente','icon'=>'📥','tone'=>'cyan','message'=>'Tu orden fue recibida y está lista para iniciar su recorrido de producción.'],
        'received' => ['label'=>'Pedido recibido','icon'=>'📥','tone'=>'cyan','message'=>'Recibimos tu pedido y comenzamos a preparar su expediente.'],
        'design' => ['label'=>'Diseño','icon'=>'🎨','tone'=>'pink','message'=>'Estamos revisando, preparando o ajustando el diseño antes de producir.'],
        'preparing' => ['label'=>'Preparando tu pedido','icon'=>'🎨','tone'=>'pink','message'=>'Estamos preparando los detalles necesarios para que tu pedido avance correctamente.'],
        'approval' => ['label'=>'Aprobación','icon'=>'✅','tone'=>'gold','message'=>'El diseño está listo para revisión y aprobación antes de pasar a producción.'],
        'printing' => ['label'=>'Impresión','icon'=>'🖨️','tone'=>'cyan','message'=>'Tu trabajo ya está en impresión y estamos produciendo tus piezas.'],
        'production' => ['label'=>'Producción','icon'=>'🔧','tone'=>'blue','message'=>'Estamos fabricando, armando o terminando los elementos de tu pedido.'],
        'quality' => ['label'=>'Calidad','icon'=>'🔍','tone'=>'purple','message'=>'Revisamos acabados y detalles finales antes de liberar tu pedido.'],
        'ready' => ['label'=>'Listo','icon'=>'📦','tone'=>'green','message'=>'Tu pedido terminó producción y está listo para entrega.'],
        'delivered' => ['label'=>'Entregado','icon'=>'🚚','tone'=>'green','message'=>'Tu pedido fue entregado. Gracias por confiar en Colibrí Print México.'],
        'cancelled' => ['label'=>'Cancelado','icon'=>'⛔','tone'=>'red','message'=>'La orden fue cancelada y el proceso quedó detenido.'],
    ];

    $key = strtolower(trim($key));

    return $map[$key] ?? [
        'label' => ucfirst($key !== '' ? $key : 'Pedido'),
        'icon' => '●',
        'tone' => 'cyan',
        'message' => 'Tu pedido tiene una actualización registrada en SISACT.',
    ];
}

function trackexp_v2_normalize_history(array $history): array
{
    $out = [];

    foreach ($history as $entry) {
        if (!is_array($entry)) {
            continue;
        }

        $key = strtolower(trim((string)($entry['key'] ?? $entry['new_status'] ?? '')));
        if ($key === '') {
            continue;
        }

        $meta = trackexp_v2_meta($key);
        $out[] = [
            'key' => $key,
            'label' => trim((string)($entry['label'] ?? '')) ?: $meta['label'],
            'icon' => trim((string)($entry['icon'] ?? '')) ?: $meta['icon'],
            'tone' => $meta['tone'],
            'note' => trim((string)($entry['note'] ?? '')) ?: $meta['message'],
            'created_at' => $entry['created_at'] ?? null,
        ];
    }

    return $out;
}

function trackexp_v2_site_url(array $company): string
{
    $website = trim((string)($company['website'] ?? ''));
    return rtrim($website !== '' ? $website : 'https://colibriprint.com.mx', '/');
}

function trackexp_v2_whatsapp(array $company, ?array $order = null): string
{
    $phone = trim((string)($company['whatsapp'] ?? ''));
    if ($phone === '') {
        $phone = trim((string)($company['phone'] ?? ''));
    }

    $digits = preg_replace('/[^0-9]/', '', $phone) ?: '';
    if (strlen($digits) === 10) {
        $digits = '52' . $digits;
    }

    $site = trackexp_v2_site_url($company);
    if ($digits === '') {
        return $site . '/#solicita-impresiones';
    }

    $orderNumber = trim((string)($order['order_number'] ?? ''));
    $message = 'Hola Colibrí Print México, estoy revisando';
    if ($orderNumber !== '') {
        $message .= ' mi pedido ' . $orderNumber;
    } else {
        $message .= ' mi seguimiento';
    }
    $message .= ' y quiero conocer promociones y opciones para mi próximo proyecto.';

    return 'https://wa.me/' . $digits . '?text=' . rawurlencode($message);
}

function trackexp_v2_duration(array $history): string
{
    $times = [];
    foreach ($history as $entry) {
        $ts = strtotime((string)($entry['created_at'] ?? ''));
        if ($ts) {
            $times[] = $ts;
        }
    }

    if (count($times) < 2) {
        return 'En proceso';
    }

    sort($times);
    $seconds = max(0, $times[count($times)-1] - $times[0]);
    $minutes = (int)floor($seconds / 60);

    if ($minutes < 60) {
        return max(1, $minutes) . ' min';
    }

    $hours = (int)floor($minutes / 60);
    $remainingMinutes = $minutes % 60;

    if ($hours < 24) {
        return $hours . ' h' . ($remainingMinutes > 0 ? ' ' . $remainingMinutes . ' min' : '');
    }

    $days = (int)floor($hours / 24);
    $remainingHours = $hours % 24;
    return $days . ' día' . ($days !== 1 ? 's' : '') . ($remainingHours > 0 ? ' ' . $remainingHours . ' h' : '');
}

function trackexp_v2_offers(array $company, ?array $order = null): array
{
    $site = trackexp_v2_site_url($company);
    $catalog = $site . '/#servicios';
    $request = $site . '/#solicita-impresiones';
    $wa = trackexp_v2_whatsapp($company, $order);

    /*
     * No se inventan descuentos ni precios. Estas tarjetas son la misma
     * selección comercial usada por la experiencia pública de cotizaciones.
     */
    return [
        [
            'tag'=>'Más solicitado',
            'eyebrow'=>'IMPRESIÓN',
            'title'=>'Gran formato que hace visible tu marca',
            'text'=>'Lonas, viniles, stickers, etiquetas y material publicitario para campañas, eventos y negocios.',
            'accent'=>'pink',
            'icon'=>'🖨️',
            'href'=>$request,
            'cta'=>'Solicitar impresiones',
            'benefit'=>'Pregunta por promociones vigentes',
        ],
        [
            'tag'=>'Alta demanda',
            'eyebrow'=>'PERSONALIZACIÓN',
            'title'=>'Grabado láser para piezas únicas',
            'text'=>'Termos, placas, maderas, acrílicos, reconocimientos y regalos empresariales personalizados.',
            'accent'=>'cyan',
            'icon'=>'✨',
            'href'=>$catalog,
            'cta'=>'Explorar grabado',
            'benefit'=>'Ideal para regalos y branding',
        ],
        [
            'tag'=>'Fabricación',
            'eyebrow'=>'TALLER',
            'title'=>'Corte CNC y láser para proyectos especiales',
            'text'=>'Letras, señalética, exhibidores, piezas y soluciones fabricadas a la medida de tu proyecto.',
            'accent'=>'gold',
            'icon'=>'⚙️',
            'href'=>$catalog,
            'cta'=>'Ver fabricación',
            'benefit'=>'Producción personalizada',
        ],
        [
            'tag'=>'Atención directa',
            'eyebrow'=>'SIGUIENTE PROYECTO',
            'title'=>'Nueva cotización por WhatsApp',
            'text'=>'Cuéntanos qué necesitas y consulta precio, disponibilidad, tiempos y promociones actuales.',
            'accent'=>'green',
            'icon'=>'💬',
            'href'=>$wa,
            'cta'=>'Cotizar por WhatsApp',
            'benefit'=>'Respuesta personalizada',
        ],
    ];
}

function trackexp_v2_build(
    ?array $order,
    array $history,
    string $currentKey,
    array $company,
    bool $isCancelled = false
): array {
    $history = trackexp_v2_normalize_history($history);
    $currentKey = strtolower(trim($currentKey));

    $stageKeys = [
        'pending','design','approval','printing','production','quality','ready','delivered'
    ];
    $compat = [
        'received'=>'pending',
        'preparing'=>'design',
    ];

    $effectiveKey = $compat[$currentKey] ?? $currentKey;
    $idx = array_search($effectiveKey, $stageKeys, true);
    if ($idx === false) {
        $idx = 0;
    }

    $progress = (int)round((($idx + 1) / count($stageKeys)) * 100);
    if ($effectiveKey === 'delivered') {
        $progress = 100;
    }
    if ($isCancelled) {
        $progress = max(1, min(100, $progress));
    }

    $currentMeta = trackexp_v2_meta($isCancelled ? 'cancelled' : $currentKey);

    $nextMeta = $idx < count($stageKeys) - 1
        ? trackexp_v2_meta($stageKeys[$idx + 1])
        : ['label'=>'Pedido completado','icon'=>'🎉','tone'=>'green','message'=>'Tu pedido completó todo el recorrido de producción.'];

    if ($isCancelled) {
        $nextMeta = ['label'=>'Proceso detenido','icon'=>'⛔','tone'=>'red','message'=>'La orden se encuentra cancelada.'];
    }

    $times = [];
    foreach ($history as $entry) {
        $ts = strtotime((string)($entry['created_at'] ?? ''));
        if ($ts) {
            $times[] = $ts;
        }
    }
    sort($times);

    $startedAt = $times ? date('d/m/Y H:i', $times[0]) : 'Por confirmar';
    $updatedAt = $times ? date('d/m/Y H:i', $times[count($times)-1]) : 'Sin movimientos';

    $unique = [];
    foreach ($history as $entry) {
        $unique[(string)$entry['key']] = true;
    }

    $orderNumber = trim((string)($order['order_number'] ?? 'Orden de servicio'));
    $customerName = trim((string)($order['customer_name'] ?? $order['customer'] ?? ''));

    $headline = $effectiveKey === 'delivered'
        ? '¡Tu pedido completó su recorrido!'
        : 'Tu pedido está avanzando';

    if ($isCancelled) {
        $headline = 'Esta orden fue cancelada';
    }

    return [
        'history'=>$history,
        'offers'=>trackexp_v2_offers($company, $order),
        'current_key'=>$currentKey,
        'current_meta'=>$currentMeta,
        'next_meta'=>$nextMeta,
        'progress_pct'=>$progress,
        'started_at'=>$startedAt,
        'updated_at'=>$updatedAt,
        'duration'=>trackexp_v2_duration($history),
        'movement_count'=>count($history),
        'stage_count'=>count($unique),
        'order_number'=>$orderNumber,
        'customer_name'=>$customerName,
        'headline'=>$headline,
        'is_complete'=>$effectiveKey === 'delivered',
        'is_cancelled'=>$isCancelled,
        'site_url'=>trackexp_v2_site_url($company),
        'whatsapp_url'=>trackexp_v2_whatsapp($company, $order),
    ];
}
