SISACT · PARCHE PRODUCCIÓN V1
NOTA INTERNA EN KANBAN
Colibrí Print México

OBJETIVO
========
Mostrar la nota interna de la Orden de Servicio directamente en la tarjeta
del Kanban para que producción pueda identificar de inmediato la instrucción,
máquina o proceso requerido.

Ejemplo:
  ⚙ INSTRUCCIÓN DE PRODUCCIÓN
  GRABADO LÁSER - VASO YETI

REVISIÓN PREVIA
===============
Se revisaron en GitHub antes de generar este parche:
- includes/produccion.php
- admin/produccion.php
- assets/css/produccion-workspace-professional-v1.css

El problema confirmado era que production_orders() no seleccionaba
cp_orders.internal_notes, por lo tanto Kanban no tenía acceso a ese dato.

ARCHIVOS A REEMPLAZAR
=====================
includes/produccion.php
admin/produccion.php
assets/css/produccion-workspace-professional-v1.css

CAMBIO 1
========
includes/produccion.php

production_orders() ahora incluye:
  o.internal_notes

No cambia joins, filtros, estados, ordenamiento ni límite de registros.

CAMBIO 2
========
admin/produccion.php

Si internal_notes contiene texto, la tarjeta muestra:

  ⚙ INSTRUCCIÓN DE PRODUCCIÓN
  [contenido de Notas internas]

El contenido se escapa con e() y conserva saltos de línea mediante nl2br().

Si la orden NO tiene nota interna, no se muestra ningún bloque adicional.

CAMBIO 3
========
assets/css/produccion-workspace-professional-v1.css

Se añade un bloque visual diferenciado para la instrucción de producción:
- tono amarillo discreto;
- borde lateral;
- texto legible;
- 14px en móvil;
- salto de línea y palabras largas controlados.

CACHE
=====
admin/produccion.php cambia:
  produccion-workspace-professional-v1.css?v=1.0.0
a:
  produccion-workspace-professional-v1.css?v=1.0.1

NO SE MODIFICA
==============
- base de datos;
- tablas;
- SQL de migración;
- production_set_stage();
- historial;
- estados;
- cp_order_status;
- cp_order_history;
- cp_orders.internal_notes;
- editor de órdenes;
- responsable;
- vencimiento;
- búsqueda;
- filtros;
- PDF;
- WhatsApp.

INSTALACIÓN
===========
1. Respaldar los tres archivos indicados.
2. Copiar el contenido del ZIP en la raíz de SISACT.
3. Reemplazar:
   includes/produccion.php
   admin/produccion.php
   assets/css/produccion-workspace-professional-v1.css
4. Abrir Producción y hacer Ctrl+F5 una vez.

PRUEBA
======
1. Abre una orden y escribe en Notas internas:
   GRABADO LÁSER - VASO YETI
2. Guarda la orden.
3. Regresa a Producción.
4. La tarjeta debe mostrar la instrucción antes de la fecha de entrega.
5. Prueba una orden sin nota interna: la tarjeta debe permanecer igual.

REVERSIÓN
=========
Restaurar los tres archivos respaldados.

SIN MIGRACIÓN SQL
=================
Este parche reutiliza cp_orders.internal_notes, que ya existe.
