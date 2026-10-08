SISACT · COTIZACIONES WORKSPACE V1.1
GUARDAR Y ABRIR WHATSAPP
Colibrí Print México

OBJETIVO
========
Agregar una segunda acción al editor de cotizaciones:

- Guardar cotización
- Guardar y abrir WhatsApp

La segunda acción SIEMPRE guarda primero la cotización. Después utiliza la
infraestructura actual de includes/whatsapp.php para construir la plantilla
quote_sent, registrar el mensaje como preparado y abrir WhatsApp.

IMPORTANTE
==========
Abrir WhatsApp NO cambia automáticamente el estado de la cotización a "Enviada".
El sistema no puede confirmar que el usuario finalmente pulse Enviar dentro de
WhatsApp, por lo que se conserva el estado existente para evitar datos falsos.

Si WhatsApp no puede prepararse (por ejemplo, cliente sin teléfono válido o
plantilla desactivada), la cotización YA QUEDA GUARDADA y se regresa al detalle
con un aviso. Un fallo de WhatsApp nunca revierte la cotización.

ARCHIVOS A REEMPLAZAR
=====================
admin/cotizacion_nueva.php
admin/cotizacion.php
assets/css/cotizacion-editor-mobile-v1.css
assets/js/cotizacion-editor-mobile-v1.js

NO SE MODIFICA
==============
- Base de datos
- Tablas
- config/runtime.php
- includes/whatsapp.php
- includes/cotizaciones.php
- includes/quote_order_sync.php
- Centro de WhatsApp
- Plantillas existentes
- PDF público de cotización
- Conexiones/Akaunting
- Login/sesiones

FLUJO NUEVO
===========
1. El usuario llena o edita la cotización.
2. Pulsa "Guardar y abrir WhatsApp".
3. SISACT valida y guarda la cotización normalmente.
4. Si existe una orden vinculada, conserva la sincronización actual.
5. Construye la plantilla oficial "quote_sent".
6. Registra el mensaje en cp_whatsapp_log como "prepared".
7. Registra actividad de WhatsApp en cp_activity_log.
8. En escritorio abre WhatsApp Web.
9. En móvil usa wa.me para facilitar la apertura de la aplicación.

SEGURIDAD
=========
- Se mantiene CSRF existente.
- El mensaje se construye solo DESPUÉS del COMMIT de la cotización.
- No se duplica la lógica de plantillas.
- No se agrega SQL ni migración.
- No se guardan credenciales nuevas.

INSTALACIÓN
===========
1. Respaldar los 4 archivos actuales indicados arriba.
2. Copiar este ZIP sobre la raíz de SISACT respetando carpetas.
3. Reemplazar los 4 archivos.
4. Hacer Ctrl+F5 en el navegador.

PRUEBAS RECOMENDADAS
====================
1. Crear cotización con cliente que tenga teléfono.
2. Pulsar Guardar cotización: debe funcionar exactamente como antes.
3. Crear/editar otra y pulsar Guardar y abrir WhatsApp.
4. Confirmar que la cotización quedó guardada antes de salir a WhatsApp.
5. Confirmar que WhatsApp abre con:
   - cliente;
   - folio;
   - total;
   - vigencia;
   - enlace PDF.
6. Probar desde móvil.
7. Probar cliente sin teléfono: la cotización debe quedar guardada y mostrar aviso.
8. Probar edición de una cotización vinculada a orden: la sincronización actual debe conservarse.

REVERSIÓN
=========
Restaurar los 4 archivos respaldados. No hay cambios de base de datos que revertir.
