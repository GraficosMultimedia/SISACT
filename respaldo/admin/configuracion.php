<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/company.php';
require_auth();

$title='Configuración';
$error = null;
$success = null;
$company = company_profile();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión del formulario expiró. Recarga la página.';
    } elseif (($_POST['form_action'] ?? '') === 'company_save') {
        $company = [
            'legal_name' => trim((string)($_POST['legal_name'] ?? '')),
            'trade_name' => trim((string)($_POST['trade_name'] ?? '')),
            'rfc' => strtoupper(trim((string)($_POST['rfc'] ?? ''))),
            'tax_regime' => trim((string)($_POST['tax_regime'] ?? '')),
            'address' => trim((string)($_POST['address'] ?? '')),
            'neighborhood' => trim((string)($_POST['neighborhood'] ?? '')),
            'city' => trim((string)($_POST['city'] ?? '')),
            'state' => trim((string)($_POST['state'] ?? '')),
            'postal_code' => trim((string)($_POST['postal_code'] ?? '')),
            'country' => trim((string)($_POST['country'] ?? 'México')),
            'phone' => trim((string)($_POST['phone'] ?? '')),
            'email' => trim((string)($_POST['email'] ?? '')),
            'website' => trim((string)($_POST['website'] ?? '')),
            'logo_path' => (string)($company['logo_path'] ?? ''),
            'quote_footer' => trim((string)($_POST['quote_footer'] ?? '')),
            'payment_info' => trim((string)($_POST['payment_info'] ?? '')),
        ];

        if ($company['legal_name'] === '') {
            $error = 'La razón social o nombre comercial de la empresa es obligatorio.';
        } elseif ($company['email'] !== '' && !filter_var($company['email'], FILTER_VALIDATE_EMAIL)) {
            $error = 'El correo de la empresa no es válido.';
        } elseif ($company['website'] !== '' && !filter_var($company['website'], FILTER_VALIDATE_URL)) {
            $error = 'El sitio web de la empresa no es válido.';
        } else {
            try {
                if (isset($_FILES['logo']) && (int)($_FILES['logo']['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_NO_FILE) {
                    if ((int)$_FILES['logo']['error'] !== UPLOAD_ERR_OK) throw new RuntimeException('No se pudo recibir el logotipo.');
                    if ((int)$_FILES['logo']['size'] > 2 * 1024 * 1024) throw new RuntimeException('El logotipo no debe superar 2 MB.');
                    $tmp = (string)$_FILES['logo']['tmp_name'];
                    $mime = (string)(new finfo(FILEINFO_MIME_TYPE))->file($tmp);
                    $allowed = ['image/jpeg'=>'jpg','image/png'=>'png','image/webp'=>'webp'];
                    if (!isset($allowed[$mime])) throw new RuntimeException('El logotipo debe ser JPG, PNG, WEBP o SVG.');
                    $dir = __DIR__ . '/../assets/img/company';
                    if (!is_dir($dir) && !mkdir($dir, 0755, true) && !is_dir($dir)) throw new RuntimeException('No se pudo crear la carpeta del logotipo.');
                    $filename = 'logo-' . date('YmdHis') . '-' . bin2hex(random_bytes(4)) . '.' . $allowed[$mime];
                    $target = $dir . '/' . $filename;
                    if (!move_uploaded_file($tmp, $target)) throw new RuntimeException('No se pudo guardar el logotipo.');
                    $company['logo_path'] = '/assets/img/company/' . $filename;
                }

                foreach ($company as $key => $value) setting_set('company.' . $key, $value);
                log_activity('update', 'settings', 'Datos de empresa actualizados');
                $success = 'Datos de empresa guardados correctamente.';
            } catch (Throwable $e) {
                $error = 'No se pudo guardar la configuración: ' . $e->getMessage();
            }
        }
    }
}

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/cotizaciones.css?v=20260917-6">
<div class="quote-toolbar">
  <div><span class="eyebrow">CONFIGURACIÓN · EMPRESA</span><h2>Datos de la empresa</h2><p class="muted">Estos datos se utilizarán en cotizaciones, documentos impresos y futuras salidas formales.</p></div>
</div>
<?php if ($error): ?><div class="notice danger" style="margin-bottom:14px"><?=e($error)?></div><?php endif; ?>
<?php if ($success): ?><div class="notice" style="margin-bottom:14px"><span class="ok">✓</span> <?=e($success)?></div><?php endif; ?>

<form method="post" enctype="multipart/form-data">
<input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><input type="hidden" name="form_action" value="company_save">
<div class="company-config-grid">
  <section class="card">
    <div class="section-heading"><div><span class="eyebrow">IDENTIDAD</span><h3>Identidad comercial y fiscal</h3></div></div>
    <div class="form-grid">
      <div class="field full"><label>Razón social / nombre legal <span class="required">*</span></label><input name="legal_name" maxlength="190" value="<?=e($company['legal_name'])?>" required></div>
      <div class="field"><label>Nombre comercial</label><input name="trade_name" maxlength="190" value="<?=e($company['trade_name'])?>"></div>
      <div class="field"><label>RFC</label><input name="rfc" maxlength="20" value="<?=e($company['rfc'])?>"></div>
      <div class="field full"><label>Régimen fiscal</label><input name="tax_regime" maxlength="190" value="<?=e($company['tax_regime'])?>" placeholder="Ej. Régimen Simplificado de Confianza"></div>
      <div class="field"><label>Teléfono / WhatsApp</label><input name="phone" maxlength="80" value="<?=e($company['phone'])?>"></div>
      <div class="field"><label>Correo</label><input type="email" name="email" maxlength="190" value="<?=e($company['email'])?>"></div>
      <div class="field full"><label>Sitio web</label><input type="url" name="website" maxlength="255" value="<?=e($company['website'])?>" placeholder="https://..."></div>
    </div>
  </section>

  <section class="card">
    <div class="section-heading"><div><span class="eyebrow">DOMICILIO</span><h3>Domicilio de la empresa</h3></div></div>
    <div class="form-grid">
      <div class="field full"><label>Dirección</label><input name="address" maxlength="500" value="<?=e($company['address'])?>"></div>
      <div class="field full"><label>Colonia</label><input name="neighborhood" maxlength="120" value="<?=e($company['neighborhood'])?>"></div>
      <div class="field"><label>Ciudad</label><input name="city" maxlength="120" value="<?=e($company['city'])?>"></div>
      <div class="field"><label>Estado</label><input name="state" maxlength="120" value="<?=e($company['state'])?>"></div>
      <div class="field"><label>Código postal</label><input name="postal_code" maxlength="20" value="<?=e($company['postal_code'])?>"></div>
      <div class="field"><label>País</label><input name="country" maxlength="80" value="<?=e($company['country'])?>"></div>
    </div>
  </section>

  <section class="card">
    <div class="section-heading"><div><span class="eyebrow">DOCUMENTOS</span><h3>Logotipo y pie de cotización</h3></div></div>
    <div class="company-logo-preview">
      <?php if ($company['logo_path']): ?><img src="<?=e($company['logo_path'])?>" alt="Logotipo actual"><div><strong>Logotipo actual</strong><small><?=e($company['logo_path'])?></small></div>
      <?php else: ?><div class="company-logo-placeholder">CP</div><div><strong>Aún no hay logotipo</strong><small>Sube una imagen para utilizarla en documentos.</small></div><?php endif; ?>
    </div>
    <div class="field" style="margin-top:14px"><label>Nuevo logotipo</label><input type="file" name="logo" accept="image/jpeg,image/png,image/webp"><small class="help-text">JPG, PNG o WEBP · máximo 2 MB.</small></div>
    <div class="field" style="margin-top:14px"><label>Leyenda al pie</label><textarea name="quote_footer" rows="4" maxlength="1000"><?=e($company['quote_footer'])?></textarea><small class="help-text">Se imprimirá en la cotización. Aquí conviene aclarar que es un documento comercial y no un CFDI.</small></div>
  </section>

  <section class="card">
    <div class="section-heading"><div><span class="eyebrow">PAGO</span><h3>Información comercial de pago</h3></div></div>
    <div class="field"><label>Datos para pago</label><textarea name="payment_info" rows="7" maxlength="2000" placeholder="Banco, titular, cuenta, CLABE u otras instrucciones que quieras mostrar al cliente."><?=e($company['payment_info'])?></textarea><small class="help-text">Se mostrará únicamente cuando exista información capturada. No es necesario llenarlo si no deseas publicarlo en cotizaciones.</small></div>
  </section>
</div>
<div class="form-actions"><button type="submit" class="btn btn-save">Guardar datos de empresa</button></div>
</form>
<?php require __DIR__ . '/../includes/footer.php'; ?>
