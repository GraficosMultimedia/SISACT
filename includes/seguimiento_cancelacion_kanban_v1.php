<?php
declare(strict_types=1);

/**
 * SISACT · Seguimiento · Cancelación + Kanban completo V1
 *
 * Este helper NO reemplaza includes/seguimiento.php.
 * Añade una capa de validación pública y de consistencia sobre:
 *
 * - cp_orders.status
 * - cp_order_status.stage
 * - cp_quotes.status
 * - cp_order_history
 *
 * Regla:
 * Una orden se considera cancelada públicamente si cualquiera de estas
 * fuentes indica cancelación:
 *
 * 1. cp_orders.status = cancelled
 * 2. cp_order_status.stage = cancelled
 * 3. cp_quotes.status = cancelled
 *
 * Esto cubre órdenes creadas desde una cotización que después fue cancelada
 * aunque el estado operativo de producción todavía no se haya sincronizado.
 */

function tracking_guard_v1_empty_state(): array
{
    return [
        'order_status' => '',
        'quote_id' => 0,
        'quote_status' => '',
        'quote_number' => '',
        'production_stage' => 'pending',
        'current_stage' => 'pending',
        'is_cancelled' => false,
        'cancel_source' => '',
        'cancelled_at' => null,
        'cancel_note' => '',
        'stage_updated_at' => null,
    ];
}

function tracking_guard_v1_state(int $orderId): array
{
    if ($orderId <= 0) {
        return tracking_guard_v1_empty_state();
    }

    $st = db()->prepare(
        "SELECT
            o.id,
            o.status AS order_status,
            o.quote_id,
            q.status AS quote_status,
            q.quote_number,
            q.updated_at AS quote_updated_at,
            COALESCE(s.stage,'pending') AS production_stage,
            s.updated_at AS stage_updated_at
         FROM cp_orders o
         LEFT JOIN cp_quotes q
           ON q.id=o.quote_id
         LEFT JOIN cp_order_status s
           ON s.order_id=o.id
         WHERE o.id=?
         LIMIT 1"
    );

    $st->execute([$orderId]);
    $row = $st->fetch(PDO::FETCH_ASSOC);

    if (!$row) {
        return tracking_guard_v1_empty_state();
    }

    $orderStatus = strtolower(
        trim((string)($row['order_status'] ?? ''))
    );

    $quoteStatus = strtolower(
        trim((string)($row['quote_status'] ?? ''))
    );

    $productionStage = strtolower(
        trim((string)($row['production_stage'] ?? 'pending'))
    );

    $validStages = array_keys(production_stages());

    if (!in_array($productionStage, $validStages, true)) {
        $productionStage = 'pending';
    }

    $isCancelled =
        $orderStatus === 'cancelled'
        || $productionStage === 'cancelled'
        || $quoteStatus === 'cancelled';

    $cancelSource = '';

    if ($productionStage === 'cancelled') {
        $cancelSource = 'production';
    } elseif ($orderStatus === 'cancelled') {
        $cancelSource = 'order';
    } elseif ($quoteStatus === 'cancelled') {
        $cancelSource = 'quote';
    }

    $cancelledAt = null;
    $cancelNote = '';

    if ($isCancelled) {
        try {
            $hist = db()->prepare(
                "SELECT note,created_at
                 FROM cp_order_history
                 WHERE order_id=?
                   AND new_status='cancelled'
                 ORDER BY id DESC
                 LIMIT 1"
            );

            $hist->execute([$orderId]);
            $cancelRow = $hist->fetch(PDO::FETCH_ASSOC);

            if ($cancelRow) {
                $cancelledAt =
                    $cancelRow['created_at']
                    ?? null;

                $cancelNote = trim(
                    (string)(
                        $cancelRow['note']
                        ?? ''
                    )
                );
            }
        } catch (Throwable $e) {
            // La validación no debe fallar si el historial no está disponible.
        }

        if (!$cancelledAt) {
            if ($cancelSource === 'quote') {
                $cancelledAt =
                    $row['quote_updated_at']
                    ?? null;
            } else {
                $cancelledAt =
                    $row['stage_updated_at']
                    ?? null;
            }
        }

        if ($cancelNote === '') {
            if ($cancelSource === 'quote') {
                $cancelNote =
                    'La cotización vinculada a esta orden fue cancelada. '
                    . 'El pedido ya no se encuentra vigente.';
            } elseif ($cancelSource === 'production') {
                $cancelNote =
                    'La orden fue cancelada desde el flujo de producción.';
            } else {
                $cancelNote =
                    'La orden de servicio fue cancelada.';
            }
        }
    }

    /*
     * Si cp_order_status ya está en "cancelled", buscamos la última etapa
     * operativa real para que la barra muestre dónde se detuvo el pedido.
     */
    $currentStage = $productionStage;

    if ($productionStage === 'cancelled') {
        try {
            $last = db()->prepare(
                "SELECT new_status
                 FROM cp_order_history
                 WHERE order_id=?
                   AND new_status IN
                   (
                     'pending',
                     'design',
                     'approval',
                     'printing',
                     'production',
                     'quality',
                     'ready',
                     'delivered'
                   )
                 ORDER BY id DESC
                 LIMIT 1"
            );

            $last->execute([$orderId]);
            $candidate = strtolower(
                trim(
                    (string)(
                        $last->fetchColumn()
                        ?: ''
                    )
                )
            );

            if (
                in_array(
                    $candidate,
                    [
                        'pending',
                        'design',
                        'approval',
                        'printing',
                        'production',
                        'quality',
                        'ready',
                        'delivered',
                    ],
                    true
                )
            ) {
                $currentStage = $candidate;
            } else {
                $currentStage = 'pending';
            }
        } catch (Throwable $e) {
            $currentStage = 'pending';
        }
    }

    return [
        'order_status' => $orderStatus,
        'quote_id' => (int)($row['quote_id'] ?? 0),
        'quote_status' => $quoteStatus,
        'quote_number' => (string)($row['quote_number'] ?? ''),
        'production_stage' => $productionStage,
        'current_stage' => $currentStage,
        'is_cancelled' => $isCancelled,
        'cancel_source' => $cancelSource,
        'cancelled_at' => $cancelledAt,
        'cancel_note' => $cancelNote,
        'stage_updated_at' => $row['stage_updated_at'] ?? null,
    ];
}

function tracking_guard_v1_progress_stages(): array
{
    $all = production_stages();

    $keys = [
        'pending',
        'design',
        'approval',
        'printing',
        'production',
        'quality',
        'ready',
        'delivered',
    ];

    $out = [];

    foreach ($keys as $key) {
        if (!isset($all[$key])) {
            continue;
        }

        $out[$key] = $all[$key];
    }

    return $out;
}

function tracking_guard_v1_stage_meta(string $stage): array
{
    $labels = [
        'pending' => [
            'label' => 'Pendiente',
            'icon' => '📥',
            'description' =>
                'Recibimos tu pedido y está pendiente de iniciar el flujo de producción.',
        ],
        'design' => [
            'label' => 'Diseño',
            'icon' => '🎨',
            'description' =>
                'Estamos preparando, revisando o ajustando el diseño de tu pedido.',
        ],
        'approval' => [
            'label' => 'Aprobación',
            'icon' => '✅',
            'description' =>
                'El diseño se encuentra en revisión o aprobación antes de continuar.',
        ],
        'printing' => [
            'label' => 'Impresión',
            'icon' => '🖨️',
            'description' =>
                'Tu pedido está en proceso de impresión.',
        ],
        'production' => [
            'label' => 'Producción',
            'icon' => '🔧',
            'description' =>
                'Tu pedido está en fabricación o proceso de producción.',
        ],
        'quality' => [
            'label' => 'Calidad',
            'icon' => '🔍',
            'description' =>
                'Estamos revisando acabados, calidad y detalles finales.',
        ],
        'ready' => [
            'label' => 'Listo',
            'icon' => '📦',
            'description' =>
                'Tu pedido está terminado y listo para entrega.',
        ],
        'delivered' => [
            'label' => 'Entregado',
            'icon' => '🚚',
            'description' =>
                'Tu pedido fue entregado. Gracias por confiar en Colibrí Print.',
        ],
        'cancelled' => [
            'label' => 'Cancelado',
            'icon' => '⛔',
            'description' =>
                'La orden fue cancelada y el proceso quedó detenido.',
        ],
    ];

    return $labels[$stage]
        ?? $labels['pending'];
}

function tracking_guard_v1_history(
    int $orderId,
    array $state
): array {
    if ($orderId <= 0) {
        return [];
    }

    $rows = [];

    try {
        $st = db()->prepare(
            "SELECT
                new_status,
                note,
                created_at
             FROM cp_order_history
             WHERE order_id=?
               AND new_status IN
               (
                 'pending',
                 'design',
                 'approval',
                 'printing',
                 'production',
                 'quality',
                 'ready',
                 'delivered',
                 'cancelled'
               )
             ORDER BY id DESC"
        );

        $st->execute([$orderId]);
        $raw = $st->fetchAll(PDO::FETCH_ASSOC) ?: [];

        foreach ($raw as $entry) {
            $key = strtolower(
                trim(
                    (string)(
                        $entry['new_status']
                        ?? ''
                    )
                )
            );

            $meta = tracking_guard_v1_stage_meta($key);

            $rows[] = [
                'key' => $key,
                'label' => $meta['label'],
                'icon' => $meta['icon'],
                'note' => trim(
                    (string)(
                        $entry['note']
                        ?? ''
                    )
                ),
                'created_at' =>
                    $entry['created_at']
                    ?? null,
            ];
        }
    } catch (Throwable $e) {
        $rows = [];
    }

    /*
     * Cotización cancelada con orden todavía operativa:
     * generamos un evento visual sintético para el cliente.
     */
    if (
        !empty($state['is_cancelled'])
        && ($state['cancel_source'] ?? '') === 'quote'
    ) {
        $hasCancelled = false;

        foreach ($rows as $entry) {
            if (($entry['key'] ?? '') === 'cancelled') {
                $hasCancelled = true;
                break;
            }
        }

        if (!$hasCancelled) {
            array_unshift(
                $rows,
                [
                    'key' => 'cancelled',
                    'label' => 'Cancelado',
                    'icon' => '⛔',
                    'note' => (string)(
                        $state['cancel_note']
                        ?? 'La cotización vinculada fue cancelada.'
                    ),
                    'created_at' =>
                        $state['cancelled_at']
                        ?? null,
                ]
            );
        }
    }

    return $rows;
}

function tracking_guard_v1_assert_active(int $orderId): void
{
    $state = tracking_guard_v1_state($orderId);

    if (!empty($state['is_cancelled'])) {
        throw new RuntimeException(
            'Esta orden fue cancelada y ya no acepta nuevas operaciones.'
        );
    }
}
