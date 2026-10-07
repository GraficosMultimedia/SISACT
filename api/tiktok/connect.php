<?php
declare(strict_types=1);

require_once __DIR__ . '/../../config/runtime.php';
require_once __DIR__ . '/../../includes/tiktok.php';

require_auth();

$state = bin2hex(random_bytes(24));
$_SESSION['tiktok_oauth_state'] = $state;

header('Location: ' . tiktok_authorize_url($state));
exit;
