<?php
declare(strict_types=1);

/*
 * Variables disponibles desde seguimiento.php:
 * $company
 * $token
 * $webRequest
 */

if (!isset($webRequest) || !is_array($webRequest)) {
    http_response_code(404);
    exit;
}

$tradeName = trim(
    (string)($company['trade_name'] ?? '')
);

if ($tradeName === '') {
    $tradeName = trim(
        (string)($company['legal_name'] ?? '')
    );
}

if ($tradeName === '') {
    $tradeName = 'Colibrí Print';
}

$phone = trim(
    (string)($company['phone'] ?? '')
);

$wa = preg_replace('/\D+/', '', $phone) ?: '';

if (
    $wa !== ''
    && !str_starts_with(
        $wa,
        '52'
    )
) {
    $wa = '52' . $wa;
}

$waUrl = $wa !== ''
    ? 'https://wa.me/'
        . $wa
        . '?text='
        . rawurlencode(
            'Hola '
            . $tradeName
            . ', quiero consultar mi solicitud '
            . (string)$webRequest['reference']
        )
    : '';

$status = strtolower(
    (string)($webRequest['status'] ?? 'new')
);

$step = match ($status) {
    'reviewing' => 2,
    'quoted' => 3,
    'closed' => 4,
    default => 1,
};

$headline = match ($step) {
    2 => 'Estamos revisando tus archivos',
    3 => 'Tu solicitud ya llegó a cotización',
    4 => 'Tu solicitud fue confirmada',
    default => 'Recibimos tus archivos correctamente',
};

$message = match ($step) {
    2 => 'Nuestro equipo está verificando medidas, materiales, acabados y los archivos que enviaste.',
    3 => 'La propuesta comercial ya fue preparada o está en proceso de confirmación contigo.',
    4 => 'La solicitud ya fue confirmada. Estamos preparando el siguiente paso para convertirla en una orden de servicio.',
    default => 'Tus archivos quedaron guardados en el expediente de la solicitud. No necesitas enviarlos nuevamente.',
};

$created = !empty($webRequest['created_at'])
    ? date(
        'd/m/Y H:i',
        strtotime(
            (string)$webRequest['created_at']
        )
    )
    : '—';

$total = (float)(
    $webRequest['estimate_total']
    ?? 0
);

$fileCount = (int)(
    $webRequest['file_count']
    ?? 0
);

$quoteNumber = trim(
    (string)(
        $webRequest['quote_number']
        ?? ''
    )
);

?>
<!doctype html>
<html lang="es-MX">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="robots" content="noindex,nofollow">
<title><?=web_flow_e((string)$webRequest['reference'])?> · <?=web_flow_e($tradeName)?></title>
<link rel="stylesheet" href="/assets/css/web-print-flow-v1.css?v=20261020-1">
</head>
<body class="wpf-public-body">

<main class="wpf-track-shell">
  <section class="wpf-track-card">

    <div class="wpf-track-brand">
      <div>
        <span class="wpf-track-kicker">SOLICITUD DE IMPRESIÓN</span>
        <strong><?=web_flow_e($tradeName)?></strong>
      </div>

      <span class="wpf-track-reference">
        <?=web_flow_e((string)$webRequest['reference'])?>
      </span>
    </div>

    <div class="wpf-track-hero">
      <div class="wpf-track-icon">✓</div>

      <span class="wpf-track-eyebrow">
        SEGUIMIENTO EN LÍNEA
      </span>

      <h1><?=web_flow_e($headline)?></h1>

      <p><?=web_flow_e($message)?></p>
    </div>

    <div class="wpf-track-progress">
      <?php
      $steps = [
          1 => ['Recibido', 'Archivos guardados'],
          2 => ['Revisión', 'Validación técnica'],
          3 => ['Cotización', 'Propuesta comercial'],
          4 => ['Confirmado', 'Preparando orden'],
      ];
      ?>

      <?php foreach ($steps as $n => $data): ?>
        <div class="wpf-track-step <?=$n <= $step ? 'is-done' : ''?> <?=$n === $step ? 'is-current' : ''?>">
          <span><?=$n < $step ? '✓' : $n?></span>
          <strong><?=web_flow_e($data[0])?></strong>
          <small><?=web_flow_e($data[1])?></small>
        </div>
      <?php endforeach; ?>
    </div>

    <div class="wpf-track-data">
      <div>
        <span>Archivos recibidos</span>
        <strong><?=$fileCount?></strong>
      </div>

      <div>
        <span>Estimado enviado</span>
        <strong><?=web_flow_e(web_flow_money($total))?></strong>
      </div>

      <div>
        <span>Fecha de recepción</span>
        <strong><?=web_flow_e($created)?></strong>
      </div>

      <div>
        <span>Cotización</span>
        <strong><?=web_flow_e($quoteNumber !== '' ? $quoteNumber : 'Por generar')?></strong>
      </div>
    </div>

    <div class="wpf-track-note">
      <strong>Tu enlace seguirá siendo el mismo.</strong>
      <span>
        Cuando esta solicitud se convierta en una orden formal, esta misma liga mostrará automáticamente el seguimiento de producción, pagos y entrega.
      </span>
    </div>

    <?php if ($waUrl !== ''): ?>
      <div class="wpf-track-actions">
        <a href="<?=web_flow_e($waUrl)?>" target="_blank" rel="noopener">
          Consultar por WhatsApp
        </a>
      </div>
    <?php endif; ?>

  </section>
</main>

</body>
</html>
