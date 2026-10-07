FIX PDF COTIZACION EN BLANCO

Reemplazar UNICAMENTE:
/includes/cotizacion_pdf_renderer.php

Causa corregida:
- El stream del contenido PDF se estaba generando con los caracteres literales \\n en lugar de saltos de línea reales.
- Se añade WinAnsiEncoding para que acentos como í, é y ó se rendericen correctamente en Helvetica.

No requiere SQL.
No reemplazar otros archivos.
