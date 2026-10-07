CAMBIOS - CONFIGURACION DE IMPRESION

Archivos:
- admin/impresion_precios.php
- admin/catalog_save.php
- admin/price_save.php
- admin/price_delete.php

Cambios principales:
1. Los formularios de tamaños, materiales y acabados ahora incluyen los campos code/sort_order que exige la BD real.
2. Se pueden agregar nuevos tamaños, materiales y acabados desde el panel.
3. Se puede editar nombre, codigo, medidas, orientacion, orden y estado.
4. Las tarifas permiten editar tamaño, material, acabado, color, modo de cobro, precio, minimo y estado.
5. Las tarifas se desactivan con enabled=0 en lugar de borrarse.
6. Los materiales usan catalog_action=delete correctamente.
7. Se conserva el historial cuando un catalogo tiene referencias.
8. El panel sigue trabajando con cp_print_prices, que es la tabla consumida por solicitar_impresion.php.

IMPORTANTE:
- Probar primero en cPanel.
- No reemplazar archivos fuera de los cuatro incluidos.
- El ZIP no contiene la base de datos.
