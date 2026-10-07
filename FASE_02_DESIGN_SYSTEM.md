# FASE 02 · DESIGN SYSTEM COLIBRÍ

## Objetivo

Formalizar el lenguaje visual de la nueva interfaz pública para que Home, Catálogo, Producto, Promociones, Servicios, Cotizador, Carrito y Checkout compartan una misma base.

## Paleta

### Dominantes

- Negro: `#090b0f`
- Negro secundario: `#12161d`
- Rojo Colibrí: `#ef164f`
- Mango: `#ffb400`
- Blanco: `#ffffff`

### Acentos

- Azul: `#159be8`
- Verde: `#25c66f`
- Morado: `#7d38e8`

## Reglas visuales

### Rojo

Usos principales:
- CTA primario;
- enlaces de acción;
- elementos de marca;
- indicadores importantes;
- promociones de alto impacto.

### Mango

Usos principales:
- llamadas secundarias;
- destacados;
- promociones;
- novedades;
- estados de atención.

### Morado

Usos principales:
- ayuda contextual;
- popups;
- interacción;
- elementos especiales;
- microinteracciones.

### Azul

Usos principales:
- información;
- enlaces secundarios;
- campos enfocados;
- estados informativos.

### Verde

Usos principales:
- disponibilidad;
- éxito;
- confirmación;
- estados positivos.

## Componentes creados

- botones;
- badges;
- chips;
- cards;
- product cards;
- promo cards;
- formularios;
- alerts;
- modal visual;
- header primitives;
- layout grid;
- contenedores;
- tipografía;
- espacios;
- sombras;
- radios;
- superficies.

## Responsive

Breakpoints de comportamiento:

- escritorio amplio;
- tablet;
- móvil;
- móvil pequeño.

No se utilizan dimensiones rígidas como estrategia principal de layout.

## Accesibilidad

Se incluye:

- `focus-visible`;
- áreas táctiles adecuadas;
- `prefers-reduced-motion`;
- contraste de estados principales;
- estructura compatible con teclado.

## Dependencias

El CSS no necesita Tailwind, Animate.css ni JavaScript para existir. Esto permite que el sistema visual sea reutilizable y ligero.

Las librerías de animación podrán incorporarse encima de este sistema en FASE 03 sin acoplar el diseño a ellas.

## No incluido en esta fase

- lógica de popup;
- sensores del teléfono;
- carrito;
- checkout;
- SEO dinámico;
- Merchant;
- modificaciones SQL.
