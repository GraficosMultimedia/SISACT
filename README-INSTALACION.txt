SISACT · TRACKING ACTIVITY + CFDI + DASHBOARD NOTIFICATIONS V1
Colibrí Print México

OBJETIVO
========
Registrar la actividad del cliente en Seguimiento y mostrarla en Dashboard:

👁 Revisó su orden / seguimiento
📄 Consultó factura PDF
🧾 Descargó XML
💳 Envió comprobante de pago

El Dashboard consulta nueva actividad cada 30 segundos y, si está abierto,
muestra una notificación flotante cuando aparece un evento nuevo.

REVISIÓN PREVIA DEL REPOSITORIO
===============================
Se revisaron antes de generar este paquete:

- seguimiento.php
- seguimiento_cfdi.php
- includes/tracking_cfdi.php
- includes/cfdi.php
- api/comprobante_pago_cliente.php
- includes/payment_receipts.php
- admin/dashboard.php
- assets/js/dashboard-intelligence.js
- assets/css/dashboard-intelligence.css

PUNTOS DE INTEGRACIÓN
=====================
1. seguimiento.php ya llama tracking_cfdi_for_order() una vez por visita válida.
   V1 aprovecha ese punto para registrar la visita sin reemplazar seguimiento.php.

2. seguimiento_cfdi.php ya centraliza PDF/XML mediante tracking_cfdi_download().
   V1 registra el evento justo antes de servir el archivo.

3. api/comprobante_pago_cliente.php ya centraliza la subida de comprobantes.
   V1 registra el evento después de una subida exitosa.

4. Dashboard Intelligence ya carga dashboard-intelligence.js.
   V1 amplía ese JS con un feed autenticado cada 30 segundos.
   No se reemplaza admin/dashboard.php.

ARCHIVOS NUEVOS
===============
includes/tracking_activity.php
admin/tracking_activity_feed.php
assets/css/tracking-activity-dashboard-v1.css
database/sql/021_tracking_activity.sql

ARCHIVOS A REEMPLAZAR
=====================
includes/tracking_cfdi.php
api/comprobante_pago_cliente.php
assets/js/dashboard-intelligence.js

BASE DE DATOS
=============
Ejecutar:
database/sql/021_tracking_activity.sql

Solo crea:
- cp_tracking_events
- cp_tracking_event_reads

No modifica tablas existentes.

PRIVACIDAD
==========
- NO se guarda el token de seguimiento.
- NO se guarda la IP en texto plano.
- visitor_hash usa SHA-256 de IP + navegador + contexto.
- Se guarda solamente device_type: mobile / tablet / desktop / unknown.
- HEAD, prefetch y bots/previews conocidos se excluyen.

IMPORTANTE SOBRE "QUIÉN VISITÓ"
===============================
SISACT puede afirmar:
"El enlace asociado a este cliente/orden fue abierto".

Técnicamente no puede demostrar que la persona física cuyo nombre aparece
tenía el dispositivo en la mano.

VISITAS
=======
Cada carga GET válida de seguimiento.php genera:
tracking_view

Se filtran:
- HEAD
- prefetch/preview
- Facebook preview
- WhatsApp preview
- Twitter/LinkedIn/Slack/Discord/Telegram bots
- buscadores
- curl/wget

PDF CFDI
========
Se registra:
cfdi_pdf_opened

El PDF sigue sirviéndose INLINE para que pueda abrirse en navegador.

XML CFDI
========
Se registra:
cfdi_xml_downloaded

El XML cambia a:
Content-Disposition: attachment

Por lo tanto, el clic inicia una descarga real del XML.

COMPROBANTES
============
Después de guardar correctamente un comprobante:
payment_receipt_uploaded

Si la subida falla, NO se registra el evento.

DASHBOARD
=========
Dentro de "Centro de alertas" aparece:

ACTIVIDAD DE CLIENTES
Seguimiento y CFDI

- cliente
- evento
- orden
- factura cuando aplica
- dispositivo
- tiempo relativo

También muestra:
"X nuevas"

El botón "Marcar revisado" guarda por usuario el último evento visto.

NOTIFICACIONES
==============
Con Dashboard abierto:
- consulta el feed cada 30 segundos;
- al detectar un ID nuevo muestra toast flotante;
- máximo 3 toast por ciclo;
- no genera sonido;
- al volver a una pestaña visible vuelve a consultar.

CACHE
=====
admin/dashboard.php actualmente referencia:
dashboard-intelligence.js?v=1.0.0

Este paquete NO reemplaza dashboard.php para evitar una regresión en el
Dashboard actual.

DESPUÉS DE INSTALAR:
hacer Ctrl+F5 una vez en Dashboard para forzar la carga del JS nuevo.

El CSS del módulo se carga dinámicamente con:
tracking-activity-dashboard-v1.css?v=1.0.0

INSTALACIÓN
===========
1. RESPALDAR:
   includes/tracking_cfdi.php
   api/comprobante_pago_cliente.php
   assets/js/dashboard-intelligence.js

2. Ejecutar:
   database/sql/021_tracking_activity.sql

3. Copiar archivos nuevos.

4. Reemplazar los 3 archivos indicados.

5. Abrir Dashboard y hacer Ctrl+F5.

PRUEBA RECOMENDADA
==================
A. VISITA
1. Abrir Dashboard en PC.
2. Desde otro teléfono abrir el link de seguimiento de una orden.
3. En máximo 30 segundos debe aparecer:
   👁 Cliente · Revisó su orden

B. PDF
1. En Seguimiento pulsar Descargar PDF.
2. Debe abrir PDF.
3. Dashboard:
   📄 Cliente · Consultó factura PDF

C. XML
1. Pulsar Descargar XML.
2. El navegador debe iniciar descarga.
3. Dashboard:
   🧾 Cliente · Descargó XML

D. COMPROBANTE
1. Enviar comprobante.
2. Dashboard:
   💳 Cliente · Envió comprobante

E. MARCAR REVISADO
1. Ver contador "X nuevas".
2. Pulsar "Marcar revisado".
3. El contador debe desaparecer para ese usuario.

DEGRADACIÓN SEGURA
==================
Si la migración NO está instalada:
- Seguimiento continúa funcionando.
- PDF/XML continúan funcionando.
- Comprobantes continúan funcionando.
- Dashboard muestra aviso de que Tracking Activity debe activarse.

Si falla el registro de un evento:
el flujo del cliente NO se interrumpe.

REVERSIÓN
=========
Restaurar los tres archivos respaldados.

Las tablas nuevas pueden conservarse; no interfieren con otros módulos.
Si se desea eliminación completa:
DROP TABLE cp_tracking_event_reads;
DROP TABLE cp_tracking_events;

NO SE MODIFICA
==============
- órdenes;
- producción;
- pagos;
- estados;
- cotizaciones;
- cp_tracking_tokens.last_access_at;
- generación/importación de CFDI;
- archivos fiscales almacenados;
- Dashboard PHP;
- seguimiento.php;
