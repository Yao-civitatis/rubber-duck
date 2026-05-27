# Project Snapshot — new-admin

> Generado por `duck-sync-docs` el 2026-05-27.
> Refleja el estado real del código en `/home/yaowu/proyectos/tilt/tilts/new-admin` en ese momento.
> No editar manualmente: el siguiente sync lo sobrescribe.

## 1. Tecnologías y versiones

### Backend

| Paquete | Versión | Uso |
|---|---|---|
| php | 7.4.29 | runtime (config.platform.php) |
| slim/slim | ^3.10 | framework HTTP |
| php-di/slim-bridge | 2.0.0 | DI container envolviendo Slim |
| illuminate/database | 8.83.15 | ORM (Eloquent) |
| illuminate/events | 8.83.15 | Eventos de Eloquent |
| twig/twig | 3.4.1 | Templating server-side |
| slim/twig-view | ^2.5.1 | Integración Slim ↔ Twig |
| monolog/monolog | 2.6.0 | Logging |
| nesbot/carbon | ^2.0 | Fechas |
| vlucas/phpdotenv | ^2.6 | Variables de entorno |
| hassankhan/config | ^2.2 | YAML config (config/*.yml) |
| symfony/console | 5.4.9 | Comandos CLI (app/Console/) |
| symfony/string | 5.4.9 | Helpers de strings |
| symfony/yaml | 5.4.3 | Parsing YAML |
| php-amqplib/php-amqplib | 3.2.0 | RabbitMQ |
| aws/aws-sdk-php | ^3.147 | S3 y otros servicios AWS |
| sentry/sdk | ^3.3 | Error tracking |
| optimizely/optimizely-sdk | ^3.0 | Feature flags |
| google/apiclient | ^2.7 | Google APIs |
| google/cloud-translate | ^1.12 | Traducción |
| zendesk/zendesk_api_client_php | ^2.2 | Zendesk |
| firebase/php-jwt | ^6.10 | JWT |
| guigpm/php-fcm | ^1.0 | Firebase Cloud Messaging |
| phpfastcache/phpfastcache | ^7.1.2 | Cache |
| phpmailer/phpmailer | ^5.2 | Email |
| phpoffice/phpspreadsheet | 1.23.0 | Excel I/O |
| shuchkin/simplexlsx | ^0.8.21 | XLSX simple |
| rap2hpoutre/fast-excel | ^4.1 | Excel rápido |
| digitick/sepa-xml | ^2.1 | Ficheros SEPA |
| respect/validation | ^1.1 | Validación de inputs |
| awobaz/compoships | ^2.3 | Relaciones Eloquent compuestas |
| spatie/fractalistic | 2.9.0 | API resource transformers |
| adhocore/cron-expr | 1.0.0 | Cron expressions |
| dflydev/fig-cookies | ^1.0 | Cookies PSR-7 |
| slim/flash | ^0.4.0 | Flash messages |
| tuupola/slim-basic-auth | 3.3.1 | HTTP basic auth middleware |
| axy/htpasswd | ^1.0 | Htpasswd files |
| ramsey/uuid | ^4.2 | UUID generation |
| nategood/httpful | ^0.2.20 | HTTP client legacy |

### Backend dev-deps

| Paquete | Versión | Uso |
|---|---|---|
| phpunit/phpunit | ^9.5 | Test runner base |
| symfony/var-dumper | ^5.4 | Debug |
| bamarni/composer-bin-plugin | ^1.8 | Aislamiento de herramientas |

Pest (`pestphp/pest`) y `mockery/mockery` también presentes en el suite real (instalados vía bin-plugin).

### Frontend

| Paquete | Versión | Uso |
|---|---|---|
| vue | ^2.6.6 | Framework UI (Options API) |
| vuex | ^3.4.0 | State management |
| vue-router | ^3.3.2 | Routing |
| bootstrap-vue | ^2.15.0 | UI components |
| webpack | 4.6.0 | Bundler |
| webpack-cli | ^2.1.5 | CLI de webpack |
| html-webpack-plugin | ^3.2.0 | Inyección de HTML |
| webpack-bundle-analyzer | ^2.13.1 | Análisis de bundle |
| babel-core | ^6.26.3 | Transpilación |
| babel-loader | ^7.1.2 | Loader webpack |
| babel-preset-env | ^1.6.0 | Preset moderno |
| babel-preset-vue-app | ^2.0.0 | Preset Vue |
| esbuild-loader | ^2.20.0 | Alternativa rápida |
| vue-loader | ^14.2.4 | Loader Vue |
| vue-template-compiler | ^2.6.6 | Compilador SFC |
| node-sass | ^4.14.1 | SCSS |
| vue-style-loader | ^4.1.3 | Styles loader |
| jest | ^26.6.3 | Tests frontend |
| @vue/test-utils | ^1.3.0 | Test helpers (vía devDependencies) |
| jest-environment-jsdom | ^26.6.2 | DOM en tests |
| axios | ^0.18.0 | HTTP client |
| axios-retry | ^3.2.0 | Reintentos automáticos |
| jquery | ^3.5.1 | DOM (residual) |
| lodash | ^4.17.10 | Utilidades |
| @sentry/vue | ^7.43.0 | Sentry para Vue |
| @sentry/browser | ^5.20.1 | Sentry navegador |
| @sentry/tracing | ^7.43.0 | Performance Sentry |
| @optimizely/optimizely-sdk | ^5.3.4 | Feature flags |
| chart.js | ^2.7.3 | Charts |
| apexcharts | ^3.19.2 | Charts adicionales |
| vue-apexcharts | ^1.4.0 | Bindings Vue |
| vue-chartkick | ^0.5.0 | Charts Vue |
| mapbox-gl | ^0.53.0 | Mapas |
| mapbox-gl-vue | ^1.9.0 | Bindings Vue |
| vue-mapbox | ^0.2.2 | Idem alternativo |
| vue-ckeditor2 | ^2.1.4 | Editor WYSIWYG |
| vue-quill-editor | ^3.0.6 | Editor alternativo |
| vue-cropperjs | ^4.1.0 | Crop de imágenes |
| vue2-dropzone | ^3.6.0 | Subida de archivos |
| vue2-datepicker | ^3.6.0 | Datepicker |
| vuejs-datepicker | ^0.9.26 | Datepicker (legacy alt) |
| vue-grid-layout | ^2.3.12 | Drag grid |
| vue-infinite-loading | ^2.4.3 | Scroll infinito |
| vue-input-tag | ^1.0.7 | Input de tags |
| vue-json-viewer | ^2.1.4 | Visor JSON |
| vue-meta | ^2.4.0 | Meta tags |
| vue-moment | ^3.2.0 | Filtros moment |
| vue-select | ^2.6.0 | Selects avanzados |
| vue-shortkey | ^3.1.6 | Shortcuts teclado |
| vue-sidebar-menu | ^4.7.4 | Sidebar |
| vue-top-progress | ^0.7.0 | Progress bar superior |
| vue-uuid | ^3.0.0 | UUIDs en Vue |
| vue-loaders | ^2.0.0 | Spinners |
| vue-clipboard2 | ^0.3.1 | Copiar al portapapeles |
| vue-cookies | ^1.7.4 | Cookies |
| vue-country-flag | ^1.0.1 | Banderas |
| vue-awesome | ^2.3.5 | Iconos FA |
| vue-awesome-notifications | ^2.2.9 | Notificaciones |
| vue-avatar | ^2.3.0 | Avatares |
| vuedals | ^1.7.0 | Modales |
| vuedraggable | ^2.17.0 | Drag & drop |
| vuelidate | ^0.7.4 | Validación |

## 2. Estructura de carpetas

```
new-admin/
├── app/                     # PSR-4 → App\ (composer.json autoload)
│   ├── Config/              # Constantes y mappings
│   ├── Console/             # Comandos symfony/console
│   ├── Controllers/         # Adaptadores HTTP — inyectan Services
│   ├── Domain/              # Entidades, value objects, exceptions de dominio
│   ├── enums/               # Enums (clases estáticas en PHP 7.4)
│   ├── Exceptions/          # Excepciones de aplicación
│   ├── Infrastructure/      # Adaptadores Gateway (S3, RabbitMQ, etc.)
│   ├── Middleware/          # Middlewares HTTP (auth, etc.)
│   ├── Models/              # Entidades Eloquent (sin lógica de negocio)
│   ├── Modules/             # Módulos agrupados (legacy/transitional)
│   ├── Observers/           # Observers Eloquent
│   ├── Repositories/        # Implementaciones Eloquent* (interfaces en Domain)
│   ├── Routes/              # Rutas por dominio (separadas de route.php)
│   ├── Services/            # Use cases (un método __invoke por Service)
│   ├── Tasks/               # Tareas programadas
│   ├── Traits/              # Traits reutilizables
│   ├── Validations/         # Validators (respect/validation)
│   ├── docs/                # Docs internas del proyecto
│   ├── helpers.php          # Autoloaded
│   └── route.php            # Entry de rutas (delegando a Routes/)
├── bin/                     # Toolchain (pre-commit + dev/*)
│   ├── pre-commit           # Dispatcher: php-cs-fixer / phparkitect / phpstan / tests
│   ├── dev/                 # Wrappers dockerizados
│   ├── lib/                 # Helpers bash
│   ├── ci-validations       # CI completo
│   └── ci-production-build  # Build prod
├── config/                  # YAML
│   ├── config.yml
│   ├── crontab.yml
│   ├── mappingPermissions.yml
│   └── routePermissions.yml
├── dev/                     # Frontend (Vue 2 + Webpack 4)
│   ├── vue/
│   │   ├── views/           # Páginas
│   │   ├── modules/         # Módulos de funcionalidad (área principal de trabajo)
│   │   ├── components/      # Componentes globales
│   │   ├── store/           # Vuex
│   │   ├── plugins/         # Plugins Vue
│   │   ├── conf/            # Configuración (router, etc.)
│   │   ├── helper/          # Helpers
│   │   ├── styles/          # SCSS
│   │   └── assets/          # Assets estáticos
│   └── package.json
├── doc/                     # Documentación adicional
├── docker/                  # Docker config
├── log/                     # Logs locales
├── platform/                # Bootstrap de plataforma
├── templates/               # Twig
├── tests/                   # Pest + PHPUnit
│   ├── Unit/                # Tests unitarios
│   ├── Domain/              # Tests de dominio
│   ├── Services/            # Tests de servicios
│   ├── Repository/          # Tests de repositorios
│   ├── Controllers/         # Tests de controllers
│   ├── Infrastructure/      # Tests de adapters
│   ├── Models/              # Tests de models
│   ├── Modules/             # Tests de módulos
│   ├── Observers/           # Tests de observers
│   ├── Validation/          # Tests de validators
│   ├── Menu/                # Tests de menú
│   └── Support/             # Helpers de test
├── web/                     # Entry HTTP + assets compilados
├── .claude/                 # Config Claude (LEER PRIMERO)
│   ├── CLAUDE.md            # — vía root CLAUDE.md
│   ├── domain-index.md      # mapping dominio → controllers/services
│   ├── project-context.md   # arquitectura detallada + problemas recurrentes
│   ├── refactoring-state.md # estado migración legacy → hexagonal
│   ├── jira-triage.md       # workflow Jira del equipo
│   ├── USAGE.md             # cómo usar el setup Claude
│   ├── agents/              # architect, backend-engineer, frontend-engineer, ...
│   ├── skills/, commands/, rules/, worktrees/
│   ├── settings.json, settings.local.json
├── composer.json, composer.lock
├── phpstan.dist.neon, phpstan-baseline.neon
├── phparkitect.php, phparkitect-baseline.json
├── .php-cs-fixer.dist.php
├── rector.php
├── CLAUDE.md                # Reglas vivas del equipo (fuente de verdad)
├── Dockerfile, docker-compose.yml
└── README.md
```

## 3. Arquitectura detectada

Arquitectura **hexagonal estricta**, validada por `phparkitect` con baseline `phparkitect-baseline.json` para deuda técnica conocida.

```
Controllers (HTTP)
  ↓
Services (use cases, un __invoke por Service)
  ↓
Domain (entidades + interfaces Repository/Gateway)
  ↑
Repositories (Eloquent*) — implementan interfaces de Domain
Infrastructure (*Adapter) — implementan Gateways de Domain
```

| Capa | Namespace | Depende de |
|---|---|---|
| Controllers | `App\Controllers` | Services + Domain (no Repositories ni Models) |
| Services | `App\Services` | Domain + ConstService (no HTTP, no Models directos) |
| Domain | `App\Domain` | nada externo (entidades + interfaces + excepciones) |
| Repositories | `App\Repositories` | Models + Domain (no Controllers ni Services) |
| Infrastructure | `App\Infrastructure` | Domain + libs externas (S3, RabbitMQ, etc.) |
| Models | `App\Models` | Domain + `Illuminate\Database` |
| Observers | `App\Observers` | un Service inyectado, sin queries propias |

Convenciones reforzadas:

- **1 endpoint = 1 Controller = 1 Service (un solo `__invoke`).**
- Servicios con sufijo `*Service` (action verb: `CreateUserService`, `UpdateUserService`).
- Repositorios nuevos con prefijo `Eloquent*`, en carpeta con nombre de la interfaz: `app/Repositories/<X>Repository/Eloquent<X>.php`.
- Adapters con sufijo `*Adapter`, en `app/Infrastructure/<X>/`.
- Excepciones con sufijo `*Exception` cerca del contexto de uso.
- Sin `Enum` (PHP 7.4) — constantes en clases estáticas o `app/enums/`.

> Estado detallado de migración legacy → hexagonal en `.claude/refactoring-state.md` (consultar antes de tocar piezas no migradas).

## 4. Puntos de entrada

- **HTTP:** `web/` (front controller) + `app/route.php` (router principal) + `app/Routes/<modulo>.php` (rutas modulares).
- **CLI:** `app/Console/` (comandos `symfony/console`).
- **Frontend bundle:** `dev/vue/main.js` (entry Webpack).
- **Consumers de cola:** RabbitMQ consumers fuera de este repo (en consumers separados); este repo es **productor** vía `application/lib/Queues/Newadmin/` del monolito civitatis.
- **Observers Eloquent:** `app/Observers/` (eventos de modelo → Services).

## 5. Dependencias externas

| Integración | Detalle |
|---|---|
| Navision (ERP) | sincronización de facturación y proveedores |
| Adyen / PayPal / Checkout | pasarelas de pago |
| Ultimate | WhatsApp / mensajería |
| RabbitMQ | colas (productor) — payloads en `queue_action_payload`, consumers callback al monolito |
| AWS S3 | almacenamiento (`aws/aws-sdk-php`) |
| Sentry | error tracking + performance |
| Optimizely | feature flags (backend + frontend) |
| Google APIs | translate + auth (`google/apiclient`, `google/cloud-translate`) |
| Zendesk | CS (`zendesk/zendesk_api_client_php`) |
| Mapbox | mapas en frontend |
| BBDD MySQL 8.x | compartida con old-admin (`civitatis`) |

## 6. Estado de deuda técnica

Indicadores visibles del estado actual:

- **Archivos grandes (top 10 por bytes, app/):**

  | Archivo | Tamaño aprox |
  |---|---|
  | `app/Repositories/ActivityRepository.php` | 184 KB |
  | `app/route.php` | 147 KB |
  | `app/Repositories/ProviderRepository.php` | 77 KB |
  | `app/Repositories/ActivityBookingRepository.php` | 71 KB |
  | `app/Repositories/AffiliateRepository.php` | 66 KB |
  | `app/Services/ConstService.php` | 60 KB |
  | `app/Services/AdjustBookingsService.php` | 50 KB |
  | `app/Repositories/TransferBookingRepository.php` | 44 KB |
  | `app/Services/TicketingIntegrationService.php` | 43 KB |
  | `app/Services/AdminApiService.php` | 43 KB |

- **`app/Services/ConstService.php`** es deuda explícita: documentado en `backend-standards.md` como "acoplamiento innecesario", uso desaconsejado en código nuevo. Constantes nuevas → cerca del contexto.

- **Repositorios legacy** en `app/Repositories/*.php` (sin `Eloquent*` prefix, sin interfaz en Domain): aún en uso. Patrón nuevo: `EloquentXRepository` con interfaz en `App\Domain\X\XRepository`. **No tocar legacy**, envolver o duplicar para refactor.

- **`app/route.php` ~147 KB**: rutas de primer nivel mezcladas con históricas. La regla del equipo es mantenerlo limpio, delegando a `app/Routes/<modulo>.php`. Trabajo de extracción pendiente.

- **Baseline `phparkitect-baseline.json`** lista las violaciones aceptadas temporalmente (Services dependiendo de Repositories, etc.). Refactor pendiente — no añadir entradas nuevas sin permiso del equipo.

- **Frontend Vue 2.6 + Webpack 4.6 + Options API** preserva el stack actual. Migración futura prevista: Vue 3 + Vite + Composition API (`duck-upgrade` plan).

- Existe `rector.php` para refactor automatizado puntual; usar con criterio.
