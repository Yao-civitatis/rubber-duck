# Spec-Driven Implementation Plan: `duck-onboarding` → `duck-ask` (experto multinivel + honestidad)

> **🗄️ CERRADO — HISTÓRICO (2026-05-29).** S1 y S2 implementados y verificados. Ver §"Cierre / Resultado de implementación". No se reabre; cambios futuros en un plan nuevo `vN+1`.

## 1. Traceability (Spec-Driven)

- **Requisito (origen):** petición directa del usuario (no hay Jira key; es desarrollo de la propia herramienta rubber-duck).
- **Cambio de responsabilidad:** el comando deja de ser solo onboarding de developers nuevos. Pasa a ser un **experto consultable** que responde cualquier pregunta sobre new-admin y old-admin, **a nivel junior y senior**. Cuando no sabe algo, **no inventa**: responde con sinceridad "no lo sé" y, si procede, a quién/dónde preguntar.
- **Cambio de nombre:** `duck-onboarding` → `duck-ask` (nombre elegido por el usuario; "onboarding" se quedaba corto para el nuevo alcance).
- **Branch:** `feature/rename-onboarding-to-ask`
- **Evolves/Modifies:**
  - `commands/onboarding.md` → `commands/ask.md`
  - `agents/onboarding-agent.md` → `agents/ask-agent.md`
  - `setup.sh`, `uninstall.sh` (array `COMMANDS`)
  - `bin/lib/help.sh` (5 referencias: HELP_SHORT, HELP_USAGE, HELP_DETAILS, orden de listado)
  - `README.md`, `SPEC.md` (superficie pública documentada)
- **Dependencies:** ninguna. Sin cambios en `bin/duck.sh` (el dispatcher resuelve `commands/<cmd>.md` por nombre; con renombrar el archivo basta). Sin cambios en MCP ni en BBDD.
- **Target Module/Bounded Context:** `rubber-duck / commands + agents + instaladores + docs`

## 2. ⚠️ Defensive Planning (Just-in-Time)

**Assumptions:**

- `bin/duck.sh` no hardcodea `onboarding` en ningún `case`/short-circuit (verificado: los short-circuits son `help`, `install-hooks`, `config`, `db`, `plan`). El comando `ask` cae por el flujo normal `claude --append-system-prompt`, igual que hoy onboarding. → **No hay que tocar `duck.sh`.**
- El comando es de **solo lectura** y así sigue: sin escribir Jira/BBDD/código. El cambio de alcance amplía el *nivel* de las preguntas (junior→senior), no los permisos.
- La regla "no inventar" es un cambio de **prompt** (personalidad/output del agente), no de lógica de bash.
- El nombre `ask` no colisiona con ningún comando existente (`analyze, plan, implement, review, audit, sync-docs, config, help, debug, migrate, db, standup, upgrade, install-hooks`).
- Los wrappers `~/.local/bin/duck-<cmd>` los regenera `setup.sh`; el usuario tendrá que re-ejecutar `setup.sh` (o crear el wrapper `duck-ask`) para que el comando exista en su PATH. El wrapper viejo `duck-onboarding` lo limpia `uninstall.sh` o queda huérfano hasta re-setup → se documenta.

**Questions:**

- ¿Mantener un alias `duck-onboarding` por retrocompat? → **No.** La herramienta está en v1 temprana, sin usuarios externos; un alias añade superficie muerta. Rename limpio. (Si el usuario lo pide, va en plan aparte.)
- ¿El nivel "senior" implica capacidades nuevas (ejecutar tools, análisis profundo de código)? → El agente ya puede leer código/docs en modo lectura. "Senior" = profundidad y alcance de las respuestas (decisiones de arquitectura, trade-offs, integraciones, edge-cases de stack), no permisos nuevos. Sin cambios de restricciones.

## 3. Architectural Pre-flight Check

- [x] Cero cambios en `bin/duck.sh`, `db-env.sh`, MCP. Solo rename de 2 archivos + arrays de instalador + help + prompts + docs.
- [x] El rename usa `git mv` para preservar historia.
- [x] Restricciones operacionales intactas: R1 (Jira solo lectura en esta sesión), R2 (no toca BBDD), sin acciones destructivas. Ampliar alcance NO afloja permisos.
- [x] Orden de comandos en `setup.sh` / `uninstall.sh` / `help.sh` se mantiene sincronizado (los tres listan en el mismo orden; `ask` ocupa la posición que tenía `onboarding`).
- [x] La regla "no lo sé" se expresa en el agente como comportamiento de primera clase (sección "Honestidad", no nota al pie).

## 4. Execution (STRICT LIMIT: ONE SCENARIO AT A TIME)

---

### 🟢 ACTIVE SCENARIO 1: `duck-onboarding` se renombra a `duck-ask` en toda la superficie

**Criteria:** *Given* el repo rubber-duck, *When* se completa el rename, *Then* existe `commands/ask.md` y `agents/ask-agent.md` (y NO existen los `onboarding*`), `setup.sh`/`uninstall.sh` listan `ask`, `duck-help` muestra `duck-ask` con su descripción/uso/detalle, y `grep -rin onboarding` fuera de `dev-history/` solo devuelve usos ajenos (p.ej. `USAGE.md` "Onboarding" de new-admin, que es otra cosa).

**First Test Confirmation:** `skipped` *(cambio mecánico de naming + prompts; validación por `grep` + `bash -n` + `duck-help`).*

#### Archivos a modificar

- **`commands/onboarding.md` → `commands/ask.md`** (`git mv`): renombrar; título y cuerpo se reescriben en S2.
- **`agents/onboarding-agent.md` → `agents/ask-agent.md`** (`git mv`): renombrar; cuerpo se reescribe en S2. La referencia interna del comando al agente pasa a `agents/ask-agent.md`.
- **`setup.sh`** (array `COMMANDS`): `onboarding` → `ask` (misma posición).
- **`uninstall.sh`** (array `COMMANDS`): `onboarding` → `ask`.
- **`bin/lib/help.sh`** (5 puntos):
  - `HELP_SHORT[onboarding]` → `HELP_SHORT[ask]` (texto nuevo en S2).
  - `HELP_USAGE[onboarding]="duck-onboarding"` → `HELP_USAGE[ask]="duck-ask [\"pregunta\"]"`.
  - `HELP_DETAILS[onboarding]` → `HELP_DETAILS[ask]` (texto nuevo en S2).
  - Bucle de orden de listado: `onboarding` → `ask`.

#### Checklist

- [x] `git mv` de los 2 archivos.
- [x] `setup.sh` y `uninstall.sh` actualizados (clave `ask`).
- [x] `help.sh`: 4 claves de array + 1 token del bucle de orden cambiados a `ask`.
- [x] `bash -n setup.sh uninstall.sh bin/lib/help.sh bin/duck.sh` → OK.
- [x] `bin/lib/help.sh` ejecuta y muestra `duck-ask`; `bin/lib/help.sh ask` muestra el detalle.
- [x] `grep -rin duck-onboarding|onboarding-agent|onboarding.md` (excluyendo `dev-history/` y `.git/`) → sin referencias propias del comando.

---

### 🟢 SCENARIO 2 (implementado): el agente es experto multinivel (junior+senior) y no inventa

**Criteria:** *Given* `duck-ask "<pregunta>"` sobre new-admin u old-admin, *When* la pregunta es de nivel junior (estructura, naming) **o** senior (trade-offs de arquitectura, integraciones, edge-cases de stack), *Then* responde con detalle y citas concretas (archivo:línea, doc, dominio); *And* cuando la respuesta requiere información que no tiene (decisión histórica no documentada, dato fuera de docs/código), responde **"no lo sé"** sin inventar y sugiere a quién/dónde preguntar.

**First Test Confirmation:** `skipped` *(cambio de prompt del agente/comando — validación por revisión del contenido).*

#### Implementado

- `agents/ask-agent.md`: propósito redefinido (experto consultable, el onboarding es un uso, no el único), personalidad que **ajusta la profundidad al nivel de la pregunta** (junior vs senior), y sección **"Honestidad (regla de primera clase)"**: prohibido inventar soluciones/archivos/APIs/decisiones; si no consta en docs/código/reglas → "no lo sé" + a quién/dónde preguntar; distinguir saber vs suposición. Inputs típicos etiquetados *(junior)*/*(senior)*. Restricciones de solo lectura intactas (nota explícita: el alcance senior no afloja permisos).
- `commands/ask.md`: propósito reescrito, uso dual (`duck-ask` interactivo / `duck-ask "pregunta"`), sección **"Honestidad (no inventar)"**, ejemplos agrupados en Junior / Senior / Workflow, referencia al agente `ask-agent.md`.
- `bin/lib/help.sh`: `HELP_SHORT[ask]` y `HELP_DETAILS[ask]` reflejan el experto multinivel y la regla de honestidad.

---

## 5. Closure Protocol (obligatorio al terminar la implementación)

> Este plan se **cierra como histórico** cuando la implementación termina. El cierre es parte del plan:

1. **Revisar** la implementación contra cada escenario y checklist.
2. **Actualizar y corregir** este archivo para reflejar lo que se hizo de verdad: marcar checklists, registrar **desviaciones justificadas**, anotar archivos realmente tocados.
3. **NO** añadir nuevos casos de implementación. Si surge trabajo nuevo, va en un plan `vN+1` aparte.
4. **Cerrar** con un banner `🗄️ CERRADO — HISTÓRICO` arriba y una sección "Cierre / Resultado de implementación" al final.
5. Actualizar `dev-history/README.md` (fila de la tabla) y, como la feature cambia superficie pública, `SPEC.md` / `README.md`.

## Resumen de archivos

| Archivo | Acción | Escenario |
|---|---|---|
| `commands/onboarding.md` → `commands/ask.md` | RENOMBRAR + reescribir | S1 + S2 |
| `agents/onboarding-agent.md` → `agents/ask-agent.md` | RENOMBRAR + reescribir | S1 + S2 |
| `setup.sh` | MODIFICAR (array COMMANDS) | S1 |
| `uninstall.sh` | MODIFICAR (array COMMANDS) | S1 |
| `bin/lib/help.sh` | MODIFICAR (HELP_SHORT/USAGE/DETAILS + orden) | S1 + S2 |
| `README.md` | MODIFICAR (tabla de comandos) | cierre |
| `SPEC.md` | MODIFICAR (árbol, tablas, descripción del agente) | cierre |
| `bin/duck.sh`, MCP | sin cambios | — |

---

## Cierre / Resultado de implementación (2026-05-29)

S1 y S2 implementados y verificados. `README.md`, `SPEC.md` y `dev-history/README.md` actualizados.

### Archivos tocados (real)

| Archivo | Acción real | Esc. |
|---|---|---|
| `commands/onboarding.md` → `commands/ask.md` | `git mv` + reescritura completa (experto multinivel, sección Honestidad, uso dual, ejemplos junior/senior) | S1+S2 |
| `agents/onboarding-agent.md` → `agents/ask-agent.md` | `git mv` + reescritura (propósito, personalidad por nivel, sección "Honestidad" de primera clase, inputs etiquetados) | S1+S2 |
| `setup.sh` | array `COMMANDS`: `onboarding` → `ask` | S1 |
| `uninstall.sh` | array `COMMANDS`: `onboarding` → `ask` | S1 |
| `bin/lib/help.sh` | `HELP_SHORT[ask]`, `HELP_USAGE[ask]`, `HELP_DETAILS[ask]` reescritos + token del bucle de orden | S1+S2 |
| `README.md` | tabla de comandos: fila `duck-ask` | cierre |
| `SPEC.md` | árbol (agents/, commands/), tabla de comandos, tabla de agentes, sección `agents/ask-agent.md` | cierre |
| `dev-history/README.md` | fila nueva en la tabla de entradas | cierre |
| `bin/duck.sh`, MCP, `db-env.sh` | **sin cambios** (confirmado: el dispatcher resuelve `commands/<cmd>.md` por nombre, sin hardcodear `onboarding`) | — |

### Desviaciones respecto al plan (justificadas)

1. **Sin alias de retrocompat `duck-onboarding`** — decidido en §2 Questions. Rename limpio; la herramienta es v1 temprana sin usuarios externos.
2. **`HELP_USAGE` no estaba listado como punto explícito en el checklist de S1** (decía "4 claves de array") pero sí se actualizó: `HELP_USAGE[ask]="duck-ask [\"<pregunta>\"]"`. Sin impacto: estaba dentro del alcance de "help.sh, todas las referencias".
3. **Ningún caso nuevo de implementación añadido** durante el cierre (conforme al Closure Protocol).

### Verificación

- `bash -n setup.sh uninstall.sh bin/lib/help.sh bin/duck.sh` → **OK**.
- `bin/lib/help.sh` lista `duck-ask` con la nueva descripción; `bin/lib/help.sh ask` renderiza USO + cuerpo + sección HONESTIDAD + EJEMPLOS.
- `grep -rin "duck-onboarding|onboarding-agent|onboarding.md"` (excl. `dev-history/`, `.git/`) → **0 referencias** al comando antiguo. (Quedan, intencionadas: la palabra "onboarding" como concepto en `help.sh`/`ask.md`, y la categoría "Onboarding" de `USAGE.md` en `skills/project-context/new_admin.md`, que es ajena al comando.)
- Pendiente del usuario: re-ejecutar `setup.sh` (o crear el wrapper `~/.local/bin/duck-ask`) para que el comando exista en el PATH; el wrapper viejo `duck-onboarding` queda huérfano hasta re-setup o `uninstall.sh`.