<?php
declare(strict_types=1);

/**
 * SISACT · Seguimiento Visual + Ofertas V1.1
 * Compatible con el seguimiento Kanban completo actual.
 */

function trackexp_v11_site_url(string $website): string
{
    $website = trim($website);
    return rtrim($website !== '' ? $website : 'https://colibriprint.com.mx', '/');
}

function trackexp_v11_whatsapp(array $company, ?array $order = null): string
{
    $phone = trim((string)($company['whatsapp'] ?? ''));
    if ($phone === '') {
        $phone = trim((string)($company['phone'] ?? ''));
    }

    $digits = preg_replace('/[^0-9]/', '', $phone) ?: '';
    if (strlen($digits) === 10) {
        $digits = '52' . $digits;
    }

    if ($digits === '') {
        return trackexp_v11_site_url((string)($company['website'] ?? '')) . '/#servicios';
    }

    $orderNumber = trim((string)($order['order_number'] ?? ''));
    $text = 'Hola Colibrí Print México, vi el seguimiento';
    if ($orderNumber !== '') {
        $text .= ' de mi pedido ' . $orderNumber;
    }
    $text .= ' y quiero conocer sus promociones y servicios actuales.';

    return 'https://wa.me/' . $digits . '?text=' . rawurlencode($text);
}

/**
 * Mismo catálogo comercial utilizado por cotizacion_pdf_publica.php V2.
 */
function trackexp_v11_offers(array $company, ?array $order = null): array
{
    $site = trackexp_v11_site_url((string)($company['website'] ?? ''));
    $catalog = $site . '/#servicios';
    $wa = trackexp_v11_whatsapp($company, $order);

    return [
        [
            'tag' => 'Más solicitado',
            'title' => 'Impresión gran formato',
            'text' => 'Lonas, viniles, stickers, etiquetas y material publicitario listo para producción.',
            'accent' => 'pink',
            'icon' => '🖨️',
            'href' => $catalog,
            'cta' => 'Ver opciones',
        ],
        [
            'tag' => 'Alta demanda',
            'title' => 'Grabado láser',
            'text' => 'Personalización en termos, placas, maderas, acrílicos y regalos empresariales.',
            'accent' => 'cyan',
            'icon' => '✨',
            'href' => $catalog,
            'cta' => 'Solicitar precio',
        ],
        [
            'tag' => 'Fabricación',
            'title' => 'Corte CNC y láser',
            'text' => 'Piezas personalizadas, letras, señalética, exhibidores y proyectos especiales.',
            'accent' => 'gold',
            'icon' => '⚙️',
            'href' => $catalog,
            'cta' => 'Explorar',
        ],
        [
            'tag' => 'Aprovecha hoy',
            'title' => 'Cotización nueva por WhatsApp',
            'text' => 'Recibe una nueva propuesta con disponibilidad, tiempos y precio actualizado.',
            'accent' => 'green',
            'icon' => '💬',
            'href' => $wa,
            'cta' => 'Pedir nueva cotización',
        ],
    ];
}

function trackexp_v11_meta(string $key): array
{
    $map = [
        'pending' => ['label'=>'Pendiente','icon'=>'📥','color'=>'cyan'],
        'received' => ['label'=>'Pedido recibido','icon'=>'📥','color'=>'cyan'],
        'design' => ['label'=>'Diseño','icon'=>'🎨','color'=>'pink'],
        'preparing' => ['label'=>'Preparando tu pedido','icon'=>'🎨','color'=>'pink'],
        'approval' => ['label'=>'Aprobación','icon'=>'✅','color'=>'gold'],
        'printing' => ['label'=>'Impresión','icon'=>'🖨️','color'=>'cyan'],
        'production' => ['label'=>'Producción','icon'=>'🔧','color'=>'blue'],
        'quality' => ['label'=>'Calidad','icon'=>'🔍','color'=>'purple'],
        'ready' => ['label'=>'Listo','icon'=>'📦','color'=>'green'],
        'delivered' => ['label'=>'Entregado','icon'=>'🚚','color'=>'green'],
        'cancelled' => ['label'=>'Cancelado','icon'=>'⛔','color'=>'red'],
    ];

    return $map[$key] ?? [
        'label' => ucfirst($key !== '' ? $key : 'Pedido'),
        'icon' => '●',
        'color' => 'cyan',
    ];
}

function trackexp_v11_time(?string $value, string $format='d/m/Y H:i'): string
{
    $value = trim((string)$value);
    if ($value === '') {
        return 'Por confirmar';
    }
    $ts = strtotime($value);
    return $ts ? date($format, $ts) : 'Por confirmar';
}

function trackexp_v11_normalize_history(array $history): array
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

        $meta = trackexp_v11_meta($key);
        $label = trim((string)($entry['label'] ?? '')) ?: $meta['label'];
        $icon = trim((string)($entry['icon'] ?? '')) ?: $meta['icon'];

        $out[] = [
            'key' => $key,
            'label' => $label,
            'icon' => $icon,
            'color' => $meta['color'],
            'note' => trim((string)($entry['note'] ?? '')),
            'created_at' => $entry['created_at'] ?? null,
        ];
    }

    return $out;
}

function trackexp_v11_build(
    ?array $order,
    array $history,
    string $currentKey,
    array $company
): array {
    $history = trackexp_v11_normalize_history($history);
    $currentKey = strtolower(trim($currentKey));
    $currentMeta = trackexp_v11_meta($currentKey);

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

    $orderKeys = [
        'pending','design','approval','printing','production','quality','ready','delivered'
    ];

    // Compatibilidad con la vista comercial antigua de 5 etapas.
    $keyMap = [
        'received'=>'pending',
        'preparing'=>'design',
    ];
    $effectiveKey = $keyMap[$currentKey] ?? $currentKey;
    $idx = array_search($effectiveKey, $orderKeys, true);
    if ($idx === false) {
        $idx = 0;
    }

    $nextMeta = $idx < count($orderKeys) - 1
        ? trackexp_v11_meta($orderKeys[$idx + 1])
        : ['label'=>'Pedido completado','icon'=>'🎉','color'=>'green'];

    $uniqueStages = [];
    foreach ($history as $entry) {
        $uniqueStages[(string)$entry['key']] = true;
    }

    $stats = [
        [
            'label'=>'Etapa actual',
            'value'=>$currentMeta['icon'] . ' ' . $currentMeta['label'],
            'hint'=>'Estado actual registrado en SISACT.',
            'tone'=>'pink',
        ],
        [
            'label'=>'Etapas registradas',
            'value'=>count($uniqueStages) . ' movimientos',
            'hint'=>'Historial visible de producción.',
            'tone'=>'cyan',
        ],
        [
            'label'=>'Última actualización',
            'value'=>$updatedAt,
            'hint'=>'Último cambio confirmado por el equipo.',
            'tone'=>'purple',
        ],
        [
            'label'=>'Próximo paso',
            'value'=>$nextMeta['icon'] . ' ' . $nextMeta['label'],
            'hint'=>'Siguiente etapa del flujo de producción.',
            'tone'=>'green',
        ],
    ];

    return [
        'history' => $history,
        'stats' => $stats,
        'current_key' => $currentKey,
        'current_meta' => $currentMeta,
        'started_at' => $startedAt,
        'updated_at' => $updatedAt,
        'next_meta' => $nextMeta,
        'offers' => trackexp_v11_offers($company, $order),
    ];
}
