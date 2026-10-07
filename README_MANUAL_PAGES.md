# Colibrí Print: análisis cancelable y páginas manuales

La recepción del archivo se separa del conteo de páginas. Cada archivo puede cancelar su análisis y capturar manualmente sus páginas. El envío distingue `page_source=manual` y conserva esa cantidad en la solicitud. También se elimina la dependencia de `$_FILES["dummy"]` al registrar.
