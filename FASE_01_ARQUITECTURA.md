# FASE 01 · Arquitectura pública

## Resultado

Se creó una capa de infraestructura pública independiente del motor administrativo.

## Cambios principales

### 1. Resolución automática de base path

El sistema determina el directorio público a partir de la ubicación real del proyecto respecto a `DOCUMENT_ROOT`.

Casos previstos:

- producción: `/`
- prueba: `/_prueba_colibri/`

También existe soporte opcional mediante:

`COLIBRI_PUBLIC_BASE`

### 2. Origen configurable

Existe `COLIBRI_PUBLIC_ORIGIN` como opción para despliegues con dominio/origen explícito.

### 3. Separación de recursos

Se diferencian dos tipos:

- assets del proyecto público;
- recursos existentes alojados en la raíz web, como `/uploads`.

Esto es importante porque el catálogo actual utiliza imágenes existentes del sistema.

### 4. Enlaces internos

La Home V2 deja de depender de rutas absolutas hardcodeadas como:

`/catalogo.php`

`/producto.php?id=...`

para los enlaces que pertenecen al nuevo proyecto público.

### 5. SEO de entorno de prueba

La subcarpeta de pruebas queda marcada como:

`noindex, nofollow, noarchive`

para reducir el riesgo de indexación accidental.

### 6. Infraestructura responsive

Se agregaron estilos y JavaScript reutilizables para:

- comportamiento móvil;
- menú;
- viewport state;
- scroll;
- safe-area en elementos flotantes;
- soporte futuro para DeviceOrientation.

## No realizado en Fase 01

- No se modificó la base de datos.
- No se creó carrito.
- No se creó checkout.
- No se modificó el motor de cotizaciones.
- No se modificó producción.
- No se modificó administración.
- No se implementó todavía el Design System completo.
- No se implementaron todavía popups globales.

Eso pertenece a fases posteriores.

## Dependencias existentes conservadas

La Home continúa utilizando:

- `/config/runtime.php`
- `/includes/company.php`
- base de datos actual;
- `cp_categories`;
- `cp_products`;
- `cp_product_images`;
- `cp_promotions`.

## Criterio de cierre

La infraestructura debe permitir construir las siguientes fases sin repetir ni hardcodear la lógica de rutas.
