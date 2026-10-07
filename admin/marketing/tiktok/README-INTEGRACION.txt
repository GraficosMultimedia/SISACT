COLIBRI PRINT - MODULO TIKTOK

Este paquete integra el módulo TikTok bajo:
  /admin/marketing/tiktok/

IMPORTANTE:
1. NO se incluyen access_token ni refresh_token reales.
2. NO se copia storage/tiktok_token.json.
3. Configura las credenciales en el servidor, fuera del ZIP público.
4. Mantén el callback OAuth apuntando al dominio HTTPS de producción.
5. Este V1 conserva la conexión/lectura de videos existente. La publicación
   automática se añadirá solamente después de validar los permisos disponibles.

Integración visual:
- El módulo se aloja dentro de Admin > Marketing > TikTok.
- No crea un segundo admin.
- El CSS específico queda aislado del resto del sistema.
- El header/sidebar global deberá envolver este módulo desde el router/layout
  principal del admin.

Antes de producción:
- regenerar/revocar tokens que hayan sido compartidos.
- configurar client_key/client_secret mediante variables/configuración segura.
