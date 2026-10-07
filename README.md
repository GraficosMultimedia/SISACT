# Colibrí Print - Impresión Precios V7.1

Parche de V7 para corregir el HTTP 500 provocado por el uso de funciones flecha `fn(...)` en `admin/impresion_precios.php`.

## Cambios
- Conserva la generación de combinaciones de V7.
- Reemplaza la función flecha por ciclos `foreach`, compatibles con versiones antiguas de PHP.
- No cambia tablas ni elimina datos.
- Incluye `price_generate.php`.

## Instalación
Subir el contenido de `admin/` al directorio `/admin/`, reemplazando los archivos de esta versión.

Primero comprobar que `/admin/impresion_precios.php` carga correctamente. No ejecutar todavía la generación masiva hasta verificar la página.
