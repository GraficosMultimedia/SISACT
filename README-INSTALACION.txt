SISACT · IMPRESIONES · ROLLOS CRUD HOTFIX V3.1.1

QUÉ PASÓ
========
La V3 sí quedó activa en el servidor:
- el Wizard de dimensiones y costos funciona;
- el popup ya muestra scrollbar;
- calcula área, paneles, metros, saldo y costo;
- el historial V3 ya muestra las nuevas columnas.

El instalador V3.1 falló solamente al intentar volver a reemplazar
la llamada "create_roll" que la V3 anterior ya había cambiado.

Por eso:
Archivado = pendiente
Auditoría = pendiente

HOTFIX V3.1.1
=============
Este paquete NO vuelve a modificar create_roll.

Solo agrega:
- edición de rollos;
- modificación de saldo;
- modificación de ancho;
- modificación de costo por metro;
- archivado;
- restauración;
- eliminación segura;
- auditoría de cambios.

NUEVA RUTA
==========
/admin/impresiones_rollos.php

ELIMINACIÓN SEGURA
==================
Rollo SIN trabajos:
puede eliminarse físicamente.

Rollo CON trabajos:
NO se elimina.
Se archiva y conserva todos los movimientos históricos.

Un rollo archivado:
- deja de contar en inventario disponible;
- deja de aparecer como rollo utilizable;
- mantiene su historial;
- puede restaurarse.

INSTALACIÓN
===========
1. Extraer el ZIP en la raíz de SISACT.

2. Abrir:
   /admin/aplicar_impresiones_rollos_v3_1_1.php

3. Pulsar:
   Aplicar Hotfix V3.1.1

4. Debe mostrar:
   Archivado      ✓ listo
   Auditoría      ✓ listo
   Página Rollos  ✓ lista
   Helper CRUD    ✓ listo

5. Abrir:
   /admin/impresiones_rollos.php

6. Editar un rollo existente y probar:
   - nombre;
   - metros iniciales;
   - metros disponibles;
   - ancho;
   - costo/ml.

IMPORTANTE
==========
No necesitas reinstalar V3.
No pulses nuevamente el instalador V3.1 anterior.

SCROLL
======
En las capturas actuales el scrollbar del Wizard ya aparece y el botón
"Confirmar y descontar" está accesible en la zona inferior.

Este hotfix no reemplaza el Wizard ni sus cálculos.

GITHUB DESPUÉS DE VALIDAR
=========================
Subir:
admin/impresiones.php
api/registrar_impresion.php
admin/impresiones_rollos.php
includes/impresiones_rollos_v3_1_1.php
assets/css/impresiones-rollos-v3-1-1.css
database/sql/026_impresiones_rollos_crud_v3_1_1.sql

NO subir:
admin/aplicar_impresiones_rollos_v3_1_1.php
*.bak_rollos_v3_1_1
