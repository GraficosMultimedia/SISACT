COLIBRI PRINT - FIX CFDI EN SEGUIMIENTO V4

OBJETIVO
Corregir el HTTP 500 provocado al integrar la sección de facturas CFDI en seguimiento.php y habilitar las descargas públicas protegidas por el token de seguimiento.

IMPORTANTE
El seguimiento.php ACTUAL DEL SERVIDOR ya contiene:
- require_once __DIR__ . '/includes/tracking_cfdi.php';
- la consulta tracking_cfdi_for_order(...)
- la sección FACTURAS Y CFDI debajo de COMPROBANTES DE PAGO.

POR ESO ESTE ZIP ES UN PARCHE MINIMO. NO REEMPLAZA seguimiento.php.

ARCHIVOS A SUBIR
1) includes/tracking_cfdi.php
2) seguimiento_cfdi.php

RUTA FINAL EN CPANEL
/public_html/includes/tracking_cfdi.php
/public_html/seguimiento_cfdi.php

DEPENDENCIAS
- El sistema ya debe tener includes/cfdi.php, config/runtime.php y la tabla cp_invoice_documents.
- No modificar facturacion.php.
- No modificar pagos.
- No modificar la base de datos.

PRUEBA
1. Subir los dos archivos conservando las rutas.
2. Abrir el seguimiento público de una orden que tenga facturas.
3. La página principal /seguimiento.php?t=... debe cargar sin HTTP 500.
4. Debe aparecer FACTURAS Y CFDI debajo de PAGOS Y COMPROBANTES.
5. Deben aparecer todas las facturas asociadas a la misma orden.
6. PDF y XML deben apuntar a /seguimiento_cfdi.php?t=...&id=...&file=pdf|xml.

RESPALDO
Antes de sobrescribir cualquier archivo, conservar copia del archivo existente.
