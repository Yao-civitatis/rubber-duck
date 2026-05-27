# Convenciones de rubber-duck

Reglas transversales que **todos** los skills, agents y commands deben respetar. Si una skill toca alguna de estas áreas, debe citar este archivo y aplicar la regla. La fuente de verdad vive aquí, no en `PLAN_IMPLEMENTATION.md` (que se elimina al cerrar el proyecto).

---

## 1. Convención universal de paths de export

**Regla:** todo artefacto persistido a disco por un comando `duck-*` sigue el mismo patrón:

```
<config.output_dir>/<carpeta>/<filename>
```

donde:

- `<config.output_dir>` es la clave de config correspondiente al comando (`plan.output_dir`, `audit.export_dir`, `review.export_dir`, `analyze.export_dir`, etc.). Default: `.`.
- `<carpeta>` es:
  - **`<JIRA-KEY>`** cuando el comando tiene clave de Jira disponible (caso normal).
  - **`<cmd>`** (nombre del comando sin prefijo `duck-`) como fallback defensivo cuando no hay clave.
- `<filename>` mantiene la forma `<JIRA-KEY>_<cmd>.<ext>` o `<slug>_<cmd>.<ext>` cuando no hay key.

**Procedimiento obligatorio** en cualquier skill que exporte:

1. Calcular `dest_dir`.
2. `mkdir -p "$dest_dir"`.
3. Calcular `dest_file`.
4. Si `$dest_file` ya existe → preguntar sobrescribir / backup `.bak` / cancelar.
5. Escribir el archivo.
6. Confirmar al usuario con `✓ <tipo> guardado en <ruta>`.

**Ejemplos:**

| Comando | Path resultante |
|---|---|
| `duck-analyze PANA-123` (opción `e`) | `<analyze.export_dir>/PANA-123/PANA-123_analyze.<ext>` |
| `duck-plan PANA-123` | `<plan.output_dir>/PANA-123/PANA-123_plan.<ext>` |
| `duck-review PANA-123` (export=true) | `<review.export_dir>/PANA-123/PANA-123_review.<ext>` |
| `duck-audit --branch` (rama `feature/PANA-123-foo`) | `<audit.export_dir>/PANA-123/PANA-123_audit.<ext>` |
| `duck-audit src/X.php` (sin key) | `<audit.export_dir>/audit/X.php_audit.<ext>` |
| `duck-audit all` (sin key) | `<audit.export_dir>/audit/all_audit.<ext>` |

**Por qué:** todos los artefactos de un mismo ticket viven en una sola carpeta. Fácil de zip / share / archivar por ticket sin reconstruir el set manualmente.

**Validación:** cualquier nuevo skill que persista artefactos debe citar esta sección y aplicar `mkdir -p` + subcarpeta. Si un export bypassa la regla, es un bug.

---

## 2. Idioma del contenido exportado

**Regla:** cualquier artefacto generado por rubber-duck (plan, informe, export de análisis, etc.) se redacta en el idioma configurado en `output.language` (`es` por defecto, `en` opcional).

**Literales que no se traducen:**

- Jira keys (`PANA-123`, `TAPEO-456`).
- X-Ray IDs.
- Símbolos de código (`PaymentService::process()`, `App\Controllers\...`).
- Paths de archivos y carpetas.
- Comandos shell, queries SQL, URLs.
- Frontmatter de YAML, claves de JSON.

**Aplicabilidad:** skills downstream que generen texto user-facing (planner, reviewer, jira-analyzer, futuro auditor) cargan `output.language` y rinden en consecuencia. Si una plantilla externa fuerza un idioma, **se modifica la plantilla local** (caso `templates/planning-template.md`, ver `templates/README.md` §"Divergencias locales").

---

## 3. Detección dinámica de proyecto

**Regla:** ningún skill, agent, command o helper hardcodea paths de proyectos. La fuente de verdad para `$PROJECT_ROOT` y `$PROJECT_TYPE` es `bin/lib/detect-project.sh`, ejecutada por el dispatcher (`bin/duck.sh`) y por los slash commands `/duck-*` en su Paso 1.

**Fitness check** (manual o automatizado en F13.10):

```bash
grep -rE "/home/[^/]+/proyectos/(ai-development-rules|tilt)" \
  skills/ agents/ commands/ templates/ bin/lib/ \
  | grep -v '<usuario>'
```

Debe devolver 0 matches.

---

## 4. Self-contained (cero dependencias externas)

**Regla:** rubber-duck no asume la existencia de otros repositorios ni rutas absolutas externas en runtime. Toda plantilla, recurso o snippet que rubber-duck necesite vive **dentro del repo**, en `$RUBBER_DUCK_HOME/templates/` u otra carpeta interna.

Cuando una plantilla provenga originalmente de otro proyecto, se **copia** a `templates/` y se referencia siempre como `$RUBBER_DUCK_HOME/templates/<nombre>.md`. Origen + commit + fecha de copia se anotan en `templates/README.md`.

---

## 5. Restricciones operacionales heredadas del proyecto

Estas restricciones se aplican a cualquier comando que toque new-admin (y por extensión a old-admin salvo indicación contraria):

- **R1 (Jira):** escritura solo en flujos explícitos con confirmación expresa del usuario (`duck-analyze`, `duck-review`). El resto de flujos solo lee.
- **R2 (BBDD):** prohibido `INSERT`/`UPDATE`/`DELETE`/`ALTER`/`DROP`/`TRUNCATE`. BBDD compartida new-admin ↔ old-admin: cualquier mutación afecta a ambos.
- **R3 (Arquitectura new-admin):** hexagonal validada por `phparkitect`. Controllers → Services → Repositories → Models.
- **R4 (Controllers new-admin):** sin `AbstractController`. Service inyectado por parámetro.
- **R5 (HTTP codes new-admin):** `Slim\Http\StatusCode::HTTP_*`, nunca literales.
- **R6 (Frontend new-admin):** 100% Options API. Container + Presentational. Módulos en `dev/vue/modules/`.
- **R7 (BBDD compartida):** ver R2. Advertir cuando un cambio afecta a ambos proyectos.

**Política old-admin:** mantenimiento-only. Funcionalidad nueva → advertir + proponer `duck-migrate`. Scope estricto `/admin` (whitelist en `skills/project-context/old_admin.md`).

---

## Mantenimiento de este archivo

- Las reglas se añaden aquí cuando son transversales (afectan a ≥2 skills/agents/commands).
- Cuando una skill nueva entre en escena, **debe citar las secciones aplicables** de este archivo en su `SKILL.md`.
- Si una sección queda obsoleta, **modificarla con un commit explícito** y propagar la actualización a las skills/agents/commands afectados en el mismo PR.
