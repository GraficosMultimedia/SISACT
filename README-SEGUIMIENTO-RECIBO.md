# Seguimiento + recibo previo V1

Muestra en el seguimiento público la descripción del servicio, total, pagos confirmados, primer pago/anticipo, saldo y avance. Incluye descarga de PDF.

El cliente no puede marcar pagos como confirmados. La página solo lee `cp_payments.status = confirmed`. El registro se realiza desde Administración.

## V2 responsive
La V2 añade una capa de estilos mobile-first, corrige contraste del recibo y convierte el progreso en una línea vertical legible en teléfonos. No modifica la lógica ni la base de datos.
