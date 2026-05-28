# Comando `duck-plan`

Genera un plan de implementación detallado a partir del análisis de un ticket de Jira. Guarda el resultado como `<JIRA-KEY>_plan.md`.

## Uso

```
duck-plan <JIRA-KEY>
```

Ejemplo:

```bash
cd ~/proyectos/tilt/tilts/new-admin
duck-plan PANA-123
# → genera <plan.output_dir>/PANA-123/PANA-123_plan.md
#   p.ej. ./PANA-123/PANA-123_plan.md con defaults
```

## Convención de paths de export

Aplica `$RUBBER_DUCK_HOME/rules/export-paths.md`: `<plan.output_dir>/<JIRA-KEY>/<JIRA-KEY>_plan.<ext>`. Los artefactos de un mismo ticket viven en una sola carpeta `<JIRA-KEY>/`.

## Comportamiento

Carga el skill `$RUBBER_DUCK_HOME/skills/task-planner/SKILL.md` y sigue su flujo:

1. **Lee el ticket** vía MCP de Atlassian, incluyendo cualquier bloque previo de `duck-analyze` entre marcadores.
2. **Carga el contexto** del proyecto detectado (`new-admin` o `old-admin`) leyendo el skill `project-context` correspondiente y, para new-admin, los archivos `$PROJECT_ROOT/.claude/{domain-index,project-context,refactoring-state}.md`.
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

- **R1 (Jira):** este comando solo **lee** de Jira. No escribe.
- **R2 (BBDD):** no toca BBDD. Si el plan implica queries, se describen como instrucciones, no se ejecutan.
- **§2.bis self-contained:** el plan se genera SIEMPRE desde `$RUBBER_DUCK_HOME/templates/planning-template.md`, nunca desde paths externos.

## Errores y exit codes

| Situación | Exit |
|---|---|
| Éxito | 0 |
| Lectura del ticket falló | 1 |
| Argumento `<JIRA-KEY>` faltante o malformado | 2 |
| Usuario canceló (archivo existe, o "no es mantenimiento" en old-admin) | 0 |
| Plantilla no encontrada | 2 |
| Detección de proyecto falló | 3 |
