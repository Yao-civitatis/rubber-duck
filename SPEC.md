# 🦆 rubber-duck

> Herramienta de skills y agentes para Claude orientada al desarrollo del proyecto **New Admin**.
> Lee tickets de Jira, genera user stories, planifica, implementa, revisa y audita código — todo desde el terminal.

---

## ¿Qué es rubber-duck?

rubber-duck es un repositorio de **skills, agentes y comandos para Claude** que automatiza el flujo completo de desarrollo de una tarea, desde que llega el ticket de Jira hasta que el código está revisado y auditado.

No es una aplicación independiente. Es una colección de instrucciones y configuraciones que Claude lee para saber exactamente cómo comportarse en cada fase del trabajo.

El proyecto sobre el que opera tiene dos partes:

| Nombre | Stack | Descripción |
|---|---|---|
| **new-admin** | PHP 7.4 + Slim 3 + illuminate/database 8 + Twig 3 + Vue 2 (Webpack 4) | Parte moderna del proyecto |
| **old-admin** | PHP 5.6 + Apache + HTML/jQuery (módulo `{URL_DOMAIN}/admin` de `civitatis`) | Parte legacy del proyecto |

---

## Flujo de trabajo

```
1. duck-analyze PROJ-123     →  lee el ticket, genera user story + AC + consideraciones técnicas
                                 muestra el resultado y pide confirmación con 3 opciones:
                                    [s] actualizar Jira (append idempotente entre marcadores
                                        <!-- rubber-duck:start --> ... <!-- rubber-duck:end -->,
                                        replace in-place si ya existían)
                                    [n] dejar solo en pantalla
                                    [e] exportar a archivo, luego re-preguntar por Jira

2. duck-plan PROJ-123        →  genera un plan de implementación adaptando
                                 templates/planning-template.md
                                 guarda como <plan.output_dir>/PROJ-123/PROJ-123_plan.md
                                 (path relativo a $PROJECT_ROOT salvo absoluto)

3. duck-implement PROJ-123_plan.md
                             →  lee el plan .md indicado y escribe el código
                                 respetando el stack: new-admin (PHP 7.4 + Slim 3 +
                                 illuminate 8 + Vue 2.6 Options API, arquitectura
                                 hexagonal R3-R6) u old-admin (PHP 5.6 + Apache +
                                 HTML/jQuery, scope estricto /admin, mantenimiento)

4. duck-review PROJ-123      →  revisa el código implementado vs AC del ticket
                                 veredicto 🟢/🟡/🔴 → exit 0/0/1
                                 si review.update_jira=true y confirmas → comentario
                                 nuevo en Jira (nunca edita comentarios previos)

5. duck-audit <ruta|all|--branch>
                             →  detecta proyecto automáticamente y audita:
                                 - new-admin: delega en $PROJECT_ROOT/bin/pre-commit
                                   (phpstan + php-cs-fixer + phparkitect) + capa
                                   semántica contra ~/.rubber-duck/docs/
                                 - old-admin: modo "sentido común" sin herramientas
                                   estáticas (política mantenimiento)

6. duck-sync-docs [new-admin|old-admin|all]
                             →  Confluence (solo new-admin) + análisis código real
                                 escribe en ~/.rubber-duck/docs/<proyecto>/
                                 --bundle para refrescar el bundle del repo (maintainer)
                                 --schema [new-admin|old-admin|all] extrae db-schema.md
                                   (tablas usadas + columnas/índices/DDL via DB read-only)
```

---

## Estructura de carpetas

```
rubber-duck/
├── bin/
│   ├── duck.sh                 # dispatcher central (parsea --env= para duck-db)
│   └── lib/
│       ├── detect-project.sh   # detección dinámica $PROJECT_ROOT / $PROJECT_TYPE
│       ├── config.sh           # CRUD sobre ~/.rubber-duck/config.json (sin Claude)
│       ├── help.sh             # render de duck-help (sin Claude)
│       ├── git.sh              # helper auto-commit/auto-push para skills
│       ├── db-env.sh           # loader schema v2 + gates (a)..(e) read-only por env
│       └── db-env.test.sh      # tests bash con stubs MYSQL_CMD_STUB / DUCK_DB_CONFIRM_STUB
├── hooks/
│   ├── git/
│   │   ├── pre-commit          # opt-in: ver git.hooks.pre_commit_enabled
│   │   ├── pre-push            # opt-in: ver git.hooks.pre_push_enabled
│   │   └── post-merge          # opt-in: ver git.hooks.post_merge_enabled
│   └── install-hooks.sh        # instalador en .git/hooks/ del repo destino
├── mcp/
│   ├── atlassian/
│   │   ├── config.example.json
│   │   ├── page-ids.json       # IDs reales de Confluence (solo new-admin)
│   │   └── (config.json)       # .gitignore — credenciales locales
│   ├── database/
│   │   ├── config.example.json # schema v2 multi-entorno (dev/qa/slave/prod)
│   │   └── (config.json)       # .gitignore — credenciales reales por env
│   ├── claude_desktop_config.example.json
│   └── README.md
├── docs/                       # bundle versionado (capa 1 del modelo docs)
│   ├── new-admin/
│   │   ├── backend-standards.md     # snapshot Confluence (id 2389508098)
│   │   ├── frontend-standards.md    # snapshot Confluence (id 2449342481)
│   │   ├── upgrade-targets.md       # stack destino — manual (placeholder)
│   │   ├── project-snapshot.md      # snapshot código real
│   │   └── db-schema.md             # schema DB auto-extraído (duck-sync-docs --schema)
│   ├── old-admin/
│   │   ├── project-snapshot.md      # solo snapshot; sin Confluence (política mantenimiento)
│   │   └── db-schema.md             # schema DB auto-extraído (scope /admin)
│   └── last-sync.json
├── rules/                      # reglas transversales (citadas por skills/agents/commands)
│   ├── README.md
│   ├── export-paths.md
│   ├── output-language.md
│   ├── project-detection.md
│   ├── self-contained.md
│   └── operational-restrictions.md  # R1-R7 + R2.1 (gates DB por env) + política old-admin
├── templates/                  # plantillas locales (regla self-contained)
│   ├── README.md
│   ├── planning-template.md
│   ├── agents-exceptions-template.md
│   └── commit-template.example.txt
├── dev-history/                # histórico de implementaciones (no consumido en runtime)
│   ├── README.md
│   └── <fecha>_plan_implementation_v<N>.md
├── skills/
│   ├── project-context/
│   │   ├── new_admin.md
│   │   └── old_admin.md
│   ├── jira-analyzer/
│   │   ├── SKILL.md
│   │   └── prompts/generate_story.md
│   ├── task-planner/
│   │   ├── SKILL.md
│   │   └── prompts/build_plan.md
│   ├── task-implementer/
│   │   ├── SKILL.md
│   │   └── prompts/{new_admin,old_admin}.md
│   ├── task-reviewer/
│   │   ├── SKILL.md
│   │   └── prompts/review.md
│   ├── docs-sync/
│   │   ├── SKILL.md
│   │   └── prompts/{sync-confluence,analyze-project,diff-report,extract-db-schema}.md
│   ├── code-audit/
│   │   ├── SKILL.md
│   │   └── prompts/{phpstan,cs-fixer,arkitect,standards}.md
│   └── config/
│       └── SKILL.md            # wizard interactivo (duck-config setup)
├── agents/
│   ├── analyzer-agent.md
│   ├── planner-agent.md
│   ├── implementer-agent.md
│   ├── reviewer-agent.md
│   ├── auditor-agent.md
│   ├── onboarding-agent.md
│   ├── debug-agent.md
│   ├── migration-agent.md
│   ├── db-agent.md
│   ├── standup-agent.md
│   └── upgrade-agent.md
├── commands/
│   ├── analyze.md  plan.md  implement.md  review.md
│   ├── audit.md    sync-docs.md
│   ├── config.md   help.md
│   ├── onboarding.md  debug.md  migrate.md
│   ├── db.md       standup.md   upgrade.md
│   └── install-hooks.md
├── setup.sh
├── uninstall.sh
├── .gitignore
└── README.md

# fuera del repo, en el home del usuario (capa 2 del modelo docs):
~/.rubber-duck/
├── config.json                 # configuración personal
├── commit-template.txt         # solo si git.commit_message_format = custom
├── upgrade-status.json         # progreso de la migración de stack
├── last-post-merge-sync.log    # log del hook post-merge (si está activo)
└── docs/                       # copia de rubber-duck/docs/, actualizada por duck-sync-docs
    ├── new-admin/{backend-standards,frontend-standards,upgrade-targets,project-snapshot,db-schema}.md
    ├── old-admin/{project-snapshot,db-schema}.md
    └── last-sync.json
```

> **Modelo de 3 capas de docs** (ver `rules/` y `skills/docs-sync/SKILL.md`):
> 1. **Bundle versionado** en `rubber-duck/docs/` (factory default).
> 2. **Install copy** en `~/.rubber-duck/docs/` (seeded por `setup.sh`, preservada en re-instalaciones).
> 3. **User updates** vía `duck-sync-docs` → escribe en `~/.rubber-duck/docs/`. Modo `--bundle` (maintainer) escribe en el repo.

---

## Descripción detallada de cada archivo y carpeta

---

### `setup.sh`

Script de instalación. Se ejecuta una sola vez tras clonar el repositorio.

Hace tres cosas:
1. Crea los comandos `duck-*` como binarios en `~/.local/bin/` para que estén disponibles en cualquier terminal del sistema.
2. Añade `~/.local/bin` al `$PATH` en el archivo de configuración del shell del usuario (`.bashrc` o `.zshrc`).
3. Exporta la variable de entorno `RUBBER_DUCK_HOME` apuntando al directorio raíz del repositorio, para que los scripts siempre sepan dónde están los skills y comandos.

Al final del proceso, pregunta opcionalmente si se quieren instalar los git hooks en algún repositorio de proyecto.

```bash
git clone https://github.com/tu-user/rubber-duck
cd rubber-duck
chmod +x setup.sh
./setup.sh
source ~/.bashrc
```

Comandos que instala:

| Comando global | Acción |
|---|---|
| `duck-analyze` | Analiza un ticket de Jira |
| `duck-plan` | Genera plan de implementación |
| `duck-implement` | Implementa el código |
| `duck-review` | Revisa el código vs requisitos |
| `duck-sync-docs` | Sincroniza docs desde Confluence + análisis código; `--schema` extrae `db-schema.md` desde la BBDD |
| `duck-audit` | Audita el código |
| `duck-config` | Gestiona la configuración personal |
| `duck-help` | Muestra ayuda de comandos y configuración |
| `duck-onboarding` | Asistente para developers nuevos |
| `duck-debug` | Diagnostica bugs |
| `duck-migrate` | Migra código de old-admin a new-admin |
| `duck-db` | Asistente de BBDD multi-entorno (`--env=dev\|qa\|slave\|prod`, default `dev`) |
| `duck-standup` | Genera el resumen del daily |
| `duck-upgrade` | Gestiona la migración de stack |
| `duck-install-hooks` | Instala git hooks en un repo |

---

### `uninstall.sh`

Deshace todo lo que hizo `setup.sh` de forma limpia:
- Elimina todos los binarios `duck-*` de `~/.local/bin/`.
- Elimina las líneas relacionadas con rubber-duck del `.bashrc` o `.zshrc`.

---

### `bin/duck.sh`

Dispatcher central. Es el script al que llaman todos los wrappers `duck-*` instalados en el sistema.

Recibe el nombre del comando como primer argumento (`analyze`, `plan`, `audit`...), localiza el archivo correspondiente en `commands/`, y lo pasa a Claude como system prompt junto con el resto de argumentos.

No se ejecuta directamente por el usuario. Es la pieza interna que conecta los comandos globales con los skills de Claude.

---

### `hooks/`

Contiene los git hooks listos para instalar en cualquier repositorio de proyecto.

#### `hooks/git/pre-commit`

Se ejecuta automáticamente antes de cada `git commit`. Detecta qué archivos `.php` están en el stage, identifica si pertenecen a new-admin o old-admin, y lanza `duck-audit` sobre esos ficheros. Si el audit falla, bloquea el commit. Se puede saltar con `git commit --no-verify`.

#### `hooks/git/pre-push`

Se ejecuta automáticamente antes de cada `git push`. Extrae la Jira key del nombre de la rama (por ejemplo `feature/PROJ-123-payment-fix` → `PROJ-123`) y lanza `duck-review` para verificar que el código cumple los requisitos del ticket. Si no encuentra Jira key en la rama, se salta el paso silenciosamente.

#### `hooks/git/post-merge`

Se ejecuta automáticamente después de un `git pull` o `git merge`. Lanza `duck-sync-docs all` para mantener los docs de normas actualizados con lo que haya en Confluence.

#### `hooks/install-hooks.sh`

Script que copia los tres hooks anteriores al directorio `.git/hooks/` del repositorio que se le indique como argumento. Hace que tengan permisos de ejecución.

```bash
# instala en el repo actual
duck-install-hooks .

# instala en otro repo
duck-install-hooks /var/www/new-admin
```

---

### `mcp/`

Configuración de los servidores MCP (Model Context Protocol) que necesita Claude para conectarse a servicios externos.

#### `mcp/atlassian/config.json`

Credenciales y configuración del servidor MCP de Atlassian, que unifica el acceso a **Jira** y **Confluence** en un solo servidor. Contiene la URL de la instancia, el token de API y las claves de proyecto y espacio de Confluence.

Este archivo contiene credenciales y está en `.gitignore`. Nunca se sube al repositorio.

#### `mcp/atlassian/config.example.json`

Plantilla del archivo anterior sin credenciales reales. Se sube al repositorio para que cualquier usuario nuevo sepa qué campos tiene que rellenar.

```json
{
  "url": "https://tu-empresa.atlassian.net",
  "token": "TU_TOKEN_AQUI",
  "jira_project_keys": ["PROJ", "ADMIN"],
  "confluence_space_key": "DEV"
}
```

#### `mcp/atlassian/page-ids.json`

Mapa entre los archivos locales de normas (`docs/`) y los IDs de sus páginas correspondientes en Confluence. El skill `docs-sync` usa este archivo para saber exactamente qué página leer en Confluence para actualizar cada doc local.

```json
{
  "new-admin": {
    "backend": "123456",
    "frontend": "789012"
  },
  "old-admin": {
    "backend": "345678",
    "frontend": "901234"
  }
}
```

#### `mcp/database/config.json`

Credenciales de conexión a la BBDD del proyecto. También en `.gitignore`. **Schema v2 multi-entorno** (ver `bin/lib/db-env.sh`):

```json
{
  "_version": 2,
  "default": "dev",
  "environments": {
    "dev":   { "host": "...", "user": "...", "password": "...", "read_only": true, "danger_level": "low" },
    "qa":    { "host": "...", "user": "...", "password": "...", "read_only": true, "danger_level": "medium" },
    "slave": { "host": "...", "user": "...", "password": "...", "read_only": true, "danger_level": "high" },
    "prod":  { "host": "...", "user": "...", "password": "...", "read_only": true, "danger_level": "critical" }
  }
}
```

`duck-db` opera sobre `dev` por defecto. Para `qa`/`slave`/`prod` se exige `--env=<nombre>` explícito en cada invocación. Las gates anti-mutación `(a)..(e)` se aplican antes de cada query según `danger_level` (ver R2.1 en `rules/operational-restrictions.md`).

#### `mcp/database/config.example.json`

Plantilla schema v2 sin credenciales. Cuatro envs (`dev`, `qa`, `slave`, `prod`). `read_only` y `danger_level` fijos por env, no negociables.

#### `bin/lib/db-env.sh`

Loader del config v2 + 5 gates anti-mutación:

| Gate | Verifica | Exit code |
|------|----------|-----------|
| `(a)` | `environments.<env>.read_only == true` | `10` |
| `(b)` | Servidor MySQL: `@@global.read_only=1 ∧ @@global.super_read_only=1` | `11` |
| `(c)` | `SHOW GRANTS FOR CURRENT_USER` sin `INSERT/UPDATE/DELETE/ALTER/DROP/TRUNCATE/CREATE/GRANT OPTION/REVOKE/RENAME/REPLACE/MERGE/CALL/SUPER/RELOAD/FILE/PROCESS/ALL PRIVILEGES` | `12` |
| `(d)` | Regex anti-mutación sobre la query | `13` |
| `(e)` | Confirmación interactiva (slave: `y/N`; prod: tipear literal `prod`) | `14` |

Matriz aplicada por env: `dev` → `(a)+(d)`. `qa` → `(a)+(d)+(e)`. `slave` → `(a)+(b)+(c)+(d)+(e)`. `prod` → idem `slave` con `(e)` requiriendo tipeo literal `prod`.

Stubs para tests (no usar en runtime): `MYSQL_CMD_STUB`, `DUCK_DB_CONFIRM_STUB`.

CLI standalone:

```bash
bin/lib/db-env.sh list                  # imprime envs (dev qa slave prod)
bin/lib/db-env.sh default               # imprime env por defecto (dev)
bin/lib/db-env.sh resolve prod          # imprime bloque JSON del env
bin/lib/db-env.sh field prod host       # imprime un campo
bin/lib/db-env.sh regex "SELECT 1"      # gate (d) standalone
bin/lib/db-env.sh gate prod             # orquestador gates (a)(b)(c)(e)
bin/lib/db-env.sh require prod 0        # 0=implicit, 1=--env explícito
```

#### `bin/lib/db-env.test.sh`

Suite de tests bash con stubs. 24 casos cubren: descubrimiento básico, detección v1, `require_explicit`, regex `(d)`, gates `(a)`–`(e)` en `dev/qa/slave/prod`. Ejecutar:

```bash
bin/lib/db-env.test.sh
# === RESULT: 24 passed, 0 failed ===
```

#### `mcp/database/schema-context.md`

Descripción manual de las tablas más relevantes de la base de datos para el agente. Evita que Claude tenga que explorar el esquema completo en cada sesión. Aquí se documenta qué tablas existen, qué significan sus campos principales, y cuáles son las más usadas por new-admin y old-admin. **Complementario** al `docs/<proyecto>/db-schema.md` auto-extraído: este aporta contexto de negocio (curación manual), aquel aporta el schema técnico real. El `db-agent` carga ambos (primero `db-schema.md`, luego este).

#### `mcp/claude_desktop_config.json`

Archivo de configuración global listo para copiar a Claude Desktop (`~/Library/Application Support/Claude/claude_desktop_config.json` en Mac). Declara los servidores MCP activos con sus comandos de arranque y variables de entorno.

```json
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-atlassian"],
      "env": {
        "JIRA_URL": "...",
        "JIRA_TOKEN": "...",
        "CONFLUENCE_SPACE_KEY": "..."
      }
    },
    "database": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://user:pass@host:5432/dbname"
      }
    }
  }
}
```

#### `mcp/README.md`

Instrucciones paso a paso para instalar los servidores MCP, rellenar los archivos de configuración y verificar que Claude los detecta correctamente.

---

### `docs/`

Normas y conocimiento del proyecto. Se genera y mantiene actualizado con `duck-sync-docs`. Tiene dos tipos de contenido por proyecto: las **normas** que vienen de Confluence y el **snapshot** que se extrae del código real.

#### `docs/new-admin/backend-standards.md`

Normas de estructura y convenciones del backend de new-admin sincronizadas desde Confluence: organización de carpetas, patrones usados, reglas de nombrado, cómo se estructuran los controladores, servicios, modelos, etc. Stack PHP 7.4 + Slim 3 + illuminate/database 8 (Eloquent) + Twig 3.

#### `docs/new-admin/frontend-standards.md`

Normas del frontend de new-admin sincronizadas desde Confluence: estructura de componentes Vue 2.6 + Vuex 3 + vue-router 3, bundling con Webpack 4, convenciones de nombrado, cómo se organizan las vistas, stores, llamadas a API (axios), etc.

#### `docs/new-admin/upgrade-targets.md`

Define el stack destino de la migración: versiones exactas de PHP 8, Laravel y Vue 3, librerías que cambian, y decisiones de arquitectura tomadas por el equipo. Lo usa el `upgrade-agent`. Este archivo se rellena manualmente por el equipo — no se genera automáticamente.

#### `docs/new-admin/project-snapshot.md`

Generado y actualizado automáticamente cada vez que se lanza `duck-sync-docs`. Refleja el estado real del proyecto en ese momento analizando el código fuente. Contiene:

- **Estructura de carpetas** — árbol real con descripción de qué hace cada carpeta principal
- **Tecnologías y versiones** — extraído de `composer.json`, `package.json` y sus lockfiles. Versiones exactas de PHP, Slim 4, Vue 2, librerías principales, herramientas de build
- **Arquitectura detectada** — patrones realmente usados en el código: cómo están organizadas las rutas, cómo funciona el middleware, cómo se gestiona la autenticación, si hay repositorios o servicios
- **Puntos de entrada** — archivos de bootstrap, index, configuración principal
- **Dependencias externas** — APIs, servicios externos e integraciones detectadas en el código
- **Estado de deuda técnica** — archivos más grandes, clases con más responsabilidades, patrones inconsistentes detectados

Ejemplo de sección de tecnologías:

```markdown
## Tecnologías y versiones
_Actualizado: 2025-05-26 10:30_

### Backend
| Paquete | Versión | Uso |
|---|---|---|
| php | 7.4.33 | runtime |
| slim/slim | ^3.10 | framework HTTP |
| illuminate/database | 8.83.15 | ORM (Eloquent) |
| twig/twig | 3.4.1 | templating |
| monolog/monolog | 2.6.0 | logging |

### Frontend
| Paquete | Versión | Uso |
|---|---|---|
| vue | ^2.6.6 | framework UI |
| vuex | ^3.4.0 | state management |
| vue-router | ^3.3.2 | routing |
| axios | ^0.18.0 | HTTP client |
| webpack | 4.6.0 | bundler |
```

#### `docs/new-admin/db-schema.md`

Schema técnico auto-extraído de la BBDD `civitatis` para las tablas que usa new-admin. Generado por `duck-sync-docs --schema new-admin` (no por el sync normal). Detección de tablas via `protected $table` en `app/Models/`. Por cada tabla: columnas, índices y DDL (`SHOW CREATE TABLE`). Tablas referenciadas en código pero ausentes en DB se marcan con ⚠️. Es la fuente de verdad de nombres/columnas reales que consume el `db-agent`. Hasta la primera ejecución es un placeholder.

#### `docs/old-admin/backend-standards.md`

Normas del backend de old-admin sincronizadas desde Confluence. Stack PHP 5.6 + Apache 2 (módulo `{URL_DOMAIN}/admin` del repo `civitatis`). Incluye las particularidades del entorno legacy: includes manuales sin autoload PSR-4 global, short tags `<?`, conexiones PDO directas.

#### `docs/old-admin/frontend-standards.md`

Normas del frontend de old-admin sincronizadas desde Confluence: estructura de archivos HTML embebidos en PHP, scripts en `webroot/static/js/admin/` y `webroot/dev/js/admin/`, estilos en `webroot/static/css/admin/` y `webroot/dev/scss/admin/`, jQuery como librería principal, convenciones de nombrado.

#### `docs/old-admin/project-snapshot.md`

Igual que el de new-admin pero para old-admin. Especialmente útil para el `migration-agent` y el `upgrade-agent` — necesitan conocer el estado real de lo que hay que migrar.

#### `docs/old-admin/db-schema.md`

Como el de new-admin pero con detección sobre SQL crudo/PDO (grep `FROM|JOIN|INTO|UPDATE`) restringida al scope `/admin`. Generado por `duck-sync-docs --schema old-admin`. La detección sobre SQL dinámico es parcial (se etiqueta como tal); tokens-ruido del regex se descartan y las tablas plausibles ausentes en DB se listan con ⚠️.

#### `docs/last-sync.json`

Registro de la última sincronización. Guarda la fecha, qué proyectos se actualizaron, y un resumen de los cambios detectados respecto al snapshot anterior. Los campos `schema_*` (`schema_updated`, `schema_tables_count`, `schema_tables_missing`) solo se actualizan en runs con `--schema`; en runs normales se preservan.

```json
{
  "last_sync": "2025-05-26T10:30:00Z",
  "projects": {
    "new-admin": {
      "confluence_updated": true,
      "snapshot_updated": true,
      "schema_updated": true,
      "schema_tables_count": 445,
      "schema_tables_missing": ["entity_type"],
      "changes": [
        "axios actualizado de 1.5.0 a 1.6.0",
        "carpeta src/Services/Payments/ añadida",
        "nueva dependencia: stripe/stripe-php 13.0.0"
      ]
    },
    "old-admin": {
      "confluence_updated": true,
      "snapshot_updated": false,
      "schema_updated": true,
      "schema_tables_count": 286,
      "schema_tables_missing": [],
      "changes": []
    }
  }
}
```

---

### `skills/`

El núcleo de rubber-duck. Cada subcarpeta es un skill: un conjunto de instrucciones en markdown que Claude lee antes de ejecutar una tarea. Funcionan igual que los skills de `/mnt/skills/` de Claude — son la forma de enseñarle a Claude cómo comportarse en un contexto específico.

Cada skill tiene:
- Un `SKILL.md` con las instrucciones principales.
- Una carpeta `prompts/` con los prompts específicos para cada subtarea.

#### `skills/project-context/new_admin.md`

Contexto completo del proyecto new-admin para que Claude lo cargue antes de implementar o auditar. Incluye: estructura de carpetas del proyecto, stack técnico exacto (versiones de PHP, Vue, librerías principales), patrones arquitectónicos usados, rutas importantes, y cualquier particularidad que Claude necesite conocer para no inventarse nada.

#### `skills/project-context/old_admin.md`

Ídem para old-admin. El scope es exclusivamente el módulo `{URL_DOMAIN}/admin` del repo `civitatis`: el código vive en `application/admin/`, `application/lib/Admin/`, `application/lib/Dao/Admin/`, `application/lib/Dto/Admin/`, `application/lib/Queues/Newadmin/`, `application/templates/admin/`, `webroot/(static|dev)/(js|scss|css)/admin/`, `dev/src/js/admin/`. Especialmente importante documentar aquí las limitaciones del stack legacy: qué no existe en PHP 5.6, qué patrones no se pueden usar, cómo funciona el sistema de includes, etc.

#### `skills/jira-analyzer/SKILL.md`

Instrucciones para el skill de análisis de tickets. Le dice a Claude que cuando se invoque debe:
1. Usar el MCP de Atlassian para leer el ticket indicado.
2. Si se pasa un archivo o texto como segundo argumento, incorporarlo como contexto adicional.
3. Generar tres secciones: **User Story**, **Criterios de Aceptación** y **Consideraciones Técnicas**.
4. Mostrar el resultado al usuario.
5. Pedir confirmación con **3 opciones**:
   - `[s]` actualizar Jira **idempotentemente** entre marcadores `<!-- rubber-duck:start -->` … `<!-- rubber-duck:end -->`. Si los marcadores ya existían → reemplaza solo el bloque (resto de la descripción intacto). Si no → añade al final.
   - `[n]` no tocar nada.
   - `[e]` exportar a archivo (path: `<analyze.export_dir>/<JIRA-KEY>/<JIRA-KEY>_analyze.<ext>`), luego re-pregunta `[s/N]` por Jira.

#### `skills/jira-analyzer/prompts/generate_story.md`

Prompt detallado con el formato exacto en que debe generarse la user story, los criterios de aceptación y las consideraciones técnicas. Define la estructura, el nivel de detalle esperado y los criterios de calidad.

#### `skills/task-planner/SKILL.md`

Instrucciones para generar el plan de implementación. Le dice a Claude que debe leer el contenido del ticket analizado, cargar el contexto del proyecto correspondiente (`project-context/`), analizar qué archivos y partes del código hay que modificar, y generar un documento `.md` con el plan detallado paso a paso.

Al terminar, guarda el plan como `PROJ-123_plan.md` en el directorio desde donde se ejecutó el comando. El nombre del archivo incluye siempre la Jira key para que sea fácil de identificar y relacionar con el ticket.

#### `skills/task-planner/prompts/build_plan.md`

Prompt con el formato del plan de implementación: qué secciones debe tener, cómo describir cada cambio, cómo referenciar archivos y funciones concretas, qué nivel de detalle se espera para que el siguiente skill (implementer) pueda trabajar con él.

#### `skills/task-implementer/SKILL.md`

Instrucciones para implementar el código a partir del plan `.md`. Recibe como parámetro el archivo de plan generado por `duck-plan` — por ejemplo `PROJ-123_plan.md`. Lee el plan, carga el contexto del proyecto correcto, y escribe el código respetando el stack (PHP 7.4 + Slim 3 + Eloquent + Twig + Vue 2 para new-admin; PHP 5.6 + Apache + HTML/jQuery dentro del módulo `{URL_DOMAIN}/admin` de `civitatis` para old-admin) y las normas de `docs/`.

El archivo de plan es obligatorio como argumento. Si no se pasa, el skill lo indica y no procede.

#### `skills/task-implementer/prompts/new_admin.md`

Prompt específico para implementaciones en new-admin. Incluye patrones de código preferidos, ejemplos del estilo esperado en PHP 7.4 + Slim 3 + Eloquent (illuminate/database 8) y Vue 2.6 + Vuex 3, y restricciones a tener en cuenta.

#### `skills/task-implementer/prompts/old_admin.md`

Ídem para old-admin. Especialmente importante para que Claude (1) no use sintaxis o funciones inexistentes en PHP 5.6 y (2) no toque rutas de `civitatis` que estén fuera del módulo `{URL_DOMAIN}/admin`.

#### `skills/task-reviewer/SKILL.md`

Instrucciones para revisar el código implementado. Le dice a Claude que debe recuperar el ticket original de Jira, leer el código modificado, y verificar que cada criterio de aceptación está cubierto. Genera un informe de revisión indicando qué está correcto, qué falta y qué hay que corregir.

#### `skills/task-reviewer/prompts/review.md`

Prompt con el formato del informe de revisión y los criterios con los que evaluar si el código cumple los requisitos del ticket.

#### `skills/docs-sync/SKILL.md`

Instrucciones para la actualización completa del conocimiento del proyecto. Es el comando más completo de rubber-duck porque combina dos fuentes de información y genera documentación estructurada a partir de ambas.

Cada vez que se lanza hace dos cosas en paralelo:

**1. Sync desde Confluence**
Lee `mcp/atlassian/page-ids.json`, obtiene el contenido actualizado de cada página de normas via MCP de Atlassian, lo convierte a markdown limpio y sobreescribe los archivos correspondientes en `docs/<proyecto>/backend-standards.md` y `docs/<proyecto>/frontend-standards.md`.

**2. Análisis del código real**
Accede a la ruta del proyecto configurada en `project_path` del config, analiza el código y genera o actualiza `docs/<proyecto>/project-snapshot.md` con:

- **Estructura de carpetas** — árbol real del proyecto con descripción de qué hace cada carpeta principal
- **Tecnologías y versiones** — extraído de `composer.json`, `package.json`, `composer.lock` y `package-lock.json`. Versiones exactas de PHP, framework, librerías principales, herramientas de build
- **Arquitectura detectada** — patrones que se están usando realmente en el código: MVC, repositorios, servicios, middlewares, cómo están organizadas las rutas, cómo se gestiona la autenticación
- **Puntos de entrada** — archivos de bootstrap, index, configuración principal
- **Dependencias externas** — APIs, servicios externos, integraciones detectadas en el código
- **Estado de deuda técnica** — archivos más grandes, clases con más responsabilidades, patrones inconsistentes detectados

Al terminar actualiza `docs/last-sync.json` con la fecha y un resumen de qué cambió.

```bash
duck-sync-docs new-admin     # actualiza solo new-admin
duck-sync-docs old-admin     # actualiza solo old-admin
duck-sync-docs all           # actualiza los dos
```

**3. Extracción de schema DB (flag explícito `--schema`)**
`duck-sync-docs --schema [new-admin|old-admin|all]` genera `docs/<proyecto>/db-schema.md` con las tablas que usa cada proyecto y, por cada una, columnas/índices/DDL extraídos de la BBDD. El flag **debe ser explícito**: un `duck-sync-docs all` normal NO toca `db-schema.md`. Detección de tablas heurística (new-admin: `protected $table` en `app/Models/`; old-admin: grep SQL crudo en scope `/admin`). Entorno DB: `slave` por defecto, fallback `dev` con aviso; reutiliza `bin/lib/db-env.sh` (gates read-only por query, cero duplicación de la lógica de duck-db). Actualiza los campos `schema_*` de `last-sync.json`.

```bash
duck-sync-docs --schema new-admin           # extrae schema de new-admin
duck-sync-docs --schema old-admin            # scope /admin
duck-sync-docs --bundle --schema all         # refresca el bundle (maintainer)
```

#### `skills/docs-sync/prompts/sync-confluence.md`

Prompt para la parte de Confluence: cómo convertir el formato de Confluence a markdown, qué partes conservar, cómo manejar tablas, bloques de código y listas anidadas.

#### `skills/docs-sync/prompts/analyze-project.md`

Prompt para el análisis del código real. Le dice a Claude cómo leer `composer.json` y `package.json` para extraer versiones, cómo recorrer la estructura de carpetas para detectar la arquitectura, qué patrones buscar, y cómo redactar el `project-snapshot.md` de forma que sea útil para los otros agentes.

#### `skills/docs-sync/prompts/diff-report.md`

Prompt para generar el resumen de cambios al terminar. Compara el snapshot anterior con el nuevo y destaca qué ha cambiado: dependencias actualizadas, carpetas nuevas, patrones nuevos detectados.

#### `skills/docs-sync/prompts/extract-db-schema.md`

Prompt para el modo `--schema`. Cuatro secciones: (A) identificación de tablas usadas por proyecto (new-admin via `protected $table` + convención Eloquent + joins de repos; old-admin via grep `FROM|JOIN|INTO|UPDATE` en scope `/admin`), (B) extracción del schema aplicando las gates de `db-env.sh` por query y ejecutando `DESCRIBE`/`SHOW INDEX`/`SHOW CREATE TABLE`, (C) formato de salida de `db-schema.md` (cabecera + por tabla columnas/índices/DDL + footer de tablas compartidas en `--schema all`), (D) actualización de los campos `schema_*` en `last-sync.json`. Tablas referenciadas en código pero ausentes en DB se marcan con ⚠️.

#### `skills/code-audit/SKILL.md`

Instrucciones para el skill de auditoría. Soporta tres modos de uso:

**Modo archivo** — audita un fichero o ruta concreta:
```bash
duck-audit new-admin src/Services/PaymentService.php
```

**Modo completo** — audita todo el proyecto:
```bash
duck-audit new-admin all
```

**Modo rama** — audita solo los archivos modificados en la rama actual respecto a `main` o `master`. Internamente ejecuta `git diff --name-only main...HEAD` para obtener la lista de archivos cambiados y pasa solo esos al proceso de auditoría:
```bash
duck-audit new-admin --branch
```

Este último modo es el más útil en el día a día: si trabajas en una rama con 5 archivos modificados, solo audita esos 5, no el proyecto entero.

En todos los modos, la auditoría tiene dos capas:

**Capa estática** — ejecuta las herramientas de análisis y lee su output:
- `phpstan`: análisis de tipos y errores estáticos.
- `php-cs-fixer`: cumplimiento de estilo de código.
- `phparkitect`: cumplimiento de reglas arquitectónicas (capas, dependencias).

**Capa semántica** — lee los `docs/` del proyecto y verifica que el código cumple las convenciones de estructura definidas ahí, cosas que las herramientas automáticas no detectan.

Al final genera un informe unificado con los tres niveles de problemas, su severidad y sugerencias de corrección.

#### `skills/code-audit/prompts/standards.md`

Prompt para la auditoría semántica contra los docs de normas. Le enseña a Claude cómo leer un `backend-standards.md` o `frontend-standards.md` e identificar si el código auditado los cumple.

#### `skills/code-audit/prompts/phpstan.md`

Prompt para interpretar el output de phpstan. Le enseña a Claude el formato de los errores de phpstan y cómo reportarlos de forma homogénea en el informe final.

#### `skills/code-audit/prompts/cs-fixer.md`

Prompt para interpretar el output de php-cs-fixer (diffs de estilo) y reportarlos de forma clara indicando exactamente qué hay que cambiar.

#### `skills/code-audit/prompts/arkitect.md`

Prompt para interpretar las violaciones de phparkitect (dependencias entre capas, reglas de arquitectura) y explicarlas en términos del proyecto concreto.

---

### `agents/`

System prompts completos para cada agente. Mientras los skills son instrucciones para una tarea concreta, los agentes son personalidades completas de Claude configuradas para operar en un modo específico durante toda una sesión.

| Archivo | Comando | Cuándo se usa |
|---|---|---|
| `analyzer-agent.md` | `duck-analyze` | Al recibir un ticket nuevo |
| `planner-agent.md` | `duck-plan` | Al planificar la implementación |
| `implementer-agent.md` | `duck-implement` | Al escribir el código |
| `reviewer-agent.md` | `duck-review` | Al revisar el código |
| `auditor-agent.md` | `duck-audit` | Al auditar calidad y normas |
| `onboarding-agent.md` | `duck-onboarding` | Cuando entra un developer nuevo al equipo |
| `debug-agent.md` | `duck-debug` | Al investigar un bug |
| `migration-agent.md` | `duck-migrate` | Al migrar código de old-admin a new-admin |
| `db-agent.md` | `duck-db` | Al trabajar con la base de datos |
| `standup-agent.md` | `duck-standup` | Para preparar el daily |
| `upgrade-agent.md` | `duck-upgrade` | Para la migración de stack PHP7+Slim4+Vue2 → PHP8+Laravel+Vue3 |

---

#### `agents/analyzer-agent.md`
Agente especializado en leer tickets de Jira y generar documentación de requisitos estructurada. Conoce el formato de los tickets del proyecto y sabe qué información es relevante para la implementación.

#### `agents/planner-agent.md`
Agente especializado en análisis técnico y planificación de implementación. Conoce la arquitectura de new-admin y old-admin y sabe proponer planes de cambio coherentes con cada stack.

#### `agents/implementer-agent.md`
Agente especializado en escribir código para new-admin y old-admin. Carga el contexto de proyecto correspondiente y las normas de `docs/` antes de generar cualquier código.

#### `agents/reviewer-agent.md`
Agente especializado en revisión de código contra requisitos. Cruza el código implementado con los criterios de aceptación del ticket original.

#### `agents/auditor-agent.md`
Agente especializado en auditoría técnica. Interpreta el output de phpstan, php-cs-fixer y phparkitect, y lo combina con la revisión semántica contra los docs de normas.

#### `agents/onboarding-agent.md`
Agente para developers nuevos. Tiene cargado el contexto completo de ambos proyectos — estructura de carpetas, stack, patrones usados, flujo de trabajo — y responde preguntas sobre el proyecto sin necesidad de molestar al equipo. Útil la primera semana de un developer nuevo.

```bash
duck-onboarding
# → Claude arranca con contexto completo y espera preguntas
```

#### `agents/debug-agent.md`
Agente especializado en diagnóstico de bugs. Conoce las particularidades de cada stack (limitaciones de PHP 5.6, patrones de Vue 2, diferencias entre los dos proyectos) y propone hipótesis ordenadas por probabilidad. Puede recibir el mensaje de error directamente o leer el bug report de Jira.

```bash
duck-debug "Call to undefined method PaymentService::process() en línea 45"
duck-debug PROJ-456   # lee el bug report directamente de Jira
```

#### `agents/migration-agent.md`
Agente especializado en migrar código del módulo `{URL_DOMAIN}/admin` de `civitatis` (old-admin) a new-admin. Conoce las diferencias entre PHP 5.6 y PHP 7.4, entre HTML/jQuery embebido y Vue 2.6 + Vuex 3, y transforma patrones del stack legacy al moderno respetando las normas de ambos proyectos.

```bash
duck-migrate src/old-admin/modules/payments/
```

#### `agents/db-agent.md`
Agente especializado en la BBDD del proyecto **multi-entorno**. Carga en orden, si existen: (1) `~/.rubber-duck/docs/<proyecto>/db-schema.md` (schema auto-extraído por `duck-sync-docs --schema`, fuente de verdad de tablas/columnas/índices reales) y (2) `mcp/database/schema-context.md` (curación manual de contexto de negocio, complementario). Ayuda a escribir queries, revisar rendimiento, o entender qué tablas afecta un cambio. Especialmente útil porque new-admin y old-admin comparten BBDD pero la acceden de formas distintas. Si `db-schema.md` es solo el placeholder, avisa de ejecutar `duck-sync-docs --schema <proyecto>`.

Antes de cada query, invoca obligatoriamente:

1. `bin/lib/db-env.sh regex "<query>"` → gate `(d)`, exit `13` si es mutación.
2. `bin/lib/db-env.sh gate $DUCK_DB_ENV` → gates `(a)(b)(c)(e)` según `danger_level`.

Recibe el env activo en `$DUCK_DB_ENV` (inyectado por el dispatcher). Default `dev`. Para `qa/slave/prod` el usuario debe pasar `--env=<nombre>` explícito.

```bash
duck-db "necesito traer los pedidos activos con su usuario y última dirección"  # dev implícito
duck-db --env=qa "verifica el contador de reservas tras el deploy"
duck-db --env=slave "report masivo para evitar carga en master"
duck-db --env=prod "consulta urgente fila X"   # tipear literal "prod" para confirmar
duck-db PROJ-789                                # analiza qué consultas necesita el ticket
```

#### `agents/standup-agent.md`
Agente para el daily. Lee los tickets asignados al usuario con actividad en las últimas 24 horas desde Jira y genera un resumen estructurado de "qué hice ayer / qué haré hoy / hay algún bloqueo". El output está listo para leer o copiar directamente en el canal del equipo.

```bash
duck-standup
```

#### `agents/upgrade-agent.md`

El agente más complejo. Gestiona la migración de stack de new-admin en tres frentes simultáneos:

```
PHP 7.4  →  PHP 8.2
Slim 3   →  Laravel 11
Vue 2.6 + Options API + Webpack 4  →  Vue 3 + Composition API + Vite
```

Tiene dos modos:

**Modo `plan`** — analiza el proyecto completo y genera un roadmap de migración en `upgrade-plan.md` con inventario de breaking changes, fases ordenadas por dependencias, complejidad por módulo y riesgos identificados. No toca código.

**Modo `migrate`** — toma un archivo o módulo concreto y lo migra al nuevo stack siguiendo el plan. Ejecución incremental.

El agente mantiene el estado de progreso en `~/.rubber-duck/upgrade-status.json` para poder retomar la migración entre sesiones.

```bash
duck-upgrade plan                    # genera el roadmap completo → upgrade-plan.md
duck-upgrade migrate src/Services/PaymentService.php
duck-upgrade migrate src/Controllers/
duck-upgrade migrate --next          # siguiente archivo pendiente del plan
duck-upgrade status                  # muestra el progreso de la migración
duck-upgrade check src/Services/     # revisa compatibilidad sin modificar
```

Output de `duck-upgrade status`:
```
🦆 Migración new-admin — progreso
████████░░░░░░░░░░░░  16% (23/142 archivos)
Último migrado:    src/Services/PaymentService.php
Siguiente sugerido: src/Services/OrderService.php
```

Este agente requiere un documento adicional en `docs/new-admin/upgrade-targets.md` que define el stack destino exacto: versiones de PHP 8, Laravel, Vue 3 y Vite, librerías que cambian, y decisiones de arquitectura tomadas por el equipo para la migración.

---

### `commands/`

Cada archivo es un prompt corto que define exactamente qué hace cada comando cuando se invoca desde el terminal. El dispatcher `bin/duck.sh` lo carga como system prompt y le pasa los argumentos del usuario.

| Archivo | Comando | Uso |
|---|---|---|
| `analyze.md` | `duck-analyze` | `duck-analyze PROJ-123 [archivo-contexto]` |
| `plan.md` | `duck-plan` | `duck-plan PROJ-123` → genera `PROJ-123_plan.md` |
| `implement.md` | `duck-implement` | `duck-implement PROJ-123_plan.md` |
| `review.md` | `duck-review` | `duck-review PROJ-123` |
| `sync-docs.md` | `duck-sync-docs` | `duck-sync-docs [new-admin\|old-admin\|all]` — sync Confluence + análisis código; `--schema [...]` extrae `db-schema.md` |
| `audit.md` | `duck-audit` | `duck-audit [proyecto] [ruta\|all\|--branch]` |
| `config.md` | `duck-config` | `duck-config [list\|get\|set\|reset\|setup] [clave] [valor]` |
| `db.md` | `duck-db` | `duck-db [--env=<dev\|qa\|slave\|prod>] "<pregunta\|JIRA-KEY>"` |
| `help.md` | `duck-help` | `duck-help [comando\|config\|config.<clave>]` |

Cada archivo de comando le dice a Claude: qué skill cargar, en qué orden ejecutar los pasos, qué confirmaciones pedir al usuario, y cómo formatear el output final.

---

### `.gitignore`

Excluye del repositorio todos los archivos con credenciales reales:

```
mcp/atlassian/config.json
mcp/database/config.json
mcp/claude_desktop_config.json
```

---

## Instalación rápida

```bash
# 1. clonar
git clone https://github.com/tu-user/rubber-duck
cd rubber-duck

# 2. instalar comandos globales
chmod +x setup.sh
./setup.sh

# 3. recargar el shell
source ~/.bashrc   # o source ~/.zshrc

# 4. copiar y rellenar configuración MCP
cp mcp/atlassian/config.example.json mcp/atlassian/config.json
cp mcp/database/config.example.json mcp/database/config.json
# edita los archivos con tus credenciales reales

# 5. instalar git hooks en tu proyecto (opcional)
duck-install-hooks /ruta/a/tu/proyecto
```

---

---

## duck-help

Muestra ayuda contextual desde el terminal. Tiene tres modos:

```bash
# ayuda general — lista todos los comandos con su descripción corta
duck-help

# ayuda de un comando concreto — uso, argumentos y ejemplos
duck-help analyze
duck-help audit
duck-help config

# ayuda de una clave de configuración concreta — qué hace, valores posibles y default
duck-help config.git.auto_commit
duck-help config.audit.export_format
duck-help config.plan.output_dir
```

### Output de `duck-help` (ayuda general)

```
🦆 rubber-duck — asistente de desarrollo para New Admin

COMANDOS

  duck-analyze  <JIRA-KEY> [contexto]
    Lee el ticket de Jira, genera user story, criterios de aceptación
    y consideraciones técnicas. Pide confirmación antes de actualizar Jira.

  duck-plan  <JIRA-KEY>
    Genera un plan de implementación detallado en formato archivo.
    Guarda el resultado como PROJ-123_plan.md (o .html según config).

  duck-implement  <plan.md>
    Implementa el código a partir del plan indicado.
    Detecta automáticamente si es new-admin o old-admin por el contenido del plan.

  duck-review  <JIRA-KEY>
    Revisa que el código implementado cumple los requisitos del ticket.
    Puede exportar el informe y actualizar el ticket en Jira.

  duck-audit  <proyecto> <ruta|all|--branch>
    Audita el código contra las normas del proyecto, phpstan,
    php-cs-fixer y phparkitect. Puede exportar el informe a archivo.

  duck-sync-docs  [new-admin|old-admin|all]
    Obtiene las normas actualizadas desde Confluence
    y sobreescribe los archivos en docs/.
    --schema [new-admin|old-admin|all]  extrae db-schema.md desde la BBDD
    (tablas usadas + columnas/índices/DDL, read-only via db-env.sh).

  duck-config  [list|get|set|reset|setup]  [clave]  [valor]
    Gestiona la configuración personal en ~/.rubber-duck/config.json.
    Usa 'duck-config setup' para relanzar el asistente inicial.

  duck-db  [--env=<env>]  "<pregunta o JIRA-KEY>"
    Asistente de BBDD multi-entorno. Default env=dev. Para qa/slave/prod
    requiere --env explícito. Gates anti-mutación (a)..(e) por danger_level.

  duck-help  [comando|config|config.<clave>]
    Muestra esta ayuda, o ayuda detallada de un comando o clave de config.

  duck-install-hooks  [ruta]
    Instala los git hooks de rubber-duck en el repositorio indicado.
    Sin argumento, usa el directorio actual.

─────────────────────────────────────────────────
Configuración actual:  duck-config list
Versión:               rubber-duck v1.0.0
```

### Output de `duck-help audit` (ayuda de comando)

```
🦆 duck-audit — auditoría de código

USO
  duck-audit <proyecto> <objetivo>

ARGUMENTOS
  proyecto    new-admin  |  old-admin
  objetivo    ruta/al/archivo.php     audita un archivo concreto
              all                     audita todo el proyecto
              --branch                audita solo los archivos modificados
                                      en la rama actual vs main/master

EJEMPLOS
  duck-audit new-admin src/Services/PaymentService.php
  duck-audit new-admin --branch
  duck-audit old-admin all

QUÉ AUDITA
  1. Normas de estructura    docs/<proyecto>/backend-standards.md
                             docs/<proyecto>/frontend-standards.md
  2. Análisis estático       phpstan
  3. Estilo de código        php-cs-fixer
  4. Arquitectura            phparkitect

CONFIGURACIÓN RELACIONADA
  audit.default_mode         Modo por defecto si no se pasa objetivo
                             Valor actual: branch
  audit.fail_on              Nivel que bloquea el proceso
                             Valor actual: error
  audit.export               Exportar informe a archivo
                             Valor actual: false
  audit.export_format        Formato del archivo exportado
                             Valor actual: md
  audit.export_dir           Directorio del archivo exportado
                             Valor actual: .

  → duck-help config.audit.export_format  para más detalle
```

### Output de `duck-help config.audit.export_format` (ayuda de clave)

```
🦆 config  →  audit.export_format

DESCRIPCIÓN
  Formato del archivo generado cuando audit.export es true.
  El archivo se nombra automáticamente como PROJ-123_audit.<formato>

VALORES POSIBLES
  md      Markdown — legible en cualquier editor o visor de GitHub/GitLab
  html    HTML — con estilos, cómodo para compartir o abrir en el navegador
  json    JSON — útil para procesar el informe con otras herramientas
  txt     Texto plano — sin formato, máxima compatibilidad

DEFAULT
  md

VALOR ACTUAL
  html  (personalizado)

CÓMO CAMBIARLO
  duck-config set audit.export_format md

CLAVES RELACIONADAS
  audit.export        activa o desactiva la exportación  (actual: true)
  audit.export_dir    dónde se guarda el archivo         (actual: .)
  review.export_format  mismo concepto para duck-review  (actual: md)
```

---

## Configuración

rubber-duck tiene un sistema de configuración personal guardado en `~/.rubber-duck/config.json` — fuera del repositorio, en el home del usuario, para que sea por persona y nunca se suba al git.

### Comandos de configuración

```bash
# ver toda la configuración actual con sus valores y defaults
duck-config list

# leer un valor concreto
duck-config get plan.output_format

# establecer un valor
duck-config set plan.output_format html
duck-config set git.auto_commit true
duck-config set git.auto_commit_after audit
duck-config set audit.default_mode branch
duck-config set audit.export true
duck-config set audit.export_format html
duck-config set review.export true
duck-config set review.export_format md

# resetear un valor al default
duck-config reset plan.output_format

# resetear toda la configuración
duck-config reset --all

# relanzar el asistente de configuración inicial
duck-config setup
```

### Opciones disponibles

| Clave | Valores | Default | Descripción |
|---|---|---|---|
| `plan.output_format` | `md`, `html` | `md` | Formato del archivo generado por `duck-plan` |
| `plan.output_dir` | cualquier ruta | `.` | Raíz del dir destino para `duck-plan`. Relativo a `$PROJECT_ROOT` si no empieza por `/` o `~`. Path final: `<resolved>/<JIRA-KEY>/<JIRA-KEY>_plan.<ext>` |
| `analyze.export_format` | `md`, `html`, `json`, `txt` | `md` | Formato del archivo exportado por `duck-analyze` (opción `e` en la confirmación) |
| `analyze.export_dir` | cualquier ruta | `.` | Raíz del dir destino para `duck-analyze`. Path final: `<resolved>/<JIRA-KEY>/<JIRA-KEY>_analyze.<ext>` |
| `project.new_admin_path` | ruta absoluta | `""` | Fallback opcional si la auto-detección desde `$PWD` falla |
| `project.old_admin_path` | ruta absoluta | `""` | Fallback opcional si la auto-detección desde `$PWD` falla |
| `implement.auto_format` | `true`, `false` | `false` | Ejecuta `php-cs-fixer` (vía `bin/pre-commit`) automáticamente tras implementar (solo new-admin) |
| `audit.default_mode` | `branch`, `all` | `branch` | Modo por defecto de `duck-audit` sin argumentos |
| `audit.fail_on` | `error`, `warning`, `all` | `error` | Severidad mínima que bloquea (exit 1) |
| `audit.export` | `true`, `false` | `false` | Exporta el informe de auditoría a un archivo |
| `audit.export_format` | `md`, `html`, `json`, `txt` | `md` | Formato del archivo exportado |
| `audit.export_dir` | cualquier ruta | `.` | Raíz del dir destino para `duck-audit`. Relativo a `$PROJECT_ROOT` |
| `review.export` | `true`, `false` | `false` | Exporta el informe de revisión a un archivo |
| `review.export_format` | `md`, `html`, `json`, `txt` | `md` | Formato del archivo exportado |
| `review.export_dir` | cualquier ruta | `.` | Raíz del dir destino para `duck-review`. Relativo a `$PROJECT_ROOT` |
| `review.update_jira` | `true`, `false` | `true` | Si `true`, tras mostrar el informe pide confirmación y postea como comentario nuevo en Jira (nunca edita comentarios previos) |
| `git.auto_commit` | `true`, `false` | `false` | Hace commit automático en `$PROJECT_ROOT` al terminar el paso indicado |
| `git.auto_commit_after` | `implement`, `review`, `audit` | `audit` | En qué paso se dispara el commit automático |
| `git.commit_message_format` | `jira`, `conventional`, `custom` | `jira` | Formato del mensaje. `custom` lee `~/.rubber-duck/commit-template.txt` con variables `{jira_key}` `{title}` `{summary}` `{step}` |
| `git.auto_push` | `true`, `false` | `false` | Hace push automático tras el commit |
| `git.hooks.pre_commit_enabled` | `true`, `false` | `false` | Activa el hook git pre-commit (audit antes del commit). Opt-in para no ralentizar commits |
| `git.hooks.pre_push_enabled` | `true`, `false` | `false` | Activa el hook git pre-push (review antes del push) |
| `git.hooks.post_merge_enabled` | `true`, `false` | `false` | Activa el hook git post-merge (sync-docs tras pull/merge) |
| `output.language` | `es`, `en` | `es` | Idioma de los textos y reportes generados (literales y código se preservan) |

### Ejemplo de configuración típica

```json
{
  "project": {
    "new_admin_path": "/var/www/new-admin",
    "old_admin_path": "/var/www/old-admin"
  },
  "plan": {
    "output_format": "md",
    "output_dir": "."
  },
  "implement": {
    "auto_format": false
  },
  "audit": {
    "default_mode": "branch",
    "fail_on": "error",
    "export": false,
    "export_format": "md",
    "export_dir": "."
  },
  "review": {
    "update_jira": true,
    "export": false,
    "export_format": "md",
    "export_dir": "."
  },
  "git": {
    "auto_commit": true,
    "auto_commit_after": "audit",
    "commit_message_format": "jira",
    "auto_push": false
  },
  "output": {
    "language": "es"
  }
}
```

### Asistente de configuración inicial

La primera vez que se ejecuta cualquier comando `duck-*`, rubber-duck detecta que no existe `~/.rubber-duck/config.json` y lanza automáticamente un asistente de configuración interactivo en la consola de Claude antes de hacer nada más. También se puede relanzar manualmente en cualquier momento con `duck-config setup`.

El asistente hace las preguntas en orden, con opciones numeradas cuando la respuesta es cerrada y texto libre cuando es abierta. Al terminar genera el `config.json` completo y confirma que está listo.

Ejemplo de sesión del asistente:

```
🦆 Bienvenido a rubber-duck. Es la primera vez que lo ejecutas.
   Vamos a configurarlo. Solo tarda un momento.

─────────────────────────────────────────────────

¿En qué idioma quieres los outputs?
  1) Español
  2) English

> 1

─────────────────────────────────────────────────

¿Cuál es el formato por defecto para los planes de implementación?
  1) Markdown (.md)
  2) HTML (.html)

> 1

─────────────────────────────────────────────────

¿Dónde quieres guardar los planes y reportes generados?
  Pulsa enter para usar el directorio actual (.)
  O escribe una ruta: _

> ./reports

─────────────────────────────────────────────────

¿Cómo quieres que duck-audit opere por defecto?
  1) Solo los archivos modificados en la rama actual (--branch) [recomendado]
  2) Todo el proyecto (all)

> 1

─────────────────────────────────────────────────

¿Qué debe bloquear el proceso de auditoría?
  1) Solo errores críticos [recomendado]
  2) Errores y warnings
  3) Cualquier incidencia

> 1

─────────────────────────────────────────────────

¿Quieres exportar los informes de auditoría y revisión a archivo,
o solo imprimirlos en pantalla?
  1) Solo pantalla [recomendado para empezar]
  2) Exportar a archivo

> 2

¿En qué formato?
  1) Markdown (.md)
  2) HTML (.html)
  3) JSON (.json)
  4) Texto plano (.txt)

> 2

─────────────────────────────────────────────────

¿Quieres que rubber-duck haga commits automáticos?
  1) No, prefiero hacer los commits manualmente [recomendado]
  2) Sí, hacer commit automático

> 2

¿En qué momento del flujo?
  1) Después de implementar el código
  2) Después de pasar la revisión
  3) Después de pasar la auditoría [recomendado]

> 3

¿Qué formato de mensaje de commit prefieres?
  1) PROJ-123: descripción del ticket  (estilo Jira)
  2) feat(scope): PROJ-123 descripción  (Conventional Commits)
  3) Personalizado (te pido la plantilla ahora)

> 1

─────────────────────────────────────────────────

¿Quieres hacer push automático tras el commit?
  1) No [recomendado]
  2) Sí

> 1

─────────────────────────────────────────────────

✓ Configuración guardada en ~/.rubber-duck/config.json

Puedes cambiar cualquier opción en cualquier momento con:
  duck-config set <clave> <valor>
  duck-config list  (para ver todo)

🦆 Todo listo. Continuando con tu comando...
```

Si el usuario interrumpe el asistente a mitad (Ctrl+C), rubber-duck guarda lo que se haya respondido hasta ese momento y rellena el resto con los valores por defecto, para no dejar una configuración vacía o corrupta.

Cuando `git.auto_commit` es `true`, el mensaje se genera automáticamente según el formato configurado:

**`jira`** — incluye la Jira key y el título del ticket:
```
PROJ-123: implementación de módulo de pagos
```

**`conventional`** — sigue la especificación Conventional Commits:
```
feat(payments): PROJ-123 añadir módulo de pagos
```

**`custom`** — usa un template definido por el usuario en `~/.rubber-duck/commit-template.txt`.

---

## Uso diario

```bash
# analizar un ticket y generar user story
duck-analyze PROJ-123

# analizar con contexto adicional
duck-analyze PROJ-123 ./contexto-extra.txt

# generar plan → crea PROJ-123_plan.md en el directorio actual
duck-plan PROJ-123

# implementar el código a partir del plan
duck-implement PROJ-123_plan.md

# revisar que el código cumple el ticket
duck-review PROJ-123

# auditar un archivo concreto
duck-audit new-admin src/Services/PaymentService.php

# auditar solo los archivos modificados en la rama actual
duck-audit new-admin --branch

# auditar todo el proyecto
duck-audit new-admin all

# sincronizar normas desde Confluence Y actualizar snapshot del código
duck-sync-docs new-admin
duck-sync-docs all
```

### Flujo típico de una tarea

```bash
# 1. llega el ticket, lo analizas
duck-analyze PROJ-456

# 2. generas el plan → crea PROJ-456_plan.md
duck-plan PROJ-456

# 3. implementas a partir del plan
duck-implement PROJ-456_plan.md

# 4. auditas solo lo que has tocado en tu rama
duck-audit new-admin --branch

# 5. revisas que todo cumple el ticket original
duck-review PROJ-456
```

---

## Tecnologías que usa internamente

| Tecnología | Para qué |
|---|---|
| **Claude** (Sonnet 4) | Motor de todos los skills y agentes |
| **MCP Atlassian** | Leer y escribir en Jira y Confluence |
| **MCP Database** | Consultar el esquema de base de datos |
| **phpstan** | Análisis estático de tipos PHP |
| **php-cs-fixer** | Estilo y formato de código PHP |
| **phparkitect** | Reglas de arquitectura PHP |

---

*rubber-duck — porque en vez de contarle tus problemas al pato, él los resuelve.*