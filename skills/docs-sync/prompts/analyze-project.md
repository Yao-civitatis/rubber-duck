# Prompt — Análisis del código real → `project-snapshot.md`

Genera un snapshot estructural del proyecto leyendo el código fuente, manifests y configuración. Salida: `<repo>/docs/<proyecto>/project-snapshot.md`.

## Output común (ambos proyectos)

```markdown
# Project Snapshot — <proyecto>

> Generado por `duck-sync-docs` el <ISO-8601 UTC>.
> Refleja el estado real del código en `<$PROJECT_ROOT>` en ese momento.
> No editar manualmente: el siguiente sync lo sobrescribe.

## 1. Tecnologías y versiones
…

## 2. Estructura de carpetas
…

## 3. Arquitectura detectada
…

## 4. Puntos de entrada
…

## 5. Dependencias externas
…

## 6. Estado de deuda técnica
…
```

Idioma: `output.language` (regla `rules/output-language.md`).

## Adaptación new-admin

### §1 Tecnologías y versiones

Extraer de:

- `composer.json` (`require`, `require-dev`, `config.platform.php`)
- `composer.lock` (versiones exactas resueltas)
- `dev/package.json` (`dependencies`, `devDependencies`)
- `dev/package-lock.json` o `dev/yarn.lock`

Tablas separadas para backend y frontend:

```markdown
### Backend
| Paquete | Versión | Uso |
|---|---|---|
| php | <X.Y.Z> | runtime |
| slim/slim | <ver> | framework HTTP |
| illuminate/database | <ver> | ORM (Eloquent) |
| twig/twig | <ver> | templating |
| …

### Frontend
| Paquete | Versión | Uso |
|---|---|---|
| vue | <ver> | framework UI |
| vuex | <ver> | state |
| vue-router | <ver> | routing |
| webpack | <ver> | bundler |
| …
```

### §2 Estructura de carpetas

Árbol real con descripción breve. Profundidad 2 desde la raíz. Excluir `vendor/`, `node_modules/`, `web/build/`, `dev/node_modules/`, `.git/`, `.idea/`, `.claude/worktrees/`.

### §3 Arquitectura detectada

- Layers reales según código (Controllers/Services/Repositories/Models/Domain).
- Cita `phparkitect.php` y `phparkitect-baseline.json` para mencionar las reglas configuradas y las excepciones vivas.
- Si existe `$PROJECT_ROOT/.claude/refactoring-state.md`, **referenciarlo** ("Estado de migración legacy → hexagonal: ver `.claude/refactoring-state.md`"). No duplicar contenido.

### §4 Puntos de entrada

- `index.php` (HTTP).
- `app/Console/` (comandos symfony/console).
- `dev/vue/main.js` (frontend).
- Webhooks y consumers de cola si los hay.

### §5 Dependencias externas

- Integraciones detectadas en el código (Navision, Adyen, PayPal, Checkout, RabbitMQ, S3, Sentry, Optimizely, Google APIs, Zendesk).
- Bases del MCP database.

### §6 Estado de deuda técnica

- Archivos más grandes del proyecto (top 5 por LOC) en `app/`.
- Clases con más métodos públicos (top 5).
- Patrones inconsistentes detectados (Controllers que extienden `AbstractController`, literales numéricos en `withStatus()`, etc.) — heurísticas, no garantías.
- Citar `$PROJECT_ROOT/.claude/refactoring-state.md` si describe el estado canónico.

## Adaptación old-admin

### Banner inicial (obligatorio)

Tras la cabecera estándar, añadir:

```markdown
> **⚠️ Política de mantenimiento.**
> old-admin está en modo mantenimiento-only. No hay desarrollo de nueva funcionalidad.
> Visión del equipo: eliminar old-admin → migrar todo a new-admin.
> Sin Confluence ni herramientas formales de calidad. Audit por sentido común.
> Detalle en `$RUBBER_DUCK_HOME/rules/operational-restrictions.md` y `$RUBBER_DUCK_HOME/skills/project-context/old_admin.md`.
```

### Scope obligatorio

El análisis se restringe a los paths del whitelist `/admin` (definidos en `skills/project-context/old_admin.md` §"Scope estricto"). **No** se recorre el resto del repo civitatis aunque exista.

### §1 Tecnologías y versiones

- PHP version desde `Dockerfile.base` (`FROM php:<X.Y>-apache`).
- Apache version si se puede inferir.
- `composer.json` raíz (probablemente con solo 3 entradas: `google/apiclient`, `ext-json`, `ext-pdo`).
- Frontend: dependencias de `dev/package.json` si existe (jQuery, build pipeline, etc.).

### §2 Estructura

Árbol limitado al scope `/admin`. Profundidad 2.

### §3 Arquitectura detectada

- Patrones reales: `include`/`require_once`, PDO directo, short tags, HTML embebido en PHP, jQuery.
- **No** hablar de capas hexagonales — no aplican.
- Si hay clases nombradas (`\Civitatis\...`), citar las más relevantes encontradas.

### §4 Puntos de entrada

- `application/admin/index.php` y similares.
- Endpoints API en `application/admin/adminApi/`.

### §5 Dependencias externas

- Integraciones detectables en el código del scope (BBDD compartida, posibles llamadas a APIs externas, colas via `application/lib/Queues/Newadmin/`).

### §6 Estado de deuda técnica

- Archivos enormes del scope (índice por LOC; típicamente >1000 líneas son habituales).
- Concentraciones de SQL inline (heurística para detectar candidatos a migrar primero).
- Recordar que **estilo legacy ≠ deuda accionable** (regla `operational-restrictions.md`). Solo reportar deuda procesable (no estilo).

## Recorrido eficiente

- Usar `find` con `-not -path` para excluir vendor/node_modules/.git desde el inicio.
- Limitar lectura de cada archivo a primeros N KB para evitar saturar contexto.
- Para conteos de LOC, `wc -l` es suficiente — no leer el contenido entero.

## Errores

- Permisos denegados en algún path → registrar y continuar con el resto.
- Manifest corrupto → registrar y omitir esa sección, no abortar.
