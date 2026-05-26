# Skill `project-context/new_admin`

Contexto completo del proyecto **new-admin** (Civitatis Panel Admin). Carga este archivo cuando `$PROJECT_TYPE == new-admin` antes de implementar, planificar, revisar o auditar código.

## Cómo se carga

Las skills downstream (task-planner, task-implementer, task-reviewer, code-audit, etc.) hacen:

```bash
cat "$RUBBER_DUCK_HOME/skills/project-context/new_admin.md"
```

y, **adicionalmente**, leen los archivos del propio repo new-admin que viven en `$PROJECT_ROOT/.claude/`:

| Archivo | Cuándo leerlo | Por qué |
|---|---|---|
| `$PROJECT_ROOT/.claude/domain-index.md` | Antes de buscar código relacionado con un dominio | Mapea dominios → controllers/services/rutas. Evita exploración a ciegas. |
| `$PROJECT_ROOT/.claude/project-context.md` | En cualquier acción no trivial | Arquitectura detallada, problemas recurrentes, decisiones del equipo. |
| `$PROJECT_ROOT/.claude/refactoring-state.md` | Antes de cambiar capas o módulos en migración | Indica qué piezas están migradas a hexagonal y cuáles aún siguen el patrón legacy. |
| `$PROJECT_ROOT/.claude/USAGE.md` | Onboarding | Cómo usar la config Claude del propio repo. |
| `$PROJECT_ROOT/CLAUDE.md` | Siempre que sea relevante | Reglas vivas del equipo (este archivo es la fuente de verdad para R1-R6). |

Este skill es un complemento, **no sustituye** los archivos del repo. En caso de conflicto, lo que dice `$PROJECT_ROOT/CLAUDE.md` y `$PROJECT_ROOT/.claude/*` **gana**.

## Stack técnico (verificado contra `composer.json` y `dev/package.json`)

### Backend

| Tecnología | Versión | Notas |
|---|---|---|
| PHP | 7.4.29 | `composer.json` → `config.platform.php` |
| Slim Framework | ^3.10 | **NO Slim 4**. Router y middleware del framework. |
| `php-di/slim-bridge` | 2.0.0 | DI container que envuelve Slim |
| `illuminate/database` | 8.83.15 | Eloquent ORM (no Laravel completo) |
| `illuminate/events` | 8.83.15 | Eventos de Eloquent |
| Twig | 3.4.1 | Templating server-side |
| Monolog | 2.6.0 | Logging |
| `vlucas/phpdotenv` | ^2.6 | Variables de entorno |
| `hassankhan/config` | ^2.2 | YAML config (`config/*.yml`) |
| `symfony/console` | 5.4.9 | Comandos CLI (en `app/Console/`) |
| `php-amqplib/php-amqplib` | 3.2.0 | RabbitMQ |
| `nesbot/carbon` | ^2 | Fechas |
| `aws/aws-sdk-php` | ^3.147 | S3 y otros servicios AWS |
| `phpoffice/phpspreadsheet`, `shuchkin/simplexlsx`, `rap2hpoutre/fast-excel` | — | Excel I/O |
| `digitick/sepa-xml` | ^2.1 | Ficheros SEPA |
| `sentry/sdk` | ^3.3 | Error tracking |
| `optimizely/optimizely-sdk` | ^3.0 | Feature flags |

### Backend dev-deps

- `phpunit/phpunit` 9.5.20
- `pestphp/pest` ^1.21.2 (capa sobre PHPUnit, usada para los tests reales)
- `mockery/mockery` ^1.5
- `rector/rector` ^0.13.3
- `symplify/easy-coding-standard` ^11.0
- `phpcompatibility/php-compatibility`

### Frontend (vive en `dev/`)

| Tecnología | Versión | Notas |
|---|---|---|
| Vue | ^2.6.6 | **Options API exclusivamente** (R6) |
| Vuex | ^3.4.0 | Store global |
| `vue-router` | ^3.3.2 | Router |
| `bootstrap-vue` | ^2.15.0 | UI components |
| Webpack | 4.6.0 | Bundler (no Vite todavía) |
| `babel-loader`, `babel-preset-env` | varios | Transpilación |
| Jest | ^26.6.3 | Tests frontend |
| `@vue/test-utils` | ^1.3.0 | Helpers de test |
| `axios` | ^0.18.0 | HTTP client |
| `mapbox-gl`, `chart.js`, `apexcharts` | — | Visualización |
| `@sentry/vue` | ^7.43.0 | Error tracking frontend |
| `@optimizely/optimizely-sdk` | ^5.3.4 | Feature flags frontend |

## Arquitectura backend (hexagonal — enforced por phparkitect)

```
Controllers → Services → Repositories → Models
                ↓
             Domain
```

Capas y dependencias permitidas (validadas por `phparkitect.php` y `phparkitect-baseline.json` en la raíz del proyecto):

| Capa | Namespace | Puede depender de | NO puede depender de |
|---|---|---|---|
| Controllers | `App\Controllers` | Services, Domain, Slim/HTTP | Repositories, Models |
| Services | `App\Services` | Domain, `App\Config` (ConstService) | Repositories*, Models, HTTP |
| Repositories | `App\Repositories` | Models, Domain | Controllers, Services |
| Models | `App\Models` | Domain, `Illuminate\Database` | Controllers, Services, Repositories |

> \* Los Services que sí dependen de Repositories tienen entrada en `phparkitect-baseline.json` (deuda técnica conocida).

## Estructura de carpetas (resumen)

```
$PROJECT_ROOT/
├── app/                # PSR-4 → App\ (composer.json autoload)
│   ├── Controllers/    # adaptadores HTTP, inyectan Services
│   ├── Services/       # use cases / lógica de negocio
│   ├── Repositories/   # acceso a datos
│   ├── Models/         # entidades Eloquent (sin lógica de negocio)
│   ├── Domain/         # entidades de dominio, value objects
│   ├── Infrastructure/ # adapters de salida (RabbitMQ, AWS, etc.)
│   ├── Middleware/     # middlewares HTTP
│   ├── Validations/    # validators (respect/validation)
│   ├── Routes/         # carga modular de rutas
│   ├── Modules/        # módulos de negocio agrupados
│   ├── Console/        # comandos symfony/console
│   ├── Observers/      # observers Eloquent
│   ├── Exceptions/     # excepciones del dominio
│   ├── Traits/, enums/, Tasks/, Config/, docs/
│   └── helpers.php     # autoloaded
├── config/             # YAML: config.yml, crontab.yml,
│                       #       mappingPermissions.yml, routePermissions.yml
├── platform/           # bootstrap de plataforma
├── web/                # entry HTTP + assets compilados
├── templates/          # Twig
├── tests/              # Pest + PHPUnit (Unit/Models/Services/Repository/...)
├── dev/                # frontend (Vue 2 + Webpack)
│   ├── vue/
│   │   ├── modules/    # módulos de UI (área principal de trabajo)
│   │   ├── views/, components/, store/, plugins/,
│   │   ├── helper/, conf/, styles/, assets/
│   │   └── main.js     # entry point
│   └── package.json
├── bin/                # quality toolchain (ver §"Toolchain")
├── docker/, doc/, log/
├── .claude/            # config Claude propia del repo (LEER PRIMERO)
├── composer.json, composer.lock
├── phpstan.dist.neon, phpstan-baseline.neon
├── phparkitect.php, phparkitect-baseline.json
├── .php-cs-fixer.dist.php, .php-cs-fixer.cache
├── rector.php
└── CLAUDE.md           # reglas vivas del equipo (fuente de verdad)
```

## Toolchain de calidad (delegación obligatoria)

El proyecto ya provee un dispatcher de calidad. **rubber-duck delega, nunca duplica.**

```
$PROJECT_ROOT/bin/pre-commit                  # ejecuta todo: cs-fixer + phparkitect + phpstan + tests
$PROJECT_ROOT/bin/pre-commit php-cs-fixer [files...]
$PROJECT_ROOT/bin/pre-commit phparkitect
$PROJECT_ROOT/bin/pre-commit phpstan [files...]
$PROJECT_ROOT/bin/pre-commit tests
```

Internamente los wrappers viven en `$PROJECT_ROOT/bin/dev/` (`php-cs-fixer`, `phparkitect`, `phpstan`, `tests`, `composer`, `app.sh`) y suelen ejecutarse dentro del contenedor docker del proyecto (no en el host).

Validaciones de CI: `$PROJECT_ROOT/bin/ci-validations`. Build de producción: `$PROJECT_ROOT/bin/ci-production-build`.

## Convenciones (R3 – R6)

### R3 — Arquitectura hexagonal

Respetar la tabla de capas. Si necesitas que un Service dependa de un Repository, añade entrada en `phparkitect-baseline.json` solo si el equipo lo aprueba.

### R4 — Controllers nuevos

- **NO** extender `AbstractController`.
- Inyectar el Service **en los parámetros del método del Controller**, no en el constructor con `$repositoryClass`.
- El Controller es un adaptador HTTP fino: lee el request, llama al Service, devuelve la response. Nada más.

Ejemplo:

```php
// ✓
public function show(Request $request, Response $response, ActivityService $service): Response
{
    $activity = $service->findById((int) $request->getAttribute('id'));
    return $this->json($response, $activity);
}

// ✗
class FooController extends AbstractController
{
    protected $repositoryClass = ActivityRepository::class;
    // ...
}
```

### R5 — Códigos HTTP

Siempre usar las constantes de Slim:

```php
use Slim\Http\StatusCode;

// ✓
$response->withStatus(StatusCode::HTTP_UNPROCESSABLE_ENTITY);
$response->withStatus(StatusCode::HTTP_BAD_REQUEST);

// ✗
$response->withStatus(422);
$response->withStatus(400);
```

### R6 — Frontend

- **100% Options API.** No Composition API. No `<script setup>`.
- **Container + Presentational:** los containers en `dev/vue/modules/<modulo>/` cargan datos y los pasan vía props a presentational components.
- **Props Down / Events Up.** No mutar props desde el hijo; emitir eventos al padre.
- Módulos nuevos viven en `dev/vue/modules/<modulo>/`.
- Vuex 3: stores en `dev/vue/store/modules/`.
- Vue Router 3: rutas en `dev/vue/conf/`.

## Rutas y permisos

- Las rutas se registran en `app/route.php` y/o ficheros bajo `app/Routes/`.
- **Cada vez que añadas o modifiques una ruta, comprueba `config/routePermissions.yml`.** Hay un mapeo explícito ruta → permisos requeridos.
- Permisos del menú: `config/mappingPermissions.yml`.

## Integraciones externas relevantes

- **Navision (ERP):** sincronización de facturación y proveedores.
- **Adyen / PayPal / Checkout:** pasarelas de pago.
- **Ultimate:** WhatsApp / mensajería.
- **RabbitMQ:** colas. Flujo crítico: insert en `queue_action_payload` → RabbitMQ → Consumer → callback al monolito (civitatis old-admin). Problemas típicos: desincronización, retries inconsistentes, payloads inválidos.

## Datos del proyecto en Atlassian

- **Jira project keys:** `PANA` (features), `TAPEO` (ops/bugs).
- **Equipo (`customfield_11001`):** "Civitatis Admin".
- **Confluence:** space `PANA`, páginas estándar:
  - Backend: `2389508098`
  - Frontend: `2449342481`
- **Restricción R1:** lectura libre. Escritura solo en flujos `duck-analyze` / `duck-review` con confirmación expresa del usuario. Append idempotente entre marcadores `<!-- rubber-duck:start -->` … `<!-- rubber-duck:end -->`.

## Base de datos

- **MySQL 8.x.** BBDD `civitatis`. Aproximadamente 898 tablas (estado mayo 2026).
- **Compartida con old-admin.** Cualquier cambio de esquema afecta a ambos proyectos.
- **R2: read-only desde rubber-duck.** Nunca `INSERT`/`UPDATE`/`DELETE`/`ALTER`/`DROP`/`TRUNCATE`. Si la tarea lo requiere, redactar la query exacta y dejar que el usuario la ejecute manualmente.

## Antes de explorar código

1. Leer `$PROJECT_ROOT/CLAUDE.md` (fuente de verdad de R1-R6).
2. Leer `$PROJECT_ROOT/.claude/domain-index.md` para localizar el área afectada.
3. Si hay duda sobre el patrón a aplicar, leer `$PROJECT_ROOT/.claude/project-context.md`.
4. Si el cambio toca una pieza migrada/no migrada, consultar `$PROJECT_ROOT/.claude/refactoring-state.md`.
5. `grep` dirigido a partir de lo que dice domain-index. No explorar a ciegas.

## Antes de validar antes de pushar

- `$PROJECT_ROOT/bin/pre-commit phparkitect` — comprueba arquitectura
- `$PROJECT_ROOT/bin/pre-commit phpstan` — análisis estático
- `$PROJECT_ROOT/bin/pre-commit php-cs-fixer` — estilo
- `$PROJECT_ROOT/bin/pre-commit tests` — Pest + PHPUnit
- O todo de golpe: `$PROJECT_ROOT/bin/pre-commit`
