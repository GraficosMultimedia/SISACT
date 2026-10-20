SISACT · FLUJO WEB → ORDEN FORMAL V1
Colibrí Print México

OBJETIVO
========
Convertir la recepción pública de archivos en UN SOLO EXPEDIENTE:

Cliente
→ Solicitud web CPQ
→ archivos + configuración + precio
→ cotización formal
→ orden formal
→ archivos de producción en la orden
→ seguimiento público continuo

PROBLEMA CORREGIDO
==================
La API pública ya estaba guardando correctamente:

cp_web_quote_requests
cp_web_quote_files
cp_print_request_items

Pero Administración seguía leyendo el formato antiguo [CPQ_JSON] y
solamente attachment_name / attachment.relative_path.

Resultado:
- el cliente sí enviaba los archivos;
- los archivos quedaban en uploads/cotizador/impresiones/{requestId};
- Administración no consultaba cp_web_quote_files;
- Convertir a cotización generaba un concepto genérico en $0;
- la orden copiaba conceptos pero no archivos.

V1 USA COMO FUENTE MAESTRA
==========================
cp_web_quote_requests
  ↓
cp_web_quote_files
  ↓
cp_print_request_items
  ↓
cp_quotes / cp_quote_items
  ↓
cp_orders / cp_order_items
  ↓
cp_order_photos

CAMBIOS
=======
1. Solicitudes web:
   admin/cotizaciones_web.php

   Ahora muestra TODOS los archivos:
   - nombre
   - tipo
   - peso
   - tamaño
   - material
   - acabado
   - color/B&N
   - páginas
   - copias
   - precio unitario
   - subtotal

2. Descarga protegida:
   admin/archivo_web.php

   Los archivos se sirven detrás de require_auth().
   Ya no es necesario publicar el path directo en Administración.

3. Conversión CPQ → Cotización:
   admin/cotizacion_desde_web.php

   Crea un concepto por configuración/archivo.
   Conserva unit_price y subtotal calculados por la API pública.
   cp_quote_totals recibe el subtotal real.

4. Cotización:
   admin/cotizacion.php

   El paquete solo agrega:
   includes/web_print_flow.php

   Como el archivo actual usa function_exists(),
   el helper sustituye el bloque antiguo de un solo archivo y muestra
   TODO el expediente.

5. Orden formal:
   admin/orden_nueva.php

   Cuando la cotización proviene de una solicitud web:
   - copia los archivos originales a uploads/orders/{orderId}/
   - crea registros cp_order_photos con photo_type=client_file
   - deja los archivos visibles en el expediente normal de la orden
   - registra historial
   - vincula CPQ con order_id

6. Seguimiento público:
   seguimiento.php

   Antes de existir la orden:
   - el mismo request_token muestra recepción/revisión/cotización.

   Después de crear la orden:
   - ese MISMO token se inserta en cp_tracking_tokens;
   - seguimiento.php cambia automáticamente al seguimiento normal
     de la orden, producción, pagos, CFDI, etc.

NUEVA TRAZABILIDAD
==================
cp_web_quote_requests:
+ converted_order_id
+ converted_order_at

cp_web_quote_item_links:
request item/file ↔ quote item

cp_web_quote_order_files:
web file ↔ order photo/file

NO SE MUEVEN LOS ORIGINALES
===========================
Los archivos originales continúan en:

uploads/cotizador/impresiones/{requestId}/

Para la orden se COPIA una versión a:

uploads/orders/{orderId}/

Esto conserva el expediente original CPQ.

INSTALACIÓN
===========
1. Extraer el ZIP en la raíz de SISACT.

2. Entrar como administrador.

3. Abrir:
   /admin/aplicar_flujo_web_orden_v1.php

4. Pulsar:
   Instalar flujo V1

5. Debe mostrar:
   Vínculo Orden       ✓ listo
   CPQ → Conceptos     ✓ listo
   Archivos → Orden    ✓ listo
   Helper              ✓ listo
   Descarga protegida  ✓ lista

PRUEBA COMPLETA
===============
A. Cliente
----------
1. Abrir:
   https://colibriprint.com.mx/#solicita-impresiones

2. Enviar 2 archivos con configuraciones diferentes.

3. Debe devolver:
   CPQ-xxxxxx
   total
   token
   enlace seguimiento

B. Seguimiento antes de cotización
----------------------------------
Abrir el enlace del cliente.

Debe mostrar:
Recibimos tus archivos correctamente.

C. Administración
-----------------
Abrir:
   /admin/cotizaciones_web.php

La solicitud debe mostrar los 2 archivos completos con:
Ver
Descargar
configuración
precio
subtotal.

D. Convertir
------------
Pulsar:
Convertir en cotización

La cotización debe tener 2 conceptos y total real.

E. Cotización
-------------
Abrir la cotización.

Debe mostrar:
EXPEDIENTE · ARCHIVOS DEL CLIENTE

con ambos archivos.

F. Aprobar
----------
Cambiar cotización a Aprobada.

G. Crear orden
--------------
Crear la orden desde la cotización aprobada.

La orden debe crearse y automáticamente copiar los archivos.

H. Orden
--------
Abrir /admin/orden.php?id=...

En:
Fotos, documentos y archivos de producción

deben aparecer los archivos originales como:
Archivo recibido del cliente.

I. Mismo seguimiento
--------------------
Abrir EL MISMO enlace de seguimiento que recibió el cliente al enviar CPQ.

Ahora debe mostrar la orden formal, producción, pagos, etc.

SEGURIDAD
=========
- Validación del token 64 hex.
- Descarga administrativa con require_auth().
- realpath() y prefijo de almacenamiento para evitar traversal.
- Los archivos de la orden se copian, no se mueven.
- La importación de archivos ocurre dentro del flujo transaccional de la orden.
- Si falla la creación de orden, el catch elimina copias creadas antes del rollback.
- Tabla de mapping evita duplicar el mismo archivo en la misma orden.

ARCHIVOS NUEVOS DE PRODUCCIÓN
=============================
includes/web_print_flow.php
includes/web_print_tracking_view.php
admin/archivo_web.php
assets/css/web-print-flow-v1.css
database/sql/027_web_print_flow_v1.sql

ARCHIVOS MODIFICADOS
====================
admin/cotizaciones_web.php
admin/cotizacion_desde_web.php
admin/cotizacion.php
admin/orden_nueva.php
seguimiento.php

ARCHIVOS DE INSTALACIÓN
=======================
admin/aplicar_flujo_web_orden_v1.php
install/web_print_flow_v1/admin/cotizaciones_web.php
install/web_print_flow_v1/admin/cotizacion_desde_web.php

Después de validar puedes eliminar:
admin/aplicar_flujo_web_orden_v1.php
install/web_print_flow_v1/

RESPALDOS
=========
El instalador crea:

*.bak_web_flow_v1

para los 5 archivos modificados.

GITHUB DESPUÉS DE APROBAR
=========================
Subir:

includes/web_print_flow.php
includes/web_print_tracking_view.php
admin/archivo_web.php
assets/css/web-print-flow-v1.css
database/sql/027_web_print_flow_v1.sql

admin/cotizaciones_web.php
admin/cotizacion_desde_web.php
admin/cotizacion.php
admin/orden_nueva.php
seguimiento.php

NO subir:
admin/aplicar_flujo_web_orden_v1.php
install/web_print_flow_v1/
*.bak_web_flow_v1

NO CAMBIA
=========
api/print-request.php

La recepción pública actual ya guarda correctamente archivos, items,
configuraciones y precios; el problema estaba en el consumo posterior
de ese expediente.
