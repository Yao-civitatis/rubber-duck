# Spec-Driven Implementation Plan: duck-analyze marcadores ocultos + duck-plan input por archivo

> **🗄️ CERRADO — HISTÓRICO (2026-05-28).** S1 y S2 implementados y verificados. Ver §"Cierre / Resultado de implementación". No se reabre; cambios futuros en un plan nuevo.

## 1. Traceability (Spec-Driven)

- **Feature A:** `duck-analyze` — los marcadores `<!-- rubber-duck:start -->` / `<!-- rubber-duck:end -->` y el texto "Generado por rubber-duck (fecha)" se ven literales en la descripción de Jira. Hacerlos no visibles.
- **Feature B:** `duck-plan` — aceptar un archivo de entrada (`duck-plan tasks/new-task.md`) además de una JIRA-KEY, para planificar desde un contexto en archivo.
- **Branch:** `feature/analyze-hidden-markers-and-plan-file-input`
- **Evolves/Modifies:**
  - `skills/jira-analyzer/SKILL.md`, `skills/jira-analyzer/prompts/generate_story.md`, `commands/analyze.md` (Feature A)
  - `skills/task-planner/SKILL.md`, `skills/task-planner/prompts/build_plan.md`, `commands/plan.md` (Feature B)
- **Dependencies:** MCP de Atlassian (`editJiraIssue`/`getJiraIssue`). Sin cambios en `bin/` ni en `setup.sh`.
- **Target Module/Bounded Context:** `rubber-duck / skills jira-analyzer + task-planner`

## 2. ⚠️ Defensive Planning (Just-in-Time)

**Assumptions:**

- La descripción de Jira Cloud es **ADF** (Atlas Doc Format). Los `<!-- HTML comments -->` no son un nodo ADF → Jira los renderiza como **texto literal**, por eso se ven. Esta es la causa raíz.
- La detección idempotente actual busca las cadenas `rubber-duck:start` / `rubber-duck:end` en el texto de la descripción leída. Cualquier solución debe **preservar esas cadenas como ancla detectable**, aunque dejen de verse.
- El MCP de Atlassian acepta el cuerpo de la descripción y lo persiste; el formato exacto que admite (markdown vs ADF JSON) se confirma en S1 (ver Questions).
- Feature B no toca Jira: es un flujo paralelo de lectura local.

**Questions:**

- ¿El MCP `editJiraIssue` permite enviar marcas de color de texto (ADF `textColor`)? Si solo acepta markdown plano, el color blanco no es viable y hay que ir a la alternativa de "marcador fuera del texto visible" (ver S1, opción A2). → **Resolver en S1 con una prueba sobre un ticket de sandbox antes de fijar la estrategia.**
- ¿Existe acceso a **entity properties** del issue vía MCP (marcador idempotente totalmente fuera de la descripción)? Sería la solución más limpia ("dejar de ver" de verdad). Los tools MCP visibles son `getJiraIssue`/`editJiraIssue`/`addCommentToJiraIssue` — no hay tool de properties → se asume **no disponible** salvo que S1 demuestre lo contrario.
- Feature B: ¿el archivo de entrada puede declarar el proyecto (`new-admin`/`old-admin`) y una pseudo-key? Asunción: se infiere igual que en `generate_story.md` (heurística por contenido) y la key se deriva del nombre de archivo si no se declara.

## 3. Architectural Pre-flight Check

- [x] Cero cambios en `bin/`, `db-env.sh`, `setup.sh`. Solo prompts de skills + docs de comando.
- [x] Idempotencia de `duck-analyze` se mantiene: el ancla de detección sigue existiendo aunque no se vea.
- [x] `duck-plan` por archivo respeta `rules/export-paths.md` (una carpeta por unidad de trabajo) y `rules/self-contained.md` (plantilla siempre desde `$RUBBER_DUCK_HOME/templates/`).
- [x] Sin nuevo comando, sin nuevo skill, sin nuevo binario. Se extienden los dos comandos existentes.
- [x] Detección de proyecto reutiliza la heurística ya definida (no se duplica lógica).
- [x] R1 (Jira): Feature A sigue exigiendo confirmación expresa antes de escribir; Feature B solo lee local.

## 4. Execution (STRICT LIMIT: ONE SCENARIO AT A TIME)

---

### 🟢 ACTIVE SCENARIO 1: Marcadores e info de rubber-duck no visibles en la descripción de Jira

**Criteria:** *Given* `duck-analyze <KEY>` escribe el bloque en Jira, *When* el usuario abre la descripción del ticket, *Then* NO ve `<!-- rubber-duck:start -->`, `<!-- rubber-duck:end -->` ni la línea "Generado por rubber-duck (fecha)"; *And* una segunda ejecución sigue detectando el bloque y lo reemplaza in-place (idempotencia intacta).

**First Test Confirmation:** `skipped` *(cambios de prompt de skill — validación manual sobre ticket de sandbox)*

#### Estrategia (decidir en orden, primera viable gana)

- **A1 — Marcador fuera del texto visible (preferida si el MCP lo permite):** almacenar el ancla idempotente en una *entity property* del issue (p.ej. `rubberduck.block`) en lugar de en la descripción. La descripción solo contiene el contenido útil (User Story + AC + Consideraciones). "Dejar de ver" real. Requiere que el MCP exponga properties → **confirmar en la prueba de la Question**; si no existe, descartar y pasar a A2.
- **A2 — Color blanco vía ADF (fallback explícito pedido por el usuario):** mantener las cadenas ancla en la descripción pero envueltas en un nodo de texto con marca ADF `textColor` = `#FFFFFF`, en su propia línea. No visibles sobre fondo claro. El timestamp deja de ser un encabezado visible: se **funde dentro del marcador de apertura** (`rubber-duck:start generated=YYYY-MM-DD`), también en blanco.
- **A3 — Degradación segura:** si el MCP no preserva ni properties ni color (solo markdown plano), reducir el ruido al mínimo: un único marcador de una línea, sin el segundo marcador visible ni el encabezado "Generado por", y documentar la limitación. (Último recurso; no debería hacer falta.)

#### Archivos a modificar

**`skills/jira-analyzer/SKILL.md` — Paso 7 (Actualización idempotente):**
- Sustituir el bloque de inserción actual (marcadores HTML + encabezado `## Generado por rubber-duck (...)` visibles) por la estrategia elegida.
- Mantener la lógica de detección: buscar el ancla (`rubber-duck:start`/`end` o la property A1) en la descripción/issue leídos; reemplazo in-place si existe, append si no.
- Eliminar el encabezado visible "Generado por rubber-duck"; el timestamp viaja oculto en el ancla.

**`skills/jira-analyzer/prompts/generate_story.md`:**
- El bloque generado deja de incluir la línea visible de marca/branding. Solo User Story + AC + Consideraciones Técnicas quedan visibles.

**`commands/analyze.md`:**
- Actualizar §"Comportamiento" punto 6 e §"Idempotencia": describir que los marcadores ya no se ven (estrategia elegida) y que la detección sigue siendo robusta.

#### Checklist

- [x] Probar en ticket de sandbox qué admite `editJiraIssue` (markdown vs ADF; color; properties) → **fijado A2**. Resultados sobre PANA-4171: `editJiraIssue contentFormat=adf` acepta marca `textColor`; render = `<font color="#ffffff">rubber-duck:start ...</font>` (invisible en claro). `getJiraIssue` devuelve la descripción como **markdown** (color stripped) → la detección por subcadena sigue funcionando. **A1 descartado:** no hay tool MCP de entity-properties (`editJiraIssue` solo escribe `fields`).
- [x] Modificar `skills/jira-analyzer/SKILL.md` Paso 7 (marcadores blancos ADF + detección por subcadena + aviso de fidelidad).
- [x] Modificar `skills/jira-analyzer/prompts/generate_story.md` (nota: no emite marcadores ni branding; los añade el Paso 7).
- [x] Modificar `commands/analyze.md` (Comportamiento punto 6 + Idempotencia).
- [x] Verificación manual sobre PANA-4171: bloque escrito con marcadores en blanco, contenido visible; marcadores presentes en el read markdown (idempotencia OK). Ticket **restaurado** a su descripción original tras el test.
- [ ] **COMMIT:** pendiente (se hará en el cierre del plan, junto con S2).

---

### ✅ SCENARIO 2 (DONE): `duck-plan` acepta un archivo de entrada

*Implementado. Ver Cierre para detalle y desviaciones.*

**Vista previa de cambios:**

- **Invocación nueva** (`commands/plan.md` + `skills/task-planner/SKILL.md`):
  ```
  duck-plan <JIRA-KEY>          # flujo actual (lee Jira)
  duck-plan <ruta-archivo>      # flujo nuevo (lee archivo local como contexto)
  ```
- **Detección de modo (primer paso del flujo):**
  - Arg coincide con `^[A-Z]+-[0-9]+$` → **modo Jira** (sin cambios).
  - Arg es ruta a archivo existente (`.md`/`.txt`) → **modo archivo**: leer el archivo como input principal en lugar de la descripción de Jira.
  - Ni key válida ni archivo existente → error, exit 2.
- **Modo archivo — adaptaciones del flujo `task-planner`:**
  - Paso 1 (lectura del ticket) → leer el archivo local; no se llama al MCP.
  - **Pseudo-key / nombre del plan:** derivar del nombre de archivo (`tasks/new-task.md` → `new-task`). Traceability usa este nombre; `[Link to JIRA]` → `N/A (input por archivo: <ruta>)`.
  - **Detección de proyecto:** `$PROJECT_TYPE` si está definido; si no, heurística por contenido del archivo (misma de `generate_story.md`). Si no se resuelve → preguntar.
  - Pasos 2–5 (contexto, generación, persistencia) sin cambios estructurales.
- **Export path** (`rules/export-paths.md`): `<plan.output_dir>/<nombre>/<nombre>_plan.<ext>` (carpeta por unidad de trabajo, igual que con JIRA-KEY).
- **`build_plan.md`:** añadir nota de que `{JIRA_KEY}` se sustituye por la pseudo-key derivada en modo archivo, y que la sección Traceability marca el origen (archivo vs Jira).
- **Restricciones:** R1 sigue siendo "no escribe en Jira"; en modo archivo Jira no se toca en absoluto.

---

## 5. Closure Protocol (obligatorio al terminar la implementación)

> Este plan se **cierra como histórico** cuando la implementación termina. El proceso de cierre es parte del plan:

1. **Revisar** la implementación realizada contra cada escenario y checklist de este documento.
2. **Actualizar y corregir** este mismo archivo para reflejar lo que se hizo de verdad: marcar checklists, registrar **desviaciones justificadas** (p.ej. qué estrategia A1/A2/A3 se eligió y por qué), y anotar archivos realmente tocados.
3. **NO** añadir nuevos casos de implementación. Si surge trabajo nuevo, va en un plan `vN+1` aparte.
4. **Cerrar** con un banner `🗄️ CERRADO — HISTÓRICO` arriba y una sección "Cierre / Resultado de implementación" al final (mismo formato que `2026-05-28_plan_db_schema_extraction_v1.md`).
5. Actualizar `dev-history/README.md` (fila de la tabla) y, si la feature cambió superficie pública, `SPEC.md` / `README.md`.

## Resumen de archivos

| Archivo | Acción | Escenario |
|---|---|---|
| `skills/jira-analyzer/SKILL.md` | MODIFICAR (Paso 7) | S1 |
| `skills/jira-analyzer/prompts/generate_story.md` | MODIFICAR (quitar branding visible) | S1 |
| `commands/analyze.md` | MODIFICAR (Comportamiento + Idempotencia) | S1 |
| `skills/task-planner/SKILL.md` | MODIFICAR (modo archivo) | S2 |
| `skills/task-planner/prompts/build_plan.md` | MODIFICAR (pseudo-key, origen) | S2 |
| `commands/plan.md` | MODIFICAR (invocación + detección de modo) | S2 |
| `SPEC.md` / `README.md` | MODIFICAR si la feature cambia superficie pública | cierre |
| `bin/**`, `setup.sh` | sin cambios | — |

---

## Cierre / Resultado de implementación (2026-05-28)

S1 y S2 implementados y verificados. `SPEC.md` y `README.md` actualizados con ambas features.

### Archivos tocados (real)

| Archivo | Acción real | Esc. |
|---|---|---|
| `skills/jira-analyzer/SKILL.md` | Paso 7 reescrito: marcadores ADF en blanco `#FFFFFF`, detección por subcadena, aviso de fidelidad de media | S1 |
| `skills/jira-analyzer/prompts/generate_story.md` | nota: el bloque NO emite marcadores/branding (los añade el Paso 7) | S1 |
| `commands/analyze.md` | Comportamiento punto 6 + Idempotencia | S1 |
| `bin/duck.sh` | **(no previsto en el plan)** `PLAN_FILE_MODE` + detección de proyecto soft en file-mode + bloque neutro de proyecto cuando `$PROJECT_TYPE` vacío | S2 |
| `commands/plan.md` | invocación dual + detección de modo + export paths + exit codes | S2 |
| `skills/task-planner/SKILL.md` | modo archivo: lectura, inferencia de proyecto, pseudo-key, persistencia por slug | S2 |
| `skills/task-planner/prompts/build_plan.md` | pseudo-key + origen archivo en Traceability | S2 |
| `SPEC.md`, `README.md`, `dev-history/README.md` | documentación | cierre |

### Desviaciones respecto al plan (justificadas)

1. **S1 — estrategia elegida = A2 (color blanco ADF).** A1 (entity property) se **descartó**: el MCP no expone tool de properties (`editJiraIssue` solo escribe `fields`). A2 verificado en vivo sobre **PANA-4171**: `editJiraIssue contentFormat=adf` con marca `textColor #FFFFFF` → render `<font color="#ffffff">rubber-duck:start ...</font>` (invisible en claro); `getJiraIssue` devuelve markdown (color stripped) → detección por subcadena intacta. Ticket restaurado a su descripción original tras el test.
2. **S1 — añadido no previsto: aviso de fidelidad.** Como el MCP solo lee markdown, escribir ADF exige reconstruir la descripción → imágenes/paneles/tablas pueden degradarse a placeholder. Se añadió un flujo de aviso con opciones (modo oculto / modo compatible con marcadores visibles / cancelar). Caveat documentado: el blanco se ve tenue en modo oscuro de Jira.
3. **S2 — cambio en `bin/duck.sh` (no contemplado en la vista previa).** El bloqueante real era que el dispatcher exige detección de proyecto (exit 3) para todo comando no-agnóstico. Se añadió `PLAN_FILE_MODE` y detección soft: en file-mode sin proyecto, `$PROJECT_ROOT=$PWD`, `$PROJECT_TYPE=""` y el skill infiere/pregunta. Además se corrigió el bloque de restricciones para no forzar la política old-admin cuando `$PROJECT_TYPE` está vacío.

### Verificación

- S1: round-trip ADF probado en PANA-4171 (color blanco persiste, marcadores detectables, idempotencia OK), ticket restaurado.
- S2: `bash -n bin/duck.sh` OK; lógica de `PLAN_FILE_MODE` probada en aislamiento (JIRA-key → modo Jira; archivo existente → modo archivo; archivo inexistente / no-key → no file-mode, el skill devuelve exit 2).
