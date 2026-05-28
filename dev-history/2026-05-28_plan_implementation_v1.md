# Plan de Implementación — rubber-duck

> **CONGELADO 2026-05-28** — implementación completa. Archivado en `dev-history/2026-05-28_plan_implementation_v1.md`. Este archivo se borra del repo al cerrar F14.
>
> Plan original: "vivo" hasta F14.

## Estado final (F14.2 review)

Todas las fases F1-F13 implementadas y commiteadas. Verificación E2E parcial:

| Fase | Estado | Commit |
|---|---|---|
| F1 — Andamiaje | ✅ | `75a566e` + `a4b8f17` (README correcciones) |
| F2 — Installer + dispatcher + detección | ✅ | `2550908` + `e8cd99c` (orphan prune) |
| F3 — duck-config + wizard | ✅ | `511b189` + `74baa7b` (wizard pregunta paths) + `2cc52ad` (search spots) |
| F4 — duck-help | ✅ | `d61363d` + `3797004` (slash commands /duck-*) |
| F5 — project-context skills | ✅ | `c050a9d` |
| F6 — analyze/plan/implement/review | ✅ | `9858f0e` + `25e9fc8` (export paths) + `328dc38` (analyze export) + `d42ae33`/`75b0426` (analyze prompt) + `61de617` (output.language) + `f1c479b`/`21f1f33` (CONVENTIONS → rules/) |
| F7 — duck-sync-docs | ✅ | `5a396f6` + `491fa2b` (relative paths) + `b14001d`/`546f57c` (docs model 3 capas) |
| F8 — duck-audit | ✅ | `4bc883a` |
| F9 — Git hooks (opt-in) | ✅ | `3ff5fec` |
| F10 — Agentes auxiliares | ✅ | `a7c3f64` |
| F11 — duck-upgrade | ✅ | `a23cee6` |
| F12 — auto-commit/auto-push | ✅ | `c9c1cca` |
| F13 — Verificación E2E | ⚠️ parcial | automatizados: F13.1, F13.2, F13.5, F13.7, F13.8, F13.9, F13.10. Manuales pendientes (requieren Claude session real): F13.3 (flujo new-admin), F13.4 (flujo old-admin), F13.6 (duck-db read/write). |
| F14 — Cierre | 🟢 en curso | este commit |

Cambios vs scope original del plan (incorporados durante implementación):

- §2.bis y §2.quater añadidas durante F1-F6 (self-contained + paths universales). Movidas a `rules/` (decisión F6-mid).
- `CONVENTIONS.md` creado temporalmente y luego refactorizado a `rules/` (5 archivos: export-paths, output-language, project-detection, self-contained, operational-restrictions).
- Modelo de 3 capas de docs introducido en F7 (bundle / install copy / live updates).
- Convención universal de paths de export (`<output_dir>/<JIRA-KEY-o-cmd>/<filename>`, relativo a `$PROJECT_ROOT`) — añadida en F6/F7.
- `duck-analyze` con opción `e` (export) + flujo idempotente con marcadores HTML comments — refinado en F6 tras feedback del usuario.
- Git hooks opt-in (default desactivados) — añadido en F9 tras feedback.
- Slash commands `/duck-*` para Claude Code (paralelos a los binarios CLI) — añadido entre F3 y F4.
- `dev-history/` carpeta de archivo histórico — definida en F14.

Tareas no completadas en este ciclo (futuras iteraciones):

- F13.3, F13.4, F13.6 manuales (requieren tickets reales y Claude session interactiva).
- Schema migration de `~/.rubber-duck/config.json` (F3.6) — pendiente, prevista post-MVP en sección §8.
- `duck-update` (auto-pull + re-setup) — sección §8 del plan.
- `CHANGELOG.md` — sección §8 del plan.

## 0. Resumen ejecutivo

Construir la herramienta `rubber-duck` definida en `README.md`: colección de skills, agentes y comandos para Claude que automatiza el flujo Jira → análisis → plan → implementación → review → audit sobre los proyectos **new-admin** y **old-admin** (módulo `{URL_DOMAIN}/admin` de `civitatis`).

No es app independiente. Conjunto de archivos markdown (skills/agentes/comandos) + scripts bash (setup, dispatcher, hooks) + configuración MCP, que se instala con `setup.sh` y expone binarios `duck-*` en `~/.local/bin/`.

**Principio fundamental:** los binarios `duck-*` se invocan desde **dentro del directorio del proyecto** (CWD). El dispatcher detecta el `$PROJECT_ROOT` dinámicamente caminando hacia arriba desde `$PWD`. **Nunca se hardcodean paths**.

## 1. Trazabilidad y contexto del entorno

- **Repo objetivo:** `/home/yaowu/proyectos/rubber-duck` (en la máquina de desarrollo actual; usuarios finales tendrán paths distintos)
- **Proyectos sobre los que opera (rutas dependen del usuario; aquí solo de referencia):**
  - **new-admin**
    - Path en esta máquina (referencia): `/home/yaowu/proyectos/tilt/tilts/new-admin`
    - **Marcador de detección:** `composer.json` con `"name": "civitatis/newadmin"` **o** presencia de `.claude/domain-index.md`
    - Stack real (verificado contra el repo y su `CLAUDE.md`):
      - PHP 7.4.29
      - Slim 3 (`slim/slim: ^3.10`) + illuminate/database 8.83.15 (Eloquent) + Twig 3.4.1
      - Vue 2.6 Options API + Vuex 3 + vue-router 3 + Webpack 4.6
      - Pest 1.21 + PHPUnit 9.5 (backend), Jest 26 (frontend)
      - Arquitectura hexagonal estricta: Controllers → Services → Repositories → Models (validada por `phparkitect` con `phparkitect-baseline.json`)
    - **Quality toolchain ya provista por el proyecto** (rubber-duck DELEGA, no duplica):
      - `bin/pre-commit` → dispatcher que ejecuta `php-cs-fixer`, `phparkitect`, `phpstan`, `tests`
      - `bin/dev/{php-cs-fixer,phparkitect,phpstan,tests,composer,app.sh}` → wrappers dockerizados
      - `bin/ci-validations`, `bin/ci-production-build`
    - **Config Claude ya existente:** `.claude/domain-index.md`, `.claude/project-context.md`, `.claude/refactoring-state.md`, `.claude/agents/*`, `.claude/jira-triage.md`. rubber-duck **lee** estos archivos antes de actuar.
  - **old-admin** (módulo `{URL_DOMAIN}/admin` del repo `civitatis`)
    - Path en esta máquina (referencia): `/home/yaowu/proyectos/tilt/tilts/civitatis`
    - **Marcador de detección:** `composer.json` minimalista de civitatis (3 paquetes: `google/apiclient`, `ext-json`, `ext-pdo`) **o** presencia de `application/admin/`
    - Stack real:
      - PHP 5.6 + Apache 2 (`Dockerfile.base` → `FROM php:5.6-apache`)
      - Short tags `<?` ampliamente usados; HTML embebido en PHP con `<?= ?>`; jQuery; PDO directo; sin namespacing global ni autoload PSR-4
    - **Política de trabajo (CRÍTICA):**
      - **Modo mantenimiento.** Solo bug fixes y mantenimiento. No se desarrollan funcionalidades nuevas.
      - **Sin Confluence de estándares.** No existe documento de estándares para old-admin y no se va a crear uno.
      - **Sin herramientas formales de calidad.** No hay `phpstan` / `phparkitect` / `php-cs-fixer` configurados para el subset `/admin`. Tampoco se configurarán.
      - **Auditoría = sentido común.** Buenas prácticas generales (no SQL injection nuevos, escape de output, consistencia con el archivo editado). No estándares externos. No fallar por estilo legacy.
      - **Respetar el entorno legacy.** Cambios nuevos siguen el estilo del archivo (PHP 5.6, sin spread, sin `??`, sin typed properties, short tags). No "modernizar" puntualmente.
      - **Visión a largo plazo:** eliminar old-admin → migrar todo a new-admin. `migration-agent` es prioridad estratégica.
    - **Scope estricto de paths** (sin cambios fuera de aquí):
      - Backend: `application/admin/`, `application/lib/Admin/`, `application/lib/Dao/Admin/`, `application/lib/Dto/Admin/`, `application/lib/Queues/Newadmin/`, `application/lib/NewAdmin/`, `application/admin/adminApi/`
      - Templates: `application/templates/admin/`
      - Frontend: `webroot/static/js/admin/`, `webroot/static/css/admin/`, `webroot/dev/js/admin/`, `webroot/dev/scss/admin/`, `dev/src/js/admin/`, `application/css_admin/`
- **Base de datos:** new-admin y old-admin **comparten la misma base de datos**. Cualquier cambio de esquema afecta a ambos.
- **Entorno de desarrollo:** Tilt (Kubernetes/microk8s, namespace `civitatis`). Skill `tilt-inspector` disponible para diagnóstico local.
- **Rama de trabajo:** `feature/rubber-duck-implementation`.

## 2. Restricciones operacionales (heredadas del `CLAUDE.md` de new-admin)

Estas restricciones se aplican a cualquier comando `duck-*` que toque new-admin. Para old-admin se aplican por extensión salvo indicación contraria:

| # | Restricción | Impacto en rubber-duck |
|---|---|---|
| R1 | **Jira escritura permitida solo en flujos explícitos con confirmación del usuario.** | `duck-analyze`: genera User Story + AC + Consideraciones Técnicas → muestra → pide confirmación → si OK, escritura **idempotente** en la descripción del ticket: si ya existe un bloque previo de "Generado por rubber-duck" → **reemplaza solo ese bloque** preservando el resto; si no existe → **añade al final**. Nunca reemplaza la descripción entera ni duplica el bloque. `duck-review`: genera informe → si `review.update_jira = true` (default `true` del README) y el usuario confirma → postea como comentario. Fuera de estos flujos, no se modifica Jira. El bloqueo "NEVER write Jira" del `CLAUDE.md` de new-admin se interpreta como guardia para sesiones ad-hoc; rubber-duck lo **anula** para sus flujos confirmados y lo documenta explícitamente en `skills/jira-analyzer/SKILL.md`. |
| R2 | **Base de datos read-only.** Prohibido `INSERT`/`UPDATE`/`DELETE`/`ALTER`/`DROP`/`TRUNCATE`. | `db-agent` y el MCP de base de datos rechazan queries de escritura. Si el usuario pide un cambio → se redacta la query y se presenta para revisión manual. |
| R3 | **Arquitectura hexagonal** validada por `phparkitect`. | `task-implementer` (new-admin) genera código respetando capas: Controllers no importan Repositories ni Models; Services no dependen de HTTP; Models sin lógica de negocio. `code-audit` delega en `bin/pre-commit phparkitect`. |
| R4 | **Controllers nuevos:** sin `AbstractController`; Service inyectado por parámetro. | Documentado en `skills/task-implementer/prompts/new_admin.md`. |
| R5 | **Códigos HTTP:** `Slim\Http\StatusCode::HTTP_*`, nunca literales. | Documentado en el mismo prompt. |
| R6 | **Frontend new-admin:** 100% Options API, Container + Presentational, módulos en `/dev/vue/src/modules/`. | Documentado en el prompt. |
| R7 | **DB compartida.** | `migration-agent` y `db-agent` advierten cuando una query/cambio afecta a ambos proyectos. |

## 2.bis Self-contained: cero dependencias de paths externos

`rubber-duck` debe poder funcionar en cualquier máquina sin asumir la existencia de otros repositorios ni rutas absolutas externas (por ejemplo `/home/<user>/proyectos/ai-development-rules/...`).

Toda plantilla, recurso o snippet que rubber-duck necesite debe vivir **dentro del repo**, en la carpeta `templates/`. Cuando una plantilla provenga originalmente de otro proyecto, se **copia** a `templates/` y se referencia siempre como `$RUBBER_DUCK_HOME/templates/<nombre>.md` — nunca por su ruta original.

Estructura nueva:

```
templates/
├── README.md                 # qué hay aquí, origen de cada plantilla
├── planning-template.md      # copia local de planning-template.md (Spec-Driven)
└── agents-exceptions-template.md  # copia local (si se necesita)
```

Reglas:
- Cualquier skill/agente que use una plantilla la lee desde `$RUBBER_DUCK_HOME/templates/`.
- No se permite leer plantillas desde paths absolutos externos (validable con `grep -r '/home/' skills/ agents/ commands/`).
- Si la plantilla origen se actualiza en su repo externo, se re-sincroniza manualmente al de rubber-duck. `templates/README.md` lleva el registro de la versión/commit origen.

## 2.ter Dos entry points: terminal y Claude Code (slash commands)

Cada comando `duck-*` debe estar disponible de **dos formas**:

1. **Binario en terminal:** `duck-<cmd> [args]` desde cualquier shell. Lo crea `setup.sh` en `~/.local/bin/` (wrapper que invoca `bin/duck.sh` → `claude`).
2. **Slash command en Claude Code:** `/duck-<cmd> [args]` dentro de cualquier sesión de Claude Code. Lo crea `setup.sh` en `~/.claude/commands/duck-<cmd>.md`.

Las dos rutas conviven y se mantienen sincronizadas: `setup.sh` instala ambas a la vez con la misma lista `COMMANDS=()`.

### Dos plantillas de slash command

- **Bash-only** (`help`, y los subcomandos `list|get|set|reset` de `config`): el markdown del slash command se limita a ejecutar el binario y mostrar su output. No invoca a Claude recursivamente.

  ```markdown
  ---
  description: <SHORT del catálogo de help.sh>
  argument-hint: <USAGE>
  allowed-tools: [Bash(duck-<cmd>:*)]
  ---

  !duck-<cmd> $ARGUMENTS
  ```

- **Skill-driven** (resto: `analyze`, `plan`, `implement`, `review`, `audit`, `sync-docs`, `onboarding`, `debug`, `migrate`, `db`, `standup`, `upgrade`, `install-hooks` y `config setup`): el markdown inlinea los tres pasos que el dispatcher haría:
  1. **Detección del proyecto** — ejecuta `bin/lib/detect-project.sh` vía Bash, exporta `$PROJECT_ROOT` y `$PROJECT_TYPE`, aborta con mensaje claro si no se detecta.
  2. **Restricciones operacionales** — bloque R1–R7 según `$PROJECT_TYPE` (mismo texto que construye el dispatcher).
  3. **Instrucciones del comando** — instrucción a Claude para leer `$RUBBER_DUCK_HOME/commands/<cmd>.md` y seguirlo, con `$ARGUMENTS` como argumentos del usuario.

  No usa `!duck-<cmd>` porque eso lanzaría un proceso `claude` anidado dentro de la sesión actual y la conversación se rompería. El slash command **es** el prompt; Claude actual lo ejecuta directamente.

### Generación y mantenimiento

- `setup.sh` extiende su loop sobre `COMMANDS=()` para escribir un `~/.claude/commands/duck-<cmd>.md` por comando, eligiendo plantilla bash-only o skill-driven según una whitelist interna.
- Cada slash command lleva una cabecera-comentario "Generado por rubber-duck/setup.sh" para detectar huérfanos (mismo mecanismo que ya se usa para los binarios en `~/.local/bin/`).
- `setup.sh` purga slash commands huérfanos al re-ejecutarse.
- `uninstall.sh` elimina todos los slash commands con el sello rubber-duck.

### Equivalencia funcional

| Terminal | Claude Code |
|---|---|
| `duck-help` | `/duck-help` |
| `duck-help audit` | `/duck-help audit` |
| `duck-config set plan.output_format html` | `/duck-config set plan.output_format html` |
| `duck-analyze PANA-123` | `/duck-analyze PANA-123` |
| `duck-audit --branch` | `/duck-audit --branch` |

## 2.quater Reglas transversales en `rules/`

Las reglas transversales viven cada una en su propio archivo dentro de `$RUBBER_DUCK_HOME/rules/`. Esa carpeta es la fuente de verdad permanente y **sobrevive** al borrado de este plan en Fase 14.

Cualquier skill, agent o command que toque alguna de esas áreas debe **citar el archivo concreto** de `rules/`. Esta sección del plan es solo un puntero.

Reglas activas:

- `rules/export-paths.md` — paths universales `<config.output_dir>/<JIRA-KEY-o-cmd>/<filename>` + `mkdir -p`.
- `rules/output-language.md` — `output.language` para todo contenido user-facing. Literales y código se preservan.
- `rules/project-detection.md` — `bin/lib/detect-project.sh` única fuente de `$PROJECT_ROOT` / `$PROJECT_TYPE`.
- `rules/self-contained.md` — cero paths externos. Plantillas copiadas a `templates/`.
- `rules/operational-restrictions.md` — R1–R7 + política old-admin mantenimiento-only.

Catálogo y mantenimiento documentados en `rules/README.md`.

## 3. Detección dinámica del proyecto (sin paths fijos)

**Esta es la decisión arquitectónica más importante del proyecto.**

`bin/duck.sh` exporta una variable `$PROJECT_ROOT` antes de invocar cualquier skill/agente. La detección sigue este orden:

1. **Walk-up desde `$PWD`** hasta encontrar un marcador de proyecto:
   - new-admin: `composer.json` con `"name": "civitatis/newadmin"` o presencia de `.claude/domain-index.md` en el directorio
   - old-admin: presencia de `application/admin/` en el directorio o `composer.json` minimalista de civitatis
2. Si encuentra marcador → exporta `$PROJECT_ROOT` y `$PROJECT_TYPE` (`new-admin` | `old-admin`).
3. Si no encuentra → fallback a `~/.rubber-duck/config.json` (`project.new_admin_path` / `project.old_admin_path`) **solo si están definidos**. Estas claves son opcionales y vacías por defecto.
4. Si tampoco → error explícito: "ejecuta este comando desde dentro del directorio de new-admin o old-admin, o configura `duck-config set project.new_admin_path <ruta>`".

Para old-admin se aplica detección adicional: si `$PROJECT_TYPE = old-admin`, todos los comandos validan que los archivos a modificar están dentro del scope `/admin` listado en la sección 1. Cualquier intento de tocar otro path se rechaza con error.

## 4. Suposiciones y preguntas

**Suposiciones:**
- Claude Code está disponible como CLI (`claude` en `$PATH`). El dispatcher invoca `claude` pasando el system prompt del comando.
- `~/.local/bin` es destino estándar para binarios de usuario.
- MCP de Atlassian disponible vía `npx -y` o equivalente.
- Tilt arriba durante la verificación E2E (Fase 13).

**Preguntas pendientes (no bloqueantes):**
- (Ninguna sobre old-admin — política confirmada: no Confluence, no herramientas formales, modo sentido común).

## 5. Datos confirmados (no hace falta preguntar)

| Dato | Valor |
|---|---|
| Atlassian URL | `https://civitatis.atlassian.net` |
| Cloud ID | `53c3ec94-9a0b-42ce-8e81-41719567106f` |
| Jira project keys | `PANA` (features), `TAPEO` (ops/bugs) |
| Confluence space | `PANA` |
| Confluence page — new-admin backend | `2389508098` |
| Confluence page — new-admin frontend | `2449342481` |
| Team custom field (Civitatis Admin) | `customfield_11001` |
| Base de datos | compartida new-admin ↔ old-admin |

---

## 6. Ejecución por fases

### 🟢 FASE 1 — Andamiaje del repositorio (ACTIVA)

**Criterio:** Estructura creada, `.gitignore` listo, rama de trabajo creada. Sin lógica todavía.

- [ ] **F1.1** Crear rama `feature/rubber-duck-implementation` desde `main`.
- [ ] **F1.2** Crear estructura de carpetas según README §"Estructura de carpetas". **Incluir `templates/`** (no listada en el README original pero requerida por la regla "self-contained" de §2.bis).
- [ ] **F1.3** `.gitignore` con: credenciales MCP, `*.original.md`, `PLAN_IMPLEMENTATION.md`.
- [ ] **F1.4** `mcp/atlassian/config.example.json` con valores reales públicos:
  ```json
  {
    "url": "https://civitatis.atlassian.net",
    "cloud_id": "53c3ec94-9a0b-42ce-8e81-41719567106f",
    "token": "TU_TOKEN_AQUI",
    "jira_project_keys": ["PANA", "TAPEO"],
    "confluence_space_key": "PANA",
    "team_custom_field": "customfield_11001",
    "team_custom_field_value": "Civitatis Admin"
  }
  ```
- [ ] **F1.5** `mcp/atlassian/page-ids.json` con IDs reales solo para new-admin. **No incluye old-admin** (no existe Confluence para esa parte):
  ```json
  {
    "new-admin": { "backend": "2389508098", "frontend": "2449342481" }
  }
  ```
  Comentario en `mcp/README.md` explicando que old-admin se omite intencionadamente (política de mantenimiento).
- [ ] **F1.6** `mcp/database/config.example.json` con placeholders. Nota: BBDD compartida.
- [ ] **F1.7** `mcp/claude_desktop_config.json` (sin credenciales, con placeholders).
- [ ] **F1.8** `mcp/README.md` con instrucciones.
- [ ] **COMMIT F1:** `feat(rubber-duck): scaffold repository structure and gitignore`

### ⏳ FASE 2 — Instalador, dispatcher y detección de proyecto

- [ ] **F2.1** `bin/lib/detect-project.sh`:
  - Función `detect_project_root()`: walk-up desde `$PWD` buscando los marcadores de la sección 3. Exporta `$PROJECT_ROOT` y `$PROJECT_TYPE`.
  - Fallback a `~/.rubber-duck/config.json` solo si está definido.
  - Error explícito con mensaje claro si no detecta nada.
- [ ] **F2.2** `bin/duck.sh` (dispatcher):
  - Primer arg = nombre de comando (`analyze`, `plan`, ...).
  - Para comandos que tocan un proyecto: invoca `detect_project_root` antes que nada.
  - Localiza `commands/<cmd>.md`, lo concatena con system prompt base (incluyendo restricciones de sección 2 y `$PROJECT_ROOT`/`$PROJECT_TYPE`), invoca `claude`.
  - Salida con código de retorno de `claude`.
  - Comandos que NO requieren proyecto (`config`, `help`): saltarse detección.
- [ ] **F2.3** `setup.sh`:
  1. Detecta `RUBBER_DUCK_HOME = $(pwd)`, lo exporta al rcfile en bloque delimitado `# >>> rubber-duck >>>` / `# <<< rubber-duck <<<` (idempotente vía `sed`).
  2. Crea wrappers `duck-<cmd>` en `~/.local/bin/`.
  3. **Prune de wrappers huérfanos:** elimina `duck-*` en `~/.local/bin/` que ya no estén en `COMMANDS=()` y cuya cabecera contenga el sello "Generado por rubber-duck/setup.sh" (preserva archivos `duck-*` creados por el usuario).
  4. Añade `~/.local/bin` al `$PATH` en el mismo bloque.
  5. Pregunta opcional: instalar git hooks → llama `hooks/install-hooks.sh`.
  6. Si no existe `~/.rubber-duck/config.json` → marca primer arranque (wizard se lanza con el primer `duck-*`).
- [ ] **F2.4** `uninstall.sh`: elimina wrappers, borra bloque del rcfile. No toca `~/.rubber-duck/` salvo confirmación.
- [ ] **F2.5** Smoke test: ejecutar `duck-help` desde `~/`, desde dentro de `tilt/tilts/new-admin`, y desde dentro de `tilt/tilts/civitatis/application/admin`. Cada uno debe imprimir info de `$PROJECT_ROOT` y `$PROJECT_TYPE` correctamente (o "fuera de proyecto" desde `~/`).
- [ ] **COMMIT F2:** `feat(rubber-duck): setup, uninstall, dispatcher, dynamic project detection`

### ⏳ FASE 3 — Configuración personal (`duck-config`)

- [ ] **F3.1** `commands/config.md` — subcomandos `list|get|set|reset|setup`.
- [ ] **F3.2** `skills/config/SKILL.md` — wizard interactivo. **Pregunta los paths de new-admin y old-admin** durante el setup para facilitar la localización posterior. Flujo por proyecto:
  1. Auto-detecta en spots derivados del directorio raíz del usuario (variantes ES/EN, sing/plur): `$HOME`, `$HOME/proyectos`, `$HOME/proyecto`, `$HOME/projects`, `$HOME/project`, `$HOME/dev`. Para cada uno, también su subdir `tilt/tilts/` si existe. Profundidad ≤ 4. Filtra spots inexistentes antes de invocar `find`.
  2. Si encuentra al menos una candidata, la propone como default. Los ejemplos mostrados al usuario usan `<usuario>` (sustituido por `$USER` al renderizar), nunca un username concreto.
  3. Pide al usuario: aceptar la sugerencia, escribir una ruta distinta, o dejar en blanco (auto-detección desde CWD será suficiente).
  4. Si la ruta no está vacía, valida que existe y contiene los marcadores; advierte si no, pero acepta. Las paths siguen siendo fallback de la detección por CWD, no fuente primaria.
  5. **Para old-admin, el path almacenado es la raíz de civitatis** (ejemplo: `/home/<usuario>/proyectos/tilt/tilts/civitatis`), no `application/admin`. Si el usuario teclea por error `…/application/admin`, normaliza con `sed 's|/application/admin/*$||'` y avísale. Los skills componen subrutas desde la raíz cuando lo necesiten.
- [ ] **F3.3** Validación de claves cerrada según README §"Opciones disponibles".
- [ ] **F3.4** Defaults conformes al README (sin cambios de default por restricciones): `review.update_jira = true` (con confirmación explícita en cada uso). El wizard explica que el `true` significa "ofrecer actualizar tras confirmación", no "actualizar silenciosamente".
- [ ] **F3.5** Tolerancia a Ctrl+C: guarda JSON parcial con defaults para el resto.
- [ ] **F3.6** Versionado del schema: el JSON incluye `"_version": <int>`. El wizard lee `~/.rubber-duck/.config-version` (o el campo `_version` del JSON) y aplica migraciones idempotentes cuando rubber-duck actualice claves en el futuro. Se documenta la versión actual aquí: **v1**.
- [ ] **COMMIT F3:** `feat(rubber-duck): personal config and setup wizard`

### ⏳ FASE 4 — `duck-help`

- [ ] **F4.1** `commands/help.md` con los tres modos del README (general / por comando / por clave).
- [ ] **F4.2** Tabla interna de mapeo comando→descripción y clave→descripción larga + default + valores.
- [ ] **COMMIT F4:** `feat(rubber-duck): duck-help contextual help`

### ⏳ FASE 5 — Skills de contexto de proyecto

- [ ] **F5.1** `skills/project-context/new_admin.md`:
  - Descripción del stack real (sección 1).
  - **Carga delegada:** primero leer `$PROJECT_ROOT/.claude/project-context.md`, `$PROJECT_ROOT/.claude/domain-index.md`, `$PROJECT_ROOT/.claude/refactoring-state.md` si existen. Esos archivos son la fuente de verdad.
  - Resumen de restricciones operacionales (sección 2: Jira RO, DB RO, hexagonal, etc.).
  - Convenciones HTTP, Vue Options API, módulos.
- [ ] **F5.2** `skills/project-context/old_admin.md`:
  - Path raíz dinámico (`$PROJECT_ROOT`).
  - **Whitelist exhaustiva del scope `/admin`** (sección 1) — el implementer y reviewer la usan para rechazar cambios fuera.
  - Limitaciones PHP 5.6: short tags, sin typed properties, sin spread, sin `??`, sin return types nullable, etc.
  - Patrones legacy: PDO directo, includes manuales, jQuery.
  - **Política de mantenimiento (CRÍTICA, repetida aquí para que cualquier agente que cargue este skill la vea):**
    - Solo bug fixes y mantenimiento. Si el plan describe funcionalidad nueva → advertir y proponer hacerlo en new-admin.
    - No hay Confluence ni estándares formales. La calidad se evalúa con "sentido común" (seguridad básica + consistencia con el archivo editado).
    - Cambios nuevos imitan el estilo del archivo editado, no introducen modernizaciones aisladas (no namespaces nuevos, no PHP 7+ syntax, no Composer autoload si el archivo no lo usa).
    - Long-term: migración completa a new-admin → `migration-agent` es la dirección estratégica.
- [ ] **COMMIT F5:** `feat(rubber-duck): project-context skills for new-admin and old-admin`

### ⏳ FASE 6 — Flujo core: analyze → plan → implement → review

- [ ] **F6.1** `skills/jira-analyzer/SKILL.md` + `prompts/generate_story.md`:
  - Lee el ticket de Jira vía MCP (incluyendo la descripción actual).
  - Genera **User Story + Criterios de Aceptación + Consideraciones Técnicas**.
  - Muestra el resultado al usuario y pregunta confirmación expresa (`¿Confirmas? [s/N]`).
  - **Si confirma → escritura idempotente en la descripción del ticket:**
    - Detecta en la descripción actual la presencia de un bloque previo delimitado por marcadores:
      - inicio: `<!-- rubber-duck:start -->`
      - fin: `<!-- rubber-duck:end -->`
    - Si los marcadores existen → **reemplaza solo el contenido entre ellos** con el nuevo bloque generado. Preserva todo el texto fuera de los marcadores intacto.
    - Si no existen → **añade al final** de la descripción el bloque nuevo entre marcadores. Precedido de separador `---`.
    - Nunca reemplaza la descripción entera; nunca duplica el bloque (si por error hay dos pares de marcadores, normaliza a uno solo manteniendo el primero).
  - Formato del bloque (entre marcadores): título `## Generado por rubber-duck (YYYY-MM-DD HH:MM)` + tres secciones (User Story, AC, Consideraciones Técnicas).
  - Si el usuario rechaza → no toca Jira; mantiene el texto generado en pantalla para copia manual.
  - El skill documenta explícitamente que **anula** la regla "NEVER write Jira" del `CLAUDE.md` de new-admin para este flujo confirmado.
- [ ] **F6.2** `commands/analyze.md`.
- [ ] **F6.3** `skills/task-planner/SKILL.md` + `prompts/build_plan.md`:
  - **Prerequisito F6.3.a:** crear `templates/` (no se creó en F1 porque la regla de §2.bis se añadió después). `mkdir -p templates/`.
  - **Prerequisito F6.3.b:** copiar `planning-template.md` desde su origen externo (`/home/yaowu/proyectos/ai-development-rules/rules/templates/planning-template.md`) a `templates/planning-template.md`. A partir de ese momento, esa copia local es la fuente de verdad.
  - **Prerequisito F6.3.c:** copiar `agents-exceptions-template.md` (mismo origen) a `templates/agents-exceptions-template.md`.
  - **Prerequisito F6.3.d:** crear `templates/README.md` documentando el origen y el commit/fecha de cada copia (regla self-contained §2.bis).
  - Detecta `$PROJECT_TYPE` (ya inyectado por el dispatcher).
  - Formato del plan: lee `$RUBBER_DUCK_HOME/templates/planning-template.md` y lo adapta. **Nunca** referencia paths externos.
  - Detecta dominio consultando `$PROJECT_ROOT/.claude/domain-index.md` (new-admin).
- [ ] **F6.4** `commands/plan.md`.
- [ ] **F6.5** `skills/task-implementer/SKILL.md` + `prompts/new_admin.md` + `prompts/old_admin.md`:
  - Lee plan `.md` (arg obligatorio).
  - Carga `project-context` correcto según `$PROJECT_TYPE`.
  - Para new-admin: aplica R3–R6.
  - Para old-admin:
    - Valida que cada path tocado esté en la whitelist del scope `/admin`. Aborta si no.
    - **Clasifica el cambio** (bug fix / mantenimiento / funcionalidad nueva). Si es "funcionalidad nueva" → muestra warning explícito y propone hacerlo en new-admin; pide confirmación expresa antes de continuar.
    - **Estilo:** imita el estilo del archivo editado (short tags, sintaxis PHP 5.6, sin modernizaciones puntuales).
    - **No invoca `php-cs-fixer`** (no existe toolchain). `implement.auto_format` se ignora silenciosamente para old-admin con un log informativo.
  - Si `implement.auto_format = true` y `$PROJECT_TYPE = new-admin`: invoca `$PROJECT_ROOT/bin/pre-commit php-cs-fixer` (no `php-cs-fixer` directo en host).
- [ ] **F6.6** `commands/implement.md`.
- [ ] **F6.7** `skills/task-reviewer/SKILL.md` + `prompts/review.md`:
  - Lee Jira (descripción + AC del flujo de `duck-analyze` previo si existe).
  - Compara con el código implementado.
  - Genera informe estructurado (qué cumple, qué falta, qué corregir).
  - Muestra el informe al usuario.
  - Si `review.update_jira = true` (default según README): pide confirmación expresa (`¿Postear informe como comentario en el ticket? [s/N]`) → si confirma, postea como comentario vía MCP. Si rechaza → no toca Jira.
  - Si `review.export = true`: guarda también el informe a archivo (independiente de la actualización de Jira).
- [ ] **F6.8** `commands/review.md`.
- [ ] **F6.9** `agents/{analyzer,planner,implementer,reviewer}-agent.md`:
  - System prompts persistentes.
  - Para new-admin: si existen `$PROJECT_ROOT/.claude/agents/{architect,backend-engineer,frontend-engineer,qa-engineer}.md`, los referencia/incluye (no duplica).
- [ ] **COMMIT F6:** `feat(rubber-duck): core workflow analyze plan implement review`

### ⏳ FASE 7 — `duck-sync-docs`

- [ ] **F7.1** `skills/docs-sync/SKILL.md` (dos modos: Confluence + análisis código).
- [ ] **F7.2** `prompts/sync-confluence.md`:
  - Usa `cloud_id` y `space_key` de `mcp/atlassian/config.json`.
  - Lee page IDs de `mcp/atlassian/page-ids.json`.
  - Para new-admin: IDs ya conocidos (`2389508098`, `2449342481`).
  - **Para old-admin: skip total.** No hay Confluence ni estándares. `duck-sync-docs old-admin` solo ejecuta el análisis de código; no genera `backend-standards.md` ni `frontend-standards.md` artificiales.
- [ ] **F7.3** `prompts/analyze-project.md`:
  - Lee `composer.json`, `dev/package.json` (new-admin) / `package.json` (donde corresponda).
  - Para old-admin: análisis restringido a los paths del scope `/admin`. El `project-snapshot.md` resultante destaca la política de mantenimiento al inicio del archivo.
  - Para new-admin: lee también `.claude/project-context.md` y lo cita.
- [ ] **F7.4** `prompts/diff-report.md` (actualiza `docs/last-sync.json`).
- [ ] **F7.5** `commands/sync-docs.md`.
- [ ] **F7.6** Primera ejecución manual:
  - `duck-sync-docs new-admin` desde dentro de `tilt/tilts/new-admin`
  - `duck-sync-docs old-admin` desde dentro de `tilt/tilts/civitatis`
- [ ] **COMMIT F7:** `feat(rubber-duck): docs-sync skill and command`

### ⏳ FASE 8 — `duck-audit`

- [ ] **F8.1** `skills/code-audit/SKILL.md` con los tres modos (archivo / `all` / `--branch`).
- [ ] **F8.2** **Delegación al toolchain del proyecto:**
  - Para new-admin: `code-audit` invoca `$PROJECT_ROOT/bin/pre-commit <herramienta> <archivos>` para cada herramienta (`php-cs-fixer`, `phparkitect`, `phpstan`). Captura stdout/stderr.
  - `--branch`: calcula archivos modificados con `git diff --name-only $(git merge-base HEAD main)...HEAD` y los pasa al pre-commit.
  - `all`: invoca `bin/pre-commit` sin args (ejecuta todo el suite).
- [ ] **F8.3** Prompts de interpretación: `prompts/{phpstan,cs-fixer,arkitect}.md` (formato homogéneo de informe).
- [ ] **F8.4** Capa semántica: `prompts/standards.md` cruza el código auditado con `docs/<proyecto>/{backend,frontend}-standards.md`.
- [ ] **F8.5** old-admin (PHP 5.6) — **modo "sentido común" por diseño**, no degradación:
  - **No ejecuta phpstan, phparkitect ni php-cs-fixer.** No están configurados y no se van a configurar.
  - Auditoría puramente semántica vía Claude: revisa el diff/archivo buscando:
    - SQL injection (concatenación sin parámetros prepared)
    - XSS (output sin escape en templates)
    - Variables no inicializadas o con tipos inconsistentes
    - Lógica obviamente rota (condicionales invertidos, return missing, etc.)
    - Inconsistencia grosera con el estilo del archivo
  - **NO reporta** problemas de estilo legacy (short tags, falta de typed properties, indentación irregular, etc.) — eso es el estado normal del código.
  - Genera informe en el mismo formato que new-admin pero con sección clara "modo sentido común, sin herramientas estáticas".
- [ ] **F8.6** Informe unificado por severidad. Respeta `audit.fail_on`, `audit.export`, etc. **Aplica las reglas universales:**
  - `rules/export-paths.md` → si se infiere JIRA-KEY desde el nombre de rama → `<audit.export_dir>/<JIRA-KEY>/<JIRA-KEY>_audit.<ext>`. Si no hay key (caso `duck-audit <file>` aislado o `duck-audit all` fuera de rama feature) → `<audit.export_dir>/audit/<slug>_audit.<ext>` donde `<slug>` es `branch`, `all`, o el nombre del archivo target.
  - `rules/output-language.md` → informe redactado en `output.language`; literales y rutas se preservan.
- [ ] **F8.7** `commands/audit.md`.
- [ ] **F8.8** `agents/auditor-agent.md`.
- [ ] **COMMIT F8:** `feat(rubber-duck): code-audit delegating to project toolchain`

### ⏳ FASE 9 — Git hooks

**Habilitación opt-in.** Todos los hooks están **desactivados por defecto**. El usuario los activa explícitamente con `duck-config set git.hooks.<hook>_enabled true`. Razón: los hooks pueden ralentizar workflows (especialmente `pre-commit` que invoca el toolchain del proyecto), así que el default conservador no toca nada hasta que el usuario lo pida.

Nuevas claves de config (añadir en `bin/lib/config.sh`):

| Clave | Default | Efecto |
|---|---|---|
| `git.hooks.pre_commit_enabled` | `false` | Si `true`, el hook ejecuta el audit antes del commit. Si `false`, el hook script existe pero hace `exit 0` inmediatamente. |
| `git.hooks.pre_push_enabled` | `false` | Si `true`, el hook ejecuta el review antes del push. |
| `git.hooks.post_merge_enabled` | `false` | Si `true`, el hook ejecuta `duck-sync-docs all` tras pull/merge. |

Cada hook script lee `~/.rubber-duck/config.json` al ejecutarse y respeta el flag en runtime (no a la hora de instalar). Así:
- Activar/desactivar es instantáneo: `duck-config set git.hooks.pre_commit_enabled true` y al siguiente commit ya se aplica.
- No hay que reinstalar hooks ni regenerar nada.
- El script siempre está presente; solo cambia su comportamiento según config.

- [ ] **F9.0** Añadir las 3 claves a `bin/lib/config.sh` con allowed=`true|false`, default=`false`, descripción clara. Documentar en `skills/config/SKILL.md` schema table y en el wizard como **Paso opcional**.

- [ ] **F9.1** `hooks/git/pre-commit`:
  - Primera línea de lógica: leer `git.hooks.pre_commit_enabled` desde config. Si `false` → `exit 0` inmediatamente.
  - Si `true`:
    - **No reimplementa** el pre-commit de new-admin. Detecta `$PROJECT_TYPE` con `detect-project.sh`.
    - Si new-admin → invoca `$PROJECT_ROOT/bin/pre-commit` con los archivos staged.
    - Si old-admin → invoca `duck-audit` en modo "sentido común" (F8.5) sobre los archivos staged dentro del scope `/admin`. Solo bloquea si detecta problemas reales de seguridad/lógica, no por estilo legacy.
    - Bloquea commit si falla. Skippable con `--no-verify`.

- [ ] **F9.2** `hooks/git/pre-push`:
  - Lee `git.hooks.pre_push_enabled`. Si `false` → `exit 0`.
  - Si `true`: extrae Jira key (`[A-Z]+-[0-9]+` del nombre de rama) → `duck-review <KEY>` (read-only). Sale silencioso si no hay key.

- [ ] **F9.3** `hooks/git/post-merge`:
  - Lee `git.hooks.post_merge_enabled`. Si `false` → `exit 0`.
  - Si `true`: `duck-sync-docs all` (modo usuario, escribe en `~/.rubber-duck/docs/`).

- [ ] **F9.4** `hooks/install-hooks.sh <ruta>`:
  - Copia los tres scripts a `<ruta>/.git/hooks/` con `chmod +x`. Sin arg → directorio actual.
  - Idempotente con backup `.bak` si ya existe un hook con el mismo nombre.
  - Imprime un recordatorio al final:
    ```
    ✓ Hooks instalados (DESACTIVADOS por defecto).
      Para activar uno o todos:
        duck-config set git.hooks.pre_commit_enabled true
        duck-config set git.hooks.pre_push_enabled true
        duck-config set git.hooks.post_merge_enabled true
    ```

- [ ] **F9.5** `duck-help` actualizado para mencionar las 3 claves nuevas en `duck-help config` y `duck-help config.git.hooks.<x>_enabled`. Ya se genera dinámicamente desde el schema; no se requiere editar `help.sh`.

- [ ] **COMMIT F9:** `feat(rubber-duck): opt-in git hooks (default disabled)`

### ⏳ FASE 10 — Agentes auxiliares

- [ ] **F10.1** `onboarding-agent` + `commands/onboarding.md` — sesión interactiva. Para new-admin, carga `$PROJECT_ROOT/.claude/USAGE.md` y `project-context.md` si existen.
- [ ] **F10.2** `debug-agent` + `commands/debug.md` — acepta error string o Jira key. Para new-admin, usa `.claude/agents/incident-analyst.md` como base.
- [ ] **F10.3** `migration-agent` + `commands/migrate.md` — old-admin → new-admin. **Prioridad estratégica del equipo** (objetivo: eliminar old-admin a largo plazo). Carga ambos `project-context/`. Restricciones: respeta scope `/admin` en origen y arquitectura hexagonal en destino. Cuando otro flujo (p.ej. `task-implementer` sobre old-admin) detecte cambios no triviales, sugiere invocar este agente para migrar la pieza entera en vez de parchear.
- [ ] **F10.4** `db-agent` + `commands/db.md` — MCP database + schema-context. **Modo read-only obligatorio (R2):** rechaza `INSERT`/`UPDATE`/`DELETE`/`ALTER`/`DROP`/`TRUNCATE`. Advierte siempre que la BBDD es compartida entre new-admin y old-admin.
- [ ] **F10.5** `standup-agent` + `commands/standup.md` — read-only Jira: filtra por `customfield_11001 = "Civitatis Admin"` y actividad reciente del usuario actual.
- [ ] **COMMIT F10:** `feat(rubber-duck): auxiliary agents (onboarding/debug/migrate/db/standup)`

### ⏳ FASE 11 — `duck-upgrade`

- [ ] **F11.1** `agents/upgrade-agent.md` con modos `plan`, `migrate`, `status`, `check`, `--next`.
- [ ] **F11.2** `docs/new-admin/upgrade-targets.md` — placeholder con estructura. Targets conocidos: PHP 7.4→8.2, Slim 3→Laravel 11 (parcialmente migrado ya, ver `.claude/refactoring-state.md`), Vue 2.6+Webpack 4→Vue 3+Vite.
- [ ] **F11.3** Estado en `~/.rubber-duck/upgrade-status.json`.
- [ ] **F11.4** `commands/upgrade.md`.
- [ ] **COMMIT F11:** `feat(rubber-duck): upgrade-agent for PHP/Laravel/Vue3 migration`

### ⏳ FASE 12 — Auto-commit y formato custom

- [ ] **F12.1** Auto-commit en `bin/duck.sh` (o `bin/lib/git.sh`): tras `git.auto_commit_after`, si `git.auto_commit = true` → commit dentro de `$PROJECT_ROOT` (no en rubber-duck).
- [ ] **F12.2** `commit_message_format = custom` leyendo `~/.rubber-duck/commit-template.txt`.
- [ ] **F12.3** `git.auto_push` → push tras commit si activo.
- [ ] **COMMIT F12:** `feat(rubber-duck): auto-commit and auto-push integration`

### ⏳ FASE 13 — Verificación end-to-end

- [ ] **F13.1** Verificar entorno Tilt arriba con skill `tilt-inspector`.
- [ ] **F13.2** Verificar detección de proyecto desde tres CWDs distintos (raíz new-admin, subdir de new-admin, `application/admin/` de civitatis). Cada uno debe resolver `$PROJECT_ROOT` y `$PROJECT_TYPE` correctos.
- [ ] **F13.3** Flujo completo contra ticket real de PANA sobre new-admin (desde dentro del repo): `analyze → plan → implement → audit --branch → review`. Verificar:
  - `duck-analyze` (primera ejecución sobre el ticket): pregunta confirmación; si confirma → la descripción queda **extendida** con el bloque entre marcadores `<!-- rubber-duck:start -->` / `<!-- rubber-duck:end -->`. Si rechaza → Jira no cambia.
  - `duck-analyze` (segunda ejecución sobre el mismo ticket): el bloque existente se **reemplaza in-place**, el resto de la descripción intacto, **sin duplicar** el bloque.
  - `duck-analyze` sobre ticket con dos bloques (forzado manualmente para test): el skill normaliza a uno solo manteniendo el primero.
  - `duck-review` pregunta confirmación antes de postear comentario; verifica ambos caminos (confirmar y rechazar).
  - `duck-audit` invoca `bin/pre-commit` correctamente.
  - Código generado respeta hexagonal (R3–R6).
- [ ] **F13.4** Flujo equivalente sobre old-admin (PANA/TAPEO ticket de **bug fix o mantenimiento** que toque `/admin`). Verificar:
  - Implementer rechaza paths fuera del scope `/admin`
  - Implementer detecta intento de "nueva funcionalidad" y advierte proponiendo new-admin
  - Audit ejecuta modo "sentido común" (sin phpstan/phparkitect/php-cs-fixer), reporta solo seguridad/lógica
  - Audit NO marca como problema el estilo legacy (short tags, indentación, etc.)
- [ ] **F13.5** `duck-sync-docs all`:
  - new-admin: Confluence (2 IDs reales) + análisis código → `docs/new-admin/*.md` poblados
  - old-admin: **solo `project-snapshot.md`** (sin Confluence, sin standards artificiales). Snapshot incluye banner "modo mantenimiento" al inicio
- [ ] **F13.6** `duck-db "SELECT count(*) from users"` → ejecuta. `duck-db "UPDATE users SET ..."` → rechaza con mensaje claro.
- [ ] **F13.7** Hooks instalados en repo de prueba; pre-commit / pre-push / post-merge funcionan.
- [ ] **F13.8** `duck-config` en sus 5 subcomandos.
- [ ] **F13.9** `uninstall.sh` + reinstalar → sin residuos.
- [ ] **F13.10** Fitness check self-contained (§2.bis): `grep -rE "/home/[^/]+/proyectos/(ai-development-rules|tilt)" skills/ agents/ commands/ templates/ bin/lib/` debe devolver 0 matches. Cualquier match indica dependencia externa indebida.
- [ ] **COMMIT F13:** `test(rubber-duck): end-to-end verification of full workflow`

### ⏳ FASE 14 — Cierre

- [ ] **F14.1** Actualizar `README.md` si hubo desviaciones:
  - Sección "Detección dinámica de proyecto" añadida (no estaba en README original)
  - Aclarar el comportamiento idempotente de `duck-analyze`: marcadores `<!-- rubber-duck:start -->` / `<!-- rubber-duck:end -->`; reemplazo in-place si existen, append si no
  - Cualquier otra divergencia
- [ ] **F14.2** **Revisión final del plan (NO añadir implementación nueva).** Recorrer este `PLAN_IMPLEMENTATION.md` de arriba a abajo y:
  - Comprobar que cada fase F1-F13 refleja lo realmente implementado en código.
  - Corregir descripciones desactualizadas (cambios pequeños hechos durante el camino que no se reflejaron en el plan).
  - Anotar cualquier paso que se completó "fuera de plan" (commits sueltos no listados, parches menores).
  - **No** introducir tareas pendientes ni alcance nuevo: esto es solo congelar el plan como **archivo definitivo** de lo que se hizo.
  - **No** cambiar las secciones §0-§5 (resumen, trazabilidad, restricciones, datos confirmados) salvo errata.
- [ ] **F14.3** Crear directorio `dev-history/` en la raíz del repo si no existe. Esta carpeta guarda artefactos del **desarrollo de la propia herramienta** y nunca es consumida por skills/agents/commands en runtime.
- [ ] **F14.4** Copiar el `PLAN_IMPLEMENTATION.md` congelado a `dev-history/<YYYY-MM-DD>_plan_implementation_v<N>.md`:
  - `<YYYY-MM-DD>` = fecha del cierre (no la fecha de inicio).
  - `<N>` = número de iteración. Empieza en `v1` para la primera implementación. Incrementa solo si en el futuro se rehace el proyecto con un plan nuevo (no se sobrescribe el histórico).
- [ ] **F14.5** Añadir `dev-history/README.md` (solo la primera vez) explicando:
  - Qué es esta carpeta: histórico de planes de implementación de rubber-duck.
  - **No** consumida por el runtime de la herramienta.
  - Convención de naming.
- [ ] **F14.6** Verificar la copia: `diff PLAN_IMPLEMENTATION.md dev-history/<archivo>` debe devolver 0.
- [ ] **F14.7** Pull request a `main` con todos los cambios hasta aquí (revisión + copia histórica).
- [ ] **F14.8** **Borrar `PLAN_IMPLEMENTATION.md`** del repo (queda solo el histórico en `dev-history/`).
- [ ] **F14.9** Borrar la entrada `PLAN_IMPLEMENTATION.md` del `.gitignore`.
- [ ] **COMMIT F14a:** `docs(rubber-duck): final review and freeze of PLAN_IMPLEMENTATION.md`
- [ ] **COMMIT F14b:** `chore(rubber-duck): archive plan to dev-history and remove working file`

---

## 7. Riesgos y mitigaciones

| Riesgo | Mitigación |
|---|---|
| Detección de proyecto falla en repos con symlinks o submodules | `detect-project.sh` usa `cd -P` para resolver symlinks; pruebas en F2.5 cubren CWD desde subdirs profundos |
| Toolchain de new-admin requiere Docker arriba para `bin/pre-commit` | F13.1 verifica Tilt arriba antes; documentar en mensaje de error de `duck-audit` |
| Usuario rechaza la confirmación de `duck-analyze` / `duck-review` | Skill mantiene el texto generado en pantalla para copia manual; no toca Jira. F13.3 prueba ambos caminos (confirmar y rechazar). |
| old-admin sin toolchain (intencional) | F8.5: modo "sentido común" por diseño. No es degradación, es la política. |
| Usuario pide nueva funcionalidad sobre old-admin | F6.5: implementer detecta y propone migrar a new-admin con `migration-agent`. No bloquea, pero registra la decisión. |
| Conflictos en `.bashrc`/`.zshrc` por re-runs | Bloque delimitado idempotente con `sed` |
| Implementer toca rutas fuera de `/admin` en civitatis | Whitelist en `project-context/old_admin.md`; validación en `task-implementer/SKILL.md`; reviewer chequea |
| MCP de base de datos sin guardia de write | F10.4 implementa el rechazo en el propio skill; doble defensa en el prompt + en la config del MCP si lo permite |
| Plantillas externas evolucionan en su repo origen y rubber-duck se queda obsoleto | F6.3.d: `templates/README.md` registra commit/fecha de origen. Cuando el equipo detecta drift, re-copia y commit. No hay sync automático: simplicidad sobre frescura. |

## 8. Actualizaciones futuras (post-MVP)

Estrategia para que `rubber-duck` soporte actualizaciones limpias:

| Necesidad | Estado actual | Solución prevista |
|---|---|---|
| Re-ejecutar `setup.sh` sin duplicar entradas | ✅ Bloque rcfile idempotente vía `sed` | — |
| Comandos nuevos al re-instalar | ✅ Wrappers sobrescritos por `setup.sh` | — |
| Wrappers huérfanos al renombrar/eliminar comandos | ✅ Prune con sello en F2.3.3 | — |
| Migración de schema de `config.json` cuando se añadan claves | ❌ Pendiente | F3.6: el wizard detecta versión guardada en `~/.rubber-duck/.config-version`, aplica migraciones idempotentes. |
| Detectar versión del repo vs versión instalada | ❌ Pendiente | Archivo `VERSION` en raíz del repo + `~/.rubber-duck/.installed-version`. `setup.sh` compara y avisa si hay cambios. |
| Auto-actualizar el repo desde git | ❌ Pendiente | Comando `duck-update` (futuro, fuera del scope MVP): `git -C "$RUBBER_DUCK_HOME" pull && "$RUBBER_DUCK_HOME"/setup.sh`. |
| Comunicar breaking changes entre versiones | ❌ Pendiente | `CHANGELOG.md` en raíz del repo; `setup.sh` muestra entradas nuevas desde la última versión instalada. |

Estas mejoras se añadirán **después** de cerrar el MVP (Fase 14). No bloquean el flujo principal.

---

## 9. Definition of Done

- Todos los binarios `duck-*` del README §"Comandos que instala" instalados y funcionales.
- `$PROJECT_ROOT`/`$PROJECT_TYPE` detectados correctamente desde cualquier CWD dentro del proyecto, sin ningún path hardcoded en el código.
- Flujo `analyze → plan → implement → audit → review` ejecutable contra un ticket real de **cada** proyecto.
- `duck-sync-docs all` produce `docs/new-admin/*.md` y `docs/old-admin/*.md` con datos reales.
- `duck-audit` delega correctamente en `$PROJECT_ROOT/bin/pre-commit` para new-admin.
- Restricciones operacionales (R1–R7) verificadas en F13.
- Hooks instalados y funcionales.
- `setup.sh` + `uninstall.sh` idempotentes.
- README actualizado con cambios de defaults y sección de detección dinámica.
- Este archivo `PLAN_IMPLEMENTATION.md` borrado.
