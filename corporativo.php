<?php
declare(strict_types=1);
require_once __DIR__ . '/config/runtime.php';
require_once __DIR__ . '/includes/company.php';

$company = company_profile();

function h(string $v): string { return htmlspecialchars($v, ENT_QUOTES, 'UTF-8'); }
function route(string $path = ''): string { return '//' . ltrim($path, '/'); }
function wa_url(string $text): string {
    global $company;
    $phone = preg_replace('/\D+/', '', (string)($company['phone'] ?? ''));
    if ($phone !== '' && !str_starts_with($phone, '52')) $phone = '52' . $phone;
    return $phone ? 'https://wa.me/' . $phone . '?text=' . rawurlencode($text) : '#';
}

$brand = $company['trade_name'] ?: 'Colibrí Print';
$city = trim((string)($company['city'] ?? 'HIDALGO DEL PARRAL'));
$state = trim((string)($company['state'] ?? 'CHIHUAHUA'));
$address = trim((string)($company['address'] ?? 'Calle Alemania 87'));
$neighborhood = trim((string)($company['neighborhood'] ?? 'LOMA LINDA'));
$phone = trim((string)($company['phone'] ?? '6271470053'));
$email = trim((string)($company['email'] ?? 'ventas@colibriprint.com.mx'));
$waText = 'Hola Colibrí Print México, quiero solicitar información sobre sus servicios.';
$wa = wa_url($waText);
$services = [
    ['icon'=>'✦','title'=>'Branding y Diseño Gráfico Pro','text'=>'Desarrollamos la imagen corporativa a medida: logotipos, isologos, papelería comercial, hojas membretadas, tarjetas, sobres, carpetas, facturas, catálogos y diseño publicitario.'],
    ['icon'=>'A','title'=>'Letras Corpóreas y Corte CNC','text'=>'Equipos profesionales para garantizar medidas exactas en letras tridimensionales y logotipos independientes de acrílico, metal, plástico o madera.'],
    ['icon'=>'⌁','title'=>'Grabado Láser de Alta Precisión','text'=>'Detalle milimétrico en artículos promocionales, placas, reconocimientos y termos mediante equipos profesionales.'],
    ['icon'=>'▣','title'=>'Sellos de Goma Autoentintables','text'=>'Selección completa de tamaños con la marca Trodat, desde opciones prácticas hasta formatos grandes para oficina y negocio.'],
    ['icon'=>'◉','title'=>'Impresión Comestible','text'=>'Oblea de azúcar con colores intensos y sabor vainilla, y oblea de papel de arroz o papa con sabor neutro, ideales para postres.'],
    ['icon'=>'T','title'=>'Textiles y Ropa Personalizada','text'=>'Playeras polo 50% poliéster y 50% algodón, además de playeras de cuello redondo 100% algodón, modelo C300 de Yazbek, desde 12 piezas.'],
    ['icon'=>'◆','title'=>'Artículos Promocionales y Souvenirs','text'=>'Vasos jaiboleros, tequileros, tarros cristalinos de 1 litro, tazas personalizadas, botellas de aluminio, cojines, rompecabezas, fotobotones y vinilos decorativos.'],
];
$specialties = [
    ['title'=>'Vinil de Corte','text'=>'Rotulación en vinil de alta durabilidad para cristales, muros y vehículos. Acabado profesional para identidad corporativa o decoración.'],
    ['title'=>'Sellos Personalizados','text'=>'Sellos automáticos y de madera para oficina o negocio. Rapidez y nitidez para formalizar tus documentos.'],
    ['title'=>'Letras Corpóreas','text'=>'Fabricación de letras 3D en aluminio y PVC con corte en CNC Router. Relieve y elegancia para fachadas.'],
    ['title'=>'Instalación y Asesoría','text'=>'Servicio completo de montaje y asesoría técnica en Hidalgo del Parral para que tu publicidad quede bien colocada.'],
    ['title'=>'Gran Formato','text'=>'Publicidad exterior e interior de gran impacto. Calidad fotográfica en diversos materiales para proyectos visibles.'],
    ['title'=>'Branding e Identidad','text'=>'Diseño de logotipos y manuales de identidad. Una imagen sólida y profesional para conectar tu marca con tus clientes.'],
    ['title'=>'Invitaciones Especiales','text'=>'Diseño y creación de invitaciones únicas para bodas, XV años y eventos con detalles premium.'],
    ['title'=>'Souvenirs y Regalos','text'=>'Personalización de termos, tazas y promocionales para eventos sociales o para posicionar tu marca todos los días.'],
    ['title'=>'Artículos Láser','text'=>'Grabado y corte láser de precisión en madera, acrílico y más para reconocimientos, medallas y regalos.'],
    ['title'=>'Impresión de Lonas','text'=>'Lonas de gran formato en alta calidad, resistentes y con acabado profesional para destacar tu negocio.'],
];
?>
<!doctype html>
<html lang="es-MX">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Servicios y Soluciones | <?=h($brand)?> México</title>
<meta name="description" content="Servicios de branding, diseño gráfico, impresión, grabado láser, CNC, textiles, souvenirs, sellos y gran formato de Colibrí Print México.">
<meta name="theme-color" content="#05070b">
<link rel="stylesheet" href="/assets/css/corporativo-v1.css" onerror="this.href='/assets/css/corporativo-v1.css'">

<link rel="stylesheet" href="/assets/css/public-header-unified-v1.css?v=20260927-1">
<script src="/assets/js/public-header-unified-v1.js?v=20260927-1" defer></script>
</head>
<body>
<a class="skip" href="#contenido">Saltar al contenido</a>
<?php require_once __DIR__ . '/includes/public_header.php'; cp_public_header('servicios'); ?>

<main id="contenido">
<section class="hero">
  <div class="hero-bg"></div>
  <div class="container hero-content">
    <div class="hero-copy">
      <span class="eyebrow">SOLUCIONES GRÁFICAS PARA TU MARCA</span>
      <h1>Todo lo que tu marca necesita para <span>verse profesional.</span></h1>
      <p>Desde la identidad corporativa hasta la producción física: diseñamos, imprimimos, grabamos, fabricamos e instalamos soluciones para negocios, eventos y proyectos.</p>
      <div class="hero-actions"><a class="btn primary" href="#servicios">Explorar servicios →</a><a class="btn ghost" href="<?=h($wa)?>" target="_blank" rel="noopener">WhatsApp ↗</a></div>
      <div class="hero-points"><span>✦ Diseño</span><span>✦ Precisión</span><span>✦ Producción</span><span>✦ Entrega</span></div>
    </div>
  </div>
</section>

<section class="intro-strip">
  <div class="container intro-grid">
    <div><span class="eyebrow">COLIBRÍ PRINT MÉXICO</span><h2>Una sola marca. Muchas formas de hacerla realidad.</h2></div>
    <p>Trabajamos proyectos de identidad, publicidad, personalización y producción gráfica con una visión práctica: que lo que diseñamos pueda convertirse en piezas reales, visibles y útiles para tu negocio.</p>
  </div>
</section>

<section id="servicios" class="section services-section">
  <div class="container">
    <div class="section-head"><div><span class="eyebrow">NUESTROS SERVICIOS</span><h2>Soluciones completas para tu negocio o evento</h2></div><a class="outline-link" href="<?=route('catalogo.php')?>">Ver catálogo →</a></div>
    <div class="service-grid">
      <?php foreach ($services as $i => $item): ?>
      <article class="service-card reveal">
        <div class="service-number">0<?=($i+1)?></div><div class="service-icon"><?=h($item['icon'])?></div>
        <h3><?=h($item['title'])?></h3><p><?=h($item['text'])?></p>
        <a href="#contacto">Solicitar información →</a>
      </article>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<section id="especialidades" class="section specialty-section">
  <div class="container">
    <div class="section-head"><div><span class="eyebrow">NUESTRAS ESPECIALIDADES</span><h2>Lo que nos hace únicos</h2></div></div>
    <div class="specialty-layout">
      <div class="specialty-list">
        <?php foreach ($specialties as $i => $item): ?>
        <article class="specialty reveal"><span class="specialty-index">0<?=($i+1)?></span><div><h3><?=h($item['title'])?></h3><p><?=h($item['text'])?></p></div></article>
        <?php endforeach; ?>
      </div>
      <div class="collage-card"><img src="/assets/img/corporativo/especialidades-collage.png" alt="Ejemplos de impresión, sublimación, corte CNC, grabado láser y artículos personalizados" loading="lazy"></div>
    </div>
  </div>
</section>

<section id="nosotros" class="section about-section">
  <div class="container about-grid">
    <div><span class="eyebrow">SOBRE COLIBRÍ PRINT MÉXICO</span><h2>Más que impresión, somos un aliado para hacer visible tu idea.</h2><p>Combinamos diseño, personalización y producción para que tu marca tenga coherencia desde una tarjeta o un sello hasta una fachada, una lona, una prenda o un artículo promocional.</p><p class="about-quote">“Tu idea, nuestra inspiración. Tu éxito, nuestro objetivo.”</p></div>
    <div class="about-badges"><div><strong>Diseño</strong><span>Identidad y piezas gráficas</span></div><div><strong>Producción</strong><span>Materiales y acabados</span></div><div><strong>Precisión</strong><span>CNC y grabado láser</span></div><div><strong>Asesoría</strong><span>Montaje y acompañamiento</span></div></div>
  </div>
</section>

<section id="contacto" class="section contact-section">
  <div class="container contact-grid">
    <div><span class="eyebrow">CONTÁCTANOS</span><h2>Estamos listos para ayudarte.</h2><p>Cuéntanos qué necesitas y te orientamos sobre materiales, cantidades, opciones de personalización, tiempos y cotización.</p><div class="contact-actions"><a class="btn primary" href="<?=h($wa)?>" target="_blank" rel="noopener">Hablar por WhatsApp →</a><a class="btn light" href="mailto:<?=h($email)?>">Enviar correo</a></div></div>
    <div class="contact-card">
      <div><span class="label">TELÉFONO</span><a href="tel:<?=h($phone)?>">+52 <?=h($phone)?></a></div>
      <div><span class="label">WHATSAPP</span><a href="<?=h($wa)?>" target="_blank" rel="noopener">+52 <?=h($phone)?></a></div>
      <div><span class="label">CORREO</span><a href="mailto:<?=h($email)?>"><?=h($email)?></a></div>
      <div><span class="label">UBICACIÓN</span><strong><?=h($address)?>, <?=h($neighborhood)?>, <?=h($city)?>, <?=h($state)?></strong></div>
      <div class="socials"><span class="label">SÍGUENOS</span><div><a href="https://www.instagram.com/colibriprintmexico/" target="_blank" rel="noopener">Instagram</a><a href="https://www.tiktok.com/@colibriprintmexico" target="_blank" rel="noopener">TikTok</a></div></div>
    </div>
  </div>
</section>
</main>

<footer class="footer"><div class="container footer-grid"><div class="footer-brand"><img src="/assets/img/corporativo/logo-colibri.png" alt="Colibrí Print México"><div><strong>Colibrí <b>Print</b></strong><small>MÉXICO · SOLUCIONES GRÁFICAS</small></div></div><div><h4>Navegación</h4><a href="<?=route('')?>">Inicio</a><a href="#servicios">Servicios</a><a href="<?=route('catalogo.php')?>">Catálogo</a><a href="#especialidades">Especialidades</a></div><div><h4>Contacto</h4><a href="<?=h($wa)?>" target="_blank" rel="noopener">WhatsApp</a><a href="mailto:<?=h($email)?>">Correo</a><span><?=h($city)?>, <?=h($state)?></span></div><div><p class="footer-slogan">IMPRIMIMOS<br><span>TUS IDEAS</span></p><div class="footer-lines"><i></i><i></i><i></i><i></i></div></div></div><div class="container copyright">© <?=date('Y')?> Colibrí Print México. Todos los derechos reservados.</div></footer>
<script src="/assets/js/corporativo-v1.js"></script>
</body></html>
