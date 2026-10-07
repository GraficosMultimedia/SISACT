COLIBRI PRINT · FASE 10B · EXPEDIENTE CFDI

OBJETIVO
Agregar a admin/facturacion.php la recepción y consulta de CFDI 4.0 ya timbrados, sin introducir timbrado ni cambiar el flujo existente de órdenes, pagos o facturación administrativa.

ARCHIVOS
- admin/facturacion.php (reemplazo compatible, añade importación y expediente CFDI)
- admin/cfdi_documento.php (consulta y descarga controlada de XML/PDF)
- includes/cfdi.php (parser, almacenamiento, consulta y seguridad de documentos)
- assets/css/cfdi-admin.css (UI responsive)
- database/migrations/013_cfdi_expediente.sql (nuevas tablas)
- storage/cfdi/ (directorio de archivos, no se suben documentos en este ZIP)

INSTALACION CPANEL
1. Respaldar admin/facturacion.php y la base de datos.
2. Ejecutar database/migrations/013_cfdi_expediente.sql una sola vez sobre colibrip_abcsistema.
3. Subir los archivos respetando las rutas.
4. Crear/verificar storage/cfdi con permisos de escritura para PHP.
5. Abrir /admin/facturacion.php.
6. Crear o editar una factura administrativa.
7. En Expediente fiscal seleccionar la factura y subir el XML CFDI 4.0. El PDF es opcional.
8. Verificar UUID, emisor, receptor, conceptos, subtotal, impuesto y total.

SEGURIDAD
- Requiere autenticación administrativa.
- Usa CSRF del sistema.
- XML y PDF se guardan fuera de la raíz pública de descarga directa mediante un endpoint autenticado.
- Se valida XML CFDI 4.0, UUID y PDF.
- Se guarda SHA-256 del XML para identificar el archivo.

IMPORTANTE
Este paquete NO timbra CFDI ni se conecta a SAT/PAC. El XML importado debe estar previamente timbrado.
