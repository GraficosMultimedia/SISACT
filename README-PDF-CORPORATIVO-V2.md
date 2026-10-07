# Colibrí Print México - PDF Corporativo de Orden de Servicio V2

## Corrección del HTTP 500
Esta versión elimina la dependencia de `includes/orden_pdf_renderer.php`.
El renderer del PDF queda integrado dentro de `orden_pdf.php`.

La URL sigue siendo:
`https://colibriprint.com.mx/orden_pdf.php?id=14`

## Contenido
- Datos fiscales del emisor
- Cliente y datos de facturación
- Folio de orden y cotización
- Fechas
- Todos los conceptos
- Total, pagos/anticipo y saldo
- Condiciones de pago y entrega
- Responsable y producción
- Notas internas
- Historial
- Redes sociales
- Metadatos del expediente
- Conteo de fotografías y evidencia JPEG si existe

## Instalación
1. Reemplazar `public_html/orden_pdf.php` por el archivo de este ZIP.
2. Opcionalmente copiar `assets/img/company/logo-pdf.jpg` a la misma ruta.

No requiere SQL ni cambios en la base.

## Nota
El botón `PDF corporativo` existente en `admin/orden.php` ya apunta a `/orden_pdf.php?id=...`.
