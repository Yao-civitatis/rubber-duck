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

\`\`\`sql
CREATE TABLE `<nombre_tabla>` (
  ...
) ENGINE=InnoDB ...;
\`\`\`
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