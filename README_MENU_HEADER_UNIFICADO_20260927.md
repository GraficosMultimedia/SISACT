# Colibrí Print · Menú público unificado V1

## Objetivo

Unificar el header y menú de navegación del sitio público para que todas las páginas utilicen una sola implementación, con comportamiento consistente en PC y móvil.

## Archivos principales

- `includes/public_header.php` · componente único del header público.
- `assets/css/public-header-unified-v1.css` · estilos responsive.
- `assets/js/public-header-unified-v1.js` · menú móvil, backdrop, ESC y cierre al navegar.

## Páginas actualizadas

- `index.php`
- `catalogo.php`
- `categoria.php`
- `producto.php`
- `cotizador.php`
- `promociones-publicas.php`
- `corporativo.php`
- `servicios.php`
- `contacto.php`
- `carrito.php`
- `seguimiento.php`
- páginas públicas de servicios/locales de Parral.

## Menú único

Inicio · Servicios · Catálogo · Impresiones · Promociones · Cotizador · Cómo trabajamos · Nosotros · Contacto

El botón principal sigue llevando a WhatsApp con el texto comercial configurado.

## Responsive

- PC: navegación horizontal.
- Tablet: navegación compacta.
- Móvil: botón MENÚ, panel desplegable, fondo oscurecido, cierre con ESC y cierre al seleccionar una opción.
- El header es sticky.

## Instalación

1. Respaldar los archivos actuales.
2. Subir conservando las rutas del ZIP.
3. No reemplazar `includes/header.php`: ese archivo corresponde al panel administrativo y no forma parte de este cambio.
4. Limpiar caché del navegador con Ctrl+F5 si el menú anterior continúa visible.

## Nota

El menú público deja de depender de las diferentes implementaciones anteriores (`.header`, `.site-header`, `.prod-header`, `.cat-page-header`, `.wc-header`, etc.). Los estilos antiguos pueden permanecer en el servidor, pero ya no controlan el menú nuevo.
