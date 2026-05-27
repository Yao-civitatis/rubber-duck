# Regla: convención universal de paths de export

**Aplica a:** cualquier comando `duck-*` que persista artefactos a disco (planes, informes, exports de análisis, etc.).

**Excepción documentada:** `duck-sync-docs` **no** sigue esta regla. Sus outputs viven dentro del repo de rubber-duck (`$RUBBER_DUCK_HOME/docs/<proyecto>/`), no en el proyecto sincronizado. Motivo: son docs internas de la herramienta sobre los proyectos que opera; meterlas en `new-admin/docs/` o `civitatis/docs/` contamina repos que tienen su propio contenido en `docs/`. Ver `skills/docs-sync/SKILL.md` §"Destino de los archivos generados".

## Patrón

```
<output_dir_resuelto>/<carpeta>/<filename>
```

### Resolución de `<output_dir_resuelto>`

El valor configurado en `<config.output_dir>` (p.ej. `plan.output_dir`, `audit.export_dir`, `review.export_dir`, `analyze.export_dir`) es **relativo a `$PROJECT_ROOT`** salvo que empiece por `/` (absoluto).

| Valor en config | `$PROJECT_ROOT` | Path resuelto |
|---|---|---|
| `.` (default) | `/.../new-admin` | `/.../new-admin` |
| `docs` | `/.../new-admin` | `/.../new-admin/docs` |
| `docs` | `/.../civitatis` | `/.../civitatis/docs` |
| `reports/duck` | `/.../new-admin` | `/.../new-admin/reports/duck` |
| `/tmp/exports` (absoluto) | (cualquiera) | `/tmp/exports` |
| `~/exports` | (cualquiera) | expandir `~` con `$HOME`, luego se considera absoluto |

Esto permite que **un mismo valor de config (`docs`) produzca outputs dentro del proyecto activo** sin importar desde dónde se invoque el comando, ni si estoy en new-admin o en old-admin.

### Resolución de `<carpeta>`

- **`<JIRA-KEY>`** cuando el comando tiene clave de Jira disponible (caso normal).
- **`<cmd>`** (nombre del comando sin prefijo `duck-`) como fallback defensivo cuando no hay clave.

### Resolución de `<filename>`

`<JIRA-KEY>_<cmd>.<ext>` cuando hay key. `<slug>_<cmd>.<ext>` cuando no hay key.

### Comandos sin contexto de proyecto

Si un comando que exporta no tiene `$PROJECT_ROOT` definido (p.ej. `duck-sync-docs all` invocado fuera de cualquier proyecto, escribiendo en cada uno):

- Para cada proyecto destino, **resolver `<output_dir>` contra el path de ESE proyecto** (`project.new_admin_path`, `project.old_admin_path`).
- Si el comando opera sin proyecto y `<output_dir>` es relativo → resolver contra `$PWD`. Este caso es excepcional; preferir paths absolutos para comandos project-agnostic con export.

## Procedimiento obligatorio

Cualquier skill que exporte debe:

1. Calcular `dest_dir`.
2. `mkdir -p "$dest_dir"`.
3. Calcular `dest_file`.
4. Si `$dest_file` ya existe → preguntar sobrescribir / backup `.bak` / cancelar.
5. Escribir el archivo.
6. Confirmar al usuario con `✓ <tipo> guardado en <ruta>`.

## Ejemplos

Con `plan.output_dir = docs` (relativo) y `$PROJECT_ROOT = /.../new-admin`:

| Comando | Path resultante |
|---|---|
| `duck-analyze PANA-123` (opción `e`) | `/.../new-admin/docs/PANA-123/PANA-123_analyze.<ext>` |
| `duck-plan PANA-123` | `/.../new-admin/docs/PANA-123/PANA-123_plan.<ext>` |
| `duck-review PANA-123` (export=true) | `/.../new-admin/docs/PANA-123/PANA-123_review.<ext>` |
| `duck-audit --branch` (rama `feature/PANA-123-foo`) | `/.../new-admin/docs/PANA-123/PANA-123_audit.<ext>` |
| `duck-audit src/X.php` (sin key) | `/.../new-admin/docs/audit/X.php_audit.<ext>` |

El mismo config funciona contra old-admin sin tocar nada: si `$PROJECT_ROOT = /.../civitatis`, los outputs van a `/.../civitatis/docs/...`.

Con `plan.output_dir = /tmp/exports` (absoluto):

| Comando | Path resultante |
|---|---|
| `duck-plan PANA-123` (desde new-admin o old-admin) | `/tmp/exports/PANA-123/PANA-123_plan.<ext>` |

## Por qué

Todos los artefactos de un mismo ticket viven en una sola carpeta. Fácil de zip / share / archivar por ticket sin reconstruir el set manualmente.

## Validación

Cualquier nuevo skill que persista artefactos debe citar esta regla y aplicar `mkdir -p` + subcarpeta. Si un export bypassa la regla, es un bug.
