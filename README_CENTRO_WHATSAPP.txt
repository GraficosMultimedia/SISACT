CENTRO DE WHATSAPP · CORRECCIÓN DE PLANTILLAS
Colibrí Print México

OBJETIVO
Corregir la información de las plantillas del Centro de WhatsApp y evitar mensajes con etiquetas o importes vacíos.

CAMBIOS
- Plantillas de servicio rediseñadas: cotización, pedido, diseño, aprobación, impresión, producción, calidad, terminado, listo y entregado.
- Plantilla comercial de promociones corregida.
- Compatibilidad con nombres antiguos de variables de promoción.
- Los datos de promociones se leen directamente de cp_promotions.
- Una línea que depende de un dato vacío se elimina completa, evitando textos como "Precio promocional:" sin valor.
- La cotización incluye enlace público al PDF.
- Producción usa mensajes distintos para Impresión, Producción y Calidad.
- Se mantiene separado servicio vs. comercial.

INSTALACIÓN
1. Ejecutar en phpMyAdmin, seleccionando la base colibrip_abcsistema o usando el USE incluido:
   database/migrations/015_centro_whatsapp_plantillas.sql
2. Reemplazar los archivos del ZIP respetando sus rutas.
3. No ejecutar migraciones anteriores.
4. Entrar a /admin/whatsapp.php y probar una cotización y una promoción.

PRUEBAS RECOMENDADAS
- Cotización CP-2026-00007: debe mostrar nombre de cliente, folio, total, vigencia, enlace PDF y empresa.
- Promoción: debe mostrar título, descripción (si existe), precio promocional, precio normal (si existe), descuento (si existe), vigencia y disponibilidad (si existe).
- Orden: el mensaje debe cambiar según la etapa interna.
