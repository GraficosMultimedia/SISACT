# Colibrí Print · Recepción de impresión v6

Este paquete está alineado con la estructura real de la base de datos entregada en `colibrip_abcsistema (1).zip`.

## Correcciones importantes

1. No se usan los INSERT con `SELECT * FROM (...) seed` que provocaban errores como `Duplicate column name 'NOW()'`.
2. No se vuelven a insertar tamaños/materiales/acabados iniciales.
3. `cp_print_sizes` conserva `code` e `is_custom`.
4. `cp_print_materials` conserva `code` y `unit_label`.
5. Las nuevas tarifas incluyen `name`, `service_key` y `price_type`, columnas obligatorias de la BD actual.
6. La edición de catálogos permite modificar nombre, código, medidas, orientación, unidad y orden.
7. `solicitar_impresion.php` guarda tanto nombres de la estructura nueva (`size_name`, `material_name`, `finish_name`) como los nombres legacy cuando existan.
8. Los PDF se cuentan en servidor y el cálculo usa `page_count × copies`.
9. Doble cara calcula hojas físicas con `ceil(páginas × copias / 2)` cuando la tarifa es por hoja.
10. El admin ya no depende de columnas que no existen en la estructura actual.

## Instalación

1. Respaldar la base de datos.
2. Ejecutar únicamente `database/20260926_print_reception_v6.sql`.
3. Subir/reemplazar:
   - `solicitar_impresion.php`
   - `includes/print_pricing.php`
   - `admin/impresion_precios.php`
   - `admin/recepcion_impresiones.php`
   - `assets/js/print-reception.js`
   - `assets/css/print-reception.css`
4. No reemplazar `config/runtime.php`.
5. No ejecutar los SQL v4/v5 anteriores.

## Prueba

Configura una tarifa por página, por ejemplo $5.

- PDF de 1 página → $5 por copia.
- PDF de 5 páginas → $25 por copia.
- PDF de 5 páginas, 2 copias → $50.
- PDF de 5 páginas, doble cara y tarifa por hoja → 5 hojas por copia.
