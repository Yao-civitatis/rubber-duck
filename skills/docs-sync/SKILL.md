# Skill `docs-sync`

Sincroniza la documentación del proyecto en dos modos paralelos:

1. **Confluence:** lee páginas configuradas en `mcp/atlassian/page-ids.json` vía MCP de Atlassian y las convierte a markdown bajo `docs/<proyecto>/`.
2. **Análisis del código real:** recorre el código del proyecto y genera `docs/<proyecto>/project-snapshot.md`.

Aplica a new-admin y old-admin con políticas distintas (ver §"Diferencias por proyecto").

## Invocación

```
duck-sync-docs [new-admin|old-admin|all]
```

Sin argumento → comportamiento equivalente a `all`.

## Reglas universales aplicables

- `$RUBBER_DUCK_HOME/rules/output-language.md` → el `project-snapshot.md` y los diff-reports se redactan en `output.language`. Encabezados, descripciones y comentarios. Literales (paths, versiones, JSON keys) se preservan.
- `$RUBBER_DUCK_HOME/rules/project-detection.md` → `$PROJECT_ROOT` puede no estar definido si el comando se invoca desde fuera de cualquier repo. En ese caso, resolver los paths leyendo `~/.rubber-duck/config.json` (`project.new_admin_path`, `project.old_admin_path`).
- `$RUBBER_DUCK_HOME/rules/self-contained.md` → cero paths externos. Todo lo necesario vive en el repo.
- `$RUBBER_DUCK_HOME/rules/operational-restrictions.md` → R1 (Jira RO en este flujo: solo lectura de Confluence), R2 (sin tocar BBDD), política old-admin (sin Confluence ni standards artificiales).

## Destino de los archivos generados

`duck-sync-docs` es una **excepción** a la regla general `rules/export-paths.md`. Los artefactos no van al proyecto sincronizado: viven todos dentro del propio repo de `rubber-duck`, agrupados por proyecto:

- new-admin → `$RUBBER_DUCK_HOME/docs/new-admin/{backend-standards,frontend-standards,project-snapshot}.md`
- old-admin → `$RUBBER_DUCK_HOME/docs/old-admin/project-snapshot.md`
- Estado global: `$RUBBER_DUCK_HOME/docs/last-sync.json` (un único archivo con ambos proyectos)

Razón: estos docs son la "fuente de verdad interna" de rubber-duck sobre los proyectos que opera. No deben contaminar los repos de new-admin / civitatis (que tienen su propio `docs/` con otras cosas).

## Resolución de los proyectos a leer

Para cada proyecto a sincronizar (`new-admin` y/o `old-admin`), resolver el path del repo **leído** (no de escritura):

1. Si `$PROJECT_ROOT` está definido y `$PROJECT_TYPE` coincide con el proyecto a sincronizar → usar `$PROJECT_ROOT` como **read root**.
2. Si no, leer `~/.rubber-duck/config.json`:
   - new-admin → `project.new_admin_path` como **read root**.
   - old-admin → `project.old_admin_path` como **read root**.
3. Si el valor es vacío o el directorio no existe → **abortar para ese proyecto** con error claro. No inventar paths.

El **read root** se usa para leer composer.json, package.json, recorrer la estructura, leer `.claude/*`, etc. Nunca se escribe en él.

## Diferencias por proyecto

### new-admin

**Confluence:**
- Lee `mcp/atlassian/page-ids.json` → claves `new-admin.backend` (`2389508098`) y `new-admin.frontend` (`2449342481`).
- Para cada ID:
  - Llamar al MCP de Atlassian para obtener el contenido (formato `storage` o `atlas_doc_format`).
  - Convertir a markdown limpio siguiendo `$RUBBER_DUCK_HOME/skills/docs-sync/prompts/sync-confluence.md`.
  - Escribir a `$RUBBER_DUCK_HOME/docs/new-admin/backend-standards.md` o `frontend-standards.md`.
- Si la lectura falla (sin permisos, sin red), registrar el error y continuar con el análisis de código.

**Análisis de código:**
- Lee `composer.json`, `composer.lock`, `dev/package.json`, `dev/package-lock.json`, `phpstan.dist.neon`, `phparkitect.php`, etc.
- Recorre la estructura `app/`, `config/`, `dev/vue/`, etc.
- Lee `$PROJECT_ROOT/.claude/project-context.md`, `domain-index.md`, `refactoring-state.md` si existen y los cita (no duplica).
- Genera `$RUBBER_DUCK_HOME/docs/new-admin/project-snapshot.md` siguiendo `prompts/analyze-project.md`.

### old-admin

**Confluence:** **skip total.** No existen páginas de estándares para old-admin y no se van a crear. `mcp/atlassian/page-ids.json` no contiene entradas para `old-admin`. **No** generar `backend-standards.md` ni `frontend-standards.md` artificiales en `docs/old-admin/`. Documentado en `rules/operational-restrictions.md` §"Política old-admin".

**Análisis de código:** **restringido al scope `/admin`** (whitelist en `skills/project-context/old_admin.md`). El snapshot recorre solo:

- `application/admin/`
- `application/lib/Admin/`, `application/lib/Dao/Admin/`, `application/lib/Dto/Admin/`, `application/lib/Queues/Newadmin/`, `application/lib/NewAdmin/`
- `application/admin/adminApi/`
- `application/templates/admin/`
- `webroot/static/(js|css)/admin/`, `webroot/dev/(js|scss)/admin/`, `dev/src/js/admin/`
- `application/css_admin/`

El `project-snapshot.md` resultante incluye al inicio un banner de "modo mantenimiento" (ver `prompts/analyze-project.md`).

## Flujo

### Paso 1 — Determinar proyectos a procesar

A partir del argumento (`new-admin` | `old-admin` | `all` | vacío).

### Paso 2 — Por cada proyecto

1. Resolver path (ver §"Resolución de paths"). Si falla, registrar y saltar.
2. **Confluence (solo new-admin):**
   - Para cada page ID configurado, fetch + convert + write.
   - Recoger lista de archivos escritos.
3. **Análisis del código:**
   - Aplicar `prompts/analyze-project.md`.
   - Escribir `$RUBBER_DUCK_HOME/docs/<proyecto>/project-snapshot.md`.

### Paso 3 — Diff report

Comparar el nuevo `project-snapshot.md` con el anterior (si existía) usando `prompts/diff-report.md`. Generar un resumen de cambios en formato:

```
new-admin:
  - axios actualizado: ^0.18.0 → ^0.18.1
  - carpeta app/Modules/Refunds/ añadida
  - 0 cambios en backend-standards.md vs Confluence
```

### Paso 4 — Actualizar `$RUBBER_DUCK_HOME/docs/last-sync.json`

**Un único archivo** con el estado de ambos proyectos:

```json
{
  "last_sync": "<ISO-8601 UTC>",
  "projects": {
    "new-admin": {
      "confluence_updated": true,
      "snapshot_updated": true,
      "changes": ["…"]
    },
    "old-admin": {
      "confluence_updated": false,
      "snapshot_updated": true,
      "changes": ["…"]
    }
  }
}
```

`confluence_updated = false` para old-admin **siempre** (no aplica).

Si en este run solo se sincronizó un proyecto (p.ej. `duck-sync-docs new-admin`), se actualiza solo esa entrada y se preserva la otra del archivo previo (si existe).

### Paso 5 — Resumen al usuario

```
🦆 duck-sync-docs completado.

new-admin:
  ✓ docs/new-admin/backend-standards.md (desde Confluence id 2389508098)
  ✓ docs/new-admin/frontend-standards.md (desde Confluence id 2449342481)
  ✓ docs/new-admin/project-snapshot.md
  Cambios destacados:
    - <bullet 1>
    - <bullet 2>

old-admin:
  ✓ docs/old-admin/project-snapshot.md (scope /admin)
  ✗ Confluence: omitido por política de mantenimiento.

✓ docs/last-sync.json actualizado.
```

### Paso 6 — Salida

| Situación | Exit |
|---|---|
| Éxito en al menos un proyecto | 0 |
| Todos los proyectos fallan (paths no resueltos) | 3 |
| Confluence MCP no disponible | 4 (continúa con snapshot) |

## Idempotencia

Llamar `duck-sync-docs all` dos veces seguidas, sin cambios en Confluence ni en el código → segundo run produce diff vacío y `last-sync.json` con `changes: []`. Archivos `.md` se sobrescriben sin cambios reales.
