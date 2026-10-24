<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/web_print_flow.php';

require_auth();

$title = 'Solicitudes web de cotización';
$error = null;
$pdo = db();

function cpqw4_h($value): string
{
    return htmlspecialchars(
        (string)$value,
        ENT_QUOTES,
        'UTF-8'
    );
}

if (
    $_SERVER['REQUEST_METHOD'] === 'POST'
    && ($_POST['action'] ?? '') === 'status'
) {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error =
            'La sesión expiró. Recarga la página.';
    } else {
        $id = (int)($_POST['id'] ?? 0);
        $status = (string)(
            $_POST['status']
            ?? ''
        );

        if (
            $id > 0
            && in_array(
                $status,
                [
                    'new',
                    'reviewing',
                    'quoted',
                    'closed',
                    'spam',
                ],
                true
            )
        ) {
            try {
                $st = $pdo->prepare(
                    'UPDATE cp_web_quote_requests
                     SET status=?,updated_at=NOW()
                     WHERE id=?'
                );
                $st->execute([
                    $status,
                    $id,
                ]);

                redirect(
                    '/admin/cotizaciones_web.php?updated=1&focus='
                    . $id
                );
            } catch (Throwable $e) {
                $error =
                    'No se pudo actualizar el estado.';
            }
        }
    }
}

$orderCols =
    web_flow_column_exists(
        'cp_web_quote_requests',
        'converted_order_id'
    )
        ? ',converted_order_id,converted_order_at'
        : '';

$rows = [];

try {
    $st = $pdo->query(
        "SELECT
            id,
            request_token,
            service_key,
            customer_name,
            email,
            phone,
            quantity,
            desired_date,
            attachment_name,
            status,
            created_at,
            updated_at,
            request_text,
            converted_quote_id,
            converted_at
            {$orderCols}
         FROM cp_web_quote_requests
         ORDER BY id DESC
         LIMIT 200"
    );

    $rows =
        $st->fetchAll(
            PDO::FETCH_ASSOC
        )
        ?: [];
} catch (Throwable $e) {
    $error =
        'No se pudieron cargar las solicitudes web.';
}

$filesByRequest = [];
$totalsByRequest = [];

foreach ($rows as $row) {
    $requestId = (int)$row['id'];

    try {
        $filesByRequest[$requestId] =
            web_flow_request_files(
                $requestId
            );

        $totalsByRequest[$requestId] =
            web_flow_request_total(
                $requestId
            );
    } catch (Throwable $e) {
        $filesByRequest[$requestId] = [];
        $totalsByRequest[$requestId] = 0.0;
    }
}

$focus = (int)(
    $_GET['focus']
    ?? 0
);

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/web-print-flow-v1.css?v=20261020-1">

<style>
#cpqw4{
  --panel:#0b1b2a;
  --panel2:#0d2232;
  --line:#21465f;
  --text:#f5f8fb;
  --muted:#8fa6b6;
  --cyan:#22c8f1;
  --green:#20d69a;
  --yellow:#ffbf1e;
  --red:#ff607a;
}
#cpqw4 *{box-sizing:border-box}
#cpqw4 .wrap{max-width:1450px;margin:0 auto;padding:4px 0 48px}
#cpqw4 .head{
  display:flex;
  justify-content:space-between;
  align-items:end;
  gap:24px;
  padding:10px 0 22px;
  border-bottom:1px solid rgba(255,255,255,.09)
}
#cpqw4 .eyebrow{
  font-size:10px;
  font-weight:900;
  letter-spacing:.16em;
  color:#1bd4ff;
  text-transform:uppercase
}
#cpqw4 h1{
  margin:6px 0;
  font-size:clamp(30px,3vw,44px);
  line-height:1.05
}
#cpqw4 .lead{
  max-width:850px;
  margin:0;
  color:var(--muted);
  font-size:14px;
  line-height:1.55
}
#cpqw4 .head-actions{
  display:flex;
  gap:8px;
  flex-wrap:wrap
}
#cpqw4 .btn4{
  min-height:40px;
  padding:9px 13px;
  display:inline-flex;
  align-items:center;
  justify-content:center;
  gap:7px;
  border:1px solid #2b526c;
  border-radius:10px;
  background:#10283a;
  color:#fff;
  font-size:12px;
  font-weight:900;
  text-decoration:none;
  cursor:pointer
}
#cpqw4 .btn4.primary{
  border-color:transparent;
  background:linear-gradient(135deg,#189ff7,#20c9ed)
}
#cpqw4 .btn4.convert{
  border-color:#1b6b59;
  background:#0d3e34;
  color:#7df0cc
}
#cpqw4 .notice4{
  margin:14px 0;
  padding:11px 13px;
  border:1px solid #26516a;
  border-radius:10px;
  background:#0c2232;
  color:#b6cad6;
  font-size:12px
}
#cpqw4 .list{
  display:grid;
  gap:14px;
  margin-top:17px
}
#cpqw4 .card4{
  overflow:hidden;
  border:1px solid #1d4058;
  border-radius:16px;
  background:
    radial-gradient(circle at 100% 0,rgba(34,200,241,.06),transparent 30%),
    linear-gradient(180deg,#0c1d2b,#091622)
}
#cpqw4 .card4.focus{
  outline:2px solid #21c8f3
}
#cpqw4 .card-head{
  display:grid;
  grid-template-columns:minmax(0,1fr) auto;
  gap:14px;
  align-items:start;
  padding:16px 17px;
  border-bottom:1px solid rgba(255,255,255,.075)
}
#cpqw4 .ref{
  color:#fff;
  font-size:17px;
  font-weight:900
}
#cpqw4 .name{
  color:#c9e2ef
}
#cpqw4 .meta{
  display:flex;
  gap:11px;
  flex-wrap:wrap;
  margin-top:6px;
  color:#849db0;
  font-size:10px
}
#cpqw4 .meta b{color:#ffc11f}
#cpqw4 .status{
  padding:6px 9px;
  border-radius:999px;
  font-size:9px;
  font-weight:900;
  text-transform:uppercase
}
#cpqw4 .status.new{color:#ffd05a;background:#3a2a07}
#cpqw4 .status.reviewing{color:#6fe1ff;background:#103447}
#cpqw4 .status.quoted{color:#71edbe;background:#0c392e}
#cpqw4 .status.closed{color:#acb8c2;background:#22303a}
#cpqw4 .status.spam{color:#ff8296;background:#3d1520}
#cpqw4 .body{
  display:grid;
  grid-template-columns:minmax(0,1fr) 280px;
  gap:16px;
  padding:16px 17px
}
#cpqw4 .summary{
  display:flex;
  gap:10px;
  flex-wrap:wrap;
  margin-bottom:12px
}
#cpqw4 .summary span{
  padding:7px 9px;
  border:1px solid rgba(255,255,255,.07);
  border-radius:9px;
  background:rgba(255,255,255,.03);
  color:#9eb4c4;
  font-size:10px
}
#cpqw4 .summary strong{
  color:#fff
}
#cpqw4 .side{
  display:grid;
  gap:8px;
  align-content:start
}
#cpqw4 .side .btn4{
  width:100%
}
#cpqw4 .converted{
  padding:10px;
  border:1px solid #1a6259;
  border-radius:10px;
  background:#0a2927;
  color:#86ecd6;
  font-size:10px;
  line-height:1.55
}
#cpqw4 .status-form{
  display:grid;
  grid-template-columns:minmax(0,1fr) auto;
  gap:7px
}
#cpqw4 .status-form select{
  width:100%;
  min-height:39px;
  padding:8px 10px;
  border:1px solid #244a63;
  border-radius:9px;
  background:#07131f;
  color:#fff;
  font-size:11px
}
#cpqw4 .empty{
  padding:30px;
  text-align:center;
  border:1px dashed #29475c;
  border-radius:14px;
  color:#8da2b1
}
#cpqw4 .no-files{
  padding:12px;
  border:1px dashed #365268;
  border-radius:11px;
  color:#9cafbc;
  font-size:11px
}
@media(max-width:900px){
  #cpqw4 .head{
    align-items:flex-start;
    flex-direction:column
  }
  #cpqw4 .body{
    grid-template-columns:1fr
  }
}
</style>

<main id="cpqw4">
<div class="wrap">

  <header class="head">
    <div>
      <div class="eyebrow">
        PLATAFORMA · ENTRADA WEB · EXPEDIENTE COMPLETO
      </div>

      <h1>Solicitudes web de impresión</h1>

      <p class="lead">
        Cada CPQ conserva archivos, configuración, precios y cliente. Al convertirlo se crean los conceptos de la cotización y, posteriormente, los archivos pasan automáticamente a la orden de servicio.
      </p>
    </div>

    <div class="head-actions">
      <a
        class="btn4 primary"
        href="/#solicita-impresiones"
        target="_blank"
        rel="noopener"
      >
        Abrir recepción web ↗
      </a>

      <a
        class="btn4"
        href="/admin/cotizaciones_web.php"
      >
        ↻ Actualizar
      </a>
    </div>
  </header>

  <?php if ($error): ?>
    <div class="notice4">
      <?=cpqw4_h($error)?>
    </div>
  <?php endif; ?>

  <?php if (isset($_GET['updated'])): ?>
    <div class="notice4">
      ✓ Estado actualizado.
    </div>
  <?php endif; ?>

  <section class="list">

  <?php foreach ($rows as $row):
      $id = (int)$row['id'];
      $reference = web_flow_reference($id);
      $status = strtolower((string)$row['status']);
      $statusClass = preg_replace('/[^a-z]/', '', $status);
      $convertedId = (int)($row['converted_quote_id'] ?? 0);
      $convertedOrderId = (int)($row['converted_order_id'] ?? 0);
      $files = $filesByRequest[$id] ?? [];
      $total = (float)($totalsByRequest[$id] ?? 0);
  ?>

    <article
      class="card4 <?=$focus === $id ? 'focus' : ''?>"
      id="cpqw4-<?=$id?>"
    >

      <div class="card-head">
        <div>
          <div class="ref">
            <?=$reference?>
            <span class="name">
              · <?=cpqw4_h((string)$row['customer_name'])?>
            </span>
          </div>

          <div class="meta">
            <span>
              <b>Servicio:</b>
              <?=cpqw4_h((string)$row['service_key'])?>
            </span>

            <span>
              <b>Archivos:</b>
              <?=count($files)?>
            </span>

            <span>
              <b>Total:</b>
              <?=cpqw4_h(web_flow_money($total))?>
            </span>

            <span>
              <b>Recibido:</b>
              <?=cpqw4_h(
                  date(
                      'd/m/Y H:i',
                      strtotime((string)$row['created_at'])
                  )
              )?>
            </span>
          </div>
        </div>

        <span class="status <?=$statusClass?>">
          <?=cpqw4_h((string)$row['status'])?>
        </span>
      </div>

      <div class="body">
        <div>

          <div class="summary">
            <span>
              Tel:
              <strong><?=cpqw4_h((string)$row['phone'])?></strong>
            </span>

            <?php if (!empty($row['email'])): ?>
              <span>
                Email:
                <strong><?=cpqw4_h((string)$row['email'])?></strong>
              </span>
            <?php endif; ?>
          </div>

          <?php if ($files): ?>
            <div class="wpf-files">

            <?php foreach ($files as $file):
                $pages = max(
                    1,
                    (int)(
                        $file['pages']
                        ?? $file['page_count']
                        ?? $file['file_page_count']
                        ?? 1
                    )
                );
                $copies = max(
                    1,
                    (int)($file['copies'] ?? 1)
                );
            ?>

              <div class="wpf-file">
                <div class="wpf-file-main">
                  <strong>
                    <?=cpqw4_h((string)$file['original_name'])?>
                  </strong>

                  <div class="wpf-file-meta">
                    <span>
                      <?=cpqw4_h(strtoupper((string)($file['extension'] ?? 'ARCHIVO')))?>
                    </span>

                    <span>
                      <?=cpqw4_h(web_flow_format_bytes((int)($file['size_bytes'] ?? 0)))?>
                    </span>

                    <?php if (!empty($file['size_name'])): ?>
                      <span><?=cpqw4_h((string)$file['size_name'])?></span>
                    <?php endif; ?>

                    <?php if (!empty($file['material_name'])): ?>
                      <span><?=cpqw4_h((string)$file['material_name'])?></span>
                    <?php endif; ?>

                    <?php if (!empty($file['finish_name'])): ?>
                      <span><?=cpqw4_h((string)$file['finish_name'])?></span>
                    <?php endif; ?>

                    <span>
                      <?=cpqw4_h(web_flow_color_label((string)($file['color_mode'] ?? 'color')))?>
                    </span>

                    <span>
                      <?=$pages?> pág. × <?=$copies?> copia(s)
                    </span>
                  </div>

                  <div class="wpf-file-pricing">
                    <span>
                      Unidad:
                      <strong>
                        <?=cpqw4_h(web_flow_money((float)($file['unit_price'] ?? 0)))?>
                      </strong>
                    </span>

                    <span>
                      Subtotal:
                      <strong>
                        <?=cpqw4_h(web_flow_money((float)($file['subtotal'] ?? 0)))?>
                      </strong>
                    </span>
                  </div>
                </div>

                <div class="wpf-file-actions">
                  <a
                    class="btn4"
                    href="/admin/archivo_web.php?id=<?=((int)$file['file_id'])?>&mode=inline"
                    target="_blank"
                    rel="noopener"
                  >
                    Ver
                  </a>

                  <a
                    class="btn4"
                    href="/admin/archivo_web.php?id=<?=((int)$file['file_id'])?>&mode=download"
                  >
                    Descargar
                  </a>
                </div>
              </div>

            <?php endforeach; ?>

            </div>
          <?php else: ?>
            <div class="no-files">
              Esta solicitud no tiene archivos registrados en cp_web_quote_files.
            </div>
          <?php endif; ?>

        </div>

        <div class="side">

          <?php if ($convertedOrderId > 0): ?>
            <div class="converted">
              ✓ Flujo completado hasta orden formal
              <br>
              <strong>Orden #<?=$convertedOrderId?></strong>
            </div>

            <a
              class="btn4 primary"
              href="/admin/orden.php?id=<?=$convertedOrderId?>"
            >
              Abrir orden
            </a>

          <?php elseif ($convertedId > 0): ?>
            <div class="converted">
              ✓ Convertida a cotización formal
              <br>
              <strong>Cotización #<?=$convertedId?></strong>
            </div>

            <a
              class="btn4"
              href="/admin/cotizacion.php?id=<?=$convertedId?>"
            >
              Abrir cotización
            </a>

          <?php else: ?>
            <form
              method="post"
              action="/admin/cotizacion_desde_web.php"
              onsubmit="return confirm('Se crearán los conceptos usando los archivos, configuraciones y precios calculados por el cotizador web. ¿Continuar?');"
            >
              <input
                type="hidden"
                name="_csrf"
                value="<?=cpqw4_h(csrf_token())?>"
              >

              <input
                type="hidden"
                name="request_id"
                value="<?=$id?>"
              >

              <button
                class="btn4 convert"
                type="submit"
                <?=$files ? '' : 'disabled'?>
              >
                ⚡ Convertir en cotización
              </button>
            </form>
          <?php endif; ?>

          <a
            class="btn4"
            href="/seguimiento.php?t=<?=cpqw4_h((string)$row['request_token'])?>"
            target="_blank"
            rel="noopener"
          >
            Ver seguimiento público
          </a>

          <a
            class="btn4"
            href="/admin/cotizacion_web_editar.php?id=<?=$id?>"
          >
            ✎ Editar solicitud
          </a>

          <form method="post" class="status-form">
            <input
              type="hidden"
              name="_csrf"
              value="<?=cpqw4_h(csrf_token())?>"
            >

            <input
              type="hidden"
              name="action"
              value="status"
            >

            <input
              type="hidden"
              name="id"
              value="<?=$id?>"
            >

            <select name="status">
              <?php
              foreach (
                  [
                      'new' => 'Nueva',
                      'reviewing' => 'En revisión',
                      'quoted' => 'Cotizada',
                      'closed' => 'Cerrada',
                      'spam' => 'Spam',
                  ]
                  as $key => $label
              ):
              ?>
                <option
                  value="<?=$key?>"
                  <?=$status === $key ? 'selected' : ''?>
                >
                  <?=cpqw4_h($label)?>
                </option>
              <?php endforeach; ?>
            </select>

            <button
              class="btn4"
              type="submit"
            >
              Guardar
            </button>
          </form>

        </div>
      </div>
    </article>

  <?php endforeach; ?>

  <?php if (!$rows): ?>
    <div class="empty">
      No hay solicitudes web registradas.
    </div>
  <?php endif; ?>

  </section>
</div>
</main>

<?php require __DIR__ . '/../includes/footer.php'; ?>
