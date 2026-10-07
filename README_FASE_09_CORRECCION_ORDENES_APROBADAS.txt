FASE 9 · CORRECCIÓN DE NUEVA ORDEN

Esta versión corrige admin/orden_nueva.php.

Cambio principal:
- Ya no se solicita manualmente el ID de la cotización.
- La pantalla carga automáticamente las cotizaciones con status=approved.
- Se excluyen cotizaciones que ya tienen una orden activa.
- Las cotizaciones canceladas permiten volver a generar una orden.
- Cada registro muestra folio, cliente, fechas y total.
- Al seleccionar una cotización se abre el formulario normal de creación de la orden.

También se conserva el Historial de Fase 9 y se incluye admin/produccion_orden.php para que los enlaces del historial tengan destino.

INSTALACIÓN:
1. Respaldar la versión actual.
2. Reemplazar los archivos del ZIP respetando las carpetas.
3. No ejecutar migraciones adicionales por este cambio de interfaz.
4. Abrir /admin/orden_nueva.php.

REQUISITO:
La base de datos debe tener las tablas de Fase 5 y Fase 6 ya instaladas, como en la versión actual del sistema.
