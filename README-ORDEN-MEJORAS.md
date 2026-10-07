# Colibrí Print · Orden de servicio V2

## Incluye
- Registro rápido de anticipo desde `admin/orden.php` usando `cp_payments`.
- Validación contra saldo pendiente.
- Historial de últimos pagos en la ficha de la orden.
- Lectura de las `Notas internas` de la cotización vinculada, solo para el equipo.
- Galería de fotos por orden.
- Tipos de foto: referencia del cliente, diseño/aprobación, evidencia de producción, entrega/resultado final.
- Descripción de cada foto y registro de usuario/fecha.
- Eliminación segura de fotos.
- Mantiene la sincronización Cotización ↔ Orden de la versión anterior.

## Instalación
1. Copiar `admin/orden.php`.
2. Copiar `includes/quote_order_sync.php` si no está instalada la versión de sincronización.
3. Copiar `includes/order_media.php`.
4. Copiar los CSS en `assets/css/`.
5. Ejecutar `018_order_photos.sql` en la base `colibrip_abcsistema`.
6. Verificar `https://colibriprint.com.mx/admin/orden.php?id=14`.

## Fotos
Se almacenan en `public_html/uploads/orders/<id>/` con nombres aleatorios y solo se aceptan JPG, PNG y WEBP hasta 8 MB.

## Anticipos
Se registran en `cp_payments` como pagos confirmados con nota iniciada por `ANTICIPO`, por lo que el resumen financiero existente los incluye en `Pagado` y `Saldo`.
