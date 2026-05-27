# Comando `duck-audit`

Audita el código del proyecto detectado combinando análisis estático del toolchain del propio proyecto (new-admin) y revisión semántica contra las normas vivas.

## Uso

```
duck-audit <ruta|all|--branch>
```

Si no se pasa argumento, se usa `audit.default_mode` (default `branch`).

Ejemplos:

```bash
duck-audit src/Services/PaymentService.php   # un archivo
duck-audit app/Controllers/                  # una carpeta
duck-audit all                               # todo el proyecto
duck-audit --branch                          # archivos cambiados vs main/master
duck-audit                                   # default según audit.default_mode
```

## Comportamiento

Carga el skill `$RUBBER_DUCK_HOME/skills/code-audit/SKILL.md` y sigue su flujo:

1. **Resuelve la lista de archivos** según el modo (`<ruta>` / `all` / `--branch`).
2. **Valida scope** (solo old-admin): archivos fuera del whitelist `/admin` → hallazgos bloqueantes.
3. **Infiere JIRA-KEY** desde el nombre de la rama (`feature/PANA-123-foo` → `PANA-123`) si aplica.
4. **Capa estática (solo new-admin):** delega en `$PROJECT_ROOT/bin/pre-commit php-cs-fixer|phpstan|phparkitect`. Captura output y normaliza a hallazgos.
5. **Capa semántica:** cruza el código con `~/.rubber-duck/docs/<proyecto>/{backend,frontend}-standards.md` (new-admin) o con buenas prácticas generales + reglas de seguridad/PHP 5.6 (old-admin).
6. **Informe unificado** con tabla de severidades + veredicto 🟢/🟡/🔴.
7. **Veredicto/exit code** según `audit.fail_on`.
8. **Exporta el informe** si `audit.export=true`, siguiendo `$RUBBER_DUCK_HOME/rules/export-paths.md`:
   - Con JIRA-KEY: `<audit.export_dir>/<JIRA-KEY>/<JIRA-KEY>_audit.<ext>`
   - Sin JIRA-KEY: `<audit.export_dir>/audit/<slug>_audit.<ext>` (`<slug>` = `branch`, `all`, o basename del archivo).

## Reglas universales aplicables

- `$RUBBER_DUCK_HOME/rules/export-paths.md` — paths del informe exportado.
- `$RUBBER_DUCK_HOME/rules/output-language.md` — informe en `output.language`.
- `$RUBBER_DUCK_HOME/rules/project-detection.md` — `$PROJECT_ROOT`/`$PROJECT_TYPE`.
- `$RUBBER_DUCK_HOME/rules/operational-restrictions.md` — R1-R7 cargadas para los checks semánticos.

## Diferencias por proyecto

| | new-admin | old-admin |
|---|---|---|
| Capa estática | ✓ phpstan + php-cs-fixer + phparkitect (vía `bin/pre-commit`) | ✗ (sin herramientas, política mantenimiento) |
| Capa semántica | R3-R6 + estándares Confluence + project-snapshot | sentido común: seguridad, lógica, scope, sintaxis PHP 5.6 |
| Scope check | n/a | obligatorio (whitelist `/admin`) |
| Reporta estilo legacy | n/a | **No** (short tags, indentación, etc. son estado normal) |

## Configuración relacionada

| Clave | Default | Efecto |
|---|---|---|
| `audit.default_mode` | `branch` | Modo cuando no se pasa argumento |
| `audit.fail_on` | `error` | Severidad mínima que bloquea (`error`, `warning`, `all`) |
| `audit.export` | `false` | Exportar informe a archivo |
| `audit.export_format` | `md` | `md`, `html`, `json`, `txt` |
| `audit.export_dir` | `.` | Raíz del directorio destino (relativo a `$PROJECT_ROOT` si no es absoluto) |
| `output.language` | `es` | Idioma del informe |

## Restricciones

- **R1 (Jira):** este comando no escribe en Jira.
- **R2 (BBDD):** no ejecuta queries.
- **Toolchain delegado:** new-admin siempre vía `bin/pre-commit`; nunca se invocan phpstan/php-cs-fixer/phparkitect en el host.
- **Scope (old-admin):** archivos fuera del whitelist → hallazgo bloqueante; no se analizan técnicamente.
- **phparkitect baseline:** nunca añadir entradas sin permiso expreso del usuario.

## Uso típico

- Manual antes de commitear: `duck-audit --branch`.
- En git hooks: `pre-commit` hook ejecuta `duck-audit <archivos-staged>` (F9 pendiente).
- En CI: comparar con `audit.fail_on=error` para bloquear merges con errores.

## Errores y exit codes

| Situación | Exit |
|---|---|
| 🟢 OK | 0 |
| 🟡 Observaciones bajo el umbral | 0 |
| 🔴 Bloqueante (sobre el umbral `audit.fail_on`) | 1 |
| Detección de proyecto falló | 3 |
| Lista de archivos vacía (sin cambios en `--branch`, p.ej.) | 0 (mensaje informativo) |
| Argumento inválido | 2 |
| Toolchain caído (Docker/Tilt off) | 0 con warning (continúa con capa semántica) |
