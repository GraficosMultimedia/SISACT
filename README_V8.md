# Colibrí Print · Módulo de impresión V8

Esta versión corrige el flujo que dejaba al cliente con un aviso global de tarifa y después perdía visualmente los archivos al fallar el POST.

## Cambios principales

- Nuevo flujo visual de 4 pasos: datos, archivos, configuración y envío.
- Cada archivo aparece como una tarjeta independiente.
- El sistema detecta páginas de PDF en el navegador y vuelve a verificarlas en servidor.
- La configuración inicial se toma de una tarifa activa existente, en vez de asumir combinaciones al azar.
- El cálculo se actualiza por archivo y en el resumen lateral.
- Se muestra páginas, hojas, copias y subtotal.
- Si una combinación no tiene tarifa, el problema aparece en la tarjeta del archivo y el botón de envío permanece deshabilitado.
- Se puede quitar un archivo individualmente.
- El servidor busca tarifas por coincidencia específica y acepta reglas existentes con service_key `document` o `impresion`.
- No se introducen nuevas columnas ni se sobrescribe la configuración de conexión.

## Archivos

- `solicitar_impresion.php`
- `includes/print_pricing.php`
- `assets/css/print-reception.css`
- `assets/js/print-reception.js`
- `admin/impresion_precios.php`
- `admin/recepcion_impresiones.php`
- `database/20260926_print_reception_v7.sql`

## Instalación

1. Respaldar la base de datos.
2. Mantener `config/runtime.php` del servidor.
3. Reemplazar los archivos del paquete en sus rutas correspondientes.
4. Si la migración V7 ya fue ejecutada, no es necesario ejecutarla nuevamente.
5. Limpiar caché del navegador y probar primero `solicitar_impresion.php`.

## Nota sobre tarifas

El cotizador necesita al menos una regla activa en `cp_print_price_rules`. La versión V8 no inventa precios ni crea tarifas automáticamente.
