<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/cotizaciones.php';
require_once __DIR__ . '/../includes/company.php';
require_once __DIR__ . '/../includes/quote_conditions.php';
require_once __DIR__ . '/../includes/quote_order_sync.php';
require_once __DIR__ . '/../includes/whatsapp.php';
require_auth();

function cp_quote_float_list(string $key): array {
    $value = $_POST[$key] ?? [];
    if (!is_array($value)) $value = [$value];
    return array_map(static fn($v) => is_numeric($v) ? (float)$v : 0.0, $value);
}

function cp_quote_string_list(string $key): array {
    $value = $_POST[$key] ?? [];
    if (!is_array($value)) $value = [$value];
    return array_map(static fn($v) => trim((string)$v), $value);
}

function cp_quote_money(float $n): string {
    return '$' . number_format($n, 2, '.', ',');
}

function cp_quote_items_normalize(array $descriptions, array $quantities, array $prices, array $sources = []): array {
    $items = [];
    $count = max(count($descriptions), count($quantities), count($prices));

    for ($i = 0; $i < $count; $i++) {
        $description = trim((string)($descriptions[$i] ?? ''));
        $quantity = max(0.001, (float)($quantities[$i] ?? 1));
        $unitPrice = max(0.0, (float)($prices[$i] ?? 0));
        $source = trim((string)($sources[$i] ?? ''));

        if ($description === '' && $unitPrice <= 0) continue;

        $items[] = [
            'description' => $description,
            'quantity' => $quantity,
            'unit_price' => $unitPrice,
            'subtotal' => round($quantity * $unitPrice, 2),
            'calculator_source' => $source !== '' ? $source : null,
            'sort_order' => count($items),
        ];
    }

    return $items;
}

if (isset($_GET['customer_search'])) {
    header('Content-Type: application/json; charset=utf-8');
    header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');

    $search = trim((string)($_GET['q'] ?? ''));
    if ($search === '' || mb_strlen($search) < 2) {
        echo json_encode([]);
        exit;
    }

    $like = '%' . $search . '%';
    $results = [];

    try {
        $st = db()->prepare(
            'SELECT id,name,email,phone,tax_number,city,state,source_type
             FROM cp_customers
             WHERE enabled=1
               AND (name LIKE ? OR email LIKE ? OR phone LIKE ? OR tax_number LIKE ?)
             ORDER BY CASE WHEN name LIKE ? THEN 0 WHEN name LIKE ? THEN 1 ELSE 2 END, name
             LIMIT 20'
        );
        $st->execute([$like, $like, $like, $like, $search . '%', $like]);

        foreach ($st->fetchAll(PDO::FETCH_ASSOC) as $row) {
            $row['source_type'] = $row['source_type'] ?: 'local';
            $results[(string)$row['id']] = $row;
        }
    } catch (Throwable $e) {
    }

    $out = array_values($results);
    usort($out, static function(array $a, array $b) use ($search): int {
        $aa = mb_strtolower((string)($a['name'] ?? ''));
        $bb = mb_strtolower((string)($b['name'] ?? ''));
        $q = mb_strtolower($search);
        $aStart = str_starts_with($aa, $q) ? 0 : 1;
        $bStart = str_starts_with($bb, $q) ? 0 : 1;
        return $aStart <=> $bStart ?: strcasecmp($aa, $bb);
    });

    echo json_encode(array_slice($out, 0, 20), JSON_UNESCAPED_UNICODE);
    exit;
}

$error = null;
$id = (int)($_GET['id'] ?? 0);
$editing = $id > 0;
$wasEditing = $editing;
$existing = $editing ? quote_get($id) : null;

if ($editing && !$existing) {
    redirect('/admin/cotizaciones.php');
}

$title = $editing ? 'Editar cotización' : 'Nueva cotización';

$selectedCustomer = null;
$customerFromQuery = (int)($_GET['customer_id'] ?? 0);
$customerId = (int)($existing['customer_id'] ?? $customerFromQuery);

if ($customerId > 0) {
    $st = db()->prepare(
        'SELECT id,name,email,phone,tax_number,city,state,source_type
         FROM cp_customers
         WHERE id=? LIMIT 1'
    );
    $st->execute([$customerId]);
    $selectedCustomer = $st->fetch(PDO::FETCH_ASSOC) ?: null;
}

$pending = quote_pending_normalize($_SESSION['cp_pending_quote'] ?? null);
$savedSource = $existing ? quote_source_from_saved($existing) : null;
$sourceData = $editing ? $savedSource : $pending;
$source = $sourceData['source'] ?? null;
$sourceResult = $sourceData['result'] ?? [];
$sourceInput = $sourceData['input'] ?? [];
$sourceTitle = $sourceData['title'] ?? quote_source_label($source);

$items = $editing ? quote_items($id) : [];
$totals = $editing ? quote_totals($id) : [];

$customerReference = (string)($existing['client_reference'] ?? '');
$paymentTerms = (string)($existing['payment_terms'] ?? '');
$deliveryTime = (string)($existing['delivery_time'] ?? '');
$deliveryPlace = (string)($existing['delivery_place'] ?? '');
$issueDate = (string)($existing['issue_date'] ?? date('Y-m-d'));
$validUntil = (string)($existing['valid_until'] ?? date('Y-m-d', strtotime('+15 days')));
$notes = (string)($existing['notes'] ?? '');
$terms = (string)($existing['terms'] ?? '');
$internalNotes = (string)($existing['internal_notes'] ?? '');

$discount = (float)($totals['discount'] ?? 0);
$discountBase = (float)($totals['subtotal'] ?? 0);
$discountPct = $discountBase > 0 ? round(($discount / $discountBase) * 100, 4) : 0.0;

$taxPct = 0.0;
$taxAmountSaved = (float)($totals['tax'] ?? 0);
$taxBaseSaved = max(0, (float)($totals['subtotal'] ?? 0) - $discount);

if ($taxBaseSaved > 0) {
    $taxPct = round(($taxAmountSaved / $taxBaseSaved) * 100, 4);
}

if (!$items) {
    $defaultDescription = $sourceTitle !== '' ? $sourceTitle : 'Nuevo concepto';
    $defaultQty = $source === 'corte_cnc' ? (float)($sourceInput['quantity'] ?? 1) : 1.0;
    $defaultPrice = (float)($sourceResult['unit_sale'] ?? $sourceResult['sale'] ?? 0);

    $items = [[
        'description' => $defaultDescription,
        'quantity' => $defaultQty,
        'unit_price' => $defaultPrice,
        'subtotal' => round($defaultQty * $defaultPrice, 2),
        'calculator_source' => $source,
        'sort_order' => 0,
    ]];
}

if (!$editing) {
    $defaultCondition = quote_condition_default();
    if ($defaultCondition) {
        $paymentTerms = (string)($defaultCondition['payment_terms'] ?? '');
        $deliveryTime = (string)($defaultCondition['delivery_time'] ?? '');
        $deliveryPlace = (string)($defaultCondition['delivery_place'] ?? '');
        $terms = (string)($defaultCondition['terms'] ?? $terms);
    }
}

$conditionTemplates = quote_condition_templates();

$previewSubtotal = 0.0;
foreach ($items as $item) {
    $previewSubtotal += round((float)$item['quantity'] * (float)$item['unit_price'], 2);
}

$discount = round($previewSubtotal * $discountPct / 100, 2);
$previewNet = max(0, $previewSubtotal - $discount);
$previewTax = round($previewNet * $taxPct / 100, 2);
$previewTotal = round($previewNet + $previewTax, 2);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión del formulario expiró. Recarga la página.';
    } else {
        $submitAction = (string)($_POST['submit_action'] ?? 'save');
        if (!in_array($submitAction, ['save', 'save_whatsapp'], true)) {
            $submitAction = 'save';
        }

        $customerId = (int)($_POST['customer_id'] ?? 0);
        $issueDate = (string)($_POST['issue_date'] ?? date('Y-m-d'));
        $validUntil = (string)($_POST['valid_until'] ?? '');
        $customerReference = trim((string)($_POST['client_reference'] ?? ''));
        $paymentTerms = trim((string)($_POST['payment_terms'] ?? ''));
        $deliveryTime = trim((string)($_POST['delivery_time'] ?? ''));
        $deliveryPlace = trim((string)($_POST['delivery_place'] ?? ''));
        $notes = trim((string)($_POST['notes'] ?? ''));
        $terms = trim((string)($_POST['terms'] ?? ''));
        $internalNotes = trim((string)($_POST['internal_notes'] ?? ''));
        $discountPct = max(0, min(100, (float)($_POST['discount'] ?? 0)));
        $discount = 0.0;
        $taxPct = max(0, min(100, (float)($_POST['tax_pct'] ?? 0)));

        $items = cp_quote_items_normalize(
            cp_quote_string_list('description'),
            cp_quote_float_list('quantity'),
            cp_quote_float_list('unit_price'),
            cp_quote_string_list('calculator_source')
        );

        $previewSubtotal = 0.0;
        foreach ($items as $item) {
            $previewSubtotal += (float)$item['subtotal'];
        }

        $discount = round($previewSubtotal * $discountPct / 100, 2);
        $previewNet = max(0, $previewSubtotal - $discount);
        $previewTax = round($previewNet * $taxPct / 100, 2);
        $previewTotal = round($previewNet + $previewTax, 2);

        $customerValid = false;
        if ($customerId > 0) {
            $st = db()->prepare('SELECT id FROM cp_customers WHERE id=? AND enabled=1 LIMIT 1');
            $st->execute([$customerId]);
            $customerValid = (bool)$st->fetchColumn();
        }

        if (!$customerValid) {
            $error = 'Selecciona un cliente activo para generar la cotización formal.';
        } elseif (!$items) {
            $error = 'Agrega al menos un concepto a la cotización.';
        } else {
            $zero = false;
            foreach ($items as $item) {
                if ((float)$item['unit_price'] <= 0) {
                    $zero = true;
                    break;
                }
            }
            if ($zero) {
                $error = 'Cada concepto debe tener un precio unitario mayor a cero.';
            }
        }

        if (!$error) {
            $internalCost = $editing
                ? (float)($totals['internal_cost'] ?? 0)
                : (float)($sourceResult['cost'] ?? 0);
            $profit = round($previewTotal - $internalCost, 2);
            $margin = $previewTotal > 0 ? round(($profit / $previewTotal) * 100, 3) : 0;

            try {
                $pdo = db();
                $pdo->beginTransaction();
                $uid = (int)(current_user()['id'] ?? 0);

                if ($editing) {
                    $st = $pdo->prepare(
                        'UPDATE cp_quotes
                         SET customer_id=?,issue_date=?,valid_until=?,client_reference=?,payment_terms=?,
                             delivery_time=?,delivery_place=?,notes=?,terms=?,internal_notes=?,
                             updated_by=?,updated_at=NOW()
                         WHERE id=?'
                    );
                    $st->execute([
                        $customerId, $issueDate, $validUntil ?: null, $customerReference ?: null,
                        $paymentTerms ?: null, $deliveryTime ?: null, $deliveryPlace ?: null,
                        $notes, $terms, $internalNotes, $uid, $id
                    ]);

                    $pdo->prepare('DELETE FROM cp_quote_items WHERE quote_id=?')->execute([$id]);
                    $pdo->prepare('DELETE FROM cp_quote_totals WHERE quote_id=?')->execute([$id]);
                    $pdo->prepare('DELETE FROM cp_quote_costs WHERE quote_id=?')->execute([$id]);
                } else {
                    $number = next_quote_number();
                    $sourceDataJson = $sourceData
                        ? json_encode($sourceData, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)
                        : null;

                    $st = $pdo->prepare(
                        'INSERT INTO cp_quotes(
                            quote_number,customer_id,status,issue_date,valid_until,client_reference,
                            payment_terms,delivery_time,delivery_place,notes,terms,internal_notes,
                            source_calculator,source_data,created_by,updated_by,created_at,updated_at
                         ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW())'
                    );

                    $st->execute([
                        $number, $customerId, 'draft', $issueDate, $validUntil ?: null,
                        $customerReference ?: null, $paymentTerms ?: null, $deliveryTime ?: null,
                        $deliveryPlace ?: null, $notes, $terms, $internalNotes, $source,
                        $sourceDataJson, $uid, $uid
                    ]);

                    $id = (int)$pdo->lastInsertId();
                    $editing = true;
                }

                $ins = $pdo->prepare(
                    'INSERT INTO cp_quote_items(
                        quote_id,description,quantity,unit_price,subtotal,
                        calculator_source,sort_order,created_at,updated_at
                     ) VALUES(?,?,?,?,?,?,?,NOW(),NOW())'
                );

                foreach ($items as $i => $item) {
                    $ins->execute([
                        $id, $item['description'], $item['quantity'], $item['unit_price'],
                        $item['subtotal'], $item['calculator_source'], $i
                    ]);
                }

                if ($sourceResult) {
                    $insCost = $pdo->prepare(
                        'INSERT INTO cp_quote_costs(quote_id,concept,amount,details,created_at)
                         VALUES(?,?,?,?,NOW())'
                    );
                    foreach (quote_source_cost_rows((string)$source, $sourceResult) as $costRow) {
                        $insCost->execute([
                            $id, $costRow[0], round((float)$costRow[1], 2), $sourceTitle
                        ]);
                    }
                }

                $pdo->prepare(
                    'INSERT INTO cp_quote_totals(
                        quote_id,subtotal,discount,tax,total,internal_cost,
                        profit,margin_pct,created_at,updated_at
                     ) VALUES(?,?,?,?,?,?,?,?,NOW(),NOW())'
                )->execute([
                    $id, $previewSubtotal, $discount, $previewTax, $previewTotal,
                    $internalCost, $profit, $margin
                ]);

                $pdo->commit();

                $syncNote = '';
                if ($wasEditing) {
                    $linkedOrder = order_for_quote($id);
                    if ($linkedOrder && quote_order_sync_allowed_status((string)$linkedOrder['status'])) {
                        try {
                            sync_order_from_quote(
                                $id, (int)$linkedOrder['id'], (int)$uid,
                                'Actualización automática desde cotización ' . $id
                            );
                            $syncNote = '&order_synced=1';
                        } catch (Throwable $syncError) {
                            $syncNote = '&order_sync_error=1';
                        }
                    } elseif ($linkedOrder) {
                        $syncNote = '&order_sync_locked=1';
                    }
                }

                unset($_SESSION['cp_pending_quote']);
                log_activity(
                    $wasEditing ? 'update' : 'create',
                    'quotes',
                    ($wasEditing ? 'Cotización actualizada ' : 'Cotización creada ') . '#' . $id
                );

                /*
                 * Guardar + WhatsApp es deliberadamente posterior al COMMIT.
                 * Así, un problema de teléfono/plantilla/WhatsApp nunca revierte
                 * ni pone en riesgo la cotización que ya quedó guardada.
                 *
                 * Tampoco cambiamos el estado a "sent": abrir WhatsApp no permite
                 * confirmar que el usuario haya pulsado Enviar dentro de WhatsApp.
                 */
                if ($submitAction === 'save_whatsapp') {
                    try {
                        $built = whatsapp_build_message('quote', $id, 'quote_sent');
                        $src = $built['source'];
                        $phone = trim((string)($src['phone'] ?? ''));

                        if ($phone === '') {
                            throw new RuntimeException('El cliente no tiene un teléfono válido para WhatsApp.');
                        }

                        whatsapp_log_prepared(
                            (string)$built['template_key'],
                            0,
                            $id,
                            (int)($src['customer_id'] ?? 0),
                            $phone,
                            (string)$built['message']
                        );

                        log_activity(
                            'whatsapp',
                            'quotes',
                            'WhatsApp preparado al guardar cotización #' . $id
                        );

                        $userAgent = (string)($_SERVER['HTTP_USER_AGENT'] ?? '');
                        $isMobile = (bool)preg_match('/Android|iPhone|iPad|iPod/i', $userAgent);
                        $whatsappUrl = (string)$built['url'];

                        if ($isMobile) {
                            $whatsappUrl = 'https://wa.me/' . rawurlencode($phone)
                                . '?text=' . rawurlencode((string)$built['message']);
                        }

                        header('Location: ' . $whatsappUrl, true, 303);
                        exit;
                    } catch (Throwable $whatsappError) {
                        error_log('[ColibriPrint][quote save+whatsapp] ' . $whatsappError->getMessage());
                        redirect('/admin/cotizacion.php?id=' . $id . '&saved=1&whatsapp_error=1' . $syncNote);
                    }
                }

                redirect('/admin/cotizacion.php?id=' . $id . '&saved=1' . $syncNote);
            } catch (Throwable $e) {
                if (isset($pdo) && $pdo->inTransaction()) {
                    $pdo->rollBack();
                }
                $error = 'No se pudo guardar la cotización. Revisa la configuración de la base de datos.';
            }
        }
    }
}

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/cotizaciones.css?v=20260919-cv2">
<link rel="stylesheet" href="/assets/css/cotizacion-nueva-v2.css?v=20260919-cv2">
<link rel="stylesheet" href="/assets/css/cotizacion-editor-mobile-v1.css?v=1.1.0">

<div class="qe-page">
    <header class="qe-editor-head">
        <div>
            <a class="qe-back-link" href="/admin/cotizaciones.php">← Cotizaciones</a>
            <span class="qe-eyebrow"><?= $editing ? 'EDITAR COTIZACIÓN' : 'NUEVA COTIZACIÓN' ?></span>
            <h2><?= $editing ? 'Editar cotización' : 'Crear cotización' ?></h2>
            <p>Captura primero cliente y conceptos. Los detalles comerciales pueden completarse después.</p>
        </div>

        <div class="qe-head-status">
            <?php if ($editing && $existing): ?>
                <span><?=e((string)$existing['quote_number'])?></span>
                <b class="status-badge status-<?=e((string)$existing['status'])?>">
                    <?=e(quote_status_label((string)$existing['status']))?>
                </b>
            <?php else: ?>
                <span>Nueva</span>
                <b>Se guardará como borrador</b>
            <?php endif; ?>
        </div>
    </header>

    <nav class="qe-progress" aria-label="Secciones de la cotización">
        <a href="#qe-client"><span>1</span> Cliente</a>
        <a href="#qe-items"><span>2</span> Conceptos</a>
        <a href="#qe-commercial"><span>3</span> Entrega y pago</a>
        <button type="button" id="qeOpenSummary"><span>4</span> Resumen</button>
    </nav>

    <?php if ($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>

    <form method="post" class="quote-form qe-form" id="quoteForm">
        <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
        <input type="hidden" name="submit_action" id="qeSubmitAction" value="save">

        <div class="quote-form-grid qe-form-grid">
            <div class="qe-main-column">
                <section class="card qe-section" id="qe-client" data-qe-section>
                    <div class="qe-section-head">
                        <div>
                            <span class="qe-eyebrow">PASO 1</span>
                            <h3>Cliente y datos básicos</h3>
                            <p>Selecciona el cliente y define la vigencia del documento.</p>
                        </div>
                        <button type="button" class="qe-section-toggle" data-qe-toggle aria-expanded="true">Ocultar</button>
                    </div>

                    <div class="qe-section-body">
                        <div class="form-grid">
                            <div class="field field-full">
                                <label for="customerSearch">Cliente <span class="required">*</span></label>
                                <div class="customer-picker">
                                    <input type="hidden" id="customerId" name="customer_id" value="<?=e((string)$customerId)?>">
                                    <input id="customerSearch" type="search" autocomplete="off"
                                           placeholder="Buscar por nombre, teléfono, correo o RFC"
                                           value="<?=e($selectedCustomer['name'] ?? '')?>">
                                    <div id="customerResults" class="customer-results" hidden></div>
                                </div>

                                <?php if ($selectedCustomer): ?>
                                    <div id="selectedCustomer" class="selected-customer">
                                        <strong><?=e($selectedCustomer['name'])?></strong>
                                        <span><?=e(trim(($selectedCustomer['email'] ?? '') . ' · ' . ($selectedCustomer['phone'] ?? '')))?></span>
                                        <button type="button" class="customer-clear" id="customerClear">Cambiar</button>
                                    </div>
                                <?php else: ?>
                                    <div id="selectedCustomer" class="selected-customer" hidden></div>
                                <?php endif; ?>

                                <div class="customer-actions qe-customer-actions">
                                    <small class="help-text">El cliente se reutiliza en PDF, WhatsApp, pedido y factura.</small>
                                    <a class="btn btn-sm btn-secondary"
                                       href="/admin/clientes.php?action=create&return_to=%2Fadmin%2Fcotizacion_nueva.php"
                                       target="_blank" rel="noopener">＋ Crear cliente</a>
                                </div>
                            </div>

                            <div class="field">
                                <label>Fecha</label>
                                <input type="date" name="issue_date" value="<?=e($issueDate)?>" required>
                            </div>

                            <div class="field">
                                <label>Vigencia hasta</label>
                                <input type="date" name="valid_until" value="<?=e($validUntil)?>">
                            </div>

                            <div class="field field-full">
                                <label>Referencia / proyecto</label>
                                <input name="client_reference" maxlength="190"
                                       value="<?=e($customerReference)?>"
                                       placeholder="Ej. lona evento, tarjetas corporativas, OC...">
                            </div>
                        </div>
                    </div>
                </section>

                <section class="card items-card qe-section qe-items-section" id="qe-items" data-qe-section>
                    <div class="qe-section-head">
                        <div>
                            <span class="qe-eyebrow">PASO 2</span>
                            <h3>Conceptos</h3>
                            <p>Agrega todos los productos o servicios incluidos en la propuesta.</p>
                        </div>
                        <div class="qe-section-actions">
                            <button type="button" class="btn btn-primary" id="addItem">＋ Agregar concepto</button>
                            <button type="button" class="qe-section-toggle" data-qe-toggle aria-expanded="true">Ocultar</button>
                        </div>
                    </div>

                    <div class="qe-section-body">
                        <div class="quote-items-head">
                            <span>Descripción</span><span>Cantidad</span><span>Precio unitario</span><span>Importe</span><span></span>
                        </div>

                        <div id="quoteItems">
                            <?php foreach ($items as $i => $item): ?>
                            <div class="quote-item-row" data-row data-item-index="<?=($i + 1)?>">
                                <div class="field">
                                    <label class="mobile-label">Descripción</label>
                                    <input name="description[]" value="<?=e((string)$item['description'])?>" required>
                                    <input type="hidden" name="calculator_source[]" value="<?=e((string)($item['calculator_source'] ?? ''))?>">
                                </div>
                                <div class="field">
                                    <label class="mobile-label">Cantidad</label>
                                    <input class="js-qty" type="number" inputmode="decimal" name="quantity[]"
                                           min="0.001" step="0.001" value="<?=e((string)$item['quantity'])?>" required>
                                </div>
                                <div class="field">
                                    <label class="mobile-label">Precio unitario</label>
                                    <input class="js-price" type="number" inputmode="decimal" name="unit_price[]"
                                           min="0" step="0.01" value="<?=e((string)$item['unit_price'])?>" required>
                                </div>
                                <div class="item-amount">
                                    <span class="mobile-label">Importe</span>
                                    <strong class="js-amount"><?=e(cp_quote_money((float)$item['subtotal']))?></strong>
                                </div>
                                <button type="button" class="item-remove" data-remove aria-label="Eliminar concepto">×</button>
                            </div>
                            <?php endforeach; ?>
                        </div>

                        <div class="items-footer qe-items-footer">
                            <button type="button" class="btn btn-secondary" id="addItemBottom">＋ Agregar otro concepto</button>
                            <span class="muted">Ejemplo: Diseño + Impresión + Instalación + Materiales.</span>
                        </div>
                    </div>
                </section>

                <section class="card qe-section" id="qe-commercial" data-qe-section data-mobile-collapsed="true">
                    <div class="qe-section-head">
                        <div>
                            <span class="qe-eyebrow">PASO 3</span>
                            <h3>Entrega, pago y condiciones</h3>
                            <p>Información comercial que aparecerá en la cotización del cliente.</p>
                        </div>
                        <button type="button" class="qe-section-toggle" data-qe-toggle aria-expanded="true">Ocultar</button>
                    </div>

                    <div class="qe-section-body">
                        <div class="condition-picker">
                            <label for="conditionTemplate">Plantilla predefinida</label>
                            <div class="condition-picker-row">
                                <select id="conditionTemplate">
                                    <option value="">Seleccionar plantilla...</option>
                                    <?php foreach ($conditionTemplates as $ct): ?>
                                    <option value="<?=e((string)$ct['id'])?>"
                                            data-payment="<?=e((string)($ct['payment_terms'] ?? ''))?>"
                                            data-delivery="<?=e((string)($ct['delivery_time'] ?? ''))?>"
                                            data-place="<?=e((string)($ct['delivery_place'] ?? ''))?>"
                                            data-terms="<?=e((string)($ct['terms'] ?? ''))?>">
                                        <?=e((string)$ct['name'])?><?=((int)$ct['is_default'] === 1 ? ' · Predeterminada' : '')?>
                                    </option>
                                    <?php endforeach; ?>
                                </select>
                                <button type="button" class="btn btn-secondary" id="applyCondition">Aplicar</button>
                                <a class="btn btn-secondary" href="/admin/condiciones_comerciales.php"
                                   target="_blank" rel="noopener">⚙ Administrar</a>
                            </div>
                            <small class="help-text">Aplicar una plantilla carga sus textos; todavía puedes editarlos antes de guardar.</small>
                        </div>

                        <div class="form-grid">
                            <div class="field">
                                <label>Condiciones de pago</label>
                                <input id="paymentTerms" name="payment_terms" maxlength="190"
                                       value="<?=e($paymentTerms)?>"
                                       placeholder="Ej. 50% anticipo + 50% contra entrega">
                            </div>
                            <div class="field">
                                <label>Tiempo de entrega</label>
                                <input id="deliveryTime" name="delivery_time" maxlength="190"
                                       value="<?=e($deliveryTime)?>" placeholder="Ej. 5 días hábiles">
                            </div>
                            <div class="field field-full">
                                <label>Lugar de entrega</label>
                                <input id="deliveryPlace" name="delivery_place" maxlength="190"
                                       value="<?=e($deliveryPlace)?>" placeholder="Ej. Domicilio / sucursal">
                            </div>
                        </div>

                        <div class="field">
                            <label>Notas para el cliente</label>
                            <textarea name="notes" rows="4" placeholder="Información adicional..."><?=e($notes)?></textarea>
                        </div>
                        <div class="field">
                            <label>Condiciones comerciales</label>
                            <textarea name="terms" rows="6" placeholder="Términos, cambios de diseño, materiales, tiempos, entregas, etc."><?=e($terms)?></textarea>
                        </div>
                        <div class="field">
                            <label>Notas internas <span class="muted">(no aparecen al cliente)</span></label>
                            <textarea name="internal_notes" rows="3" placeholder="Información interna..."><?=e($internalNotes)?></textarea>
                        </div>
                    </div>
                </section>
            </div>

            <aside class="card quote-live qe-summary" id="qeSummary" aria-label="Resumen de cotización">
                <div class="qe-summary-head">
                    <div>
                        <span class="qe-eyebrow">RESUMEN</span>
                        <h3>Vista previa comercial</h3>
                    </div>
                    <button type="button" class="qe-summary-close" id="qeSummaryClose" aria-label="Cerrar resumen">×</button>
                </div>

                <div class="live-row"><span>Subtotal</span><strong id="liveSubtotal"><?=e(cp_quote_money($previewSubtotal))?></strong></div>
                <div class="live-row"><span>Descuento</span><strong id="liveDiscount"><?=e(number_format($discountPct, 2))?>%</strong></div>
                <div class="live-row">
                    <span>Impuestos <small id="liveTaxHint"><?=e(number_format($taxPct, 2))?>%</small></span>
                    <strong id="liveTax"><?=e(cp_quote_money($previewTax))?></strong>
                </div>
                <div class="live-total"><span>Total</span><strong id="liveTotal"><?=e(cp_quote_money($previewTotal))?></strong></div>

                <div class="summary-fields">
                    <div class="field">
                        <label>Descuento (%)</label>
                        <input id="quoteDiscount" type="number" inputmode="decimal" name="discount"
                               min="0" max="100" step="0.01" value="<?=e((string)$discountPct)?>">
                    </div>
                    <div class="field">
                        <label>Impuesto (%)</label>
                        <input id="quoteTaxPct" type="number" inputmode="decimal" name="tax_pct"
                               min="0" max="100" step="0.01" value="<?=e((string)$taxPct)?>">
                    </div>
                </div>

                <?php if ($sourceResult): ?>
                <div class="internal-summary">
                    <span>🔒 Costo interno</span>
                    <strong><?=e(cp_quote_money((float)($sourceResult['cost'] ?? 0)))?></strong>
                    <small>Solo control interno.</small>
                </div>
                <?php endif; ?>

                <div class="form-actions form-actions-stack qe-save-actions">
                    <?=cancel_button('/admin/cotizaciones.php')?>
                    <?=save_button($editing ? 'Guardar cambios' : 'Guardar cotización')?>
                    <button
                        class="btn qe-whatsapp-save"
                        type="submit"
                        data-qe-submit-action="save_whatsapp"
                    >💬 Guardar y abrir WhatsApp</button>
                    <small class="qe-whatsapp-note">Guarda primero la cotización y después abre WhatsApp con la plantilla y el PDF preparados.</small>
                </div>
            </aside>
        </div>
    </form>

    <div class="qe-mobile-savebar" id="qeMobileSavebar">
        <button type="button" class="qe-mobile-total" id="qeMobileSummaryToggle">
            <span>Total</span>
            <strong id="qeMobileLiveTotal"><?=e(cp_quote_money($previewTotal))?></strong>
            <small>Ver resumen</small>
        </button>
        <div class="qe-mobile-actions">
            <button
                class="qe-mobile-save"
                type="submit"
                form="quoteForm"
                data-qe-submit-action="save"
            ><?= $editing ? 'Guardar' : 'Crear' ?></button>

            <button
                class="qe-mobile-whatsapp"
                type="submit"
                form="quoteForm"
                data-qe-submit-action="save_whatsapp"
                aria-label="Guardar cotización y abrir WhatsApp"
            >💬 WhatsApp</button>
        </div>
    </div>
</div>

<script src="/assets/js/cotizacion-nueva-v2.js?v=20260922-cv6" defer></script>
<script src="/assets/js/cotizacion-editor-mobile-v1.js?v=1.1.0" defer></script>
<?php require __DIR__ . '/../includes/footer.php'; ?>
