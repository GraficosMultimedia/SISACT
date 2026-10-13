SISACT · CENTRO DE NOTIFICACIONES DE CLIENTES V3

OBJETIVO
========
Crear un sistema persistente de notificaciones similar al patrón funcional
de Akaunting: campana global, contador, panel desplegable, historial,
leído/no leído y avisos nuevos.

CAMBIO CLAVE
============
La visita ya NO depende de identificar al cliente por User-Agent.

Cuando seguimiento.php está realmente visible en un navegador, ejecuta un
POST a /api/tracking_view_cliente.php.

Los previews de enlaces normalmente no ejecutan JavaScript, por lo que no
generan la misma señal.

PDF y XML se registran como acciones verificadas porque seguimiento_cfdi.php
ya validó token + documento + orden.

ARCHIVOS NUEVOS
===============
includes/tracking_activity_verified.php
api/tracking_view_cliente.php
assets/js/admin-notifications-v1.js
assets/css/admin-notifications-v1.css
admin/notificaciones.php
admin/aplicar_centro_notificaciones_v3.php

ARCHIVOS MODIFICADOS POR EL INSTALADOR
======================================
includes/header.php
includes/tracking_cfdi.php
seguimiento.php

RESPALDOS
=========
*.bak_notificaciones_v3

SQL
===
No hay migración nueva.
V3 usa cp_tracking_events y cp_tracking_event_reads.
Se incluye database/sql/021_tracking_activity.sql como recuperación.

INSTALACIÓN
===========
1. Extraer ZIP en la raíz de SISACT.
2. Abrir /admin/aplicar_centro_notificaciones_v3.php
3. Pulsar "Instalar Centro V3".
4. Ctrl+F5 en el panel.
5. Debe aparecer una campana en la barra superior.

PRUEBA
======
Desde otro teléfono:
1. Abrir seguimiento.php?t=TOKEN.
2. Esperar 1-2 segundos.
3. En Administración esperar máximo 20 segundos.
4. Debe aparecer "Orden revisada".
5. Abrir PDF de CFDI: debe aparecer "Factura PDF vista".
6. Descargar XML: debe aparecer "XML descargado".

HISTORIAL
=========
/admin/notificaciones.php

GITHUB DESPUÉS DE APROBAR
=========================
Subir:
includes/header.php
includes/tracking_cfdi.php
seguimiento.php
includes/tracking_activity_verified.php
api/tracking_view_cliente.php
assets/js/admin-notifications-v1.js
assets/css/admin-notifications-v1.css
admin/notificaciones.php

NO subir:
admin/aplicar_centro_notificaciones_v3.php
*.bak_notificaciones_v3
