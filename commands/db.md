# Comando `duck-db`

Asistente de base de datos sobre la BBDD `civitatis` (MySQL 8.x, ~898 tablas), **compartida** entre new-admin y old-admin.

## Uso

```
duck-db [--env=<entorno>] "<pregunta o consulta>"
duck-db [--env=<entorno>] <JIRA-KEY>
```

Ejemplos:

```bash
duck-db "cuántos pedidos activos hay"               # env=dev (implícito)
duck-db --env=qa "cuántas reservas activas hay"     # env=qa
duck-db --env=slave "report grande, evitar carga en master"
duck-db --env=prod "verificación rápida de fila X"  # READ-ONLY ENFORCED + tipear "prod"
duck-db "qué tablas tocaría una nueva columna 'refund_reason' en bookings"
duck-db PANA-789                                    # analiza queries del ticket (env=dev)
```

## Selección de entorno

Por defecto: `dev`. Cambiar con `--env=<nombre>`:

| Env     | `danger_level` | Cuándo usarlo |
|---------|----------------|---------------|
| `dev`   | `low`          | Default. BBDD local de Tilt. |
| `qa`    | `medium`       | Verificación en QA antes de promocionar. Confirmación interactiva por query. |
| `slave` | `high`         | Reports masivos contra réplica de lectura. Triple gate. |
| `prod`  | `critical`     | Verificación urgente de fila concreta. Triple gate + tipear literal `prod`. |

Reglas:

- Solo `dev` puede operar sin flag.
- `--env=<x>` con `<x>` no configurado en `~/.rubber-duck/mcp/database/config.json` → exit 2 + lista de entornos disponibles.
- El flag se consume en el dispatcher; no llega al agente como argumento. El agente recibe el env vía `$DUCK_DB_ENV`.
- Antes de cada query, `bin/lib/db-env.sh` aplica las gates correspondientes al nivel del env. Ver `agents/db-agent.md` §"Gates de seguridad por entorno".

## Comportamiento

Carga el agente `$RUBBER_DUCK_HOME/agents/db-agent.md`. Para cada invocación:

1. **Si el argumento parece JIRA-KEY** (`^[A-Z]+-[0-9]+$`): lee el ticket vía MCP y analiza qué consultas necesita.
2. **Si parece texto:** se trata como pregunta en lenguaje natural sobre la BBDD.
3. Consulta `mcp/database/schema-context.md` (si está poblado) para localizar tablas relevantes.
4. Para preguntas de **lectura**: ejecuta la query (solo `SELECT`/`SHOW`/`EXPLAIN`/`DESCRIBE`), muestra resultado + notas sobre uso por proyecto.
5. Para preguntas de **mutación**: redacta la query, **no la ejecuta**, la presenta para que el usuario la ejecute manualmente. Incluye query de rollback cuando aplique.

## Modo read-only obligatorio (R2)

Rechaza ejecutar:

```
INSERT, UPDATE, DELETE, ALTER, DROP, TRUNCATE, CREATE,
RENAME, GRANT, REVOKE, REPLACE, MERGE, CALL,
SET (excepto autocommit/session)
```

Si el usuario insiste en ejecutar una de estas: el agente las redacta con su descripción de impacto, identifica el efecto en ambos proyectos (new-admin via Eloquent, old-admin via PDO directo), y deja al usuario ejecutar fuera.

## Restricciones

- **R2 (BBDD read-only)** — obligatorio. Documentado en `rules/operational-restrictions.md`.
- **R7 (BBDD compartida)** — toda mutación de esquema afecta a ambos proyectos. El agente advierte siempre.
- **R1 (Jira):** lectura del ticket si se pasa JIRA-KEY. Sin escritura.
- **Idioma:** `output.language` (default `es`).

## Salida típica

### Lectura

```
🦆 duck-db: cuántos pedidos activos hay

Query ejecutada:
  SELECT COUNT(*) FROM bookings WHERE status = 'active';

Resultado: 12,345

Notas:
- Tabla `bookings` consumida por:
  - new-admin: App\Models\Booking, App\Repositories\BookingRepository
  - old-admin: application/lib/Dao/Admin/Bookings.php
```

### Mutación (no ejecutada)

```
🦆 duck-db: redacta query para marcar bookings del proveedor X como cancelados

⚠️ Query propuesta (NO EJECUTADA):
  UPDATE bookings SET status='cancelled' WHERE provider_id = 42;

Impacto estimado (verificar con SELECT antes):
  ~ 250 filas afectadas

⚠️ Impacto en ambos proyectos:
  - new-admin: triggers Observer de Booking (notifica vía RabbitMQ).
  - old-admin: usado en application/admin/proveedores/listado.php.

Query de rollback:
  UPDATE bookings SET status='active' WHERE provider_id = 42 AND <criterio reversible>;

Ejecutar manualmente:
  mysql -h <host> -u <user> -p civitatis < query.sql
```

## Errores y exit codes

| Situación | Exit |
|---|---|
| Pregunta respondida | 0 |
| MCP de BBDD no accesible | 1 (queries se redactan, no se ejecutan) |
| Argumento ausente / `--env=<x>` con env no configurado | 2 |
| Config schema v1 detectado (migración manual requerida) | 3 |
| Gate (a) `config.read_only=false` | 10 |
| Gate (b) servidor MySQL no es read-only | 11 |
| Gate (c) usuario MySQL tiene privilegios de mutación | 12 |
| Gate (d) regex de mutación en la query | 13 |
| Gate (e) confirmación fallida (slave/prod) | 14 |
| Intento de mutación detectado y rechazado | 0 (con query redactada para ejecutar manualmente) |

## Configuración previa

Antes de la primera invocación, configura el MCP de base de datos en `~/.rubber-duck/mcp/database/config.json` (**schema v2 multi-entorno**). Opción recomendada:

```bash
duck-config setup     # pregunta por dev (obligatorio) + qa/slave/prod (opcionales)
```

Opción manual:

```bash
cp $RUBBER_DUCK_HOME/mcp/database/config.example.json ~/.rubber-duck/mcp/database/config.json
# edita con credenciales reales por entorno
# read_only: true en cada env ← obligatorio (gate (a))
chmod 600 ~/.rubber-duck/mcp/database/config.json
```

Si el archivo no existe cuando se invoca `duck-db`, el comando se aborta con un aviso indicando cómo configurarlo.

### Migración schema v1 → v2

Si tienes un `config.json` antiguo (plano, sin `environments`), `duck-db` aborta con exit 3 y la guía:

```
Error: schema v1 detectado, se esperaba v2.

Migracion manual requerida:
  1) Renombra ~/.rubber-duck/mcp/database/config.json a ...config.json.v1.bak
  2) Copia la plantilla nueva: $RUBBER_DUCK_HOME/mcp/database/config.example.json
  3) Rellena las credenciales por entorno (dev/qa/slave/prod)
  4) chmod 600 ~/.rubber-duck/mcp/database/config.json
```

No se migra automáticamente para no tocar credenciales personales.
