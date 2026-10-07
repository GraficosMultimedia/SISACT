<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/company.php';
require_auth();
$title = $title ?? 'Colibrí Print';
$user = current_user();
$company = company_profile();
$currentPath = parse_url($_SERVER['REQUEST_URI'] ?? '', PHP_URL_PATH) ?: '';
$logoPath = trim((string)($company['logo_path'] ?? ''));
if ($logoPath === '') {
    $logoPath = '/assets/img/logo-mark.svg';
}

$navGroups = [
    'operacion' => [
        'label' => 'Operación',
        'icon' => '▦',
        'items' => [
            ['/admin/clientes.php', 'Clientes', '♙'],
            ['/admin/ordenes.php', 'Órdenes de servicio', '◆'],
            ['/admin/cotizaciones.php', 'Cotizaciones', '▤'],
            
        ],
    ],
    'produccion' => [
        'label' => 'Taller Central',
        'icon' => '⚙',
        'items' => [
            ['/admin/produccion.php', 'Procesos', '▦'],
            ['/admin/produccion_historial.php', 'Historial', '◴'],
        ],
    ],
    'comunicacion' => [
        'label' => 'Comunicación',
        'icon' => '✦',
        'items' => [
            ['/admin/whatsapp.php', 'WhatsApp', '◉'],
            ['/admin/facebook.php', 'Facebook', 'f'],
            ['/admin/marketing/tiktok/index.php', 'TikTok', '♪'],
        ],
    ],
    'administracion' => [
        'label' => 'Administración',
        'icon' => '▥',
        'items' => [
            ['/admin/productos.php', 'Productos', '□'],
            ['/admin/categorias.php', 'Categorías', '◫'],
            ['/admin/promociones.php', 'Promociones', '%'],
            ['/admin/pagos.php', 'Pagos', '$'],
            ['/admin/facturacion.php', 'Facturación', '▤'],
            ['/admin/reportes.php', 'Reportes', '▥'],
            ['/admin/cotizadores.php', 'Cotizadores', '∑'],
            ['/admin/impresiones.php', 'Impresiones', '▣'],
        ],
    ],
    'sistema' => [
        'label' => 'Sistema',
        'icon' => '⚙',
        'items' => [
            ['/admin/autorizaciones.php', 'Imp Clientes', '✓'],
            ['/admin/configuracion.php', 'Configuración general', '⚙'],
            ['/admin/impresion_precios.php', 'Configuración de impresión', '🖨'],
            ['/admin/recepcion_impresiones.php', 'Recepción de impresiones', '▣'],
            ['/admin/recepcion_historial.php', 'Historial de impresiones', '◴'],
        ],
    ],
];

$groupHasActive = static function(array $group) use ($currentPath): bool {
    foreach ($group['items'] as $item) {
        if ($currentPath === $item[0]) {
            return true;
        }
    }
    return false;
};

$userName = trim((string)($user['name'] ?? ''));
$userInitials = '';
if ($userName !== '') {
    $parts = preg_split('/\s+/', $userName) ?: [];
    $userInitials = strtoupper(substr((string)($parts[0] ?? ''), 0, 1));
    if (count($parts) > 1) {
        $userInitials .= strtoupper(substr((string)end($parts), 0, 1));
    }
}
if ($userInitials === '') {
    $userInitials = 'CP';
}
?><!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><?=e($title)?> | Colibrí Print</title>
<link rel="stylesheet" href="/assets/css/app.css">
<link rel="stylesheet" href="/assets/css/admin-topnav.css">
<script src="/assets/js/app.js" defer></script>
<script src="/assets/js/admin-topnav.js" defer></script>
</head>
<body class="cp-admin-body">
<div class="cp-admin-shell">
    <header class="cp-topnav" data-cp-topnav>
        <div class="cp-topnav-inner">
            <a class="cp-brand" href="/admin/dashboard.php" aria-label="Colibrí Print, ir al inicio">
                <span class="cp-brand-mark"><img src="<?=e($logoPath)?>" alt="" loading="eager"></span>
                <span class="cp-brand-copy">
                    <strong><?=e($company['trade_name'] !== '' ? $company['trade_name'] : 'Colibrí Print')?></strong>
                    <small>México</small>
                </span>
            </a>

            <button class="cp-menu-toggle" type="button" aria-expanded="false" aria-controls="cp-main-menu" data-cp-menu-toggle>
                <span class="cp-menu-icon" aria-hidden="true"><i></i><i></i><i></i></span>
                <span>Menú</span>
            </button>

            <nav class="cp-main-menu" id="cp-main-menu" aria-label="Navegación administrativa">
                <?php foreach ($navGroups as $groupKey => $group):
                    $isActiveGroup = $groupHasActive($group);
                    $singleItem = count($group['items']) === 1;
                ?>
                    <?php if ($singleItem): $item = $group['items'][0]; ?>
                        <a class="cp-nav-link<?= $isActiveGroup ? ' is-active' : '' ?>" href="<?=e($item[0])?>">
                            <span class="cp-nav-icon" aria-hidden="true"><?=e($item[2])?></span>
                            <span><?=e($item[1])?></span>
                        </a>
                    <?php else: ?>
                        <div class="cp-nav-group<?= $isActiveGroup ? ' is-active' : '' ?>" data-cp-group>
                            <button class="cp-nav-trigger" type="button" aria-expanded="false" data-cp-group-toggle>
                                <span class="cp-nav-icon" aria-hidden="true"><?=e($group['icon'])?></span>
                                <span><?=e($group['label'])?></span>
                                <span class="cp-nav-chevron" aria-hidden="true">⌄</span>
                            </button>
                            <div class="cp-nav-menu" data-cp-menu>
                                <?php foreach ($group['items'] as $item):
                                    $isActive = $currentPath === $item[0];
                                ?>
                                    <a class="cp-dropdown-link<?= $isActive ? ' is-active' : '' ?>" href="<?=e($item[0])?>">
                                        <span class="cp-dropdown-icon" aria-hidden="true"><?=e($item[2])?></span>
                                        <span><?=e($item[1])?></span>
                                    </a>
                                <?php endforeach; ?>
                            </div>
                        </div>
                    <?php endif; ?>
                <?php endforeach; ?>
            </nav>

            <div class="cp-account">
                <div class="cp-avatar" aria-hidden="true"><?=e($userInitials)?></div>
                <div class="cp-account-copy">
                    <strong><?=e($userName !== '' ? $userName : 'Usuario')?></strong>
                    <small>Administrador</small>
                </div>
                <a class="cp-logout" href="/admin/logout.php">Salir</a>
            </div>
        </div>
    </header>
    <div class="cp-mobile-backdrop" data-cp-backdrop hidden></div>
    <main class="content cp-admin-content">
        <header class="cp-page-head">
            <div>
                <span class="cp-eyebrow">PLATAFORMA</span>
                <h1><?=e($title)?></h1>
            </div>
            <div class="cp-page-status"><span></span> Panel administrativo</div>
        </header>
