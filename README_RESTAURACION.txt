COLIBRÍ PRINT MÉXICO - RESTAURACIÓN CENTRO DE WHATSAPP

Este paquete recupera la versión histórica del Centro de WhatsApp que incluía:
- Bandeja de conversaciones.
- Cotizaciones, pedidos y promociones como fuentes de comunicación.
- Mensajes predeterminados.
- Plantillas editables.
- Restaurar plantilla a su mensaje original.
- Vista previa antes de abrir WhatsApp.
- Registro de mensajes preparados.

PLANTILLAS RECUPERADAS
1. quote_sent        - Cotización enviada
2. order_confirmed   - Pedido confirmado
3. design_ready      - Diseño listo
4. design_approval  - Aprobación de diseño
5. printing          - En impresión
6. in_production     - En producción
7. quality_review    - Control de calidad
8. finished          - Trabajo terminado
9. ready_delivery    - Listo para entrega
10. delivered        - Entregado
11. promotion_offer  - Promoción comercial

ARCHIVOS
- admin/whatsapp.php                 Versión histórica del Centro de WhatsApp (v2)
- admin/whatsapp_historico.php       Copia de referencia de la versión anterior
- database/restore_templates.sql     Restauración segura de las plantillas
- database/README_SQL.txt            Indicaciones SQL

INSTALACIÓN
1. Respaldar la base de datos antes de modificarla.
2. Ejecutar database/restore_templates.sql sobre la base del sistema.
3. Guardar una copia del admin/whatsapp.php actual.
4. Copiar el archivo histórico como /admin/whatsapp.php.
5. NO sustituir config.php ni includes/whatsapp.php con este paquete.
6. Recargar /admin/whatsapp.php.

IMPORTANTE
La restauración de plantillas es independiente del endpoint de envío directo por Whapi. Si el servidor continúa devolviendo HTTP 409/HTML al enviar desde la bandeja, ese problema debe resolverse aparte.
