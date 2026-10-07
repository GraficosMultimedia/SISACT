# Colibrí Print México · PDF corporativo de Orden de Servicio V3

## Qué corrige
La versión anterior devolvía HTTP 500 en producción.
Esta versión separa:
- `orden_pdf.php`: endpoint.
- `includes/orden_pdf_renderer.php`: renderer.

El renderer no usa `mb_strlen` ni `mb_substr`, evitando la dependencia de `mbstring`.

## Instalación en public_html

Subir:

`orden_pdf.php` -> `/public_html/orden_pdf.php`

`includes/orden_pdf_renderer.php` -> `/public_html/includes/orden_pdf_renderer.php`

Opcional:
`assets/img/company/logo-pdf.jpg` -> `/public_html/assets/img/company/logo-pdf.jpg`

## URL de prueba

`https://colibriprint.com.mx/orden_pdf.php?id=14`

## Contenido del PDF

- Identidad corporativa y logotipo.
- Razón social / nombre comercial.
- RFC y régimen fiscal.
- Domicilio y contacto.
- Datos del cliente.
- Folio de orden y cotización.
- Fechas.
- Conceptos y cantidades.
- Precios e importes.
- Total.
- Anticipo / pagos y saldo.
- Condiciones de entrega y pago.
- Responsable y etapa de producción.
- Notas del servicio.
- Notas internas para archivo.
- Historial.
- Redes sociales.
- Ficha de archivo histórico.

No requiere SQL.
