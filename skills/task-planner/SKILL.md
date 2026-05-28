# Skill `task-planner`

Genera un plan de implementación detallado a partir de **un ticket de Jira** o **un archivo local** de contexto. Guarda el resultado como `<nombre>_plan.md` (o `.html`) en el directorio configurado.

## Invocación

```
duck-plan <JIRA-KEY>        # modo Jira
duck-plan <ruta-archivo>    # modo archivo
```

Ejemplos: `duck-plan PANA-123` → `./PANA-123/PANA-123_plan.md`; `duck-plan tasks/new-task.md` → `./new-task/new-task_plan.md`.

## Prerrequisitos

- **Modo Jira:** el ticket debe ser legible vía MCP de Atlassian.
- **Modo archivo:** el archivo de entrada debe existir y ser legible (`.md`/`.txt`). Jira no se usa.
- `$PROJECT_TYPE` lo exporta el dispatcher (`detect-project.sh`). En modo archivo puede venir **vacío** (invocado fuera de un repo) → se infiere en el Paso 2.
- `$PROJECT_ROOT/.claude/domain-index.md` se lee si existe (new-admin).
- `$RUBBER_DUCK_HOME/templates/planning-template.md` se usa como base.

## Detección de modo

El dispatcher marca `$PLAN_FILE_MODE=1` cuando el primer argumento no es una `^[A-Z]+-[0-9]+$` y es un archivo existente. Si `$PLAN_FILE_MODE=1` → **modo archivo**; si no → **modo Jira**. Si el argumento no es ni key válida ni archivo existente → error, exit 2.

## Flujo

### Paso 1 — Lectura de la fuente de contexto

**Modo Jira:** lee el ticket completo vía MCP, incluyendo descripción actual. Si la descripción contiene un bloque entre marcadores `rubber-duck:start` … `rubber-duck:end` (visibles u **ocultos en blanco**; detección por subcadena), **úsalo como input principal** (es el resultado de `duck-analyze`). Si no, usa la descripción cruda.

**Modo archivo:** lee el archivo local indicado como input principal. **No** se llama al MCP. Deriva la **pseudo-key** del basename sin extensión (`tasks/new-task.md` → `new-task`); se usa donde el flujo Jira usaría `<JIRA-KEY>`. El link a Jira en Traceability queda como `N/A (input por archivo: <ruta>)`.

### Paso 2 — Carga de contexto

**Resolución del proyecto:** si `$PROJECT_TYPE` está definido, úsalo. Si está **vacío** (modo archivo fuera de un repo), infiere `new-admin`/`old-admin` del contenido del input con la heurística de `$RUBBER_DUCK_HOME/skills/jira-analyzer/prompts/generate_story.md` §"Detección de proyecto" (componentes, labels, paths mencionados). Si no queda claro → **pregunta al usuario** antes de continuar; no asumas old-admin por defecto. En modo archivo puede que `$PROJECT_ROOT/.claude/*` no exista → omite esas lecturas y básate en el contenido del archivo.

Según el proyecto resuelto:

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
<plan.output_dir>/<slug>/<slug>_plan.<ext>
```

donde:

- `<slug>` = la `<JIRA-KEY>` (modo Jira) o la **pseudo-key** derivada del basename del archivo sin extensión (modo archivo; `tasks/new-task.md` → `new-task`).
- `<plan.output_dir>` viene de config (default `.`). **Si es relativo, se resuelve contra `$PROJECT_ROOT`**; si es absoluto (empieza por `/` o `~`), se usa tal cual. En modo archivo sin proyecto, `$PROJECT_ROOT` es el CWD.
- `<ext>` viene de `plan.output_format` (default `md`).
- Si por algún motivo no hubiera `<slug>` (defensivo), usar `<plan.output_dir>/plan/plan.<ext>`.

Procedimiento:

1. Resolver `<plan.output_dir>` aplicando la regla anterior → `resolved_output_dir`.
2. Calcular `dest_dir = "$resolved_output_dir/<slug>"`.
3. `mkdir -p "$dest_dir"`.
4. Calcular `dest_file = "$dest_dir/<slug>_plan.<ext>"`.
5. Si `$dest_file` ya existe → preguntar:
   ```
   Ya existe <ruta>. ¿Qué hago?
     [s] Sobrescribir
     [b] Crear backup .bak y sobrescribir
     [N] Cancelar
   > _
   ```
6. Escribe el archivo.
7. Confirma: `✓ Plan guardado en <ruta>`.

### Paso 5 — Salida

- Éxito: exit 0, ruta del archivo en stdout.
- Lectura de la fuente (ticket o archivo) falló: exit 1.
- Argumento que no es ni `<JIRA-KEY>` válida ni archivo existente: exit 2.
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
