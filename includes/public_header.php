<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/company.php';

if (!function_exists('cp_public_header')) {
    function cp_public_header(string $active = '', array $options = []): void
    {
        $company = company_profile();
        $brand = trim((string)($company['trade_name'] ?? '')) ?: 'Colibrí Print';
        $phone = (string)($company['phone'] ?? '');
        $email = (string)($company['email'] ?? '');
        $city = trim((string)($company['city'] ?? 'Hidalgo del Parral'));
        $state = trim((string)($company['state'] ?? 'Chihuahua'));
        $location = trim($city . ', ' . $state, ', ');
        $logo = trim((string)($company['logo_path'] ?? ''));
        if ($logo === '') $logo = '/assets/img/logo-mark.svg';

        $path = parse_url($_SERVER['REQUEST_URI'] ?? '', PHP_URL_PATH) ?: '/';
        $base = rtrim(str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'] ?? '/')), '/');
        $file = basename($path);
        if ($active === '') {
            $active = match ($file) {
                'catalogo.php', 'categoria.php', 'producto.php' => 'catalogo',
                'cotizador.php' => 'cotizador',
                'promociones-publicas.php' => 'promociones',
                'servicios.php', 'letras-corporeas-parral.php', 'grabado-laser-parral.php', 'imprenta-parral.php', 'impresion-digital-parral.php', 'productos-personalizados-parral.php' => 'servicios',
                'contacto.php' => 'contacto',
                'seguimiento.php', 'carrito.php', 'checkout.php', 'pedido.php' => '',
                default => 'inicio',
            };
        }

        $home = '/';
        $url = static function (string $target) use ($home): string {
            return $target === '' ? $home : '/' . ltrim($target, '/');
        };
        $waRaw = preg_replace('/\D+/', '', $phone);
        if ($waRaw !== '' && !str_starts_with($waRaw, '52')) $waRaw = '52' . $waRaw;
        $wa = $waRaw !== '' ? 'https://wa.me/' . $waRaw . '?text=' . rawurlencode('Hola Colibrí Print, quiero información sobre sus productos y promociones.') : '#';

        $menu = [
            ['inicio', 'Inicio', $url('')],
            ['servicios', 'Servicios', $url('') . '#servicios'],
            ['catalogo', 'Catálogo', $url('catalogo.php')],
            ['impresiones', 'Impresiones', $url('') . '#solicita-impresiones'],
            ['promociones', 'Promociones', $url('') . '#promociones'],
            ['cotizador', 'Cotizador', $url('cotizador.php')],
            ['proceso', 'Cómo trabajamos', $url('') . '#proceso'],
            ['nosotros', 'Nosotros', $url('') . '#nosotros'],
            ['contacto', 'Contacto', $url('') . '#contacto'],
        ];
        $mark = $logo;
        if (!preg_match('#^(?:https?:)?//#i', $mark)) $mark = '/' . ltrim($mark, '/');
        $menuId = 'cpPublicMainMenu';
        ?>
        <div class="cp-public-shell">
            <div class="cp-public-topbar">
                <div class="cp-public-container cp-public-topbar-inner">
                    <div class="cp-public-contact">
                        <?php if ($phone): ?><a href="tel:<?=htmlspecialchars($phone, ENT_QUOTES, 'UTF-8')?>">☎ <?=htmlspecialchars($phone, ENT_QUOTES, 'UTF-8')?></a><?php endif; ?>
                        <?php if ($email): ?><a href="mailto:<?=htmlspecialchars($email, ENT_QUOTES, 'UTF-8')?>">✉ <?=htmlspecialchars($email, ENT_QUOTES, 'UTF-8')?></a><?php endif; ?>
                        <span>⌖ <?=htmlspecialchars($location, ENT_QUOTES, 'UTF-8')?></span>
                    </div>
                    <span class="cp-public-top-tag">ATENCIÓN EN TODO MÉXICO</span>
                </div>
            </div>
            <header class="cp-public-header" data-cp-public-header>
                <div class="cp-public-container cp-public-nav-row">
                    <a class="cp-public-brand" href="<?=$url('')?>" aria-label="<?=$brand?> México">
                        <span class="cp-public-brand-mark"><img src="<?=htmlspecialchars($mark, ENT_QUOTES, 'UTF-8')?>" alt="" loading="eager"></span>
                        <span class="cp-public-brand-copy"><strong>Colibrí <b>Print</b></strong><small>MÉXICO · SOLUCIONES GRÁFICAS</small></span>
                    </a>
                    <button class="cp-public-menu-toggle" type="button" aria-expanded="false" aria-controls="<?=$menuId?>" data-cp-public-toggle>
                        <span>MENÚ</span><i aria-hidden="true">☰</i>
                    </button>
                    <nav class="cp-public-nav" id="<?=$menuId?>" aria-label="Navegación principal" data-cp-public-nav>
                        <?php foreach ($menu as [$key, $label, $href]): ?>
                            <a class="<?= $active === $key ? 'is-active' : '' ?>" href="<?=htmlspecialchars($href, ENT_QUOTES, 'UTF-8')?>"><?=htmlspecialchars($label, ENT_QUOTES, 'UTF-8')?></a>
                        <?php endforeach; ?>
                    </nav>
                    <div class="cp-public-actions">
                        <span class="cp-public-location"><b>⌖</b><span><strong><?=htmlspecialchars($location, ENT_QUOTES, 'UTF-8')?></strong><small>Atención en todo México</small></span></span>
                        <?php if ($waRaw !== ''): ?><a class="cp-public-cta" href="<?=htmlspecialchars($wa, ENT_QUOTES, 'UTF-8')?>" target="_blank" rel="noopener">Cotizar ahora <span>→</span></a><?php endif; ?>
                    </div>
                </div>
            </header>
            <div class="cp-public-backdrop" data-cp-public-backdrop hidden></div>
        </div>
        <?php
    }
}
