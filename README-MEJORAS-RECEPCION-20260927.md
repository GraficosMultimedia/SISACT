# Mejoras de recepción de impresiones

Incluye:
- Marcar una solicitud como "impresión realizada".
- Conservar archivo + registro en historial.
- Eliminar trabajo y archivos cuando no está vinculado a cotización/orden.
- Historial de trabajos archivados.
- Editar y eliminar materiales desde Configuración > Precios.
- Si un material ya tiene tarifas o uso histórico, "Eliminar" lo desactiva para proteger el histórico.

## Instalación
1. Hacer respaldo de la base de datos.
2. Ejecutar `migration_recepcion_impresiones_20260927.sql`.
3. Subir los archivos PHP modificados dentro de `admin/`.
4. Conservar la estructura actual de `config/bootstrap.php` del servidor. El paquete de código entregado contiene referencias a esa ruta aunque el ZIP recibido no incluía esa carpeta.
5. Probar primero con una solicitud de prueba.
