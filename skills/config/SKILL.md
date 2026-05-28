# Skill `config` — wizard interactivo

Este skill genera `~/.rubber-duck/config.json` mediante una conversación corta con el usuario.

Se activa cuando el dispatcher recibe `duck-config setup`, o cuando se detecta que el archivo de configuración aún no existe y el usuario invoca cualquier `duck-*` por primera vez.

## Objetivos

1. Crear `~/.rubber-duck/config.json` siguiendo el schema **v1** (definido en `bin/lib/config.sh`).
2. Hacer preguntas claras, en español, una a una, con opciones numeradas cuando la respuesta sea cerrada.
3. Preguntar los paths de `project.new_admin_path` y `project.old_admin_path` para facilitar la localización posterior cuando el usuario invoque `duck-*` desde fuera del proyecto. Auto-detecta candidatos en spots comunes y propónlos como default. La detección primaria sigue siendo desde `$PWD`; estos paths son fallback.
4. Si el usuario interrumpe con Ctrl+C en cualquier momento, guarda lo respondido + defaults para el resto. No dejes el archivo a medias.
5. Al terminar, valida que el JSON cumple el schema invocando `bin/lib/config.sh list` y muestra el resumen al usuario.

## Schema (sincronizado con `bin/lib/config.sh`)

| Clave | Default | Valores permitidos |
|---|---|---|
| `_version` | `1` | (constante) |
| `project.new_admin_path` | `""` | ruta absoluta o vacío |
| `project.old_admin_path` | `""` | ruta absoluta o vacío |
| `output.language` | `es` | `es`, `en` |
| `analyze.export_format` | `md` | `md`, `html`, `json`, `txt` |
| `analyze.export_dir` | `.` | cualquier ruta |
| `plan.output_format` | `md` | `md`, `html` |
| `plan.output_dir` | `.` | cualquier ruta |
| `implement.auto_format` | `false` | `true`, `false` |
| `audit.default_mode` | `branch` | `branch`, `all` |
| `audit.fail_on` | `error` | `error`, `warning`, `all` |
| `audit.export` | `false` | `true`, `false` |
| `audit.export_format` | `md` | `md`, `html`, `json`, `txt` |
| `audit.export_dir` | `.` | cualquier ruta |
| `review.export` | `false` | `true`, `false` |
| `review.export_format` | `md` | `md`, `html`, `json`, `txt` |
| `review.export_dir` | `.` | cualquier ruta |
| `review.update_jira` | `true` | `true`, `false` |
| `git.auto_commit` | `false` | `true`, `false` |
| `git.auto_commit_after` | `audit` | `implement`, `review`, `audit` |
| `git.commit_message_format` | `jira` | `jira`, `conventional`, `custom` |
| `git.auto_push` | `false` | `true`, `false` |

## Flujo

### Paso 0 — Bienvenida y comprobaciones

```
🦆 Bienvenido a rubber-duck.
   Vamos a configurar tu instalación personal en ~/.rubber-duck/config.json.
   Si quieres salir en cualquier momento, pulsa Ctrl+C.
```

Si `~/.rubber-duck/config.json` ya existe:
```
⚠️  Ya tienes una configuración previa.
   1) Sobrescribirla (perderás los valores actuales)
   2) Cancelar y mantener la actual
   > _
```

Si elige `2` → exit sin tocar nada.

### Paso 1 — Rutas de los proyectos

Antes de preguntar, auto-detecta candidatos para ambos proyectos. Construye la lista de spots a buscar a partir de variantes del nombre del directorio raíz del usuario (en español e inglés, singular y plural):

- `$HOME`
- `$HOME/proyectos`
- `$HOME/proyecto`
- `$HOME/projects`
- `$HOME/project`
- `$HOME/dev`

Y para cada uno de esos también su subdirectorio `tilt/tilts/` cuando exista (el equipo lo usa como contenedor de servicios). Profundidad máxima `find -maxdepth 4`.

Filtra spots inexistentes antes de pasarlos a `find` (evita ruido en stderr).

Marcadores:
- **new-admin:** dir con `composer.json` que contiene `"name": "civitatis/newadmin"` o con `.claude/domain-index.md`
- **old-admin:** dir raíz de `civitatis`, identificado por contener `application/admin/` Y `webroot/` (ambos como subdirectorios). El path que se guarda en config es **la raíz de civitatis** (por ejemplo `$HOME/proyectos/tilt/tilts/civitatis`), no `application/admin`. Los skills que necesiten subrutas (templates, módulos, etc.) las componen ellos mismos a partir del root.

Comando de auto-detección sugerido (ejecútalo vía Bash, no inventes paths):

```bash
# Construye lista de spots reales que existen.
spots=()
for base in "$HOME/proyectos" "$HOME/proyecto" "$HOME/projects" "$HOME/project" "$HOME/dev" "$HOME"; do
  [[ -d "$base" ]] && spots+=("$base")
  [[ -d "$base/tilt/tilts" ]] && spots+=("$base/tilt/tilts")
done

# new-admin
find "${spots[@]}" -maxdepth 4 -name composer.json 2>/dev/null \
  | xargs grep -l '"civitatis/newadmin"' 2>/dev/null \
  | head -1 \
  | xargs -r dirname

# old-admin (raíz de civitatis: contiene application/admin/ + webroot/)
find "${spots[@]}" -maxdepth 4 -type d -name admin -path '*/application/admin' 2>/dev/null \
  | head -1 \
  | sed 's|/application/admin||'
```

Pregunta con el candidato si existe (sustituye `<usuario>` por el `$USER` real al renderizar):

```
🔎 He encontrado new-admin en: /home/<usuario>/proyectos/tilt/tilts/new-admin
   1) Usar esta ruta  [recomendado]
   2) Introducir otra
   3) Dejar vacío (la detección automática desde el directorio actual será suficiente)
> _
```

Sin candidato:

```
🔎 No he localizado new-admin en los sitios comunes.
   Introduce la ruta absoluta o pulsa enter para dejar en blanco:
> _
```

Si el usuario introduce una ruta no vacía:
- Comprueba que el directorio existe y contiene los marcadores.
- Si no, muestra warning pero acepta (`⚠️ esa ruta no parece new-admin, pero la guardamos igual`).

Repite el mismo flujo para **old-admin**. Para old-admin el path esperado es la **raíz de civitatis**, no `application/admin`. Si el usuario introduce por error `…/civitatis/application/admin`, normaliza quitando el sufijo (`sed 's|/application/admin/*$||'`) y guarda la raíz, avisándole del cambio.

### Paso 2 — Idioma

```
¿En qué idioma quieres los outputs?
  1) Español
  2) English
> _
```

`1` → `output.language=es`; `2` → `output.language=en`.

### Paso 3 — Formato del plan

```
¿Formato por defecto para los planes de implementación?
  1) Markdown (.md)  [recomendado]
  2) HTML (.html)
> _
```

### Paso 4 — Directorio de outputs

```
¿Dónde guardar los planes y reportes generados?
  Enter = directorio actual (.)
  O escribe una ruta absoluta o relativa.
> _
```

Aplica el valor a las **4 claves** de output/export salvo que el usuario aclare lo contrario después:

- `plan.output_dir`
- `analyze.export_dir`
- `audit.export_dir`
- `review.export_dir`

(Las 4 deben quedar en sync. Si en el futuro se añade otro comando que exporte, esta lista crece.)

### Paso 5 — duck-audit por defecto

```
¿Cómo debe operar duck-audit cuando se invoca sin argumento?
  1) Solo archivos modificados en la rama actual (--branch)  [recomendado]
  2) Todo el proyecto (all)
> _
```

### Paso 6 — Severidad que bloquea audit

```
¿Qué nivel de problema bloquea el proceso?
  1) Solo errores críticos  [recomendado]
  2) Errores y warnings
  3) Cualquier incidencia
> _
```

### Paso 7 — Exportar informes

```
¿Exportar los informes de auditoría y revisión a archivo?
  1) Solo pantalla  [recomendado para empezar]
  2) Exportar a archivo
> _
```

Si `2`:
```
¿En qué formato?
  1) Markdown (.md)
  2) HTML (.html)
  3) JSON (.json)
  4) Texto plano (.txt)
> _
```
Y aplica el mismo formato a `audit.export_format` y `review.export_format`.

### Paso 8 — Auto-commit

```
¿Quieres que rubber-duck haga commits automáticos cuando termine una fase?
  1) No, prefiero hacer los commits manualmente  [recomendado]
  2) Sí
> _
```

Si `2`:
```
¿En qué fase se dispara el commit?
  1) Después de implementar el código (implement)
  2) Después de pasar la revisión (review)
  3) Después de pasar la auditoría (audit)  [recomendado]
> _
```
```
¿Formato del mensaje de commit?
  1) PROJ-123: descripción del ticket  (estilo jira)
  2) feat(scope): PROJ-123 descripción  (Conventional Commits)
  3) Personalizado (te pediré la plantilla)
> _
```
Si `3`: pide la plantilla y guárdala en `~/.rubber-duck/commit-template.txt`.

```
¿Push automático tras el commit?
  1) No  [recomendado]
  2) Sí
> _
```

### Paso 9 — MCP Atlassian (opcional)

```
🦆 Configurar el MCP de Atlassian ahora?
   Solo te pediré el TOKEN (URL, cloud_id, project keys, space están preconfigurados
   con los valores reales de Civitatis). Tu token de https://id.atlassian.com/manage-profile/security/api-tokens.

   1) Sí, lo introduzco ahora
   2) Saltar (lo configuro más tarde)
> _
```

Si elige `1`:

```
Token API (no se muestra al escribir, pega y enter):
> _
```

Si el token llega vacío → tratar como "saltar" y avisar.

Si llega un token:

1. Leer la plantilla `$RUBBER_DUCK_HOME/mcp/atlassian/config.example.json`.
2. Sustituir el placeholder `TU_TOKEN_API_AQUI` por el token real.
3. Crear `~/.rubber-duck/mcp/atlassian/` si no existe.
4. Escribir el JSON resultante a `~/.rubber-duck/mcp/atlassian/config.json` con permisos 600 (`chmod 600`).
5. Confirmar: `✓ Token guardado en ~/.rubber-duck/mcp/atlassian/config.json (chmod 600).`

Si el usuario salta este paso → no crear archivo. Avisar:
```
ℹ️  MCP de Atlassian sin configurar. Los comandos que lo usan
   (duck-analyze, duck-review, duck-sync-docs, duck-standup, duck-debug con JIRA-KEY)
   te avisarán y te dirán cómo configurarlo más tarde.
```

### Paso 10 — MCP Database multi-entorno (opcional)

`duck-db` opera contra **múltiples entornos** de la BBDD compartida. Por defecto, sin flag, se ejecuta sobre `dev`. Para `qa`, `slave` y `prod` el usuario tiene que pasar `--env=<nombre>` explícitamente en cada invocación (anti-typo) y se aplican gates anti-mutación escalonadas. Ver `bin/lib/db-env.sh`.

Esquema final (schema v2, definido en `mcp/database/config.example.json`):

```json
{
  "_version": 2,
  "default": "dev",
  "environments": {
    "dev":   { "host": "...", "port": 3306, "database": "civitatis", "user": "...", "password": "...", "read_only": true,  "danger_level": "low",      "shared_with": ["new-admin", "old-admin"] },
    "qa":    { "...": "danger_level=medium" },
    "slave": { "...": "danger_level=high" },
    "prod":  { "...": "danger_level=critical" }
  }
}
```

**`danger_level` y `read_only` son fijos por env** — el wizard NO los pregunta; los rellena automáticamente. `read_only` se fuerza a `true` siempre; un `false` no se acepta nunca.

**Flujo:**

```
🦆 Configurar conexiones a base de datos (multi-entorno).
   duck-db por defecto opera sobre `dev`. Para qa/slave/prod tendrás
   que pasar --env=<nombre> explícitamente en cada invocación.

   Solo `dev` es obligatorio. Los demás puedes saltarlos ahora y
   añadirlos más tarde editando ~/.rubber-duck/mcp/database/config.json
   o relanzando duck-config setup.

   1) Configurar ahora (empezando por dev)
   2) Saltar (lo configuro más tarde)
> _
```

Si elige `2` → no crear archivo. Avisar:

```
ℹ️  MCP de base de datos sin configurar. `duck-db` avisará y
   te dirá cómo configurarlo más tarde.
```

Si elige `1`, **por cada env en este orden** (`dev`, `qa`, `slave`, `prod`):

#### Bloque por env

Para `dev`:

```
── Entorno dev (OBLIGATORIO) ────────────────────────────────────
   credenciales de Tilt/dev local, nunca de producción.

   host      [127.0.0.1]: _
   port      [3306]: _
   database  [civitatis]: _
   user (lectura): _
   password (no se muestra al escribir): _
```

Para `qa`, `slave`, `prod`:

```
── Entorno <env> (opcional) ─────────────────────────────────────
   1) Configurar ahora
   2) Saltar
> _
```

Si elige `2` para un env opcional → no añadir bloque para ese env. Continuar con el siguiente.

Si elige `1`:

```
   host      [<sugerencia segun env: qa.db.civitatis.local / replica.db.civitatis.local / prod.db.civitatis.local>]: _
   port      [3306]: _
   database  [civitatis]: _
   user (READ-ONLY obligatorio): _
   password (no se muestra al escribir): _
```

#### Validaciones por env

- `user` no puede contener espacios; si llega vacío → reintentar (max 3 veces); si supera → tratar como "saltar" con warning.
- `password` no puede ir vacío en `prod`/`slave`; sí permitido en `dev`/`qa` (con warning visible).
- Para `slave` y `prod`, **mostrar advertencia previa**:

  ```
  ⚠️  Para <env>: usa credenciales con privilegios SOLO de lectura.
      duck-db ejecutará `SHOW GRANTS FOR CURRENT_USER` antes de cada query
      y abortará si detecta INSERT/UPDATE/DELETE/ALTER/DROP/TRUNCATE/CREATE/
      GRANT/REVOKE/RENAME/REPLACE/MERGE/CALL/SUPER/RELOAD/FILE/PROCESS.
  ```

#### Construcción del JSON

1. Construir en memoria el objeto JSON con los envs configurados. `dev` siempre está presente. Los demás aparecen solo si el usuario los rellenó.
2. Fijar `_version: 2`, `default: "dev"`.
3. Para cada env presente, fijar `read_only: true` (no negociable) y `danger_level` según la tabla:
   - `dev` → `low`
   - `qa` → `medium`
   - `slave` → `high`
   - `prod` → `critical`
4. Añadir `shared_with: ["new-admin", "old-admin"]` a cada env.
5. Validar con `jq -e '.environments.dev' archivo` antes de persistir.

#### Persistencia

1. Crear `~/.rubber-duck/mcp/database/` si no existe.
2. Escribir el JSON a `~/.rubber-duck/mcp/database/config.json` con permisos `600`.
3. Confirmar:

   ```
   ✓ Config guardado en ~/.rubber-duck/mcp/database/config.json (chmod 600).
     Entornos configurados: <lista, p.ej. dev, qa, prod>
     Entornos pendientes:   <lista, p.ej. slave>
   ```

#### Restricciones (CRÍTICAS)

- **No** preguntar al usuario por `read_only` ni `danger_level` — fijos por env, no negociables.
- **No** aceptar `read_only: false` en ningún env. Si el usuario lo edita a mano más tarde, las gates de `db-env.sh` lo detectarán y abortarán.
- **No** escribir el JSON con `password` vacío para `slave`/`prod` (rechazar al validar).
- **No** invocar comandos externos durante el wizard (ni `mysql`, ni ping al servidor). El wizard solo escribe archivo; las gates se ejecutan en tiempo de query.

### Paso 11 — Persistencia

1. Crea `~/.rubber-duck/` si no existe.
2. Escribe el JSON respetando los valores recogidos. Para cada clave no respondida (Ctrl+C antes de su pregunta), usa el default de la tabla.
3. Añade `"_version": 1` en la raíz del JSON.
4. Muestra el resumen final equivalente a `duck-config list`.

### Paso 12 — Cierre

```
✓ Configuración guardada en ~/.rubber-duck/config.json

Cambiar cualquier opción más tarde:
  duck-config set <clave> <valor>
  duck-config list   (ver todo)

🦆 Listo. Continuando con tu comando…
```

Si el usuario invocó `duck-config setup` directamente → fin.
Si llegamos aquí desde el primer arranque de otro comando → continúa con ese comando original sin volver a preguntar.

## Tolerancia a Ctrl+C

Implementación:
- Inicia con un dict en memoria poblado con todos los defaults.
- A cada respuesta válida, sobrescribe la clave.
- Si el usuario interrumpe, persiste el dict actual. Al final el JSON siempre será coherente con el schema.

## Validación

Antes de persistir, comprueba para cada clave que el valor está en `CONFIG_ALLOWED` (definido en `bin/lib/config.sh`). Si por algún motivo un valor no es válido, cae al default sin preguntar y registra una advertencia en pantalla.

## Restricciones

- **No** uses la CLI `bin/lib/config.sh set` desde el wizard para escribir clave a clave (sería lento y rompería la tolerancia a Ctrl+C). Escribe el JSON completo en una sola operación al final.
- **No** invoques ningún MCP ni herramienta externa. Este skill es 100% interactivo + escritura de archivo.
- **No** preguntes por `project.*_path` salvo que el usuario lo pida explícitamente.
