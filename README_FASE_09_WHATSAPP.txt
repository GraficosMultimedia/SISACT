FASE 9 · WHATSAPP Y COMUNICACIONES DE SERVICIO

Base integrada:
- Fases 5-8 actuales
- Datos de empresa y documento formal de cotización
- Producción estabilizada y seguimiento cliente en 5 etapas

Nuevas capacidades:
1) Plantillas de WhatsApp de servicio configurables.
2) Variables dinámicas: {cliente}, {folio}, {orden}, {total}, {vigencia}, {fecha_entrega}, {seguimiento}, {empresa}.
3) Botón WhatsApp en cotización, orden y producción.
4) Mensaje de etapa automática según etapa interna.
5) Registro interno de mensajes preparados para WhatsApp.
6) Separación de comunicaciones de servicio. Las campañas comerciales quedan fuera de esta fase.
7) Uso de https://wa.me/ para abrir WhatsApp con el mensaje precargado. El sistema registra que el mensaje fue preparado, no que fue enviado.

INSTALACION:
1. Respaldar la versión actual.
2. Reemplazar/subir el contenido del ZIP completo respetando rutas.
3. Ejecutar UNA SOLA VEZ:
   database/migrations/011_fase9_whatsapp.sql
4. Entrar a /admin/whatsapp.php y revisar/editar plantillas.
5. Probar los botones desde una cotización, una orden y una orden en producción.

Archivos nuevos principales:
- admin/whatsapp.php
- includes/whatsapp.php
- assets/css/whatsapp.css
- database/migrations/011_fase9_whatsapp.sql

Archivos integrados modificados:
- includes/header.php
- admin/cotizacion.php
- admin/orden.php
- admin/produccion_orden.php

Compatibilidad:
- PHP sin dependencia de funciones exclusivas de PHP 8.1+.
- MySQL 5.7 compatible.
