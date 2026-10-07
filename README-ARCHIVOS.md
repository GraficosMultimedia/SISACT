# Colibrí Print · Archivos de orden V5

Esta versión parte de la orden que ya incluye pagos, comprobantes de pago, seguimiento, fotos y la lógica administrativa existente.

## Se agrega
La galería de fotos se convierte visualmente en un expediente de:
- Fotos
- PDF
- Word
- Excel
- PowerPoint
- CSV/TXT
- ZIP/RAR/7Z
- AI/EPS/PSD/CDR
- DXF/DWG/STP/STEP/3MF/OBJ/STL
- GIF/BMP/SVG y otras referencias visuales admitidas

Máximo: 25 MB por archivo.

## No se crea otra tabla
Se reutiliza `cp_order_photos`, porque ya almacena:
`file_path`, `original_name`, `mime_type`, `file_size`, `photo_type`, `caption`, `created_by`.

## Seguridad
`admin/orden_archivo.php` requiere autenticación y verifica que el archivo esté dentro de la carpeta correspondiente a la orden.

## Importante
No ejecutar SQL nuevo.
No se eliminan los registros de fotos existentes.
No se elimina la funcionalidad de comprobantes de pago.
