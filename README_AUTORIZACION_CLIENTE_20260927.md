# Colibrí Print · Autorización pública de cotizaciones

## Flujo nuevo

1. El cliente envía una solicitud de impresión y recibe un enlace `/seguimiento.php?t=...`.
2. El enlace funciona desde que existe la solicitud, aunque todavía no haya una orden.
3. Administración convierte la solicitud en cotización formal.
4. Al enviar la cotización, la solicitud web pasa a `quoted`.
5. El cliente abre el mismo enlace, revisa el PDF y pulsa **Autorizar pedido**.
6. La autorización cambia la cotización a `approved`, registra fecha/IP de autorización y cierra la solicitud web.
7. Si no existe una orden activa, el sistema crea automáticamente una orden de servicio `pending` y copia sus conceptos.
8. El cliente es redirigido al seguimiento real de la orden.

## Migración

Ejecutar una sola vez:

`migration_cliente_autoriza_cotizacion_20260927.sql`

La migración agrega a `cp_quotes`:

- `client_approved_at`
- `client_approval_ip`

## Importante

El enlace de 64 caracteres funciona como credencial privada del expediente. No se muestra la aprobación si la cotización todavía está en borrador o revisión.
