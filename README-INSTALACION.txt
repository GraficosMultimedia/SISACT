SISACT · EDITOR DE ÓRDENES V1
Colibrí Print México

OBJETIVO
========
Agregar edición real de órdenes ya generadas sin cambiar el folio ni romper
la relación con su cotización de origen.

REVISIÓN PREVIA
===============
Se revisaron en GitHub antes de crear este paquete:
- admin/orden.php
- admin/ordenes.php
- admin/orden_nueva.php
- includes/ordenes.php
- includes/quote_order_sync.php
- includes/finanzas.php

La orden actual ya permite estado, archivos, pagos, responsables y notas, pero
no tiene un editor para cliente/conceptos/precios/total.

ARCHIVOS
========
NUEVOS:
- admin/orden_editar.php
- assets/css/orden-editor-v1.css
- assets/js/orden-editor-v1.js

REEMPLAZAR:
- admin/orden.php
- admin/ordenes.php
- assets/css/orden-detail-professional-v1.css

QUÉ SE PUEDE EDITAR
===================
- Cliente.
- Fecha de orden.
- Fecha compromiso.
- Responsable.
- Descripciones.
- Cantidades.
- Precios unitarios.
- Agregar conceptos.
- Eliminar conceptos.
- Notas operativas.
- Notas internas.

El total NO llega confiado desde JavaScript.
PHP vuelve a calcular cada subtotal y el total antes de guardar.

QUÉ NO CAMBIA
=============
- Folio OS-...
- quote_id / cotización de origen.
- Estado de la orden.
- Producción.
- Archivos.
- Comprobantes.
- Historial existente.
- Pagos.
- WhatsApp.
- Seguimiento.
- PDF.
- Base de datos.
- Esquema SQL.

ESTADOS EDITABLES
=================
Solo:
- pending / Pendiente
- in_progress / En proceso

Completada, Entregada y Cancelada quedan bloqueadas como histórico.

IMPORTANTE SOBRE "LISTO"
========================
La etapa de producción "Listo" normalmente sigue perteneciendo a una orden
general "En proceso", por lo que puede editarse mientras cp_orders.status sea
in_progress.

PROTECCIONES FINANCIERAS
========================
Si existen pagos confirmados:
- el nuevo total no puede quedar por debajo de lo ya pagado.

Si existen pagos o facturas:
- no se permite cambiar de cliente desde este editor.

Si existe una factura con status=issued:
- no se permite cambiar el total hasta corregir/cancelar esa factura.

Esto evita dejar datos financieros inconsistentes.

TRAZABILIDAD
============
Cada guardado agrega una entrada en cp_order_history con el mismo estado
anterior/nuevo y la nota "Orden editada manualmente...".
También se registra log_activity().

COTIZACIÓN VINCULADA
====================
La orden conserva quote_id.

Después de una edición manual, quote_order_diff() puede indicar que cliente,
conceptos, total o fecha difieren de la cotización.

ATENCIÓN:
El botón "Sincronizar desde cotización" de la ficha mantiene su comportamiento
actual. Si se usa posteriormente, volverá a copiar desde la cotización:
- cliente;
- total;
- fecha compromiso;
- conceptos.

INSTALACIÓN
===========
1. Respaldar:
   admin/orden.php
   admin/ordenes.php
   assets/css/orden-detail-professional-v1.css

2. Copiar este ZIP en la raíz de SISACT respetando carpetas.

3. Reemplazar los tres archivos indicados.

4. Copiar:
   admin/orden_editar.php
   assets/css/orden-editor-v1.css
   assets/js/orden-editor-v1.js

5. Ctrl+F5 una vez.

NO HAY SQL
==========
No requiere migración.

PRUEBA URGENTE RECOMENDADA
==========================
Primero usa una orden Pendiente o En proceso.

1. Abrir Orden.
2. Pulsar "Editar orden".
3. Cambiar una descripción.
4. Cambiar cantidad o precio.
5. Confirmar que el total cambia en pantalla.
6. Guardar.
7. Verificar en la ficha:
   - conceptos;
   - total;
   - historial;
   - PDF.
8. Volver a editar y agregar un concepto.
9. Volver a editar y eliminar un concepto.

Luego probar una orden con pagos para confirmar las protecciones.

REVERSIÓN
=========
Restaurar los tres archivos respaldados.
Los archivos nuevos orden_editar.php / CSS / JS pueden eliminarse.
