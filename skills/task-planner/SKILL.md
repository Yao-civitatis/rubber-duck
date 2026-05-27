# Skill `task-planner`

Genera un plan de implementación detallado a partir de un ticket de Jira analizado. Guarda el resultado como `<JIRA-KEY>_plan.md` (o `.html`) en el directorio configurado.

## Invocación

`duck-plan <JIRA-KEY>`

Ejemplo: `duck-plan PANA-123` → genera `./PANA-123_plan.md`.

## Prerrequisitos

- El ticket debe ser legible vía MCP de Atlassian.
- `$PROJECT_TYPE` debe estar definido (`new-admin` o `old-admin`). El dispatcher lo exporta tras `detect-project.sh`.
- `$PROJECT_ROOT/.claude/domain-index.md` se lee si existe (new-admin).
- `$RUBBER_DUCK_HOME/templates/planning-template.md` se usa como base.

## Flujo

### Paso 1 — Lectura del ticket

Lee el ticket completo vía MCP, incluyendo descripción actual. Si la descripción contiene un bloque `<!-- rubber-duck:start --> ... <!-- rubber-duck:end -->`, **úsalo como input principal** (es el resultado de `duck-analyze`). Si no, usa la descripción cruda.

### Paso 2 — Carga de contexto

Según `$PROJECT_TYPE`:

**new-admin:**
1. Lee `$RUBBER_DUCK_HOME/skills/project-context/new_admin.md`.
2. Lee `$PROJECT_ROOT/CLAUDE.md` si existe.
3. Lee `$PROJECT_ROOT/.claude/domain-index.md` y mapea el dominio del ticket → controllers/services/rutas concretos.
4. Lee `$PROJECT_ROOT/.claude/refactoring-state.md` y comprueba si las piezas afectadas están migradas a hexagonal o aún siguen patrón legacy.

**old-admin:**
1. Lee `$RUBBER_DUCK_HOME/skills/project-context/old_admin.md`.
2. Verifica que el cambio cabe en la política mantenimiento-only. Si parece funcionalidad nueva, advierte al usuario y propón hacerlo en new-admin. Pide confirmación expresa para continuar.
3. Identifica qué paths del scope `/admin` se tocarán (lista exhaustiva en el skill de context).

### Paso 3 — Generación del plan

Sigue el formato definido en `$RUBBER_DUCK_HOME/templates/planning-template.md`, adaptado vía `$RUBBER_DUCK_HOME/skills/task-planner/prompts/build_plan.md`. Estructura mínima del plan:

1. **Traceability** — JIRA-KEY, link, rama esperada (`feature/JIRA-KEY` o `bugfix/JIRA-KEY`), módulo objetivo.
2. **Defensive Planning** — suposiciones y preguntas pendientes.
3. **Architectural Pre-flight Check** — checklist específico del proyecto:
   - new-admin: capas hexagonales, no leak de Models a Controllers, YAGNI.
   - old-admin: scope `/admin` validado, ningún path fuera, política mantenimiento confirmada.
4. **Execution (ONE scenario at a time)** — expande solo el **primer** escenario activo. El resto queda como `[Pending Planning]`.
   - Test matrix con `T1`, `T2`, ... cada uno mapeado a un X-Ray ID (o pseudo-ID si no aplica).
   - RED → GREEN → REFACTOR → COMMIT por escenario.
   - Para old-admin no hay test matrix formal; sustituye por checklist de verificación manual (qué endpoints/vistas comprobar tras el cambio).

### Paso 4 — Persistencia

Sigue la **convención universal de paths de export** definida en `$RUBBER_DUCK_HOME/rules/export-paths.md`:

```
<plan.output_dir>/<JIRA-KEY>/<JIRA-KEY>_plan.<ext>
```

donde:

- `<plan.output_dir>` viene de config (default `.`).
- `<ext>` viene de `plan.output_format` (default `md`).
- `<JIRA-KEY>` es la clave del ticket (siempre disponible para `duck-plan`).
- Si por algún motivo no hubiera key (defensivo), usar `<plan.output_dir>/plan/plan.<ext>`.

Procedimiento:

1. Calcular `dest_dir = "<plan.output_dir>/<JIRA-KEY>"`.
2. `mkdir -p "$dest_dir"`.
3. Calcular `dest_file = "$dest_dir/<JIRA-KEY>_plan.<ext>"`.
4. Si `$dest_file` ya existe → preguntar:
   ```
   Ya existe <ruta>. ¿Qué hago?
     [s] Sobrescribir
     [b] Crear backup .bak y sobrescribir
     [N] Cancelar
   > _
   ```
5. Escribe el archivo.
6. Confirma: `✓ Plan guardado en <ruta>`.

### Paso 5 — Salida

- Éxito: exit 0, ruta del archivo en stdout.
- Lectura del ticket falló: exit 1.
- Usuario canceló al detectarse "funcionalidad nueva en old-admin": exit 0 con mensaje claro.
- Plantilla no encontrada: exit 2.

## Restricciones

- **R1 (Jira):** este skill **no escribe** en Jira. Solo lee.
- **R2 (BBDD):** no accede a BBDD. Si el plan lo requiere para verificación, se especifica como query a ejecutar por el usuario.
- **§2.bis self-contained:** lee siempre `$RUBBER_DUCK_HOME/templates/planning-template.md`, **nunca** referencia paths externos como `/home/<usuario>/proyectos/ai-development-rules/...`.

## Idempotencia

Llamar `duck-plan PANA-123` dos veces:
- Sin cambios en el ticket → produce el mismo plan (modulo timestamp en cabecera).
- Si el archivo ya existe → pregunta antes de sobrescribir.
