# Spec-Driven Implementation Plan: DB Schema Extraction

> **🗄️ CERRADO — HISTÓRICO (2026-05-28).** Implementado en su totalidad. Ver §"Cierre / Resultado de implementación" al final. Este documento no se reabre; futuros cambios van en un plan nuevo.

## 1. Traceability (Spec-Driven)

- **Feature:** DB Schema Extraction para duck-sync-docs
- **Branch:** `feature/db-schema-extraction`
- **Evolves/Modifies:** `skills/docs-sync`, `agents/db-agent.md`, `commands/db.md`
- **Dependencies:** `bin/lib/db-env.sh` (ya implementado, sin cambios), MCP database configurado con `slave`
- **Target Module/Bounded Context:** `rubber-duck / docs-sync skill`

## 2. ⚠️ Defensive Planning (Just-in-Time)

**Assumptions:**

- DB compartida `civitatis` (~898 tablas) — extraer solo tablas usadas por cada proyecto, no todas.
- `slave` es el entorno preferido para extracción masiva (sin carga en master). Fallback: `dev` con aviso.
- `bin/lib/db-env.sh` y sus gates (a)(b)(c)(d)(e) se reutilizan sin modificación.
- `mcp/database/schema-context.md` (curación manual, pendiente) convive como complemento; `db-schema.md` es el auto-generado técnico. El `db-agent` carga ambos si existen.
- Detección de tablas por proyecto es heurística (scan de código): puede estar incompleta. El doc se etiqueta explícitamente como tal.
- `setup.sh` no requiere cambios: ya copia `docs/` → `~/.rubber-duck/docs/` en primera instalación; los placeholders llegarán solos.

**Questions:**

- ¿Qué pasa si el usuario tiene slave configurado pero no accesible en el momento del sync? → Abortar con error claro, no silencio. El usuario debe reintentarlo con slave activo (o usar `--env=dev` explícito).
- ¿Tablas compartidas entre new-admin y old-admin se documentan en ambos `db-schema.md`? → Sí, cada doc es independiente por proyecto. Cross-reference al final solo si se corre `--schema all`.

## 3. Architectural Pre-flight Check

- [x] Sigue modelo de 3 capas existente: bundle (`$RUBBER_DUCK_HOME/docs/`) → install copy (`~/.rubber-duck/docs/`) → actualizaciones del usuario.
- [x] Reutiliza resolución de paths de docs-sync SKILL (`$DOCS_DIR`, auto-seed).
- [x] Reutiliza `db-env.sh` y sus gates — cero duplicación de lógica de seguridad.
- [x] Sigue convención de naming: `docs/<proyecto>/db-schema.md` — mismo namespace que archivos existentes.
- [x] YAGNI: sin nuevo comando, sin nuevo agente, sin nuevo binario. Solo flag `--schema` en comando existente.
- [x] Layer isolation: la extracción vive en el skill prompt; el agente consume el doc generado — no se mezclan.

## 4. Execution (STRICT LIMIT: ONE SCENARIO AT A TIME)

---

### ✅ SCENARIO 1 (DONE): Prompt de extracción de schema DB

**Criteria:** *Given* `duck-sync-docs --schema <proyecto>` se invoca, *When* el skill ejecuta extracción, *Then* genera `db-schema.md` con tablas reales del proyecto, columnas/índices/DDL del slave.

**First Test Confirmation:** `skipped` *(skill prompt — validación manual/visual)*

#### Archivo a crear: `skills/docs-sync/prompts/extract-db-schema.md`

```
# Prompt: extract-db-schema

Ejecutar cuando se invoca `duck-sync-docs --schema [new-admin|old-admin|all]`.

## Sección A — Identificación de tablas usadas por proyecto

### new-admin
Recorrer `<read_root>/app/Models/`:
  - Leer propiedad `protected $table = '...'` si existe.
  - Si no, inferir por convención Eloquent: clase `BookingDetail` → tabla `booking_details`.
Recorrer `<read_root>/app/Repositories/`:
  - Grep de `->join(`, `->leftJoin(`, `->whereHas(` para detectar tablas secundarias.
Resultado: lista deduplicada de nombres de tabla, con path del modelo/repo fuente.

### old-admin (scope /admin únicamente)
Recorrer paths de scope:
  - `application/lib/Dao/Admin/`
  - `application/admin/`
Grep regex (case-insensitive): `FROM\s+`?(\w+)`?` y `(INTO|UPDATE)\s+`?(\w+)`?`
Excluir: subconsultas (nombre precedido de `(`), aliases.
Resultado: lista deduplicada con path del DAO/archivo fuente.

Anotar en el doc final si la detección es parcial (archivos con queries dinámicas, etc.).

## Sección B — Extracción del schema via DB

Entorno por defecto para `--schema`: `slave` (danger_level=high, gates (a)(b)(c)(d)(e)).
Si `slave` no está configurado en `~/.rubber-duck/mcp/database/config.json`:
  - Avisar: ⚠️ Entorno `slave` no configurado. Usando `dev`. Para producción usa `--env=slave`.
  - Fallback a `dev`.
Si ninguno está configurado → abortar con código 1 y mensaje de configuración.

Aplicar protocolo de gates por query (igual que duck-db):
  1. `bin/lib/db-env.sh regex "<query>"` → exit ≠ 0 → rechazar.
  2. `bin/lib/db-env.sh gate "$DUCK_DB_ENV"` → exit ≠ 0 → abortar.

Para cada tabla identificada, ejecutar en orden:
  1. `DESCRIBE \`<tabla>\`;`
  2. `SHOW INDEX FROM \`<tabla>\`;`
  3. `SHOW CREATE TABLE \`<tabla>\`;`

Si la tabla no existe en la DB → marcarla con ⚠️ en el doc ("tabla referenciada en código pero no encontrada en DB").
Si error de conexión → abortar todo con mensaje claro.

## Sección C — Formato de salida (db-schema.md)

### Cabecera

```markdown
# DB Schema — <proyecto>

> Generado por `duck-sync-docs --schema` el <ISO-8601>.
> Entorno: <env>. Base de datos: civitatis (MySQL 8.x).
> Tablas detectadas por heurística scan del código — puede estar incompleto.
> No editar: el siguiente `duck-sync-docs --schema` lo sobrescribe.

## Resumen

- **Tablas detectadas:** N
- **Tablas encontradas en DB:** M
- **Tablas no encontradas:** K (listadas con ⚠️)
```

### Por tabla

```markdown
### `<nombre_tabla>`

**Usado por:**
- `<proyecto>`: `<Clase\Ruta>` (`<path/relativo>`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | bigint unsigned | NO | PRI | NULL | auto_increment |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `<nombre_tabla>` (
  ...
) ENGINE=InnoDB ...;
```
```

### Footer (solo cuando --schema all)

```markdown
## Tablas compartidas (new-admin + old-admin)

| Tabla | new-admin | old-admin |
|-------|-----------|-----------|
| bookings | App\Models\Booking | Dao/Admin/Bookings.php |
```

## Sección D — Actualización de last-sync.json

Al completar, actualizar la entrada del proyecto en `$DOCS_DIR/last-sync.json`:

```json
"schema_updated": true,
"schema_tables_count": <N>,
"schema_tables_missing": ["tabla_x", "tabla_y"]
```

Si solo se sincronizó un proyecto, preservar la entrada del otro (igual que flujo existente).
```

#### Checklist

- [x] Crear `skills/docs-sync/prompts/extract-db-schema.md` con el contenido anterior.
- [x] Verificar que el prompt referencia `bin/lib/db-env.sh regex` y `bin/lib/db-env.sh gate` correctamente. (Confirmado: subcomandos `regex`/`gate` en `db-env.sh:400,402`.)
- [x] **COMMIT:** incluido en el commit de cierre de esta feature.

---

### ✅ SCENARIO 2 (DONE): Ampliar SKILL docs-sync con flag `--schema`

*Implementado tal cual la vista previa.*

**Vista previa de cambios en `skills/docs-sync/SKILL.md`:**

- Nueva invocación:
  ```
  duck-sync-docs --schema [new-admin|old-admin|all]
  duck-sync-docs --bundle --schema [all|new-admin|old-admin]   # maintainer
  ```
- Nueva sección `## Modo --schema (extracción manual de schema DB)`:
  - Flag **debe ser explícito** — `duck-sync-docs all` NO toca `db-schema.md`.
  - Entorno DB: `slave` por defecto, fallback `dev` con warning.
  - Aplica prompt `skills/docs-sync/prompts/extract-db-schema.md`.
  - Escribe `$DOCS_DIR/<proyecto>/db-schema.md`.
- Sección `--bundle` actualizada: `--bundle all` incluye schema extraction de ambos proyectos.
- Tabla de destinos: añadir fila para `db-schema.md`.
- Schema `last-sync.json`: añadir campos `schema_updated`, `schema_tables_count`, `schema_tables_missing`.

---

### ✅ SCENARIO 3 (DONE): Bundle placeholders

*Placeholders creados y, posteriormente, poblados con schema real (ver Cierre).*

**Archivos a crear:**

- `docs/new-admin/db-schema.md`
- `docs/old-admin/db-schema.md`

**Formato:**

```markdown
# DB Schema — <proyecto>

> ⚠️ Este archivo es un placeholder. No contiene datos reales de schema.
>
> Para generar el schema real, ejecuta:
>
>     duck-sync-docs --schema <proyecto>
>
> Requisitos:
> - Entorno `slave` (recomendado) o `dev` configurado en `~/.rubber-duck/mcp/database/config.json`.
> - Acceso a la BBDD `civitatis` desde tu máquina.
>
> El archivo se sobrescribe en cada ejecución de `duck-sync-docs --schema`.
```

`setup.sh` ya copia `docs/` → `~/.rubber-duck/docs/` en primera instalación — sin cambios en setup.sh.

---

### ✅ SCENARIO 4 (DONE): Anotaciones en db-agent y commands/db

*Implementado tal cual la vista previa.*

**`agents/db-agent.md` — cambio en sección "Capacidades":**

De:
```
- Carga `mcp/database/schema-context.md` cuando esté disponible (descripción curada de tablas principales) para evitar exploración a ciegas.
```
A:
```
- Carga en orden, si existen:
  1. `~/.rubber-duck/docs/<proyecto>/db-schema.md` — schema auto-extraído por `duck-sync-docs --schema`.
     Fuente de verdad para nombres de tabla, columnas e índices reales.
  2. `$RUBBER_DUCK_HOME/mcp/database/schema-context.md` — curación manual de contexto de negocio (complementario).
  Para determinar `<proyecto>`: usar `$PROJECT_TYPE` si está definido; si no, cargar ambos.
  Si `db-schema.md` existe pero es solo el placeholder → avisar:
  ⚠️ Schema no generado. Ejecuta: duck-sync-docs --schema <proyecto>
```

**`commands/db.md` — nueva nota en sección "Comportamiento":**

```
3. Consulta en orden (si existen): `~/.rubber-duck/docs/<proyecto>/db-schema.md` (schema auto-extraído)
   y `mcp/database/schema-context.md` (contexto manual) para localizar tablas relevantes.
   Si `db-schema.md` es solo el placeholder → avisar: ⚠️ Schema no generado. Ejecuta: duck-sync-docs --schema <proyecto>
```

---

## Resumen de archivos

| Archivo | Acción | Escenario |
|---|---|---|
| `skills/docs-sync/prompts/extract-db-schema.md` | CREAR | S1 |
| `skills/docs-sync/SKILL.md` | MODIFICAR | S2 |
| `docs/new-admin/db-schema.md` | CREAR (placeholder) | S3 |
| `docs/old-admin/db-schema.md` | CREAR (placeholder) | S3 |
| `agents/db-agent.md` | MODIFICAR | S4 |
| `commands/db.md` | MODIFICAR | S4 |
| `setup.sh` | sin cambios | — |
| `bin/lib/db-env.sh` | sin cambios | — |
| `mcp/database/schema-context.md` | sin cambios (curación manual) | — |

---

## Cierre / Resultado de implementación (2026-05-28)

Las 4 escenarios implementados y verificados. `SPEC.md` actualizado con la feature.

### Archivos tocados (real)

| Archivo | Acción real |
|---|---|
| `skills/docs-sync/prompts/extract-db-schema.md` | CREADO |
| `skills/docs-sync/SKILL.md` | invocación + tabla destinos + sección `--schema` + `--bundle --schema` + campos `schema_*` en `last-sync.json` |
| `docs/new-admin/db-schema.md` | CREADO placeholder → **poblado** (445 tablas, 664K) |
| `docs/old-admin/db-schema.md` | CREADO placeholder → **poblado** (286 tablas, 484K, scope /admin) |
| `docs/last-sync.json` | campos `schema_*` para ambos proyectos |
| `agents/db-agent.md` | orden de carga db-schema.md → schema-context.md |
| `commands/db.md` | paso 3 orden de consulta + aviso placeholder |
| `SPEC.md` | feature `--schema` documentada en todas las secciones relevantes |
| `setup.sh` / `bin/lib/db-env.sh` / `mcp/database/schema-context.md` | sin cambios (confirmado) |

### Desviaciones respecto al plan (justificadas)

1. **Entorno DB:** el plan fijaba `slave` por defecto. En ejecución, `slave` **falló la gate (b)** del propio `db-env.sh`: el servidor réplica reporta `@@global.super_read_only=0` (read_only=1 pero super_read_only=0). La gate hizo su trabajo y bloqueó. Fallback a `dev` (Tilt local, gate PASS level=low), confirmado por el usuario. Documentado en la cabecera de ambos `db-schema.md`. Pendiente externo: infra debe `SET GLOBAL super_read_only=1` en la réplica para habilitar `--env=slave`.
2. **Detección de tablas new-admin:** se usó solo `protected $table` en `app/Models/` (447 declaraciones explícitas, 445 en DB). No se añadió la inferencia por convención Eloquent ni el scan de joins de repositorios que el plan contemplaba como opcional — las tablas legacy de Civitatis usan nombres en español que no siguen la convención inglesa, por lo que `$table` explícito es la señal fiable. Limitación etiquetada en el doc.
3. **old-admin:** detección por grep `FROM|JOIN|INTO|UPDATE` sobre SQL crudo en scope `/admin` (319 candidatos). Se añadió un **filtro de ruido** (no previsto en el plan) para descartar tokens basura del regex (aliases, palabras SQL sueltas como `an`, `de`, `en`); 286 tablas válidas en DB, 33 plausibles ausentes (legacy/solo-prod) listadas con ⚠️.
4. **Instalación:** verificado que `setup.sh:343` (`cp -R docs/ → ~/.rubber-duck/docs/`) copia recursivo, por lo que `db-schema.md` viaja con el resto de docs sin cambios en `setup.sh`.

### Verificación

- Gates `db-env.sh regex`/`gate` correctas; todas las queries `SELECT`/`SHOW`/`information_schema` (read-only, R2).
- Fences markdown balanceados en ambos docs (new-admin 445/445, old-admin 286/286). DDL sin `\n` literales.
