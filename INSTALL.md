# Instalación FASE 02

## 1. Copiar los archivos

Dentro de `_prueba_colibri` crea/copia:

```text
assets/css/colibri-design-system.css
```

y el archivo:

```text
design-system-demo.php
```

El demo necesita que exista:

```text
config/public.php
```

de FASE 01.

## 2. Cargar el CSS

En las páginas públicas, después de `public-shell.css`, cargar:

```php
<link rel="stylesheet" href="<?= h(cp_public_asset('assets/css/colibri-design-system.css')) ?>">
```

Si la página no utiliza la función `h()`, puede utilizarse:

```php
<link rel="stylesheet" href="<?= htmlspecialchars(cp_public_asset('assets/css/colibri-design-system.css'), ENT_QUOTES, 'UTF-8') ?>">
```

## 3. Vista de prueba

Abrir:

```text
autodetectado/_prueba_colibri/design-system-demo.php
```

La URL exacta depende de la ruta donde se instale el proyecto.

## 4. No modificar

Esta fase no requiere SQL y no debe modificar:

- `cp_products`
- `cp_categories`
- `cp_promotions`
- `cp_quotes`
- `cp_orders`
- `cp_payments`
- producción
- administración

## Nota

Los componentes son visuales. Las interacciones avanzadas de popup, cascada, sensores y movimiento se implementarán en la fase correspondiente.
