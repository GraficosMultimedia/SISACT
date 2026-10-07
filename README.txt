COLIBRIPRINT - FIX EDICION ORDEN V1

Problema:
Al editar una factura, $orderOptions queda vacío, por lo que el <select>
"Orden de servicio" no muestra la orden existente.

Solución:
Cargar la orden vinculada por invoice['order_id'] y añadirla a $orderOptions.
No se modifican endpoints, BD, CSRF ni invoice_save.

Este ZIP contiene un parche documentado y seguro, no una reconstrucción
completa del módulo.
