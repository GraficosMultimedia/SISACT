COLIBRI PRINT · FACTURAS EN SEGUIMIENTO V2

OBJETIVO
Mostrar al cliente, dentro de seguimiento.php y justo debajo de "Pagos y comprobantes",
las facturas CFDI asociadas a la misma orden de servicio.

INCLUYE
- Consulta de N CFDI por order_id.
- Tarjetas con nombre/folio, UUID, fecha, subtotal y total.
- Descarga segura de PDF y XML mediante seguimiento_cfdi.php.
- Validación de token de seguimiento + document_id + order_id.
- No se exponen rutas físicas.
- Soporta varias facturas por una misma orden.
- Responsive PC/móvil.
- No modifica facturacion.php, cfdi.php, finanzas.php ni la BD.

INSTALACION
1. Subir/extractar el ZIP en la raiz.
2. Abrir /admin/seguimiento_cfdi_patch.php estando autenticado.
3. Probar el seguimiento de una orden con 2 CFDI.
4. Eliminar /admin/seguimiento_cfdi_patch.php.
5. Conservar el respaldo seguimiento.php.bak_cfdi_tracking_v1 solo como respaldo local.

NOTA
El patch es idempotente: no duplica la sección si se ejecuta dos veces.
