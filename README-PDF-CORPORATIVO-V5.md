# Colibrí Print México - PDF corporativo V5

## Corrección confirmada
El diagnóstico de producción mostró que `company_profile()` no estaba disponible.
Al revisar el endpoint V4, `includes/company.php` no se estaba cargando.

V5 corrige eso con:
`require_once __DIR__ . '/includes/company.php';`

Además, si la función no estuviera disponible, el endpoint devuelve un mensaje técnico claro en vez de una pantalla 500 vacía.

## Instalación
Reemplazar únicamente:
`public_html/orden_pdf.php`

No requiere SQL.

El logo `assets/img/company/logo-pdf.jpg` es opcional como respaldo.
