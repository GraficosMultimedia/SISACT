COLIBRÍ PRINT MÉXICO
FASE 10 · PAGOS Y FACTURACIÓN + MEJORA DEL SEGUIMIENTO

Base de esta entrega: snapshot estable del sistema previo.

CAMBIOS
1. Pagos
   - Nuevo módulo /admin/pagos.php.
   - Registro de anticipos y pagos parciales.
   - Métodos: efectivo, transferencia, tarjeta, depósito, OXXO y otro.
   - Saldo calculado por orden.
   - Edición y cancelación lógica mediante estado.
   - Validación para no registrar cobros confirmados por encima del saldo disponible.

2. Facturación administrativa
   - Nuevo control funcional en /admin/facturacion.php.
   - Folio, fecha, subtotal, impuesto, total, estado, UUID/folio fiscal y notas.
   - Edición de registros.
   - El módulo NO genera ni timbra CFDI.

3. Integración con la orden
   - /admin/orden.php incorpora acceso directo a Pagos y Facturación.
   - Se muestra un resumen de total, pagado y saldo cuando la migración financiera está instalada.

4. Seguimiento del cliente
   - /seguimiento.php ahora usa los datos guardados en Configuración > Datos de la empresa.
   - Encabezado corporativo con logotipo, nombre comercial/legal, domicilio, teléfono, correo, sitio web y RFC cuando estén capturados.
   - Diseño responsive para escritorio y móvil.
   - Se mantiene el esquema de 5 etapas comerciales y la aprobación de diseño solo cuando aplica.
   - Meta robots noindex,nofollow para el enlace privado de seguimiento.

ARCHIVOS
- admin/pagos.php                 NUEVO
- admin/facturacion.php           REEMPLAZAR
- admin/orden.php                 REEMPLAZAR
- includes/finanzas.php           NUEVO
- includes/company.php            DEPENDENCIA DEL ENCABEZADO CORPORATIVO
- includes/header.php             REEMPLAZAR
- includes/seguimiento.php        SIN CAMBIO FUNCIONAL, SE ENTREGA PARA CONSISTENCIA
- seguimiento.php                 REEMPLAZAR
- assets/css/finanzas.css         NUEVO
- assets/css/seguimiento.css      REEMPLAZAR
- database/migrations/012_fase10_pagos_facturacion.sql  NUEVO

INSTALACIÓN
1. Respaldar los archivos actuales y la base de datos.
2. Subir cada archivo respetando su ruta en /public_html.
3. Ejecutar una sola vez:
   database/migrations/012_fase10_pagos_facturacion.sql
   sobre la base colibrip_abcsistema.
4. Confirmar que Configuración > Datos de la empresa tenga nombre, domicilio y contacto.
5. Abrir una orden existente y comprobar los botones Pagos y Facturación.
6. Registrar un pago de prueba y revisar el saldo.
7. Registrar una factura administrativa de prueba.
8. Abrir el enlace público de seguimiento y comprobar el encabezado corporativo.

NOTA SOBRE CFDI
Este módulo es control administrativo. No sustituye un CFDI ni realiza timbrado SAT. La integración con un PAC/servicio de facturación electrónica debe ser una etapa independiente.

COMPROBACIÓN LOCAL
Se ejecutó php -l sobre los PHP modificados/creados y no se detectaron errores de sintaxis.
