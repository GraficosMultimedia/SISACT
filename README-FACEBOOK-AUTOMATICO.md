# Facebook automático para promociones

## Qué hace
- Una promoción marcada para Facebook y con estado `Activa` se intenta publicar automáticamente.
- Se usa la imagen de campaña; si no existe, se usa la imagen del primer producto asociado.
- El texto se genera con etiqueta, título, descripción, producto, precio, vigencia, WhatsApp, ubicación y URL pública.
- Se guarda un estado por promoción y el identificador del post para evitar duplicados.
- Las promociones con fecha futura quedan `pending` y se procesan con el cron de cPanel.

## Migración
Ejecuta una sola vez: `database/migrations/016_facebook_promociones_auto.sql`

## Configuración
En el administrador abre `/admin/facebook.php`. Captura ID de Página, Page Access Token, versión Graph API (por defecto v26.0) y URL pública `https://colibriprint.com.mx`. Activa la integración y prueba la conexión.

## Meta
La publicación usa el endpoint de fotos de la Página de Graph API. Para el flujo de publicación se necesita un Page Access Token y el permiso `pages_manage_posts`; `pages_show_list` se usa normalmente para listar las páginas del usuario y `pages_read_engagement` para leer datos de la Página.

## Cron de cPanel
En producción, programa cada hora: `php /home/USUARIO/public_html/cron/publicar_promociones_facebook.php` usando la ruta absoluta real de tu hosting.

## Importante
La publicación real no puede activarse hasta que exista una App de Meta, una Página administrada, permisos válidos y un Page Access Token. El sistema no simula publicaciones exitosas.
