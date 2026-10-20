# Colibrí Print · Acciones globales solicitudes web V1

## Archivos
- `admin/cotizaciones_web.php`
- `admin/cotizacion_web_editar.php`
- `admin/cotizacion_web_eliminar.php`
- `assets/css/cotizaciones-web-v1.css`

## Funciones
### Globales
- Seleccionar todo
- Editar una solicitud seleccionada
- Borrar una o varias solicitudes seleccionadas

### Individuales
Cada solicitud tiene:
- Editar
- Borrar, si no está convertida
- Abrir cotización, si ya fue convertida
- WhatsApp
- Correo
- Abrir archivo
- Cambiar estado

## Protección
- Todas las mutaciones usan CSRF.
- Borrado en transacción.
- Solicitudes convertidas (`converted_quote_id`) quedan bloqueadas para borrado.
- Archivos eliminados solo si la ruta pertenece a `/uploads/cotizador/`.
- No se toca una cotización formal existente.

## Edición
La página de edición reutiliza los datos existentes:
- cliente
- WhatsApp
- correo
- servicio
- cantidad
- fecha
- diseño
- aplicación/instalación
- entrega
- notas

Los detalles técnicos adicionales y el archivo existente se conservan.

## DB
No requiere migración ni cambios de esquema.
La columna `converted_quote_id` se detecta de forma dinámica.
