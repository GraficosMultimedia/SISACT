<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/ordenes.php';
require_once __DIR__ . '/../includes/finanzas.php';
require_auth();

$id = (int)($_GET['id'] ?? $_POST['id'] ?? 0);
$order = order_get($id);
if (!$order) redirect('/admin/ordenes.php');

$title = 'Editar ' . $order['order_number'];
$error = null;
$canEdit = in_array((string)$order['status'], ['pending','in_progress'], true);

try {
    $customersStmt = db()->prepare(
        'SELECT id,name,phone,email,enabled
         FROM cp_customers
         WHERE enabled=1 OR id=?
         ORDER BY name
         LIMIT 1000'
    );
    $customersStmt->execute([(int)($order['customer_id'] ?? 0)]);
    $customers = $customersStmt->fetchAll();
} catch (Throwable $e) {
    $customers = [];
    $error = 'No se pudieron cargar los clientes.';
}

try {
    $users = db()->query('SELECT id,name FROM cp_users ORDER BY name')->fetchAll();
} catch (Throwable $e) {
    $users = [];
    $error = $error ?: 'No se pudieron cargar los responsables.';
}

$items = order_items($id);
$financeSummary = finance_tables_ready() ? finance_order_summary($id) : [
    'paid_total'=>0.0,'payment_count'=>0,'invoice_count'=>0
];

$form = [
    'customer_id' => (int)($order['customer_id'] ?? 0),
    'order_date' => (string)($order['order_date'] ?? date('Y-m-d')),
    'due_date' => (string)($order['due_date'] ?? ''),
    'responsible_user_id' => (int)($order['responsible_user_id'] ?? 0),
    'notes' => (string)($order['notes'] ?? ''),
    'internal_notes' => (string)($order['internal_notes'] ?? ''),
];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión del formulario expiró. Recarga la página.';
    } elseif (!$canEdit) {
        $error = 'Esta orden está cerrada y se conserva como histórico. Solo pueden editarse órdenes Pendientes o En proceso.';
    } else {
        $form = [
            'customer_id' => (int)($_POST['customer_id'] ?? 0),
            'order_date' => trim((string)($_POST['order_date'] ?? '')),
            'due_date' => trim((string)($_POST['due_date'] ?? '')),
            'responsible_user_id' => (int)($_POST['responsible_user_id'] ?? 0),
            'notes' => trim((string)($_POST['notes'] ?? '')),
            'internal_notes' => trim((string)($_POST['internal_notes'] ?? '')),
        ];

        $postedIds = $_POST['item_id'] ?? [];
        $postedQuoteIds = $_POST['quote_item_id'] ?? [];
        $descriptions = $_POST['description'] ?? [];
        $quantities = $_POST['quantity'] ?? [];
        $prices = $_POST['unit_price'] ?? [];

        $normalizedItems = [];
        $count = max(count($descriptions), count($quantities), count($prices));

        try {
            if ($form['customer_id'] < 1) {
                throw new RuntimeException('Selecciona un cliente.');
            }

            $customerCheck = db()->prepare('SELECT id FROM cp_customers WHERE id=? LIMIT 1');
            $customerCheck->execute([$form['customer_id']]);
            if (!$customerCheck->fetchColumn()) {
                throw new RuntimeException('El cliente seleccionado no existe.');
            }

            $date = DateTime::createFromFormat('Y-m-d', $form['order_date']);
            if (!$date || $date->format('Y-m-d') !== $form['order_date']) {
                throw new RuntimeException('La fecha de la orden no es válida.');
            }

            if ($form['due_date'] !== '') {
                $due = DateTime::createFromFormat('Y-m-d', $form['due_date']);
                if (!$due || $due->format('Y-m-d') !== $form['due_date']) {
                    throw new RuntimeException('La fecha compromiso no es válida.');
                }
            }

            if ($form['responsible_user_id'] > 0) {
                $userCheck = db()->prepare('SELECT id FROM cp_users WHERE id=? LIMIT 1');
                $userCheck->execute([$form['responsible_user_id']]);
                if (!$userCheck->fetchColumn()) {
                    throw new RuntimeException('El responsable seleccionado no existe.');
                }
            }

            $newTotal = 0.0;
            for ($i=0; $i<$count; $i++) {
                $description = trim((string)($descriptions[$i] ?? ''));
                $qtyRaw = str_replace(',', '', trim((string)($quantities[$i] ?? '0')));
                $priceRaw = str_replace(',', '', trim((string)($prices[$i] ?? '0')));

                // Filas completamente vacías se ignoran.
                if ($description === '' && ((float)$qtyRaw) == 0.0 && ((float)$priceRaw) == 0.0) {
                    continue;
                }

                $qty = round((float)$qtyRaw, 3);
                $price = round((float)$priceRaw, 2);

                if ($description === '') {
                    throw new RuntimeException('Todos los conceptos deben tener descripción.');
                }
                if ($qty <= 0) {
                    throw new RuntimeException('La cantidad de cada concepto debe ser mayor a cero.');
                }
                if ($price < 0) {
                    throw new RuntimeException('El precio unitario no puede ser negativo.');
                }

                $subtotal = round($qty * $price, 2);
                $newTotal = round($newTotal + $subtotal, 2);

                $normalizedItems[] = [
                    'id' => (int)($postedIds[$i] ?? 0),
                    'quote_item_id' => (int)($postedQuoteIds[$i] ?? 0) ?: null,
                    'description' => $description,
                    'quantity' => $qty,
                    'unit_price' => $price,
                    'subtotal' => $subtotal,
                ];
            }

            if (!$normalizedItems) {
                throw new RuntimeException('La orden debe conservar al menos un concepto.');
            }

            $pdo = db();
            $pdo->beginTransaction();

            $lock = $pdo->prepare('SELECT * FROM cp_orders WHERE id=? FOR UPDATE');
            $lock->execute([$id]);
            $current = $lock->fetch();
            if (!$current) {
                throw new RuntimeException('La orden ya no existe.');
            }

            if (!in_array((string)$current['status'], ['pending','in_progress'], true)) {
                throw new RuntimeException('La orden cambió de estado y ya no puede editarse.');
            }

            // Seguridad financiera: nunca crear un saldo negativo.
            $paidTotal = 0.0;
            $paymentCount = 0;
            $invoiceCount = 0;
            $issuedInvoiceCount = 0;

            if (finance_tables_ready()) {
                $pay = $pdo->prepare("SELECT COALESCE(SUM(amount),0),COUNT(*) FROM cp_payments WHERE order_id=? AND status='confirmed'");
                $pay->execute([$id]);
                [$paidTotal,$paymentCount] = $pay->fetch(PDO::FETCH_NUM) ?: [0,0];
                $paidTotal = (float)$paidTotal;
                $paymentCount = (int)$paymentCount;

                $inv = $pdo->prepare("SELECT COUNT(*),SUM(CASE WHEN status='issued' THEN 1 ELSE 0 END) FROM cp_invoices WHERE order_id=?");
                $inv->execute([$id]);
                [$invoiceCount,$issuedInvoiceCount] = $inv->fetch(PDO::FETCH_NUM) ?: [0,0];
                $invoiceCount = (int)$invoiceCount;
                $issuedInvoiceCount = (int)$issuedInvoiceCount;

                if ($newTotal + 0.009 < $paidTotal) {
                    throw new RuntimeException(
                        'El nuevo total no puede ser menor que los pagos confirmados ($' .
                        number_format($paidTotal,2,'.',',') . ').'
                    );
                }

                if ($issuedInvoiceCount > 0 && abs($newTotal - (float)$current['total']) > 0.009) {
                    throw new RuntimeException('La orden tiene una factura emitida. Cancela o corrige la factura antes de cambiar el total.');
                }

                if (($paymentCount > 0 || $invoiceCount > 0)
                    && (int)$current['customer_id'] !== $form['customer_id']) {
                    throw new RuntimeException('La orden ya tiene movimientos financieros. No es seguro cambiar el cliente desde este editor.');
                }
            }

            $uid = (int)(current_user()['id'] ?? 0);

            $pdo->prepare(
                'UPDATE cp_orders
                 SET customer_id=?,order_date=?,due_date=?,responsible_user_id=?,
                     total=?,notes=?,internal_notes=?,updated_by=?,updated_at=NOW()
                 WHERE id=?'
            )->execute([
                $form['customer_id'],
                $form['order_date'],
                $form['due_date'] ?: null,
                $form['responsible_user_id'] ?: null,
                $newTotal,
                $form['notes'],
                $form['internal_notes'],
                $uid ?: null,
                $id
            ]);

            $existingStmt = $pdo->prepare(
                'SELECT id FROM cp_order_items WHERE order_id=? ORDER BY sort_order,id'
            );
            $existingStmt->execute([$id]);
            $existingIds = array_map('intval', array_column($existingStmt->fetchAll(), 'id'));
            $keptIds = [];

            $updateItem = $pdo->prepare(
                'UPDATE cp_order_items
                 SET quote_item_id=?,description=?,quantity=?,unit_price=?,subtotal=?,sort_order=?,updated_at=NOW()
                 WHERE id=? AND order_id=?'
            );
            $insertItem = $pdo->prepare(
                'INSERT INTO cp_order_items
                 (order_id,quote_item_id,description,quantity,unit_price,subtotal,sort_order,created_at,updated_at)
                 VALUES(?,?,?,?,?,?,?,NOW(),NOW())'
            );

            foreach ($normalizedItems as $sort=>$item) {
                if ($item['id'] > 0 && in_array($item['id'], $existingIds, true)) {
                    $updateItem->execute([
                        $item['quote_item_id'],
                        $item['description'],
                        $item['quantity'],
                        $item['unit_price'],
                        $item['subtotal'],
                        $sort,
                        $item['id'],
                        $id
                    ]);
                    $keptIds[] = $item['id'];
                } else {
                    $insertItem->execute([
                        $id,
                        $item['quote_item_id'],
                        $item['description'],
                        $item['quantity'],
                        $item['unit_price'],
                        $item['subtotal'],
                        $sort
                    ]);
                }
            }

            foreach ($existingIds as $existingId) {
                if (!in_array($existingId, $keptIds, true)) {
                    $del = $pdo->prepare('DELETE FROM cp_order_items WHERE id=? AND order_id=?');
                    $del->execute([$existingId,$id]);
                }
            }

            $changes = [];
            if ((int)$current['customer_id'] !== $form['customer_id']) $changes[] = 'cliente';
            if ((string)$current['order_date'] !== $form['order_date']) $changes[] = 'fecha';
            if ((string)($current['due_date'] ?? '') !== $form['due_date']) $changes[] = 'fecha compromiso';
            if ((int)($current['responsible_user_id'] ?? 0) !== $form['responsible_user_id']) $changes[] = 'responsable';
            if (abs((float)$current['total'] - $newTotal) > 0.009) $changes[] = 'total';
            $changes[] = 'conceptos/datos operativos';

            $historyNote = 'Orden editada manualmente';
            if ($changes) $historyNote .= ': ' . implode(', ', array_values(array_unique($changes)));

            $pdo->prepare(
                'INSERT INTO cp_order_history
                 (order_id,old_status,new_status,note,changed_by,created_at)
                 VALUES(?,?,?,?,?,NOW())'
            )->execute([
                $id,
                (string)$current['status'],
                (string)$current['status'],
                $historyNote,
                $uid ?: null
            ]);

            $pdo->commit();

            log_activity(
                'update',
                'orders',
                'Orden editada ' . $current['order_number'] . ' · total $' . number_format($newTotal,2,'.','')
            );

            redirect('/admin/orden.php?id='.$id.'&edited=1');

        } catch (Throwable $e) {
            if (isset($pdo) && $pdo->inTransaction()) $pdo->rollBack();
            $error = $e->getMessage();
        }

        // Reconstruir filas desde POST si hubo error.
        if ($error) {
            $items = [];
            for ($i=0; $i<$count; $i++) {
                $description = (string)($descriptions[$i] ?? '');
                $qty = (string)($quantities[$i] ?? '');
                $price = (string)($prices[$i] ?? '');
                if (trim($description)==='' && trim($qty)==='' && trim($price)==='') continue;
                $items[] = [
                    'id'=>(int)($postedIds[$i] ?? 0),
                    'quote_item_id'=>(int)($postedQuoteIds[$i] ?? 0) ?: null,
                    'description'=>$description,
                    'quantity'=>$qty,
                    'unit_price'=>$price,
                    'subtotal'=>round((float)str_replace(',','',$qty) * (float)str_replace(',','',$price),2),
                ];
            }
        }
    }
}

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/ordenes.css?v=20260917-9b">
<link rel="stylesheet" href="/assets/css/sisact-design-system-v1.css?v=1.0.1">
<link rel="stylesheet" href="/assets/css/orden-editor-v1.css?v=1.0.0">

<div class="oe-page">
  <div class="order-toolbar oe-hero">
    <div>
      <span class="eyebrow">ORDEN DE SERVICIO · EDICIÓN</span>
      <h2><?=e($order['order_number'])?></h2>
      <p class="muted">
        Cotización de origen:
        <a href="/admin/cotizacion.php?id=<?=((int)$order['quote_id'])?>"><?=e($order['quote_number'] ?: 'Sin cotización')?></a>
        · Estado: <?=e(order_status_label((string)$order['status']))?>
      </p>
    </div>
    <div class="order-toolbar-actions">
      <a class="btn btn-secondary" href="/admin/orden.php?id=<?=((int)$id)?>">Cancelar</a>
    </div>
  </div>

  <?php if(!$canEdit): ?>
    <div class="notice danger oe-lock">
      <strong>🔒 Orden cerrada.</strong>
      Solo pueden editarse órdenes en estado <b>Pendiente</b> o <b>En proceso</b>.
      Esta orden se conserva como histórico.
    </div>
    <div class="oe-lock-actions">
      <a class="btn btn-primary" href="/admin/orden.php?id=<?=((int)$id)?>">Volver a la orden</a>
    </div>
  <?php else: ?>

  <?php if($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>

  <form method="post" id="orderEditForm">
    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
    <input type="hidden" name="id" value="<?=((int)$id)?>">

    <div class="oe-layout">
      <main>
        <section class="card oe-section">
          <div class="oe-section-head">
            <div>
              <span class="eyebrow">1 · DATOS GENERALES</span>
              <h3>Cliente y fechas</h3>
            </div>
            <span class="oe-origin">Folio protegido: <?=e($order['order_number'])?></span>
          </div>

          <div class="oe-grid">
            <div class="field full">
              <label for="customer_id">Cliente</label>
              <select name="customer_id" id="customer_id" required>
                <option value="">Selecciona un cliente</option>
                <?php foreach($customers as $customer): ?>
                  <option value="<?=((int)$customer['id'])?>" <?=((int)$form['customer_id']===(int)$customer['id']?'selected':'')?>>
                    <?=e($customer['name'])?>
                    <?=!empty($customer['phone']) ? ' · '.e($customer['phone']) : ''?>
                    <?=((int)$customer['enabled']===0 ? ' · INACTIVO' : '')?>
                  </option>
                <?php endforeach; ?>
              </select>
            </div>

            <div class="field">
              <label for="order_date">Fecha de orden</label>
              <input type="date" id="order_date" name="order_date" value="<?=e($form['order_date'])?>" required>
            </div>

            <div class="field">
              <label for="due_date">Fecha compromiso</label>
              <input type="date" id="due_date" name="due_date" value="<?=e($form['due_date'])?>">
            </div>

            <div class="field full">
              <label for="responsible_user_id">Responsable</label>
              <select id="responsible_user_id" name="responsible_user_id">
                <option value="0">Sin asignar</option>
                <?php foreach($users as $user): ?>
                  <option value="<?=((int)$user['id'])?>" <?=((int)$form['responsible_user_id']===(int)$user['id']?'selected':'')?>>
                    <?=e($user['name'])?>
                  </option>
                <?php endforeach; ?>
              </select>
            </div>
          </div>
        </section>

        <section class="card oe-section">
          <div class="oe-section-head">
            <div>
              <span class="eyebrow">2 · CONCEPTOS</span>
              <h3>Productos y servicios</h3>
              <p>El total se calcula nuevamente al guardar.</p>
            </div>
            <button type="button" class="btn btn-secondary" id="oeAddItem">＋ Agregar concepto</button>
          </div>

          <div class="oe-items" id="oeItems">
            <?php foreach($items as $index=>$item): ?>
              <article class="oe-item" data-oe-item>
                <input type="hidden" name="item_id[]" value="<?=((int)($item['id'] ?? 0))?>">
                <input type="hidden" name="quote_item_id[]" value="<?=((int)($item['quote_item_id'] ?? 0))?>">

                <div class="oe-item-head">
                  <span>Concepto <b data-oe-number><?=($index+1)?></b></span>
                  <button type="button" class="oe-remove" data-oe-remove aria-label="Eliminar concepto">Eliminar</button>
                </div>

                <div class="field full">
                  <label>Descripción</label>
                  <textarea name="description[]" rows="3" required><?=e((string)$item['description'])?></textarea>
                </div>

                <div class="oe-item-grid">
                  <div class="field">
                    <label>Cantidad</label>
                    <input type="number" name="quantity[]" min="0.001" step="0.001"
                           value="<?=e((string)$item['quantity'])?>" inputmode="decimal" required data-oe-qty>
                  </div>

                  <div class="field">
                    <label>Precio unitario</label>
                    <input type="number" name="unit_price[]" min="0" step="0.01"
                           value="<?=e(number_format((float)$item['unit_price'],2,'.',''))?>" inputmode="decimal" required data-oe-price>
                  </div>

                  <div class="oe-item-subtotal">
                    <span>Importe</span>
                    <strong data-oe-subtotal><?=quote_money((float)$item['subtotal'])?></strong>
                  </div>
                </div>
              </article>
            <?php endforeach; ?>
          </div>

          <template id="oeItemTemplate">
            <article class="oe-item" data-oe-item>
              <input type="hidden" name="item_id[]" value="0">
              <input type="hidden" name="quote_item_id[]" value="0">

              <div class="oe-item-head">
                <span>Concepto <b data-oe-number></b></span>
                <button type="button" class="oe-remove" data-oe-remove aria-label="Eliminar concepto">Eliminar</button>
              </div>

              <div class="field full">
                <label>Descripción</label>
                <textarea name="description[]" rows="3" required></textarea>
              </div>

              <div class="oe-item-grid">
                <div class="field">
                  <label>Cantidad</label>
                  <input type="number" name="quantity[]" min="0.001" step="0.001" value="1" inputmode="decimal" required data-oe-qty>
                </div>
                <div class="field">
                  <label>Precio unitario</label>
                  <input type="number" name="unit_price[]" min="0" step="0.01" value="0.00" inputmode="decimal" required data-oe-price>
                </div>
                <div class="oe-item-subtotal">
                  <span>Importe</span>
                  <strong data-oe-subtotal>$0.00</strong>
                </div>
              </div>
            </article>
          </template>
        </section>

        <section class="card oe-section">
          <div class="oe-section-head">
            <div>
              <span class="eyebrow">3 · OPERACIÓN</span>
              <h3>Notas de la orden</h3>
            </div>
          </div>

          <div class="oe-grid">
            <div class="field full">
              <label for="notes">Notas operativas</label>
              <textarea id="notes" name="notes" rows="5"><?=e($form['notes'])?></textarea>
            </div>
            <div class="field full">
              <label for="internal_notes">Notas internas</label>
              <textarea id="internal_notes" name="internal_notes" rows="5"><?=e($form['internal_notes'])?></textarea>
              <small>Solo visibles para el equipo.</small>
            </div>
          </div>
        </section>
      </main>

      <aside>
        <section class="card oe-summary-card">
          <span class="eyebrow">RESUMEN</span>
          <h3>Total de la orden</h3>
          <strong class="oe-total" id="oeTotal"><?=quote_money((float)$order['total'])?></strong>
          <small>El servidor recalculará este importe antes de guardar.</small>

          <?php if((float)($financeSummary['paid_total'] ?? 0)>0): ?>
            <div class="oe-finance-warning">
              <span>Pagos confirmados</span>
              <strong>$<?=e(number_format((float)$financeSummary['paid_total'],2,'.',','))?></strong>
            </div>
          <?php endif; ?>

          <?php if((int)($financeSummary['invoice_count'] ?? 0)>0): ?>
            <div class="oe-finance-note">
              Esta orden tiene <?=((int)$financeSummary['invoice_count'])?> registro(s) de facturación.
            </div>
          <?php endif; ?>

          <div class="oe-protection">
            <b>Se conserva</b>
            <span>Folio <?=e($order['order_number'])?></span>
            <span>Cotización <?=e($order['quote_number'] ?: '—')?></span>
            <span>Estado actual <?=e(order_status_label((string)$order['status']))?></span>
          </div>

          <button class="btn btn-primary oe-save" type="submit">Guardar cambios</button>
          <a class="btn btn-secondary oe-cancel" href="/admin/orden.php?id=<?=((int)$id)?>">Cancelar</a>
        </section>
      </aside>
    </div>

    <div class="oe-mobile-bar">
      <button type="button" class="oe-mobile-total" id="oeMobileTotalButton">
        <span>Total</span>
        <strong id="oeMobileTotal"><?=quote_money((float)$order['total'])?></strong>
      </button>
      <button class="btn btn-primary" type="submit">Guardar cambios</button>
    </div>
  </form>
  <?php endif; ?>
</div>

<script src="/assets/js/orden-editor-v1.js?v=1.0.0"></script>
<?php require __DIR__ . '/../includes/footer.php'; ?>
