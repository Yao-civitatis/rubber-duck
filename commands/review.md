# Comando `duck-review`

Revisa que el código en la rama actual cumple los Criterios de Aceptación del ticket de Jira. Genera un informe estructurado y, opcionalmente y tras confirmación, lo postea como comentario en el ticket.

## Uso

```
duck-review <JIRA-KEY>
```

Ejemplo:

```bash
cd ~/proyectos/tilt/tilts/new-admin
git checkout feature/PANA-123-refunds
duck-review PANA-123
```

## Comportamiento

Carga el skill `$RUBBER_DUCK_HOME/skills/task-reviewer/SKILL.md` y sigue su flujo:

1. **Lee el ticket** vía MCP (incluye los AC del bloque rubber-duck si existe).
2. **Calcula el diff** vs `main`/`master`.
3. **Lee los archivos cambiados** (versión actual).
4. **Carga el contexto del proyecto** (`skills/project-context/*.md` + `$PROJECT_ROOT/.claude/*` cuando aplique).
5. **Genera el informe** según `$RUBBER_DUCK_HOME/skills/task-reviewer/prompts/review.md`:
   - Cobertura de AC.
   - Calidad del cambio (R3-R6 para new-admin; scope + sentido común para old-admin).
   - Lista accionable de lo que falta.
   - Veredicto: 🟢 / 🟡 / 🔴.
6. **Muestra el informe** en pantalla.
7. **Exporta a archivo** si `review.export=true`.
8. **Pide confirmación** y postea como comentario en Jira si `review.update_jira=true` y el usuario acepta. Default = N (no postea).

## Restricciones

- **R1 (Jira):** la escritura **requiere confirmación expresa**. Default = N. Solo se postea como **comentario nuevo** (no edita comentarios previos ni la descripción).
- **R2 (BBDD):** no toca BBDD. Verificaciones que requieran datos se sugieren como queries para el usuario.
- **R3-R6 (new-admin):** se reportan en el informe, no se mutan.
- **Scope (old-admin):** se verifica. Cualquier path fuera del scope = bloqueante 🔴.

## Configuración relacionada

| Clave | Default | Efecto |
|---|---|---|
| `review.export` | `false` | Si `true`, guarda el informe a archivo |
| `review.export_format` | `md` | `md`, `html`, `json`, `txt` |
| `review.export_dir` | `.` | Raíz del directorio destino. Path final: `<review.export_dir>/<JIRA-KEY>/<JIRA-KEY>_review.<ext>` (ver `$RUBBER_DUCK_HOME/rules/export-paths.md`) |
| `review.update_jira` | `true` | Si `true`, ofrece postear comentario tras confirmación. Si `false`, ni siquiera pregunta. |
| `output.language` | `es` | Idioma del informe |

## Uso típico en hooks

- `git pre-push`: ejecuta `duck-review <KEY>` extrayendo la key del nombre de rama. Veredicto 🔴 = bloquea el push.
- Manual antes de PR: `duck-review <KEY>` y, si 🟢/🟡, confirmar el comentario en Jira para dejar constancia.

## Errores y exit codes

| Situación | Exit |
|---|---|
| 🟢 / 🟡 Listo (con o sin observaciones) | 0 |
| 🔴 No listo (AC sin cumplir, violaciones bloqueantes) | 1 |
| Lectura del ticket falló | 2 |
| Argumento `<JIRA-KEY>` faltante o malformado | 2 |
| Detección de proyecto falló | 3 |
| Sin cambios en la rama vs base | 0 (mensaje informativo) |
