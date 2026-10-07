# Colibrí Print · Recepción de impresión v7

Reconstrucción del módulo de impresión a partir del paquete v6 y de la estructura real de la base de datos entregada.

## Qué recupera esta versión

### Identidad visual
- Se recupera el lenguaje visual de Colibrí Print: fondo claro, tarjetas blancas, bordes suaves, sombras ligeras, azul principal, jerarquía tipográfica y botones consistentes.
- Se elimina el aspecto de CRUD básico con botones HTML desnudos.
- Administración, cotizador y recepción utilizan el mismo sistema visual.

### `admin/impresion_precios.php`
- Tamaños, materiales y acabados se presentan como catálogos visuales.
- Cada elemento se puede editar sin tocar código.
- Las tarifas se presentan como reglas de precio legibles.
- Se conserva la edición de:
  - nombre
  - código
  - medidas
  - orientación
  - unidad
  - orden
  - activo/inactivo
- Se conserva la configuración de:
  - tamaño
  - material
  - acabado
  - color
  - forma de cobro
  - precio
  - cantidad mínima
  - prioridad

### `solicitar_impresion.php`
- Permite múltiples archivos.
- PDF: detecta las páginas.
- JPG/PNG: se consideran 1 página.
- Cada archivo conserva su propia configuración.
- Cada archivo puede tener:
  - tamaño
  - material
  - acabado
  - color
  - una/doble cara
  - copias
  - notas
- El cálculo distingue páginas de hojas físicas.
- Doble cara calcula hojas con `ceil(páginas × copias / 2)` cuando la regla cobra por hoja.
- El nombre del archivo NO determina la tarifa. La tarifa depende de la configuración de impresión.
- Si no existe una tarifa, el mensaje queda asociado al archivo y explica que debe ajustarse la combinación o configurarse la tarifa.

### Corrección visual importante
El selector de archivos nativo queda oculto detrás del botón "Seleccionar archivos". Ya no aparecen simultáneamente el botón estilizado y el botón nativo "Elegir archivos".

## Archivos incluidos

- `solicitar_impresion.php`
- `admin/impresion_precios.php`
- `admin/recepcion_impresiones.php`
- `includes/print_pricing.php`
- `assets/css/print-reception.css`
- `assets/js/print-reception.js`
- `database/20260926_print_reception_v7.sql`
- `README_V7.md`

No reemplazar `config/runtime.php`.

## Instalación

1. Respaldar la base de datos.
2. Ejecutar `database/20260926_print_reception_v7.sql` una sola vez.
3. Reemplazar los archivos del módulo incluidos en este paquete.
4. No ejecutar los SQL v4/v5/v6 anteriores después de instalar v7.
5. Limpiar caché del navegador y probar:
   - `/admin/impresion_precios.php`
   - `/solicitar_impresion.php`
   - `/admin/recepcion_impresiones.php`

## Prueba recomendada

Crear una tarifa:

- Tamaño: Carta
- Material: Papel bond
- Acabado: Sin acabado
- Color: Color
- Cobro: Por página
- Precio: $5.00

Después cargar:
- PDF de 1 página → $5.00 con 1 copia.
- PDF de 5 páginas → $25.00 con 1 copia.
- PDF de 5 páginas → $50.00 con 2 copias.
- PDF de 5 páginas, doble cara, tarifa por hoja → 3 hojas por copia.

El servidor vuelve a contar las páginas del PDF al recibir la solicitud, por lo que el conteo del navegador es una previsualización y no la fuente definitiva.
