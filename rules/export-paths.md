# Regla: convención universal de paths de export

**Aplica a:** cualquier comando `duck-*` que persista artefactos a disco (planes, informes, exports de análisis, etc.).

## Patrón

```
<config.output_dir>/<carpeta>/<filename>
```

donde:

- `<config.output_dir>` es la clave de config correspondiente al comando (`plan.output_dir`, `audit.export_dir`, `review.export_dir`, `analyze.export_dir`, etc.). Default: `.`.
- `<carpeta>` es:
  - **`<JIRA-KEY>`** cuando el comando tiene clave de Jira disponible (caso normal).
  - **`<cmd>`** (nombre del comando sin prefijo `duck-`) como fallback defensivo cuando no hay clave.
- `<filename>` mantiene la forma `<JIRA-KEY>_<cmd>.<ext>` o `<slug>_<cmd>.<ext>` cuando no hay key.

## Procedimiento obligatorio

Cualquier skill que exporte debe:

1. Calcular `dest_dir`.
2. `mkdir -p "$dest_dir"`.
3. Calcular `dest_file`.
4. Si `$dest_file` ya existe → preguntar sobrescribir / backup `.bak` / cancelar.
5. Escribir el archivo.
6. Confirmar al usuario con `✓ <tipo> guardado en <ruta>`.

## Ejemplos

| Comando | Path resultante |
|---|---|
| `duck-analyze PANA-123` (opción `e`) | `<analyze.export_dir>/PANA-123/PANA-123_analyze.<ext>` |
| `duck-plan PANA-123` | `<plan.output_dir>/PANA-123/PANA-123_plan.<ext>` |
| `duck-review PANA-123` (export=true) | `<review.export_dir>/PANA-123/PANA-123_review.<ext>` |
| `duck-audit --branch` (rama `feature/PANA-123-foo`) | `<audit.export_dir>/PANA-123/PANA-123_audit.<ext>` |
| `duck-audit src/X.php` (sin key) | `<audit.export_dir>/audit/X.php_audit.<ext>` |
| `duck-audit all` (sin key) | `<audit.export_dir>/audit/all_audit.<ext>` |

## Por qué

Todos los artefactos de un mismo ticket viven en una sola carpeta. Fácil de zip / share / archivar por ticket sin reconstruir el set manualmente.

## Validación

Cualquier nuevo skill que persista artefactos debe citar esta regla y aplicar `mkdir -p` + subcarpeta. Si un export bypassa la regla, es un bug.
