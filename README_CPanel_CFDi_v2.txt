COLIBRI PRINT · FACTURACIÓN CFDI · V2

OBJETIVO
La captura de facturación ahora parte del CFDI: se carga XML + PDF, el navegador muestra los datos detectados y los campos que no existan pueden completarse manualmente. Al guardar se crea la factura administrativa y se adjunta el expediente CFDI directamente a la orden del cliente.

FLUJO
1. Abrir /admin/facturacion.php.
2. Cargar XML CFDI 4.0.
3. Opcionalmente cargar PDF.
4. Revisar los datos detectados: emisor, receptor, UUID, forma/método de pago, conceptos, folio, fecha, subtotal, impuesto y total.
5. Seleccionar cliente.
6. Seleccionar una orden de ese cliente.
7. Completar únicamente los datos que falten.
8. Pulsar "Crear registro y adjuntar CFDI".

RESULTADO
- Se crea cp_invoices.
- Se relaciona con customer_id y order_id.
- Se guarda el XML original y su SHA-256.
- Se guarda el PDF cuando se proporciona.
- Se crea el expediente cp_invoice_documents.
- Se guardan los conceptos en cp_invoice_items.
- El UUID se conserva como folio fiscal.
- Si el XML contiene UUID, el estado se registra como Emitida.
- La orden queda vinculada al expediente CFDI.

SEGURIDAD / VALIDACION
- El servidor vuelve a leer y validar el XML al guardar. No se confía únicamente en el autollenado del navegador.
- CFDI 4.0.
- XML máximo 5 MB.
- PDF máximo 15 MB.
- UUID validado y duplicado rechazado.
- XML y PDF se almacenan bajo storage/cfdi/.
- No se agrega timbrado ni conexión con PAC/SAT.

ARCHIVOS
- admin/facturacion.php
- includes/cfdi.php
- assets/css/cfdi-admin.css
- admin/cfdi_documento.php (sin cambio funcional, incluido para consistencia)

MIGRACION
La migración 013_cfdi_expediente.sql de la versión anterior permanece igual. No es necesario ejecutarla de nuevo si ya fue instalada.

NO SE REEMPLAZAN
- includes/header.php
- includes/footer.php
- includes/finanzas.php
- database/migrations/012_fase10_pagos_facturacion.sql

NOTA
La edición de facturas existentes se conserva. La creación nueva utiliza el flujo XML-first.
