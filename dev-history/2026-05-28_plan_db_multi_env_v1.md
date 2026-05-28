# Plan de Implementación — `duck-db` multi-entorno + read-only reforzado

> **Fecha de redacción:** 2026-05-28
> **Fecha de cierre:** 2026-05-28
> **Estado:** ✅ completado (F1–F8). Tests 24/24 PASS. F7 self-review aplicado sin nuevo scope.
> **Iteración:** v1 (primer plan post-MVP que extiende `duck-db`)
> **Scope congelado:** las fases F1–F8 son el alcance total. F7 = self-review; F7 puede corregir defectos detectados sobre F1–F6 pero **NO puede añadir fases nuevas ni ampliar el scope funcional**.

## Estado final por fase

| Fase | Estado | Notas |
|---|---|---|
| F1 — Schema v2 | ✅ | `mcp/database/config.example.json` reescrito. Legacy backup borrado en F8. |
| F2 — `db-env.sh` + tests | ✅ | 24/24 tests PASS. Gates `(a)..(e)` implementadas. |
| F3 — Wizard multi-env | ✅ | `skills/config/SKILL.md` Paso 10 reescrito. |
| F4 — Agente env-aware | ✅ | `agents/db-agent.md` con tabla de gates + protocolo por query. |
| F5 — `--env=` + dispatcher | ✅ | `commands/db.md` + `bin/duck.sh` sección 4.5. Verificado con DUCK_DRY_RUN. |
| F6 — R2.1 en reglas | ✅ | `rules/operational-restrictions.md`. |
| F7 — Self-review | ✅ | 1 fix cosmético aplicado (`keys_unsorted`). Sin items out-of-scope. |
| F8 — Cierre | ✅ | Legacy borrado, plan marcado cerrado, README actualizado. |

## 0. Resumen ejecutivo

Extender `duck-db` para soportar múltiples entornos de base de datos (`dev`, `slave`, `qa`, `prod`) guardados en un único `~/.rubber-duck/mcp/database/config.json` con clave `environments`. Sin flag explícito, `duck-db` opera **siempre sobre `dev`**. Los entornos `slave`, `qa` y `prod` requieren `--env=<nombre>` en cada invocación y aplican un sistema de **gates** anti-mutación escalonado por nivel de peligro (`low` → `critical`).

Objetivo no negociable: **antes de ejecutar cada query sobre `slave` o `prod`, garantizar al 1000% que la conexión es read-only** mediante triple verificación (config flag + variables servidor + privilegios usuario MySQL + regex query + confirmación interactiva).

## 1. Trazabilidad

- **Comando afectado:** `duck-db` (`commands/db.md`)
- **Agente afectado:** `agents/db-agent.md`
- **Skill afectado:** `skills/config/SKILL.md` (Paso 10 — wizard MCP database)
- **Schema/config:** `mcp/database/config.example.json`, `bin/lib/config.sh`
- **Reglas afectadas:** `rules/operational-restrictions.md` (R2 — extensión por nivel)
- **Restricciones globales aplicables:** R2 (read-only obligatorio), R7 (BBDD compartida new-admin ↔ old-admin)
- **Dependencias:** ninguna externa nueva. Sigue dependiendo de `jq` y del MCP de MySQL ya existente.

## 2. Defensive planning

**Asunciones:**
- El MCP de base de datos acepta un parámetro de conexión por invocación (no requiere un único `config.json` fijo).
- Las credenciales de `slave` y `prod` que el usuario configure corresponden a un usuario MySQL con permisos `SELECT` exclusivos (no `civitatis@%` que tiene `ALL PRIVILEGES`).
- `SHOW GRANTS FOR CURRENT_USER` y `SELECT @@global.read_only, @@global.super_read_only` están permitidos para cualquier usuario lector.

**Decisiones confirmadas con el usuario (2026-05-28):**
- D1: Nombre `slave` se mantiene (no se usa `replica`/`readonly`).
- D2: `qa` aplica gate `(a)` config + `(d)` regex + `(e)` confirmación interactiva simple. Sin gates de servidor `(b)(c)`.
- D3: `prod` exige confirmación tipeando literalmente `prod` como segundo paso (anti-typo).

## 3. Architectural pre-flight

- [ ] Configuración local (no en repo) — `config.json` sigue en `.gitignore`, los datos personales del usuario no se comprometen.
- [ ] El nuevo loader `bin/lib/db-env.sh` no acopla con `bin/lib/config.sh`; se puede invocar independientemente (separación de concerns: `config.sh` = config general de `rubber-duck`; `db-env.sh` = config específica de MCP BBDD).
- [ ] No se duplica lógica del agente en bash: las gates de seguridad están en bash (rápidas, reusables por otras herramientas), pero el agente sigue ejecutando el rechazo regex sobre la query final.
- [ ] YAGNI: NO añadir soporte multi-BBDD (PostgreSQL, etc.) ni multi-cluster. Solo MySQL `civitatis` por env.

## 4. Fases

### F1 — Schema del config + plantilla

**Archivos:**
- `mcp/database/config.example.json` — reescribir.
- `mcp/database/config.example.legacy.json` — copia del schema antiguo, **solo para referencia** durante migración manual del usuario (se borra en F8).

**Nuevo schema:**

```json
{
  "_comment": "Multi-entorno. Default: dev. Otros entornos requieren --env=<nombre>. slave/prod aplican triple read-only gate antes de cada query.",
  "_version": 2,
  "default": "dev",
  "environments": {
    "dev": {
      "host": "127.0.0.1",
      "port": 3306,
      "database": "civitatis",
      "user": "TU_USUARIO_DEV",
      "password": "TU_PASSWORD_DEV",
      "read_only": true,
      "danger_level": "low",
      "shared_with": ["new-admin", "old-admin"]
    },
    "qa": {
      "host": "qa.db.civitatis.local",
      "port": 3306,
      "database": "civitatis",
      "user": "TU_USUARIO_QA",
      "password": "TU_PASSWORD_QA",
      "read_only": true,
      "danger_level": "medium",
      "shared_with": ["new-admin", "old-admin"]
    },
    "slave": {
      "host": "replica.db.civitatis.local",
      "port": 3306,
      "database": "civitatis",
      "user": "TU_USUARIO_READONLY",
      "password": "TU_PASSWORD_READONLY",
      "read_only": true,
      "danger_level": "high",
      "shared_with": ["new-admin", "old-admin"]
    },
    "prod": {
      "host": "prod.db.civitatis.local",
      "port": 3306,
      "database": "civitatis",
      "user": "TU_USUARIO_READONLY_PROD",
      "password": "TU_PASSWORD_READONLY_PROD",
      "read_only": true,
      "danger_level": "critical",
      "shared_with": ["new-admin", "old-admin"]
    }
  }
}
```

**Aceptación F1:**
- [ ] `jq -e '.environments.dev,.environments.slave,.environments.qa,.environments.prod' config.example.json` no falla.
- [ ] `default` solo puede valer `dev` (validado en F2 al cargar).
- [ ] `_version` = 2; el loader de F2 detecta `_version=1` y aborta con instrucciones de migración manual.

### F2 — `bin/lib/db-env.sh` (loader + gates)

**Archivo nuevo:** `bin/lib/db-env.sh`

**Funciones públicas:**

| Función | Comportamiento |
|---|---|
| `db_env_path` | Imprime `~/.rubber-duck/mcp/database/config.json`. |
| `db_env_exists` | 0 si existe, 1 si no. |
| `db_env_list` | Imprime `dev qa slave prod` (los nombres encontrados en el JSON). |
| `db_env_default` | Imprime el valor de `.default` (siempre `dev` en v2). |
| `db_env_resolve <env>` | Imprime el bloque JSON del env (`jq '.environments[$e]'`). Aborta si no existe. |
| `db_env_require_explicit <env>` | 0 si `env=dev`; 1 con mensaje de error si `env` es no-dev y el usuario no pasó `--env` explícito. |
| `db_env_gate_pre_query <env>` | Ejecuta todas las gates correspondientes al `danger_level` del env. Imprime banner. Devuelve 0 si todas pasan, ≥1 si alguna falla (con `stderr` indicando cuál). |
| `db_env_gate_query_regex <query>` | Aplica regex de mutación sobre la query candidata. Devuelve 0 si es SELECT/SHOW/EXPLAIN/DESCRIBE puro; 1 en caso contrario. |

**Algoritmo de `db_env_gate_pre_query`:**

```
nivel = .environments[env].danger_level
case $nivel in
  low)
    # dev — gate (a) solo
    [ .read_only == true ] || abort "config.read_only=false"
    ;;
  medium)
    # qa — gate (a) + (e)
    [ .read_only == true ] || abort
    confirm_interactive "qa" || abort
    ;;
  high|critical)
    # slave / prod — triple gate (a..e)
    [ .read_only == true ]                                              || abort "(a) config.read_only=false"
    server_readonly=$(mysql -e "SELECT @@global.read_only, @@global.super_read_only")
    [[ "$server_readonly" =~ ^1\s+1$ ]]                                 || abort "(b) server no es read_only"
    grants=$(mysql -e "SHOW GRANTS FOR CURRENT_USER")
    grep -qiE "(INSERT|UPDATE|DELETE|ALTER|DROP|TRUNCATE|CREATE|GRANT|REVOKE|RENAME|REPLACE|MERGE|CALL)" <<<"$grants" \
      && abort "(c) usuario MySQL tiene privilegios de mutación"
    # (d) regex se aplica por query (`db_env_gate_query_regex`) en el agente, no aquí
    if [[ "$nivel" == "critical" ]]; then
      banner_rojo "PROD"
      read -p 'Escribe literalmente "prod" para confirmar: ' typed
      [[ "$typed" == "prod" ]]                                          || abort "(e) typo en confirmación"
    else
      confirm_interactive "slave" || abort
    fi
    ;;
esac
```

**Aceptación F2:**
- [ ] Tests bash con stubs de `mysql` (función fake en `tests/db-env.bats` o smoke en `bin/lib/db-env.test.sh`):
  - `db_env_gate_pre_query dev` con `read_only=true` → exit 0.
  - `db_env_gate_pre_query dev` con `read_only=false` → exit ≠ 0.
  - `db_env_gate_pre_query prod` con servidor `read_only=0` → exit ≠ 0 marcando gate `(b)`.
  - `db_env_gate_pre_query prod` con grants conteniendo `INSERT` → exit ≠ 0 marcando gate `(c)`.
  - `db_env_gate_pre_query prod` con typo en confirmación → exit ≠ 0 marcando gate `(e)`.
- [ ] `db_env_gate_query_regex "UPDATE x SET y=1"` → exit 1.
- [ ] `db_env_gate_query_regex "SELECT * FROM x"` → exit 0.

### F3 — Wizard (`skills/config/SKILL.md` — Paso 10)

Reescribir el Paso 10 para preguntar **secuencialmente por los 4 entornos**, marcando `dev` como obligatorio y los otros como opcionales:

```
🦆 Configurar conexiones de base de datos.
   `duck-db` opera por defecto sobre `dev`. Para `slave/qa/prod` deberás
   pasar `--env=<nombre>` explícitamente en cada invocación.

   Vamos a recoger las credenciales por entorno. Solo `dev` es obligatorio;
   el resto puedes saltarlos y configurarlos más tarde con
   `duck-config db-env set <env>`.
```

Por cada env preguntar: `host`, `port`, `database`, `user`, `password`, `read_only` (siempre `true` para v2; el wizard rechaza `false`).

**Aceptación F3:**
- [ ] El JSON generado pasa `jq -e '.environments.dev'` (mínimo).
- [ ] Si el usuario salta `slave`/`qa`/`prod`, esos bloques no aparecen en el JSON (no se escriben con placeholders sin sentido).
- [ ] `chmod 600` aplicado al archivo final.

### F4 — Agente (`agents/db-agent.md`)

Modificaciones:

1. Añadir sección **"Selección de entorno"** al inicio: explicar que el agente recibe el env como contexto inyectado por el dispatcher (`$DUCK_DB_ENV`); si no existe → `dev`.
2. Sección **"Gates de seguridad por entorno"** referenciando `bin/lib/db-env.sh`. Tabla:

   | Env | `danger_level` | Gates |
   |---|---|---|
   | `dev` | `low` | (a) config + (d) regex |
   | `qa` | `medium` | (a) + (d) + (e) confirmación interactiva simple |
   | `slave` | `high` | (a) + (b) servidor + (c) grants + (d) + (e) confirmación |
   | `prod` | `critical` | (a) + (b) + (c) + (d) + (e) confirmación tipeando `prod` |

3. Reforzar: para `slave/prod`, **antes de cada query** invocar `bin/lib/db-env.sh db_env_gate_pre_query "$DUCK_DB_ENV"` y abortar si exit ≠ 0.
4. Banner obligatorio en cada respuesta (no solo en mutaciones):
   ```
   🦆 duck-db [env=prod] ⚠️ READ-ONLY ENFORCED — gates (a)(b)(c)(d)(e) PASS
   ```

**Aceptación F4:**
- [ ] El agente cita `bin/lib/db-env.sh` y nombra las 5 gates por letra.
- [ ] El agente rechaza ejecutar si `$DUCK_DB_ENV` apunta a un env no presente en el config.
- [ ] El agente nunca llama directamente al MCP sin que `db_env_gate_pre_query` haya devuelto 0 antes.

### F5 — Comando (`commands/db.md`) + dispatcher

**`commands/db.md`** — añadir:

```
## Selección de entorno

Por defecto: `dev`. Cambiar con `--env=<nombre>`:

duck-db "..."                              # dev (implícito)
duck-db --env=qa "..."                     # qa
duck-db --env=slave "..."                  # slave (read-replica)
duck-db --env=prod "..."                   # prod (READ-ONLY ENFORCED)

Pasar `--env` con un valor no configurado → exit 2 + lista de entornos disponibles.
Sin `--env` y `default ≠ dev` en config → exit 2 (defensa anti-typo en el JSON).
```

**`bin/duck.sh`** — añadir parseo de `--env=<x>` antes de delegar al agente:

```bash
DUCK_DB_ENV="dev"
for arg in "$@"; do
  case "$arg" in
    --env=*) DUCK_DB_ENV="${arg#--env=}" ;;
  esac
done
export DUCK_DB_ENV
# Validar contra db_env_list antes de invocar Claude.
```

**Aceptación F5:**
- [ ] `duck-db --env=foo "..."` → exit 2 con mensaje `entorno "foo" no configurado. Disponibles: dev, qa, slave, prod`.
- [ ] `duck-db "..."` con config v2 válida → `$DUCK_DB_ENV=dev` exportado al system prompt.
- [ ] El flag se elimina de `$@` antes de pasar el resto al agente como prompt.

### F6 — Reglas (`rules/operational-restrictions.md`)

Extender R2 con la matriz de niveles. Sin crear regla nueva — sigue siendo R2.

Texto a añadir tras la fila R2 en la tabla:

> **R2.1 — Niveles por entorno DB.** `duck-db` aplica gates anti-mutación escalonadas por `danger_level` del env: `low` (dev) → gates (a)(d); `medium` (qa) → (a)(d)(e); `high` (slave) → (a)(b)(c)(d)(e); `critical` (prod) → (a)(b)(c)(d)(e) con confirmación tipeada. Ver `bin/lib/db-env.sh`.

**Aceptación F6:**
- [ ] `rules/operational-restrictions.md` cita las 5 gates por letra.
- [ ] Sin nuevas reglas R8/R9 — la extensión vive bajo R2.

### F7 — 🔍 Self-review y corrección (sin nuevo scope)

**Objetivo:** revisar el resultado de F1–F6 y corregir defectos detectados, **respetando el scope congelado**. Si se detecta una funcionalidad que falta pero no estaba planeada → **NO se implementa aquí**; se documenta en la sección §5 ("Out of scope detectado en F7") y se cierra.

**Checklist de revisión (esto **sí** se ejecuta):**

- [ ] **Coherencia schema ↔ código:** `jq` de `config.example.json` cuadra con las claves que `db-env.sh` lee.
- [ ] **Coherencia gates:** las 5 gates citadas en `db-agent.md`, `db.md`, `operational-restrictions.md` y `db-env.sh` usan los mismos identificadores `(a)..(e)`.
- [ ] **Tests F2:** todos los casos listados en F2 pasan. Re-ejecutar.
- [ ] **End-to-end manual:**
  - [ ] `duck-db "SELECT 1"` (dev implícito) → exit 0.
  - [ ] `duck-db --env=foo "..."` → exit 2.
  - [ ] `duck-db --env=prod "SELECT 1"` con MCP-prod stub que finja servidor `read_only=0` → bloqueado en gate (b).
  - [ ] `duck-db --env=prod "UPDATE x SET y=1"` → bloqueado en gate (d) regex.
  - [ ] `duck-db --env=prod "SELECT 1"` con todo OK pero typeando `PROD` (mayúscula) en confirmación → bloqueado en gate (e).
- [ ] **Seguridad:** `chmod 600` aplicado a `~/.rubber-duck/mcp/database/config.json` tras wizard.
- [ ] **Migración:** mensaje claro al detectar `_version: 1` (config antiguo plano) — no se intenta migrar automáticamente; se imprime guía.
- [ ] **R7 (BBDD compartida):** banner sigue apareciendo en mutaciones redactadas, independientemente del env.
- [ ] **YAGNI:** no se ha añadido configuración para SSL/TLS, certificados, IAM, multi-cluster, ni nada fuera del schema definido en F1.

**Acciones permitidas en F7:**
- Corregir bugs detectados en F1–F6 (escritura defectuosa, typos, regex mal, exit codes inconsistentes).
- Mejorar mensajes de error.
- Renombrar funciones/variables internas si la inconsistencia entre archivos lo justifica.
- Añadir tests faltantes que cubren casos de F1–F6 ya implementados.

**Acciones PROHIBIDAS en F7 (parar y documentar en §5):**
- Añadir un quinto env (`staging`, etc.).
- Añadir una sexta gate.
- Añadir soporte multi-BBDD.
- Añadir un nuevo subcomando (`duck-db env list`, `duck-db env switch`, etc.).
- Cambiar el schema del JSON (campos nuevos, renames de claves públicas).

**Salida de F7:** un mini-informe inline en el commit message (`fix(db-multi-env): F7 self-review — N defectos corregidos, M items out-of-scope documentados`) y, si aplica, sección §5 rellenada.

### F8 — Cierre

- [ ] Mover este archivo a su forma final (ya está en `dev-history/`). Añadir entrada al `dev-history/README.md`.
- [ ] Borrar `mcp/database/config.example.legacy.json` (creado en F1).
- [ ] Commit final: `feat(db): multi-entorno con read-only reforzado (v2 schema)`.
- [ ] Notificar al usuario para que migre su `~/.rubber-duck/mcp/database/config.json` manualmente al schema v2 siguiendo la guía impresa por `duck-db` cuando detecta v1.

## 5. Out of scope detectado en F7

Ningún item out-of-scope detectado durante F7. Todos los cambios aplicados durante el self-review fueron correcciones a F1–F6 (no nuevas funcionalidades).

| Item | Por qué se descarta ahora | Próximo paso sugerido |
|---|---|---|
| — | — | — |

**Fixes aplicados en F7 (dentro de scope):**

- `db_env_list`: `jq '.environments | keys[]'` → `keys_unsorted[]`. Razón: la lista impresa en error messages aparecía alfabética (`dev prod qa slave`); con `keys_unsorted` respeta el orden del JSON (`dev qa slave prod`), más natural para el usuario. Tests siguen 24/24 PASS (el test usaba `| sort`, no se ve afectado).

## 6. Mapa de archivos tocados

| Archivo | Cambio | Fase |
|---|---|---|
| `mcp/database/config.example.json` | Reescritura completa (schema v2) | F1 |
| `mcp/database/config.example.legacy.json` | Copia temporal del schema v1 (se borra en F8) | F1 |
| `bin/lib/db-env.sh` | **NUEVO** | F2 |
| `bin/lib/db-env.test.sh` | **NUEVO** (tests bash con `mysql` stub) | F2 |
| `skills/config/SKILL.md` | Reescritura del Paso 10 | F3 |
| `agents/db-agent.md` | Añadir secciones env + gates | F4 |
| `commands/db.md` | Añadir sección `--env` | F5 |
| `bin/duck.sh` | Parseo `--env=` para `cmd=db` | F5 |
| `rules/operational-restrictions.md` | Extender R2 con R2.1 | F6 |
| `dev-history/README.md` | Nueva entrada `2026-05-28_plan_db_multi_env_v1.md` | F8 |

## 7. Exit codes de `duck-db` (actualizado)

| Situación | Exit |
|---|---|
| Query respondida | 0 |
| MCP de BBDD no accesible | 1 |
| Argumento ausente | 2 |
| Env inválido (`--env=foo` no configurado) | 2 |
| Gate (a) config.read_only=false | 10 |
| Gate (b) servidor no read_only | 11 |
| Gate (c) grants con mutación | 12 |
| Gate (d) regex de mutación en query | 13 |
| Gate (e) confirmación fallida | 14 |
| Intento de mutación detectado y rechazado | 0 (query redactada, no ejecutada) |
| Config v1 detectado | 3 (con guía de migración) |

## 8. Riesgos

| Riesgo | Mitigación |
|---|---|
| Usuario configura `slave/prod` con credenciales que **sí** tienen privilegios de mutación. | Gate (c) ejecuta `SHOW GRANTS` y aborta. La defensa no depende solo de la cuenta. |
| `SHOW GRANTS` es lento en algunas cuentas (>500ms). | Cachear el resultado por env durante la sesión Claude (TTL=sesión). Se implementa en F2 solo si los tests miden >300ms. **No es un caso nuevo de scope — es optimización de gate (c).** |
| Usuario olvida `--env=` y dispara prod creyendo dev. | Imposible: sin `--env=` el dispatcher fuerza `dev`. Para llegar a prod hay que tipearlo explícitamente y además pasar gate (e). |
| MCP de BBDD no acepta cambiar de conexión por invocación. | Verificar en F2 antes de cerrar el algoritmo. Si no acepta → relanzar el proceso MCP con cada `--env`. |

---

**Notas para el implementador:**

- F7 es **revisión + corrección, no expansión**. Si surge la tentación de añadir algo, va a §5.
- Las gates `(a)..(e)` son letras fijas en toda la documentación; renombrar requiere update masivo (revisar en F7).
- El usuario es quien migra el config v1 → v2 a mano. `rubber-duck` solo imprime la guía. No tocamos archivos personales sin permiso.