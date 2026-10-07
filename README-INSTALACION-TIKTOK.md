# Integración TikTok para Colibrí Print

## Archivos
- `admin/tiktok.php`
- `includes/tiktok.php`
- `api/tiktok/connect.php`
- `api/tiktok/callback.php`
- `api/tiktok/publish.php`
- `api/tiktok/status.php`
- `api/tiktok/webhook.php`
- `assets/css/tiktok.css`
- `database/migrations/018_tiktok_content.sql`

## Instalación
1. Copiar cada archivo respetando su ruta.
2. Ejecutar `database/migrations/018_tiktok_content.sql` una sola vez.
3. Abrir `/admin/tiktok.php`.
4. Crear/configurar la app en TikTok for Developers.
5. Agregar Login Kit y Content Posting API.
6. Registrar exactamente la Redirect URI HTTPS mostrada en el administrador.
7. Capturar Client Key y Client Secret.
8. Conectar la cuenta TikTok.
9. Para publicación directa se requiere el scope `video.publish`.
10. Para PULL_FROM_URL el dominio o prefijo del video debe estar verificado en TikTok.
11. Antes de automatizar publicaciones, probar una publicación manual desde el admin.

## Importante
- El Client Secret y los tokens permanecen en servidor.
- El endpoint de publicación usa `PULL_FROM_URL`, por lo que el video debe estar en una URL pública y verificable.
- El webhook se entrega como punto de extensión. La validación de webhook debe completarse conforme a la configuración vigente de la aplicación antes de depender de él en producción.
- Los clientes de TikTok sin auditoría tienen restricciones de visibilidad para publicaciones directas según la plataforma.

## Menú
El paquete no toca el header actual para evitar alterar otros módulos. Añade `/admin/tiktok.php` dentro del grupo "Comunicación" en el menú superior.
