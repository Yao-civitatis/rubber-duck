# Comando `duck-plan`

Genera un plan de implementación detallado. La fuente del contexto puede ser **un ticket de Jira** (`<JIRA-KEY>`) **o un archivo local** (`<ruta>.md`). Guarda el resultado como `<nombre>_plan.md`.

## Uso

```
duck-plan <JIRA-KEY>        # lee el ticket de Jira (flujo Jira)
duck-plan <ruta-archivo>    # lee un archivo local como contexto (flujo archivo)
```

Ejemplos:

```bash
cd ~/proyectos/tilt/tilts/new-admin
duck-plan PANA-123
# → genera <plan.output_dir>/PANA-123/PANA-123_plan.md

duck-plan tasks/new-task.md
# → genera <plan.output_dir>/new-task/new-task_plan.md
#   (no toca Jira; el contexto sale del archivo)
```

### Detección de modo (primer argumento)

- Coincide con `^[A-Z]+-[0-9]+$` → **modo Jira** (lee el ticket vía MCP).
- Es la ruta a un archivo existente → **modo archivo** (lee el archivo como input principal; Jira no se toca).
- Ni key válida ni archivo existente → error, exit 2.

## Convención de paths de export

Aplica `$RUBBER_DUCK_HOME/rules/export-paths.md`:
- Modo Jira: `<plan.output_dir>/<JIRA-KEY>/<JIRA-KEY>_plan.<ext>`.
- Modo archivo: `<plan.output_dir>/<nombre>/<nombre>_plan.<ext>`, donde `<nombre>` es el basename del archivo de entrada sin extensión (`tasks/new-task.md` → `new-task`).

Los artefactos de una misma unidad de trabajo viven en una sola carpeta.

## Comportamiento

Carga el skill `$RUBBER_DUCK_HOME/skills/task-planner/SKILL.md` y sigue su flujo:

1. **Lee la fuente de contexto:**
   - Modo Jira → lee el ticket vía MCP de Atlassian, incluyendo cualquier bloque previo de `duck-analyze` entre marcadores (visibles u ocultos).
   - Modo archivo → lee el archivo local indicado como input principal. **No** llama a Jira. La pseudo-key del plan es el basename sin extensión; el link a Jira queda como `N/A (input por archivo: <ruta>)`.
2. **Carga el contexto** del proyecto: usa `$PROJECT_TYPE` si está definido (el dispatcher lo detecta). En modo archivo sin proyecto detectado, **infiere** new-admin/old-admin del contenido del archivo (heurística de `generate_story.md`); si no queda claro, pregunta. Luego lee el skill `project-context` correspondiente y, para new-admin, `$PROJECT_ROOT/.claude/{domain-index,project-context,refactoring-state}.md` si están disponibles.
3. **Adapta la plantilla** `$RUBBER_DUCK_HOME/templates/planning-template.md` siguiendo las reglas de `$RUBBER_DUCK_HOME/skills/task-planner/prompts/build_plan.md`.
4. **Detecta el dominio** consultando `domain-index.md` (new-admin) o el scope `/admin` (old-admin).
5. **Para old-admin:** valida que el cambio sea bug fix / mantenimiento. Si parece funcionalidad nueva, pide confirmación expresa al usuario antes de continuar.
6. **Guarda el archivo** en `plan.output_dir` con extensión `plan.output_format` (default `./PROJ-XXX_plan.md`).
7. **Si el archivo ya existía**, pregunta si sobrescribir / crear `.bak` / cancelar.

## Configuración relacionada

| Clave | Default | Efecto |
|---|---|---|
| `plan.output_format` | `md` | `md` o `html` |
| `plan.output_dir` | `.` | Directorio donde se guarda el plan |
| `output.language` | `es` | El plan se escribe en inglés siempre (regla del template), pero los mensajes interactivos siguen este idioma |

## Restricciones

- **R1 (Jira):** en modo Jira solo **lee**, no escribe. En modo archivo **no toca Jira** en absoluto.
- **R2 (BBDD):** no toca BBDD. Si el plan implica queries, se describen como instrucciones, no se ejecutan.
- **§2.bis self-contained:** el plan se genera SIEMPRE desde `$RUBBER_DUCK_HOME/templates/planning-template.md`, nunca desde paths externos.

## Errores y exit codes

| Situación | Exit |
|---|---|
| Éxito | 0 |
| Lectura del ticket (modo Jira) o del archivo (modo archivo) falló | 1 |
| Argumento faltante, o no es ni `<JIRA-KEY>` válida ni archivo existente | 2 |
| Usuario canceló (archivo existe, o "no es mantenimiento" en old-admin) | 0 |
| Plantilla no encontrada | 2 |
| Detección de proyecto falló (modo Jira; en modo archivo se infiere/pregunta) | 3 |
