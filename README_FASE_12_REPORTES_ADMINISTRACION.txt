COLIBRÍ PRINT MÉXICO | FASE 12 | REPORTES Y ADMINISTRACIÓN

Archivos del paquete:
- admin/reportes.php
- assets/css/reportes.css
- includes/header.php

No requiere migración SQL nueva.

El reporte trabaja con las tablas ya existentes de cotizaciones, órdenes, pagos, facturación y promociones.

Funciones:
- Filtro por fecha desde/hasta.
- KPIs de ventas, cobros, saldos, facturación, conversión y ticket promedio.
- Tendencia mensual de ventas.
- Estado de órdenes y cotizaciones.
- Principales clientes.
- Conceptos más vendidos por importe.
- Órdenes vencidas abiertas.
- Indicadores administrativos.
- Exportación CSV de órdenes del periodo.
- Impresión amigable.

Definiciones del reporte:
- Ventas: suma de o.total por fecha de orden, excluyendo canceladas.
- Cobrado en periodo: pagos con status=confirmed por fecha de pago.
- Saldo: total actual de órdenes del periodo menos pagos confirmados registrados para cada orden.
- Facturado: suma de cp_invoices.total con invoice_date dentro del periodo y status distinto de cancelled.

No modifica las tablas de datos.
