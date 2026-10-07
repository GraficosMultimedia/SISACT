<?php
declare(strict_types=1);
require_once __DIR__ . '/config/runtime.php';
require_once __DIR__ . '/includes/company.php';

$company = company_profile();

function cp_h(string $v): string { return htmlspecialchars($v, ENT_QUOTES, 'UTF-8'); }

function cp_base(): string {
    static $base = null;
    if ($base !== null) return $base;
    $doc = isset($_SERVER['DOCUMENT_ROOT']) ? realpath((string)$_SERVER['DOCUMENT_ROOT']) : false;
    $root = realpath(__DIR__);
    if ($doc && $root) {
        $doc = rtrim(str_replace('\\','/',$doc),'/');
        $root = str_replace('\\','/',$root);
        if ($doc === $root) return $base = '';
        $prefix = $doc.'/';
        if (str_starts_with($root,$prefix)) {
            $rel = trim(substr($root,strlen($prefix)),'/');
            return $base = $rel !== '' ? '/'.$rel : '';
        }
    }
    return $base = '';
}
function cp_url(string $path=''): string { return cp_base().'/'.ltrim($path,'/'); }

$brand = trim((string)($company['trade_name'] ?? '')) ?: 'Colibrí Print';
$phone = (string)($company['phone'] ?? '627 147 0053');
$email = (string)($company['email'] ?? '');
$location = trim((string)($company['city'] ?? 'Hidalgo del Parral')).', '.trim((string)($company['state'] ?? 'Chihuahua'));
$digits = preg_replace('/\D+/', '', $phone);
if ($digits !== '' && !str_starts_with($digits,'52')) $digits = '52'.$digits;
$wa = $digits ? 'https://wa.me/'.$digits.'?text='.rawurlencode('Hola Colibrí Print México, quiero cotizar un proyecto.') : '#';
$mark = cp_url('assets/img/home/colibri-mark-v1.png');
?>
<!doctype html>
<html lang="es-MX">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="description" content="Cotiza tu proyecto con Colibrí Print México.">
<meta name="robots" content="index,follow">
<meta name="theme-color" content="#08090d">
<title>Cotiza tu proyecto | Colibrí Print México</title>
<link rel="canonical" href="<?=cp_h(((!empty($_SERVER['HTTPS'])&&$_SERVER['HTTPS']!=='off')?'https':'http').'://'.($_SERVER['HTTP_HOST']??'localhost').cp_url('cotizador.php'))?>">
<link rel="stylesheet" href="<?=cp_h(cp_url('assets/css/home-v5.css'))?>?v=20260919-1">
<link rel="stylesheet" href="<?=cp_h(cp_url('assets/css/pasarela-cotizador.css'))?>?v=20260919-3">
<link rel="stylesheet" href="<?=cp_h(cp_url('assets/css/home-legibility-v5.css'))?>?v=20260919-1">
<style>
.cpq-page-head{padding:58px 0 34px;background:#08090d;color:#fff}
.cpq-page-head h1{margin:10px 0 12px;font-size:clamp(44px,6vw,72px);line-height:.95;letter-spacing:-.05em}
.cpq-page-head h1 span{color:#ff1751}
.cpq-page-head p{max-width:760px;color:#aebbc6;font-size:17px;line-height:1.65;margin:0}
.cpq-lock{overflow:hidden}
#cpqSubmitState{margin-top:12px;font-size:13px;color:#596c7d;min-height:18px}
#cpqSubmitState.is-error{color:#b62042;background:#fff1f4;border:1px solid #ffc4d1;border-radius:10px;padding:11px 12px}
.cpq-result.is-visible{display:block}
.cpq-result{display:none}
@media(max-width:640px){
 .cpq-page-head{padding:45px 0 28px}
 .cpq-page-head h1{font-size:44px}
 .cpq-page-head p{font-size:15px}
}
</style>

<link rel="stylesheet" href="/assets/css/public-header-unified-v1.css?v=20260927-1">
<script src="/assets/js/public-header-unified-v1.js?v=20260927-1" defer></script>
</head>
<body>
<?php require_once __DIR__ . '/includes/public_header.php'; cp_public_header('cotizador'); ?>

<main>
<section class="cpq-page-head">
  <div class="shell">
    <div class="eyebrow">COTIZADOR COLIBRÍ PRINT</div>
    <h1>Cuéntanos tu <span>proyecto.</span></h1>
    <p>Una sola pasarela para reunir servicio, detalles, archivos, entrega y contacto. La solicitud se guarda en Colibrí Print al finalizar.</p>
  </div>
</section>

<section class="cpq-section" id="cpq-launch">
  <div class="cpq-bg-grid" aria-hidden="true"></div>
  <div class="cpq-glow cpq-glow-red" aria-hidden="true"></div>
  <div class="cpq-glow cpq-glow-yellow" aria-hidden="true"></div>
  <div class="cpq-shell">
    <div class="cpq-intro">
      <p class="cpq-eyebrow">DE UNA IDEA A UN GRAN RESULTADO</p>
      <h2>Tu proyecto, <strong>nuestra pasión.</strong></h2>
      <p>Responde unas preguntas y reúne toda la información necesaria para que nuestro equipo pueda revisar y cotizar tu proyecto.</p>
      <button class="cpq-open cpq-open-primary" id="openQuote" type="button">Quiero cotizar <span>→</span></button>
      <div class="cpq-benefits"><span><b>01</b> Te escuchamos</span><span><b>02</b> Definimos</span><span><b>03</b> Preparamos</span><span><b>04</b> Entregamos</span></div>
    </div>
    <div class="cpq-process-card">
      <button class="cpq-process-row is-active" type="button" data-step-open="1"><span class="cpq-process-num">01</span><span><b>Cuéntanos</b><small>qué necesitas</small></span><i>↗</i></button>
      <button class="cpq-process-row" type="button" data-step-open="2"><span class="cpq-process-num">02</span><span><b>Definimos</b><small>materiales y detalles</small></span><i>↗</i></button>
      <button class="cpq-process-row" type="button" data-step-open="3"><span class="cpq-process-num">03</span><span><b>Preparamos</b><small>diseño y archivos</small></span><i>↗</i></button>
      <button class="cpq-process-row" type="button" data-step-open="4"><span class="cpq-process-num">04</span><span><b>Entregamos</b><small>contacto y fecha</small></span><i>↗</i></button>
    </div>
  </div>
</section>

<div class="cpq-modal" id="cpqModal" aria-hidden="true">
  <div class="cpq-backdrop" id="cpqBackdrop"></div>
  <div class="cpq-dialog" role="dialog" aria-modal="true" aria-labelledby="cpqTitle">
    <header class="cpq-dialog-head"><div><span class="cpq-mini">COTIZADOR COLIBRÍ PRINT</span><h3 id="cpqTitle">Cuéntanos tu proyecto</h3></div><button class="cpq-close" id="cpqClose" type="button" aria-label="Cerrar">×</button></header>

    <div class="cpq-progress-wrap">
      <div class="cpq-progress-label"><span id="cpqStepTitle">Servicio</span><strong><span id="cpqStepNumber">1</span> / 5</strong></div>
      <div class="cpq-progress"><span class="is-current"></span><span></span><span></span><span></span><span></span></div>
    </div>

    <form id="cpqForm" enctype="multipart/form-data" novalidate>
      <div class="cpq-step is-visible" data-step="1">
        <div class="cpq-step-head"><span>01</span><div><p>EMPECEMOS</p><h4>¿Qué quieres producir?</h4><small>Elige el servicio que más se acerque a tu proyecto.</small></div></div>
        <div class="cpq-service-grid" id="cpqServiceGrid"></div>
        <div class="cpq-inline-error" id="cpqServiceError" aria-live="polite"></div>
      </div>

      <div class="cpq-step" data-step="2">
        <div class="cpq-step-head"><span>02</span><div><p>DETALLES DEL SERVICIO</p><h4 id="cpqDetailsTitle">Definamos tu proyecto</h4><small>Solo aparecerán las preguntas relacionadas con el servicio seleccionado.</small></div></div>
        <div class="cpq-fields" id="cpqDynamicFields"></div>
      </div>

      <div class="cpq-step" data-step="3">
        <div class="cpq-step-head"><span>03</span><div><p>DISEÑO Y ARCHIVOS</p><h4>Preparemos la producción</h4><small>Indica el estado de tu diseño y adjunta una referencia si la tienes.</small></div></div>
        <div class="cpq-fields">
          <label class="cpq-field"><span>¿Ya tienes diseño?</span><select name="design_status"><option>Tengo el diseño final</option><option>Tengo un boceto o referencia</option><option>Necesito diseño</option><option>Solo tengo la idea</option></select></label>
          <label class="cpq-field"><span>¿Necesitas aplicación / instalación?</span><select name="application"><option>No aplica</option><option>Sí, necesito aplicación</option><option>Sí, necesito instalación</option><option>No lo sé todavía</option></select></label>
          <label class="cpq-field cpq-full"><span>Archivo o referencia</span><input type="file" name="attachment" accept=".jpg,.jpeg,.png,.webp,.pdf,.ai,.eps,.cdr,.svg,.psd,.zip"></label>
          <label class="cpq-field cpq-full"><span>Cuéntanos algo más</span><textarea name="notes" rows="5" placeholder="Colores, medidas, evento, acabados, referencias o cualquier detalle importante..."></textarea></label>
        </div>
      </div>

      <div class="cpq-step" data-step="4">
        <div class="cpq-step-head"><span>04</span><div><p>ENTREGA Y CONTACTO</p><h4>¿Dónde y cuándo lo necesitas?</h4><small>Estos datos nos permiten dar seguimiento a tu solicitud.</small></div></div>
        <div class="cpq-fields">
          <label class="cpq-field"><span>Nombre *</span><input required name="name" autocomplete="name" placeholder="Tu nombre o empresa"></label>
          <label class="cpq-field"><span>WhatsApp *</span><input required name="phone" autocomplete="tel" inputmode="tel" placeholder="627 147 0053"></label>
          <label class="cpq-field"><span>Correo</span><input type="email" name="email" autocomplete="email" placeholder="correo@empresa.com"></label>
          <label class="cpq-field"><span>Forma de entrega</span><select name="delivery_method"><option>Recoger en sucursal</option><option>Entrega local</option><option>Paquetería</option><option>Aún no lo sé</option></select></label>
          <label class="cpq-field cpq-full"><span>¿Para cuándo lo necesitas?</span><input type="date" name="desired_date"><small>No es una promesa de entrega. Nos ayuda a priorizar y confirmar tiempos.</small></label>
          <input type="text" name="website" class="cpq-honeypot" tabindex="-1" autocomplete="off" aria-hidden="true">
        </div>
      </div>

      <div class="cpq-step" data-step="5">
        <div class="cpq-step-head"><span>05</span><div><p>REVISA ANTES DE ENVIAR</p><h4>Tu solicitud está casi lista.</h4><small>Confirma los datos principales antes de enviarla.</small></div></div>
        <div class="cpq-review" id="cpqReview"></div>
        <div class="cpq-review-note"><strong>Sobre el precio</strong><p>Esta pasarela no inventa precios. La solicitud se guarda y Colibrí Print confirma la cotización formal según medidas, materiales, cantidad, acabados, diseño y tiempos.</p></div>
        <div id="cpqSubmitState" aria-live="polite"></div>
      </div>

      <div class="cpq-result" id="cpqResult">
        <div class="cpq-result-icon">✓</div><span class="cpq-mini">SOLICITUD REGISTRADA</span><h4>Ya tenemos tu proyecto.</h4><p id="cpqResultText"></p>
        <div class="cpq-ticket"><span>FOLIO DE SOLICITUD</span><strong id="cpqRequestId">CPQ-000000</strong><small>Guarda este folio.</small></div>
        <div class="cpq-result-actions"><a class="cpq-open cpq-open-primary" id="cpqResultWhatsApp" href="#" target="_blank" rel="noopener">Enviar por WhatsApp ↗</a><button class="cpq-open cpq-open-secondary" id="cpqNewRequest" type="button">Nueva cotización</button></div>
      </div>

      <footer class="cpq-footer" id="cpqFooter">
        <button class="cpq-open cpq-open-secondary" id="cpqBack" type="button">← Atrás</button>
        <div class="cpq-footer-right"><span id="cpqFooterLabel">Paso 1 de 5</span><button class="cpq-open cpq-open-primary" id="cpqNext" type="button">Continuar →</button></div>
      </footer>
    </form>
  </div>
</div>
</main>

<footer class="footer" id="contacto">
  <div class="shell footer-grid">
    <div><div class="footer-brand"><img src="<?=cp_h($mark)?>" alt=""><div><strong>Colibrí <b>Print</b></strong><small>MÉXICO · SOLUCIONES GRÁFICAS</small></div></div><p><?=cp_h((string)($company['address']??''))?> · <?=cp_h($location)?></p></div>
    <div><strong>Contacto</strong><?php if($phone):?><a href="tel:<?=cp_h($phone)?>"><?=cp_h($phone)?></a><?php endif;?><?php if($email):?><a href="mailto:<?=cp_h($email)?>"><?=cp_h($email)?></a><?php endif;?></div>
    <div><strong>Explora</strong><a href="<?=cp_h(cp_url(''))?>#servicios">Servicios</a><a href="<?=cp_h(cp_url('catalogo.php'))?>">Catálogo</a><a href="<?=cp_h(cp_url('cotizador.php'))?>">Cotiza tu proyecto</a><a href="<?=cp_h(cp_url(''))?>#nosotros">Nosotros</a></div>
    <div><strong>¿Listo?</strong><a class="footer-cta" href="#cpq-launch">Empezar cotización →</a></div>
  </div>
  <div class="shell footer-bottom"><span>© <?=date('Y')?> <?=cp_h($brand)?>. Todos los derechos reservados.</span></div>
</footer>

<script defer src="<?=cp_h(cp_url('assets/js/home-v5.js'))?>?v=20260919-1"></script>
<script>
(() => {
'use strict';

const SERVICES = {
  playeras:{name:'Playeras personalizadas',icon:'👕',desc:'DTF, bordado, vinil o sublimación',fields:[
    {name:'quantity',label:'Cantidad de piezas',type:'number',min:1,placeholder:'Ej. 25',required:true},
    {name:'garment',label:'Tipo de prenda',type:'select',options:['Playera cuello redondo','Playera polo','Sudadera','Otra']},
    {name:'technique',label:'Técnica',type:'select',options:['DTF','Bordado','Sublimación','Vinil textil','No lo sé todavía']},
    {name:'color',label:'Color de prenda',type:'text',placeholder:'Ej. Negro, blanco...'}]},
  bordado:{name:'Bordado',icon:'🧵',desc:'Prendas, gorras y artículos',fields:[
    {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 20',required:true},
    {name:'item',label:'¿Qué vamos a bordar?',type:'text',placeholder:'Playeras, gorras, chamarras...'},
    {name:'positions',label:'Número de posiciones',type:'select',options:['1','2','3 o más']},
    {name:'size',label:'Tamaño aproximado del bordado',type:'select',options:['Pequeño','Mediano','Grande','No lo sé']}]},
  sublimacion:{name:'Sublimación',icon:'🎨',desc:'Textiles y artículos personalizados',fields:[
    {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 12',required:true},
    {name:'product',label:'Producto',type:'select',options:['Taza','Playera','Termo','Llavero','Rompecabezas','Otro']},
    {name:'colors',label:'¿Cuántos diseños diferentes?',type:'number',min:1,placeholder:'Ej. 2'},
    {name:'size',label:'Medida o tamaño',type:'text',placeholder:'Ej. 22 × 9 cm'}]},
  dtf:{name:'DTF',icon:'✨',desc:'Impresión para personalización textil',fields:[
    {name:'quantity',label:'Cantidad de aplicaciones',type:'number',min:1,placeholder:'Ej. 25',required:true},
    {name:'size',label:'Tamaño aproximado',type:'select',options:['Logo pequeño','A4','A3','Medio metro','Metro','Varios metros']},
    {name:'designs',label:'¿Cuántos diseños diferentes?',type:'number',min:1,placeholder:'Ej. 3'},
    {name:'application',label:'¿Necesitas aplicación en prenda?',type:'select',options:['Sí','No','Todavía no lo sé']}]},
  impresion:{name:'Impresión',icon:'🖨️',desc:'Papelería, publicidad y piezas impresas',fields:[
    {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 100',required:true},
    {name:'product',label:'¿Qué producto necesitas?',type:'text',placeholder:'Tarjetas, volantes, trípticos, menús...'},
    {name:'size',label:'Medidas',type:'text',placeholder:'Ej. Carta, media carta, 90 × 60 cm...'},
    {name:'material',label:'Material',type:'text',placeholder:'Couché, opalina, sintético...'},
    {name:'finish',label:'Acabado',type:'select',options:['Sin acabado','Laminado','Barniz','Corte','Doblez','No lo sé']}]},
  gran_formato:{name:'Gran formato',icon:'🖼️',desc:'Lonas, vinil, banners y publicidad',fields:[
    {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 1',required:true},
    {name:'product',label:'Producto',type:'select',options:['Lona','Vinil de impresión','Vinil de corte','Banner','Pendón','Otro']},
    {name:'width',label:'Ancho (cm)',type:'number',min:1,placeholder:'Ej. 200'},
    {name:'height',label:'Alto (cm)',type:'number',min:1,placeholder:'Ej. 100'},
    {name:'finish',label:'Acabado',type:'select',options:['Ojillos','Dobladillo','Instalación','Sin acabado','No lo sé']}]},
  etiquetas:{name:'Etiquetas y stickers',icon:'🏷️',desc:'Etiquetas adhesivas y señalización',fields:[
    {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 500',required:true},
    {name:'size',label:'Medida',type:'text',placeholder:'Ej. 5 × 5 cm'},
    {name:'material',label:'Material',type:'select',options:['Papel','Vinil','Transparente','Otro']},
    {name:'finish',label:'Acabado',type:'select',options:['Mate','Brillante','Troquelado','Rectangular','No lo sé']},
    {name:'roll',label:'Presentación',type:'select',options:['Por pieza','En rollo','No lo sé']}]},
  sellos:{name:'Sellos personalizados',icon:'◼',desc:'Autoentintables y de madera',fields:[
    {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 1',required:true},
    {name:'type',label:'Tipo de sello',type:'select',options:['Autoentintable','Madera','Otro']},
    {name:'size',label:'Tamaño aproximado',type:'text',placeholder:'Ej. 38 × 14 mm'},
    {name:'text',label:'Texto que llevará',type:'text',placeholder:'Nombre, RFC, teléfono...'}]},
  laser:{name:'Grabado láser',icon:'⌁',desc:'Madera, acrílico, termos y reconocimientos',fields:[
    {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 10',required:true},
    {name:'material',label:'Material / artículo',type:'text',placeholder:'Madera, acrílico, termo...'},
    {name:'size',label:'Medidas aproximadas',type:'text',placeholder:'Ej. 10 × 10 cm'},
    {name:'detail',label:'¿Qué se grabará?',type:'text',placeholder:'Logo, nombre, frase, diseño...'}]},
  cnc:{name:'Corte CNC',icon:'✂',desc:'MDF, melamina, madera, acrílico y más',fields:[
    {name:'quantity',label:'Cantidad de piezas',type:'number',min:1,placeholder:'Ej. 4',required:true},
    {name:'material',label:'Material',type:'text',placeholder:'MDF, melamina, madera, acrílico...'},
    {name:'thickness',label:'Espesor',type:'text',placeholder:'Ej. 15 mm'},
    {name:'size',label:'Medidas de placa',type:'text',placeholder:'Ej. 122 × 244 cm'},
    {name:'cut_type',label:'Tipo de trabajo',type:'select',options:['Corte recto','Corte con forma','Perforado','Grabado CNC','No lo sé']}]},
  corporea:{name:'Letras corpóreas',icon:'🔠',desc:'3D para fachadas, interiores y señalización',fields:[
    {name:'quantity',label:'Cantidad de letras / piezas',type:'number',min:1,placeholder:'Ej. 8',required:true},
    {name:'material',label:'Material',type:'select',options:['PVC','Acrílico','Aluminio','Madera','Otro']},
    {name:'height',label:'Altura aproximada',type:'text',placeholder:'Ej. 30 cm'},
    {name:'installation',label:'¿Requieres instalación?',type:'select',options:['Sí','No','No lo sé']}]},
  diseno:{name:'Diseño gráfico',icon:'✎',desc:'Logotipos, publicidad, identidad y piezas digitales',fields:[
    {name:'quantity',label:'Cantidad de piezas / diseños',type:'number',min:1,placeholder:'Ej. 1',required:true},
    {name:'type',label:'Tipo de diseño',type:'select',options:['Logotipo','Identidad corporativa','Flyer','Etiqueta','Menú','Redes sociales','Catálogo','Invitación','Otro']},
    {name:'format',label:'Entrega final',type:'select',options:['Digital','Impresión','Digital + impresión']},
    {name:'reference',label:'¿Tienes referencias?',type:'text',placeholder:'Describe el estilo, colores o referencias...'}]},
  comestible:{name:'Impresión comestible',icon:'🍰',desc:'Oblea de azúcar y papel de arroz/papa',fields:[
    {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 20',required:true},
    {name:'material',label:'Tipo de oblea',type:'select',options:['Azúcar sabor vainilla','Arroz / papa sabor neutro','No lo sé']},
    {name:'size',label:'Medidas',type:'text',placeholder:'Ej. 20 × 20 cm'},
    {name:'event',label:'¿Para qué evento o producto?',type:'text',placeholder:'Pastel, cupcakes, evento...'}]},
  promo:{name:'Artículos promocionales',icon:'🎁',desc:'Tazas, termos, vasos, botellas, souvenirs y más',fields:[
    {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 30',required:true},
    {name:'product',label:'Producto',type:'text',placeholder:'Taza, termo, botella, vaso, cojín...'},
    {name:'personalization',label:'Personalización',type:'text',placeholder:'Logo, nombre, frase, foto...'},
    {name:'occasion',label:'Uso / evento',type:'text',placeholder:'Empresa, boda, regalo, evento...'}]},
  vinil:{name:'Vinil de corte',icon:'✦',desc:'Cristales, muros, vehículos y rotulación',fields:[
    {name:'quantity',label:'Cantidad de piezas',type:'number',min:1,placeholder:'Ej. 2',required:true},
    {name:'surface',label:'¿Dónde se instalará?',type:'select',options:['Cristal','Muro','Vehículo','Otro']},
    {name:'size',label:'Medidas',type:'text',placeholder:'Ej. 100 × 50 cm'},
    {name:'color',label:'Color de vinil',type:'text',placeholder:'Ej. Negro, blanco, rojo...'}]},
  invitaciones:{name:'Invitaciones especiales',icon:'💌',desc:'Bodas, XV años y eventos',fields:[
    {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 100',required:true},
    {name:'event',label:'Tipo de evento',type:'select',options:['Boda','XV años','Cumpleaños','Bautizo','Corporativo','Otro']},
    {name:'size',label:'Formato / tamaño',type:'text',placeholder:'Ej. 15 × 21 cm'},
    {name:'finish',label:'Acabado',type:'select',options:['Simple','Premium','Con sobre','Con acabados especiales','No lo sé']}]},
  otro:{name:'Otro proyecto',icon:'＋',desc:'Algo diferente que quieres fabricar o imprimir',fields:[
    {name:'quantity',label:'Cantidad aproximada',type:'number',min:1,placeholder:'Ej. 1'},
    {name:'project',label:'¿Qué necesitas?',type:'text',placeholder:'Descríbelo en una frase...'},
    {name:'size',label:'Medidas aproximadas',type:'text',placeholder:'Si aplica'},
    {name:'material',label:'Material',type:'text',placeholder:'Si lo conoces'}]}
};

const modal = document.getElementById('cpqModal');
const form = document.getElementById('cpqForm');
const serviceGrid = document.getElementById('cpqServiceGrid');
const dynamicFields = document.getElementById('cpqDynamicFields');
const review = document.getElementById('cpqReview');
const footer = document.getElementById('cpqFooter');
const next = document.getElementById('cpqNext');
const back = document.getElementById('cpqBack');
const result = document.getElementById('cpqResult');
const submitState = document.getElementById('cpqSubmitState');

let currentStep = 1;
let selectedService = '';

const esc = value => String(value ?? '').replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[char]));

function renderServices() {
  serviceGrid.innerHTML = Object.entries(SERVICES).map(([key,service]) => `
    <button type="button" class="cpq-service ${selectedService===key?'is-selected':''}" data-service="${esc(key)}">
      <span class="cpq-service-icon">${service.icon}</span>
      <span class="cpq-service-name">${esc(service.name)}</span>
      <small>${esc(service.desc)}</small><i>→</i>
    </button>`).join('');

  serviceGrid.querySelectorAll('[data-service]').forEach(btn => {
    btn.addEventListener('click', () => {
      selectedService = btn.dataset.service || '';
      document.getElementById('cpqServiceError').textContent = '';
      renderServices();
      renderFields();
    }, {once:true});
  });
}

function renderFields() {
  const service = SERVICES[selectedService];
  if (!service) {
    dynamicFields.innerHTML = '<div class="cpq-empty">Selecciona un servicio para continuar.</div>';
    return;
  }
  document.getElementById('cpqDetailsTitle').textContent = service.name;
  dynamicFields.innerHTML = service.fields.map(field => {
    const req = field.required ? 'required' : '';
    const label = `${esc(field.label)}${field.required ? ' *' : ''}`;
    if (field.type === 'select') {
      return `<label class="cpq-field"><span>${label}</span><select name="${esc(field.name)}" ${req}>${field.options.map(o=>`<option value="${esc(o)}">${esc(o)}</option>`).join('')}</select></label>`;
    }
    return `<label class="cpq-field"><span>${label}</span><input name="${esc(field.name)}" type="${esc(field.type)}" ${field.min?`min="${esc(field.min)}"`:''} placeholder="${esc(field.placeholder||'')}" ${req}></label>`;
  }).join('');
}

function collect() {
  const data = {};
  form.querySelectorAll('input,select,textarea').forEach(el => {
    if (!el.name || el.name === 'website' || el.type === 'file') return;
    data[el.name] = String(el.value || '').trim();
  });
  data.service = selectedService;
  data.service_name = SERVICES[selectedService]?.name || '';
  return data;
}

function validateStep() {
  if (currentStep===1) {
    if (!selectedService) {
      document.getElementById('cpqServiceError').textContent = 'Selecciona un servicio.';
      return false;
    }
  }
  if (currentStep===2) {
    const service = SERVICES[selectedService];
    for (const field of (service?.fields||[])) {
      if (!field.required) continue;
      const el = dynamicFields.querySelector(`[name="${CSS.escape(field.name)}"]`);
      if (!el || !String(el.value||'').trim()) {
        el?.focus();
        alert(`Completa: ${field.label}`);
        return false;
      }
    }
  }
  if (currentStep===4) {
    const name = form.elements.name?.value.trim() || '';
    const phone = form.elements.phone?.value.trim() || '';
    const email = form.elements.email?.value.trim() || '';
    if (!name || !phone) { alert('Completa tu nombre y WhatsApp.'); return false; }
    if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) { alert('Revisa el correo.'); return false; }
  }
  return true;
}

function renderReview() {
  const data = collect();
  const service = SERVICES[selectedService];
  const details = (service?.fields||[]).map(field => {
    const value = data[field.name];
    return value ? `<div class="cpq-review-row"><span>${esc(field.label)}</span><strong>${esc(value)}</strong></div>` : '';
  }).join('');

  review.innerHTML = `
    <div class="cpq-review-card cpq-review-main">
      <div class="cpq-review-icon">${service?.icon || '✦'}</div>
      <div><span>SERVICIO</span><strong>${esc(service?.name || '')}</strong></div>
    </div>
    <div class="cpq-review-grid">
      <div class="cpq-review-card"><span>DETALLES</span>${details || '<p>Sin detalles adicionales.</p>'}</div>
      <div class="cpq-review-card"><span>PRODUCCIÓN Y ENTREGA</span>
        <div class="cpq-review-row"><span>Diseño</span><strong>${esc(data.design_status||'No indicado')}</strong></div>
        <div class="cpq-review-row"><span>Aplicación / instalación</span><strong>${esc(data.application||'No indicado')}</strong></div>
        <div class="cpq-review-row"><span>Entrega</span><strong>${esc(data.delivery_method||'Por confirmar')}</strong></div>
        <div class="cpq-review-row"><span>Fecha solicitada</span><strong>${esc(data.desired_date||'Por confirmar')}</strong></div>
      </div>
    </div>
    <div class="cpq-review-card cpq-review-contact"><span>CONTACTO</span>
      <div class="cpq-review-row"><span>Nombre</span><strong>${esc(data.name||'')}</strong></div>
      <div class="cpq-review-row"><span>WhatsApp</span><strong>${esc(data.phone||'')}</strong></div>
      ${data.email?`<div class="cpq-review-row"><span>Correo</span><strong>${esc(data.email)}</strong></div>`:''}
      ${data.notes?`<div class="cpq-review-note-row"><span>Notas</span><p>${esc(data.notes)}</p></div>`:''}
    </div>`;
}

function updateUI() {
  document.querySelectorAll('.cpq-step').forEach(panel => panel.classList.toggle('is-visible', Number(panel.dataset.step)===currentStep));
  document.querySelectorAll('.cpq-progress span').forEach((bar,index) => {
    bar.classList.toggle('is-current', index===currentStep-1);
    bar.classList.toggle('is-done', index<currentStep-1);
  });
  document.getElementById('cpqStepTitle').textContent = ['Servicio','Detalles','Archivos','Entrega','Revisión'][currentStep-1];
  document.getElementById('cpqStepNumber').textContent = currentStep;
  document.getElementById('cpqFooterLabel').textContent = `Paso ${currentStep} de 5`;
  back.style.visibility = currentStep===1 ? 'hidden' : 'visible';
  next.textContent = currentStep===5 ? 'Enviar solicitud →' : 'Continuar →';
  if (currentStep===5) renderReview();
  const dialog = document.querySelector('.cpq-dialog');
  if (dialog) dialog.scrollTop = 0;
}

function openModal(step=1) {
  currentStep = Math.max(1,Math.min(5,Number(step)||1));
  modal.classList.add('is-open');
  modal.setAttribute('aria-hidden','false');
  document.body.classList.add('cpq-lock');
  updateUI();
}

function closeModal() {
  modal.classList.remove('is-open');
  modal.setAttribute('aria-hidden','true');
  document.body.classList.remove('cpq-lock');
}

async function sendRequest() {
  if (!validateStep()) return;
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 15000);
  const fd = new FormData(form);
  fd.set('service',selectedService);
  fd.set('service_name',SERVICES[selectedService]?.name || '');

  submitState.textContent = 'Enviando solicitud...';
  submitState.classList.remove('is-error');
  next.disabled = true;
  back.disabled = true;

  try {
    const response = await fetch('api/pasarela-cotizador.php', {
      method:'POST',
      body:fd,
      credentials:'same-origin',
      cache:'no-store',
      headers:{'Accept':'application/json','X-Requested-With':'XMLHttpRequest'},
      signal:controller.signal
    });
    const raw = await response.text();
    let payload;
    try { payload=JSON.parse(raw); } catch (_) {
      throw new Error(`El servidor respondió HTTP ${response.status}, pero no devolvió JSON.`);
    }
    if (!response.ok || !payload.ok) throw new Error(payload.message || `No se pudo registrar la solicitud (HTTP ${response.status}).`);

    document.getElementById('cpqRequestId').textContent = payload.reference || `CPQ-${String(payload.id||'').padStart(6,'0')}`;
    document.getElementById('cpqResultText').textContent = payload.message || 'Tu solicitud quedó registrada correctamente.';
    document.getElementById('cpqResultWhatsApp').href = payload.whatsapp_url || '#';

    document.querySelectorAll('.cpq-step').forEach(panel => panel.classList.remove('is-visible'));
    result.classList.add('is-visible');
    footer.style.display='none';
    submitState.textContent='';
  } catch (error) {
    submitState.textContent = error.name==='AbortError'
      ? 'El servidor tardó más de 15 segundos. No se pudo confirmar el registro.'
      : (error.message || 'No se pudo registrar la solicitud.');
    submitState.classList.add('is-error');
  } finally {
    clearTimeout(timeout);
    next.disabled=false;
    back.disabled=false;
  }
}

function resetForm() {
  form.reset();
  selectedService='';
  currentStep=1;
  result.classList.remove('is-visible');
  footer.style.display='flex';
  submitState.textContent='';
  submitState.classList.remove('is-error');
  renderServices();
  renderFields();
  updateUI();
}

document.getElementById('openQuote').addEventListener('click',()=>openModal(1));
document.querySelectorAll('[data-step-open]').forEach(button=>button.addEventListener('click',()=>openModal(Number(button.dataset.stepOpen)||1)));
document.getElementById('cpqClose').addEventListener('click',closeModal);
document.getElementById('cpqBackdrop').addEventListener('click',closeModal);
back.addEventListener('click',()=>{
  if(currentStep>1){currentStep--;updateUI();}
});
next.addEventListener('click',()=>{
  if(currentStep<5){
    if(validateStep()){currentStep++;updateUI();}
  } else {
    sendRequest();
  }
});
document.getElementById('cpqNewRequest').addEventListener('click',resetForm);
document.addEventListener('keydown',event=>{
  if(event.key==='Escape' && modal.classList.contains('is-open')) closeModal();
});

renderServices();
renderFields();
updateUI();
})();
</script>
</body>
</html>
