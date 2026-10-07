# Colibrí Print · Ficha Interna de Producción V3

Esta versión parte de la orden V2 que ya contiene:
- sincronización cotización ↔ orden;
- anticipo y pagos;
- notas internas;
- fotos;
- historial.

Agrega, sin eliminar lo anterior:
- Ficha técnica interna;
- plantillas por tipo de servicio;
- instrucciones generales;
- instrucciones críticas;
- control de diseño y versión aprobada;
- prioridad;
- checklist por etapa;
- indicador de preparación para producción.

## Migración
Ejecutar:
`database/sql/019_order_production.sql`

## Archivos
- admin/orden.php
- includes/production_brief.php
- assets/css/order-production.css
- database/sql/019_order_production.sql
- includes/order_media.php (solo se corrigió el uso de mb_substr por compatibilidad)

## Privacidad
Esta información es interna y no se incorpora al seguimiento público.

## Servicios con plantilla
Playeras, Impresión, Gran Formato/Vinil, CNC, Grabado Láser, Letras Corpóreas, Diseño/Branding, Promocionales, Impresión Comestible y Otro.
