FASE 9 · HISTORIAL Y BITÁCORA DE ÓRDENES
==========================================

Archivos modificados:
- admin/produccion.php
- admin/produccion_historial.php
- admin/orden.php
- includes/produccion.php
- includes/header.php
- database/migrations/009_fase9_historial_ordenes.sql

Qué incorpora:
1. Las órdenes entregadas salen del tablero activo de Producción.
2. La etapa de producción "Entregado" sincroniza cp_orders.status = delivered.
3. Si una orden se marca como Entregada desde su ficha, también se cierra la etapa de producción.
4. El historial reconoce las órdenes entregadas y conserva la bitácora existente.
5. Se mantiene la paginación del historial.
6. Se agrega "Historial" al menú administrativo.
7. Se incluye una migración para sincronizar órdenes ya entregadas antes de Fase 9.

IMPORTANTE:
- Este paquete se construyó sobre los archivos entregados en ARCHIVOS SOLICITADO.zip.
- No contiene config/runtime.php porque ese archivo no fue incluido en el paquete recibido.
- Tampoco contiene admin/produccion_orden.php, que es referenciado por producción.php pero no fue incluido en el paquete recibido.
- No se deben eliminar archivos existentes del servidor que no formen parte de este ZIP.

INSTALACIÓN:
1. Realiza una copia de seguridad.
2. Sube/reemplaza los archivos respetando sus rutas.
3. Ejecuta database/migrations/009_fase9_historial_ordenes.sql una sola vez.
4. Prueba:
   - una orden activa en Producción;
   - moverla a Entregado;
   - comprobar que desaparece del Kanban;
   - abrir Historial;
   - comprobar que aparece paginada;
   - abrir la orden y verificar su bitácora;
   - abrir el enlace de seguimiento del cliente y comprobar que muestra Entregado.
