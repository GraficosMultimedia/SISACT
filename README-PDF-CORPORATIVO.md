# Colibrí Print México · PDF corporativo de Orden de Servicio V1

## Qué cambia
- `admin/orden.php` añade botón **PDF corporativo** y conserva **Vista de impresión**.
- `orden_pdf.php` genera el documento A4 en PDF desde el servidor.
- `includes/orden_pdf_renderer.php` genera PDF con logo JPEG, encabezado corporativo y paginación.
- `assets/img/company/logo-pdf.jpg` es una versión optimizada del logotipo actual para el PDF.

## Contenido del PDF
### Página 1
- Logo y datos del emisor.
- Razón social, nombre comercial, RFC y régimen fiscal.
- Domicilio fiscal.
- Datos del cliente, RFC, contacto y domicilio.
- Folio de orden y cotización de origen.
- Fecha de orden, compromiso, cotización y actualización.
- Todos los conceptos con cantidad, precio e importe.
- Total, pagado/anticipo y saldo.
- Primer pago confirmado.

### Página 2
- Control operativo.
- Responsable y etapa de producción.
- Evidencia fotográfica contabilizada.
- Condiciones de pago, entrega y términos.
- Registro de pagos.
- Notas del servicio.
- Notas internas para archivo.

### Página 3
- Ficha maestra de archivo.
- IDs de orden, cotización y cliente.
- Tiempos de creación y actualización.
- Historial de servicio.
- Sitio web y redes sociales.
- Leyenda documental.

## Criterio documental
Es una **Orden de Servicio / Documento interno de control y archivo histórico**. No sustituye un CFDI ni pretende ser una factura fiscal.

## Logo
El sistema intenta usar `company.logo_pdf_path` si existe. Si no existe, usa `/assets/img/company/logo-pdf.jpg`.

## Instalación
Copiar respetando las rutas en `public_html/`.
No requiere migración SQL.
