SISACT · API COMPROBANTE DE PAGO CLIENTE · CONSOLIDADO
======================================================

ARCHIVO
-------
api/comprobante_pago_cliente.php

OBJETIVO
--------
Mantener la carga pública de comprobantes desde seguimiento.php, pero impedir
nuevas operaciones cuando la orden o la cotización vinculada estén canceladas.

VALIDACIÓN DE CANCELACIÓN
-------------------------
Antes de ejecutar payment_receipt_upload(), se llama:

tracking_guard_v1_assert_active($orderId)

El helper considera cancelación cuando cualquiera de estas fuentes está en
cancelled:

- cp_orders.status
- cp_order_status.stage
- cp_quotes.status

DEPENDENCIAS YA EXISTENTES EN SISACT
------------------------------------
config/runtime.php
includes/payment_receipts.php
includes/tracking_activity.php
includes/seguimiento.php
includes/seguimiento_cancelacion_kanban_v1.php

COMPORTAMIENTO
--------------
1. Solo acepta POST.
2. Valida token hexadecimal de 64 caracteres.
3. Resuelve order_id únicamente desde cp_tracking_tokens activo.
4. Bloquea la operación si la orden/cotización está cancelada.
5. Solo después guarda el comprobante.
6. Registra payment_receipt_uploaded en la actividad del cliente.
7. Redirige de regreso a seguimiento.php con receipt_sent=1.

INSTALACIÓN
-----------
Reemplazar en producción:

/api/comprobante_pago_cliente.php

No requiere SQL ni cambios de base de datos.

GITHUB
------
Subir exactamente:

api/comprobante_pago_cliente.php

VALIDACIÓN
----------
- Probar una orden vigente: debe aceptar el comprobante.
- Probar una orden cancelada: debe rechazarlo.
- Probar cotización cancelada con orden todavía vinculada: también debe rechazarlo.
