# Skill `code-audit`

Audita el código del proyecto detectado contra:

1. **Capa estática (solo new-admin):** `phpstan`, `php-cs-fixer`, `phparkitect` invocados vía el dispatcher del propio proyecto (`bin/pre-commit`).
2. **Capa semántica:** cruza el código auditado con las normas vivas en `~/.rubber-duck/docs/<proyecto>/{backend,frontend}-standards.md` (para new-admin) o con buenas prácticas generales (para old-admin).

Produce un informe unificado con severidades y, opcionalmente, lo exporta a archivo siguiendo la convención de paths.

## Invocación

```
duck-audit <ruta|all|--branch>
```

Ejemplos:

```bash
duck-audit src/Services/PaymentService.php   # archivo concreto
duck-audit all                                # todo el proyecto
duck-audit --branch                           # solo archivos modificados vs main/master
```

Sin argumento → fallback a `audit.default_mode` (default `branch`).

## Reglas universales aplicables

- `$RUBBER_DUCK_HOME/rules/export-paths.md` → si se exporta el informe, sigue la convención.
- `$RUBBER_DUCK_HOME/rules/output-language.md` → informe en `output.language`.
- `$RUBBER_DUCK_HOME/rules/project-detection.md` → `$PROJECT_ROOT` y `$PROJECT_TYPE` exportados por el dispatcher.
- `$RUBBER_DUCK_HOME/rules/operational-restrictions.md` → R1-R7 aplicadas a las reglas de revisión.

## Flujo

### Paso 1 — Resolver el conjunto de archivos a auditar

Según el argumento (o `audit.default_mode` si no se pasó nada):

**Modo `<ruta>`** (archivo o directorio concreto):
- Resolver el path contra `$PROJECT_ROOT` si es relativo.
- Si es directorio → expandir a la lista de archivos `.php`, `.vue`, `.js`, `.scss`, `.css` que contiene (recursivamente).
- Si es archivo único → la lista tiene un solo elemento.

**Modo `all`:**
- new-admin: todo `$PROJECT_ROOT/app/`, `$PROJECT_ROOT/config/`, `$PROJECT_ROOT/dev/vue/` (excluir `vendor/`, `node_modules/`, `web/build/`).
- old-admin: todo el scope `/admin` (whitelist en `skills/project-context/old_admin.md`).

**Modo `--branch`:**
- Calcular la base: `git -C "$PROJECT_ROOT" merge-base HEAD main 2>/dev/null || git -C "$PROJECT_ROOT" merge-base HEAD master`.
- Listar archivos: `git -C "$PROJECT_ROOT" diff --name-only $base...HEAD` filtrando por extensiones auditables.
- Si la rama actual es `main`/`master`, no hay comparación → exit 0 con mensaje informativo.

Si la lista de archivos está vacía → exit 0 con mensaje "No hay archivos para auditar".

### Paso 2 — Validación de scope (solo old-admin)

Para cada archivo de la lista, verificar que su path coincide con un prefijo del whitelist `/admin` (definido en `skills/project-context/old_admin.md` §"Scope estricto").

- Archivos dentro del scope → continúan al Paso 3.
- Archivos fuera → registrar como **hallazgo bloqueante** y excluir del análisis técnico (se reportan al final como "fuera del scope").

### Paso 3 — Inferir JIRA-KEY desde la rama (best-effort)

`git -C "$PROJECT_ROOT" rev-parse --abbrev-ref HEAD` y extraer la key con regex `[A-Z]+-[0-9]+`. Si no se encuentra, `JIRA_KEY=""`.

Se usa para nombrar el archivo de export y agrupar por ticket (§"Persistencia del informe").

### Paso 4 — Capa estática

#### new-admin

Delegación obligatoria al toolchain del proyecto. **No reimplementar.**

```bash
# php-cs-fixer (solo los archivos relevantes)
"$PROJECT_ROOT/bin/pre-commit" php-cs-fixer --dry-run --diff <archivos.php>

# phpstan
"$PROJECT_ROOT/bin/pre-commit" phpstan <archivos.php>

# phparkitect (analiza el proyecto entero, no se pueden filtrar archivos)
"$PROJECT_ROOT/bin/pre-commit" phparkitect
```

Para cada herramienta:

- Capturar `stdout` + `stderr` + exit code.
- Interpretar el output siguiendo el prompt correspondiente:
  - `phpstan.md`
  - `cs-fixer.md`
  - `arkitect.md`
- Acumular hallazgos en la lista global con severidad y referencia archivo:línea.

**Tolerancia a docker apagado:** si el wrapper falla porque Docker / Tilt no está arriba, registrar como warning ("toolchain no disponible — solo capa semántica") y continuar.

#### old-admin

**No ejecutar nada de la capa estática.** El proyecto no tiene `phpstan`, `phparkitect` ni `php-cs-fixer` configurados (política mantenimiento-only, documentada en `rules/operational-restrictions.md`). Saltar directamente al Paso 5.

### Paso 5 — Capa semántica

Aplica el prompt `prompts/standards.md` cruzando el código auditado con:

- new-admin: `~/.rubber-duck/docs/new-admin/backend-standards.md` + `frontend-standards.md` + `project-snapshot.md`.
- old-admin: buenas prácticas generales (sin estándares formales). Foco en seguridad y lógica.

Hallazgos típicos buscados:

| new-admin | old-admin |
|---|---|
| R3: violaciones de hexagonal (Controllers importan Repositories) | SQL injection (queries nuevas con concatenación) |
| R4: Controllers extendiendo `AbstractController` | XSS (output HTML sin escape) |
| R5: literales numéricos en `withStatus()` | Lógica obviamente rota |
| R6: Composition API en componentes Vue | Inconsistencia grosera con estilo del archivo |
| Servicios sin `__invoke` o con múltiples métodos públicos | Permisos faltantes (`$user_admin->hasPermission(...)`) |
| Models con lógica de negocio | Sintaxis ilegal en PHP 5.6 (`??`, `?Type`, etc.) si se introdujo |
| Repositorios nuevos sin prefijo `Eloquent*` | Paths fuera del scope `/admin` |
| Excepciones genéricas (`\Exception`) en código nuevo | — |
| Rutas nuevas sin entry en `config/routePermissions.yml` | — |

**No reportar como problema en old-admin:**
- Short tags `<?`
- Indentación irregular
- Falta de typed properties / return types
- Globals, includes manuales, PDO directo
- HTML embebido en PHP

Eso es el **estado normal** del código (regla `operational-restrictions.md`).

### Paso 6 — Componer informe unificado

Estructura:

```markdown
# Audit Report — <proyecto> · <modo>

> Generado por `duck-audit` el <ISO-8601 UTC>.
> Proyecto: <proyecto> (`$PROJECT_ROOT`)
> Modo: <archivo|all|--branch>
> Archivos auditados: <N>
> JIRA: <KEY o "(sin clave inferida)">

## 1. Resumen

| Severidad | Cantidad |
|---|---|
| 🔴 Error    | N |
| 🟡 Warning  | N |
| 🔵 Info     | N |

Veredicto: 🟢 OK / 🟡 Con observaciones / 🔴 Bloqueante.

## 2. Capa estática

(solo new-admin; sección omitida o "(no aplica)" en old-admin)

### 2.1 phpstan
…
### 2.2 php-cs-fixer
…
### 2.3 phparkitect
…

## 3. Capa semántica

…

## 4. Hallazgos accionables

- [ ] <Acción 1> — `<archivo>:<línea>` — severidad
- [ ] <Acción 2> — …
```

### Paso 7 — Veredicto y exit code

Comparar el max de severidad encontrada con `audit.fail_on` (default `error`):

| `audit.fail_on` | Bloquea si hay |
|---|---|
| `error` | 🔴 Error |
| `warning` | 🔴 Error o 🟡 Warning |
| `all` | cualquier hallazgo (incluido 🔵 Info) |

| Veredicto | Exit code |
|---|---|
| 🟢 OK (o bloqueos por debajo del umbral) | 0 |
| 🟡 Con observaciones (por debajo del umbral) | 0 |
| 🔴 Bloqueante (sobre el umbral) | 1 |

`exit 1` es útil para git hooks (`pre-commit` bloquea el commit).

### Paso 8 — Persistencia del informe (opcional)

Si `audit.export = true`, aplicar `$RUBBER_DUCK_HOME/rules/export-paths.md`:

- Con JIRA-KEY inferida: `<audit.export_dir>/<JIRA-KEY>/<JIRA-KEY>_audit.<ext>`.
- Sin JIRA-KEY: `<audit.export_dir>/audit/<slug>_audit.<ext>` donde `<slug>` es `branch`, `all`, o el basename del archivo.

`<audit.export_dir>` se resuelve contra `$PROJECT_ROOT` si es relativo (rule §"Resolución").

Procedimiento (idéntico a otros exporters):

1. `mkdir -p` del directorio destino.
2. Si el archivo existe → preguntar sobrescribir / `.bak` / cancelar.
3. Renderizar según `audit.export_format` (`md` por defecto; `html`, `json`, `txt` también).
4. Confirmar: `✓ Informe guardado en <ruta>`.

### Paso 8.bis — Auto-commit (si aplica)

Si el audit modificó archivos en el proyecto (caso raro — algunos fixers auto-correctores podrían escribir; lo habitual es que el audit sea read-only), delegar en `$RUBBER_DUCK_HOME/bin/lib/git.sh`:

```bash
"$RUBBER_DUCK_HOME/bin/lib/git.sh" \
  audit \
  "<JIRA-KEY o vacío>" \
  "<título breve>" \
  "<veredicto>" \
  <archivo1> ...
```

El helper aplica `git.auto_commit_after = audit` y los formatos definidos en `git.commit_message_format`. En la mayoría de los casos no hay archivos a commitear (audit es lectura) y el helper sale sin hacer nada.

### Paso 9 — Resumen al usuario

Pantalla final (siempre, exporte o no):

```
🦆 duck-audit completado.

Modo:        --branch
Archivos:    7
Severidad:   🔴 2 errores · 🟡 5 warnings
Veredicto:   🔴 Bloqueante (fail_on=error)

Hallazgos accionables:
  1. R5 HTTP literal en RefundController.php:42 — reemplazar 422 por StatusCode::HTTP_UNPROCESSABLE_ENTITY
  2. R4 Controller extiende AbstractController en LegacyController.php:8 — refactor a Service inyectado
  …

Informe exportado: ~/proyectos/.../docs/PANA-123/PANA-123_audit.md
```

## Restricciones (recordatorio)

- **R1 (Jira):** este skill no escribe en Jira. Si necesita notas, las muestra en stdout.
- **R2 (BBDD):** no ejecuta queries. Si descubre que una query necesita ser revisada manualmente, lo reporta como hallazgo.
- **R3-R6 (new-admin):** se verifican, no se mutan.
- **Scope (old-admin):** archivos fuera del whitelist → hallazgo bloqueante. No se analizan técnicamente.
- **Toolchain delegado (new-admin):** siempre `bin/pre-commit <herramienta>`, nunca invocar herramientas en el host.

## Idempotencia

Llamar dos veces con la misma rama/archivos → mismo informe (modulo timestamp). Si el archivo de export existe, preguntar sobrescribir.
