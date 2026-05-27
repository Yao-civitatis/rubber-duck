# Upgrade Targets — new-admin

> Documento mantenido **manualmente por el equipo**. NO se regenera con `duck-sync-docs`.
> Define el stack destino exacto al que va la migración gestionada por `duck-upgrade`.

> ⚠️ **Placeholder.** Algunas decisiones siguen abiertas (marcadas como `(por confirmar)`). El equipo debe cerrar esos puntos antes de empezar `duck-upgrade plan` en serio.

## 1. Stack destino

### Backend

| Dimensión | Actual | Destino | Notas |
|---|---|---|---|
| PHP | 7.4.29 | **8.2.x** | Saltar a 8.2 directamente (LTS hasta 2025-12). 8.3+ tras estabilizar. |
| Framework HTTP | Slim 3 (`slim/slim: ^3.10`) | **Laravel 11** | Cambio mayor. Router, middleware, DI container, request lifecycle distintos. |
| ORM | `illuminate/database` 8.83.15 | **Laravel Eloquent** (parte del framework Laravel 11) | Continuidad — ya usamos Eloquent standalone. |
| Templating | Twig 3.4.1 + `slim/twig-view` | **Blade** (estándar Laravel) o **mantener Twig** vía adapter (por confirmar) |
| DI Container | `php-di/slim-bridge` 2.0.0 | **Service container nativo de Laravel** | |
| Config | `hassankhan/config` YAML | **Laravel config (PHP arrays)** | Convertir YAML → PHP arrays. |
| CLI | `symfony/console` 5.4.9 | **Artisan** | Migrar comandos a `app/Console/Commands/`. |
| Logging | Monolog 2.6.0 | **Monolog 3.x via Laravel logging** | Mantener channels existentes. |
| Validación | `respect/validation` ^1.1 | **Laravel form requests / validator nativo** | Migrar reglas. |
| Cache | `phpfastcache/phpfastcache` ^7.1.2 | **Cache facade de Laravel** | Redis driver para producción. |
| Cola | `php-amqplib/php-amqplib` 3.2.0 | **Laravel queues con driver RabbitMQ** (`vladimir-yuldashev/laravel-queue-rabbitmq` o similar) | Mantener payload format para no romper consumers. |
| Sesiones | `slim/flash` ^0.4.0 | **Session/flash de Laravel** | |
| HTTP Client | `nategood/httpful` + `aws/aws-sdk-php` | **Laravel HTTP client** (Guzzle wrapper) + `aws/aws-sdk-php` igual | |

### Backend dev-deps

| Dimensión | Actual | Destino | Notas |
|---|---|---|---|
| Test runner | PHPUnit 9.5 + Pest 1.21 | **Pest 2.x** + PHPUnit 10 | Mantener Pest como capa principal. |
| Static analysis | phpstan + phparkitect + baseline | **phpstan 1.x + phparkitect (nuevo phparkitect.php para Laravel)** | Adaptar reglas hexagonales a la estructura Laravel (mismas capas, namespaces nuevos). |
| Style | `symplify/easy-coding-standard` 11 + php-cs-fixer | **mismo** o **Laravel Pint** (por confirmar) | |
| Refactor | rector 0.13 | **rector 1.x con sets `LARAVEL_*` y `PHP_82`** | Pieza clave de la migración. |

### Frontend

| Dimensión | Actual | Destino | Notas |
|---|---|---|---|
| Framework | Vue 2.6 Options API | **Vue 3.4+** | |
| API style | Options API | **Composition API** (por confirmar — podría conservarse Options API si el equipo prefiere; Vue 3 lo sigue soportando) | Si Composition: usar `<script setup>` y composables. |
| State | Vuex 3.4 | **Pinia** | Más simple, mejor TS-friendly. |
| Router | vue-router 3.3 | **vue-router 4.x** | API distinta. |
| Bundler | Webpack 4.6 | **Vite 5.x** | Cambio mayor. HMR + build mucho más rápido. |
| Transpiler | Babel 6 | **esbuild + SWC** (incluidos en Vite) | |
| Tests | Jest 26 | **Vitest** | Más rápido, mismo API. |
| Test utils | `@vue/test-utils` 1.x | **`@vue/test-utils` 2.x** | |
| UI Lib | bootstrap-vue 2.15 | **bootstrap-vue-next** (Vue 3) o reemplazo (por confirmar) | bootstrap-vue 2 no soporta Vue 3. |
| Charts | chart.js 2.7 + apexcharts | **chart.js 4 + apexcharts 3.x** | Compatibles con Vue 3 vía wrappers actualizados. |
| Maps | mapbox-gl 0.53 + mapbox-gl-vue 1.x | **mapbox-gl 3.x** + reemplazo de wrapper (por confirmar) | mapbox-gl-vue 1.x es Vue 2 only. |
| HTTP | axios 0.18 | **axios 1.x** | API estable; subir versión mayor. |
| Editor WYSIWYG | vue-ckeditor2 + vue-quill-editor | **decidir uno solo + versión Vue 3** (por confirmar) | |
| Calendar | v-calendar 0.9 + vue-cal | **v-calendar 3.x** (Vue 3) | |
| Datepicker | vue2-datepicker + vuejs-datepicker | **uno solo + Vue 3** (por confirmar) | |
| Icons | vue-awesome 2.3 | **`@fortawesome/vue-fontawesome` 3.x** | |
| Lodash | lodash 4.x | **lodash 4.x** | Sin cambios. |
| jQuery | jquery 3.5 | **eliminar** | Sin justificación para mantener con Vue 3. |

## 2. Decisiones abiertas (por confirmar antes de `duck-upgrade plan`)

- [ ] **Templating:** Blade vs Twig (mantener Twig vía adapter).
- [ ] **API Vue:** Composition API obligatoria o Options API permitido en Vue 3.
- [ ] **Pinia vs Vuex 4** (Vuex 4 sigue funcionando con Vue 3, pero Pinia es la recomendación oficial).
- [ ] **UI Library:** bootstrap-vue-next, PrimeVue, Element Plus, o custom.
- [ ] **Style tool:** Easy Coding Standard vs Laravel Pint.
- [ ] **WYSIWYG editor:** unificar a uno solo y elegir versión Vue 3.

## 3. Librerías sin equivalente claro (riesgos)

- `mapbox-gl-vue` 1.x — sin versión Vue 3 estable conocida. Opciones: fork, reescribir wrapper, o usar mapbox-gl directo sin wrapper Vue.
- `vue2-dropzone` 3.6 — buscar alternativa Vue 3 (`vue-filepond` u otra).
- `bootstrap-vue` 2.15 — `bootstrap-vue-next` está en alpha al cierre de este documento; verificar madurez.

## 4. Orden recomendado de fases (input para `duck-upgrade plan`)

```
Fase 0 — Tooling
   - composer up con composer 2.7
   - eslint/prettier configs alineadas
   - rector setup con sets LARAVEL_* y PHP_82

Fase 1 — PHP 7.4 → 8.0
   - rector PHP_80
   - sintaxis incompatible (curly braces en strings, callable, etc.)

Fase 2 — PHP 8.0 → 8.2
   - rector PHP_81 + PHP_82
   - typed properties readonly, enums, never return type

Fase 3 — Slim 3 → Laravel 11
   - bootstrap nuevo
   - service providers
   - migrar Controllers (estructura idéntica gracias a hexagonal — bajo riesgo)
   - migrar middleware
   - migrar rutas (app/route.php → app/Http/routes.php o equivalente Laravel 11)
   - migrar comandos symfony/console → Artisan
   - migrar config YAML → PHP arrays

Fase 4 — Vue 2.6 → Vue 3
   - reemplazar bootstrap-vue, mapbox wrapper, datepickers (ver §3)
   - migrar componentes uno a uno (vue-router 3 → 4 incluido)
   - decidir Composition API y aplicar

Fase 5 — Webpack 4 → Vite
   - vite.config.js
   - alias y plugins equivalentes
   - migrar tests Jest → Vitest
```

## 5. Verificación post-migración (cada fase)

- `composer install` y `composer dump-autoload` sin errores.
- `bin/pre-commit` (o equivalente post-migración) limpia.
- Tests Pest + Jest/Vitest verdes con cobertura ≥ a la actual.
- Smoke test manual de endpoints críticos (auth, bookings, pagos).
- QA pase de regresión completo antes de cerrar la fase.

## 6. Owner y plazo

- **Owner:** equipo Civitatis Admin.
- **Plazo objetivo:** por definir (depende de prioridades de producto).
- **Riesgo principal:** Slim 3 → Laravel 11 es el cambio más invasivo. Hacerlo en una rama larga viva con muchos commits sincronizados a `main` es caro; considerar feature flags / build paralelo.
