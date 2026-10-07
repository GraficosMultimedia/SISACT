FASE 6 - Nueva orden: filtros y vistas · CORRECCIÓN 2

Reemplazar:
- admin/orden_nueva.php
- assets/css/ordenes.css

Comportamiento:
- Al entrar a Nueva orden, el filtro predeterminado es "Aprobadas disponibles".
- Solo aparecen automáticamente cotizaciones aprobadas sin una orden activa.
- Las cotizaciones no aprobadas pueden consultarse mediante filtros, pero nunca muestran "Crear orden".
- Vista Lista o Cuadros.
- En Cuadros cada cotización es una tarjeta independiente y responsive, sin superposición.
- Búsqueda por folio o cliente.
- Los controles de filtro y cambio de vista se procesan por POST para evitar respuestas HTML antiguas de cachés de página.
- La pantalla administrativa envía encabezados no-cache/no-store.
- No requiere migración SQL.
- La lógica de creación sigue validando que la cotización esté aprobada y sin orden activa.
