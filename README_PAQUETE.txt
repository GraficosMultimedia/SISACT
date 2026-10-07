COLIBRI PRINT MÉXICO
PAQUETE WEB COMPLETO LIMPIO
Origen: GitHub main (SISTEMA-COLIBRI-PRINT-WEB)
Fecha de empaquetado: 2026-09-19

Este paquete conserva la estructura de main para despliegue/backup, con dos exclusiones deliberadas:
1) tiktok-callback/ se omite porque la integración TikTok quedó pospuesta.
2) archivos error_log y cachés generados se omiten para no distribuir registros de producción.

No se ha creado un segundo sistema ni se han sustituido los módulos existentes.

IMPORTANTE:
- Respaldar cPanel antes de reemplazar archivos.
- Revisar config/config.php antes de producción.
- No sobrescribir la base de datos sin respaldo.
