<?php
declare(strict_types=1);

/**
 * SISACT · Seguimiento Visual + Ofertas V1
 *
 * Mejora la experiencia pública de seguimiento con un bloque de historia
 * más visual e informativo, además de una sección comercial con ofertas
 * y servicios destacados de Colibrí Print.
 */

function trackexp_v1_catalog_url(string $website): string
{
    $website = trim($website);
    if ($website === '') {
        $website = 'https://colibriprint.com.mx';
    }
    return rtrim($website, '/') . '/#solicita-impresiones';
}

function trackexp_v1_services_url(string $website): string
{
    $website = trim($website);
    if ($website === '') {
        $website = 'https://colibriprint.com.mx';
    }
    return rtrim($website, '/') . '/#servicios';
}

function trackexp_v1_whatsapp_url(array $company, ?array $order = null): string
{
    $phone = trim((string)($company['whatsapp'] ?? ''));
    if ($phone === '') {
        $phone = trim((string)($company['phone'] ?? ''));
    }
    $digits = preg_replace('/[^0-9]/', '', $phone);
    if ($digits !== '' && strlen($digits) === 10) {
        $digits = '52' . $digits;
    }
    if ($digits === '') {
        return trackexp_v1_catalog_url((string)($company['website'] ?? ''));
    }

    $name = trim((string)($company['trade_name'] ?? '')) ?: 'Colibrí Print';
    $orderNumber = trim((string)($order['order_number'] ?? ''));
    $msg = 'Hola ' . $name . ', vi mi seguimiento';
    if ($orderNumber !== '') {
        $msg .= ' del pedido ' . $orderNumber;
    }
    $msg .= ' y me interesa conocer sus promociones y servicios actuales.';

    return 'https://wa.me/' . $digits . '?text=' . rawurlencode($msg);
}

function trackexp_v1_offer_cards(array $company, ?array $order = null): array
{
    $catalog = trackexp_v1_catalog_url((string)($company['website'] ?? ''));
    $services = trackexp_v1_services_url((string)($company['website'] ?? ''));
    $wa = trackexp_v1_whatsapp_url($company, $order);

    return [
        [
            'tag' => 'Oferta exclusiva',
            'title' => 'Impresión gran formato',
            'text' => 'Lonas, viniles, stickers, etiquetas y material publicitario listo para producción.',
            'meta' => 'Ideal para negocios, eventos y campañas de temporada.',
            'accent' => 'pink',
            'href' => $catalog,
            'cta' => 'Solicitar impresiones',
        ],
        [
            'tag' => 'Personalización',
            'title' => 'Grabado láser',
            'text' => 'Termos, placas, acrílicos, maderas, reconocimientos y regalos empresariales.',
            'meta' => 'Dale valor a tu marca con piezas únicas.',
            'accent' => 'cyan',
            'href' => $services,
            'cta' => 'Ver opciones',
        ],
        [
            'tag' => 'Fabricación',
            'title' => 'Corte CNC y láser',
            'text' => 'Letras, señalética, exhibidores y proyectos especiales con excelente acabado.',
            'meta' => 'Soluciones creativas para producción y montaje.',
            'accent' => 'gold',
            'href' => $services,
            'cta' => 'Explorar servicios',
        ],
        [
            'tag' => 'Atención directa',
            'title' => 'Nueva cotización por WhatsApp',
            'text' => 'Pregunta por precios actuales, disponibilidad y promociones vigentes para tu siguiente pedido.',
            'meta' => 'Te atendemos de forma rápida y personalizada.',
            'accent' => 'green',
            'href' => $wa,
            'cta' => 'Hablar por WhatsApp',
        ],
    ];
}

function trackexp_v1_build(
    ?array $order,
    array $history,
    array $clientHistory,
    array $clientStages,
    string $currentClient,
    string $currentInternal,
    array $company
): array {
    $timestamps = [];
    foreach ($clientHistory as $entry) {
        $created = trim((string)($entry['created_at'] ?? ''));
        if ($created !== '') {
            $ts = strtotime($created);
            if ($ts) {
                $timestamps[] = $ts;
            }
        }
    }
    sort($timestamps);
    $startedAt = $timestamps ? date('d/m/Y H:i', $timestamps[0]) : 'Pendiente';
    $lastAt = $timestamps ? date('d/m/Y H:i', $timestamps[count($timestamps)-1]) : 'Sin movimientos';

    $keys = array_values(array_keys($clientStages));
    $currentIndex = array_search($currentClient, $keys, true);
    if ($currentIndex === false) {
        $currentIndex = 0;
    }
    $nextStageLabel = 'Pedido completado';
    if (isset($keys[$currentIndex + 1], $clientStages[$keys[$currentIndex + 1]]['label'])) {
        $nextStageLabel = (string)$clientStages[$keys[$currentIndex + 1]]['label'];
    }

    $currentLabel = 'Pedido recibido';
    $currentIcon = '📦';
    if (isset($clientStages[$currentClient])) {
        $currentLabel = (string)($clientStages[$currentClient]['label'] ?? $currentLabel);
        $currentIcon = (string)($clientStages[$currentClient]['icon'] ?? $currentIcon);
    }

    $completedSteps = 0;
    foreach ($clientHistory as $entry) {
        $key = (string)($entry['key'] ?? '');
        if ($key !== '') {
            $completedSteps++;
        }
    }
    if ($completedSteps <= 0 && $order) {
        $completedSteps = 1;
    }

    $stats = [
        [
            'label' => 'Etapa actual',
            'value' => $currentIcon . ' ' . $currentLabel,
            'hint' => 'Así va tu orden en este momento.',
            'tone' => 'cyan',
        ],
        [
            'label' => 'Etapas registradas',
            'value' => (string)$completedSteps,
            'hint' => 'Movimientos visibles para tu cliente.',
            'tone' => 'pink',
        ],
        [
            'label' => 'Última actualización',
            'value' => $lastAt,
            'hint' => 'Último cambio reportado en el sistema.',
            'tone' => 'green',
        ],
        [
            'label' => 'Próximo paso',
            'value' => $nextStageLabel,
            'hint' => 'La siguiente etapa planeada del flujo.',
            'tone' => 'gold',
        ],
    ];

    return [
        'stats' => $stats,
        'offers' => trackexp_v1_offer_cards($company, $order),
        'started_at' => $startedAt,
        'updated_at' => $lastAt,
        'current_label' => $currentLabel,
        'current_icon' => $currentIcon,
        'next_label' => $nextStageLabel,
        'current_internal' => $currentInternal,
    ];
}
