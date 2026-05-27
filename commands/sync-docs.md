# Comando `duck-sync-docs`

Sincroniza la documentación de los proyectos en dos frentes paralelos:

1. **Confluence:** descarga las páginas configuradas y las guarda como markdown bajo `docs/<proyecto>/{backend,frontend}-standards.md`. **Solo new-admin** (old-admin no tiene Confluence — política de mantenimiento).
2. **Análisis del código real:** recorre cada proyecto y genera `docs/<proyecto>/project-snapshot.md` con stack, estructura, arquitectura detectada y deuda técnica visible.

## Uso

```
duck-sync-docs [new-admin|old-admin|all]
```

Sin argumento = `all`.

Ejemplos:

```bash
duck-sync-docs new-admin       # solo new-admin (Confluence + snapshot)
duck-sync-docs old-admin       # solo snapshot del scope /admin
duck-sync-docs all             # ambos
duck-sync-docs                 # equivalente a all
```

## Comportamiento

Carga el skill `$RUBBER_DUCK_HOME/skills/docs-sync/SKILL.md`. Resumen:

1. **Resuelve paths de cada proyecto** desde `$PROJECT_ROOT/$PROJECT_TYPE` (si coincide con el target) o desde `~/.rubber-duck/config.json` (`project.new_admin_path`, `project.old_admin_path`). Si no se resuelve → skip ese proyecto con motivo.
2. **Confluence (solo new-admin):**
   - Lee IDs de `mcp/atlassian/page-ids.json` (backend `2389508098`, frontend `2449342481`).
   - Fetch + conversión via `prompts/sync-confluence.md`.
   - Escribe `docs/new-admin/backend-standards.md` y `frontend-standards.md`.
   - **Skip total para old-admin.** No se generan standards artificiales.
3. **Análisis de código:**
   - new-admin: recorre `app/`, `config/`, `dev/vue/`, lee manifests, cita `.claude/*` cuando existe.
   - old-admin: **restringido al scope `/admin`** (whitelist). Banner "modo mantenimiento" al inicio del snapshot.
   - Escribe `docs/<proyecto>/project-snapshot.md` via `prompts/analyze-project.md`.
4. **Diff report:** compara con snapshot anterior via `prompts/diff-report.md`. Resumen accionable.
5. **Actualiza `docs/last-sync.json`** con fecha + proyectos + cambios.
6. **Resumen al usuario.**

## Reglas universales aplicables

- `$RUBBER_DUCK_HOME/rules/output-language.md` → snapshots y diff-reports en `output.language`.
- `$RUBBER_DUCK_HOME/rules/project-detection.md` → fallback a config si CWD no resuelve.
- `$RUBBER_DUCK_HOME/rules/self-contained.md` → cero paths externos.
- `$RUBBER_DUCK_HOME/rules/operational-restrictions.md` → R1 (Confluence read-only), R2 (sin tocar BBDD), política old-admin sin Confluence.

## Configuración relacionada

| Clave | Default | Efecto |
|---|---|---|
| `project.new_admin_path` | `""` | Path de fallback si no se detecta desde CWD |
| `project.old_admin_path` | `""` | Idem para old-admin |
| `output.language` | `es` | Idioma de los snapshots y diff-reports |

## Restricciones

- **R1 (Jira):** Confluence solo se **lee**. Nunca se escribe.
- **R2 (BBDD):** no toca BBDD.
- **Old-admin policy:** sin Confluence, sin standards artificiales, análisis restringido al scope `/admin`.

## Errores y exit codes

| Situación | Exit |
|---|---|
| Éxito en al menos un proyecto | 0 |
| Todos los proyectos fallan (paths no resueltos) | 3 |
| Confluence MCP no disponible (snapshot completa igualmente) | 0 con warning |
| Argumento inválido | 2 |

## Uso típico en hooks

`post-merge`: `duck-sync-docs all` se ejecuta tras cada `git pull`/`git merge` para mantener docs frescas (configurable, ver F9).
