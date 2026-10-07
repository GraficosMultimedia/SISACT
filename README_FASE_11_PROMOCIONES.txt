COLIBRÍ PRINT MÉXICO
FASE 11 · PROMOCIONES, REMATES Y LIQUIDACIONES

OBJETIVO
Crear un módulo comercial separado de las comunicaciones operativas, con promoción reutilizable en web, catálogo y WhatsApp.

ARCHIVOS DE ESTA ENTREGA
- admin/promociones.php                         NUEVO
- includes/promociones.php                      NUEVO
- assets/css/promociones.css                    NUEVO
- api/promociones.php                            NUEVO
- database/migrations/013_fase11_promociones.sql NUEVO
- includes/header.php                            REEMPLAZAR

BASE DE DATOS
La migración selecciona explícitamente la base colibrip_abcsistema antes de crear las tablas.

Tablas creadas:
- cp_promotions
- cp_promotion_products

La migración usa CREATE TABLE IF NOT EXISTS para evitar problemas cuando la tabla ya exista.

FUNCIONES PRINCIPALES
- Alta, edición y eliminación de promociones.
- Producto(s) asociados.
- Precio normal y precio promocional.
- Descuento porcentual o precio especial.
- Fecha de inicio y término.
- Cantidad disponible de la campaña. Vacío = ilimitada.
- Imagen personalizada. Si no existe, las vistas pueden usar la imagen del producto.
- Estado: borrador, activa o pausada.
- Canales: web, catálogo y WhatsApp.
- Vista previa de la promoción.
- Texto comercial reutilizable para WhatsApp.
- Feed JSON público: /api/promociones.php?channel=web|catalog|whatsapp

IMPORTANTE
La cantidad disponible de una promoción es un control comercial de la campaña. En esta fase no descuenta automáticamente inventario ni reduce existencias de cp_products.

COMUNICACIONES
Las promociones son comunicaciones comerciales. Se mantienen separadas de los mensajes operativos de cotizaciones, órdenes y producción.
El botón de WhatsApp abre un mensaje preparado en WhatsApp Web. La página no adjunta ni envía archivos automáticamente.

INSTALACIÓN
1. Respaldar los archivos actuales y la base de datos.
2. Ejecutar una sola vez:
   database/migrations/013_fase11_promociones.sql
   sobre colibrip_abcsistema.
3. Subir los PHP/CSS respetando las rutas indicadas.
4. Abrir /admin/promociones.php.
5. Crear una promoción de prueba con un producto activo.
6. Guardarla, editarla y comprobar el cambio de estado.
7. Revisar el feed /api/promociones.php?channel=web.
8. Probar el botón de WhatsApp con una promoción marcada para WhatsApp.

COMPROBACIÓN LOCAL
Se ejecutó php -l sobre todos los archivos PHP de esta entrega y no se detectaron errores de sintaxis.
