<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/bootstrap.php';
cp_check_csrf($_POST['csrf'] ?? null);
$_POST['section_action'] = 'catalog_save';
require __DIR__ . '/impresion_precios.php';
