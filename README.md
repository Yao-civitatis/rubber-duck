# 🦆 rubber-duck

Asistente de desarrollo basado en Claude para los proyectos **new-admin** y **old-admin** de Civitatis. Automatiza el flujo Jira → análisis → plan → implementación → revisión → audit desde la terminal o desde Claude Code.

```
duck-analyze PANA-123     →    duck-plan PANA-123     →    duck-implement PANA-123_plan.md
                                                                    │
                                                                    ▼
                                          duck-audit --branch    duck-review PANA-123
```

---

## ¿Qué es?

Un repo de **skills, agentes y comandos para Claude** + un puñado de scripts bash. No es una aplicación: es una capa de instrucciones que enseña a Claude cómo trabajar en estos proyectos siguiendo las reglas del equipo.

**Dos formas de uso, mismas funcionalidades:**

- **Terminal:** `duck-analyze PANA-123`
- **Claude Code:** `/duck-analyze PANA-123`

---

## Requisitos

- **Linux / macOS** (no probado en Windows nativo; WSL debería funcionar).
- **bash** ≥ 4.
- **git**.
- **jq** (para CRUD de configuración).
- **Claude Code CLI** (`claude` en `$PATH`).
- **MCP de Atlassian** instalado en Claude Code (para Jira/Confluence).
- **MCP de Database** opcional (para `duck-db`).
- **Cuenta Atlassian** con token API: https://id.atlassian.com/manage-profile/security/api-tokens.

---

## Instalación

```bash
# 1. Clonar
git clone https://github.com/tu-user/rubber-duck ~/proyectos/rubber-duck
cd ~/proyectos/rubber-duck

# 2. Instalar (crea los duck-* en ~/.local/bin/ y los /duck-* en ~/.claude/commands/)
chmod +x setup.sh
./setup.sh

# 3. Recargar shell
source ~/.bashrc      # o source ~/.zshrc

# 4. Lanzar el asistente de configuración personal
#    (incluye pasos opcionales para configurar el MCP de Atlassian y el MCP de Database)
duck-config setup
```

`setup.sh` también siembra `~/.rubber-duck/docs/` con las normas por defecto. Estas se actualizan después con `duck-sync-docs`.

### Verificar que está instalado

```bash
duck-help
which duck-analyze     # → ~/.local/bin/duck-analyze
```

---

## Quick start

Desde dentro del proyecto que vayas a tocar (la detección del proyecto es automática por CWD):

```bash
cd ~/proyectos/tilt/tilts/new-admin       # o civitatis para old-admin

duck-analyze PANA-123                     # lee Jira, propone US + AC + consideraciones
duck-plan PANA-123                        # genera plan en docs/PANA-123/PANA-123_plan.md
duck-implement PANA-123_plan.md           # escribe el código según el plan
duck-audit --branch                       # audit solo de lo cambiado en la rama
duck-review PANA-123                      # cruza el código con los AC del ticket
```

En Claude Code el equivalente es `/duck-analyze PANA-123`, `/duck-plan PANA-123`, etc.

---

## Comandos disponibles

| Comando | Acción |
|---|---|
| `duck-analyze <KEY>` | Lee ticket, genera User Story + AC + Consideraciones. Pide confirmación con 3 opciones: actualizar Jira / nada / exportar. |
| `duck-plan <KEY>` | Genera plan de implementación detallado en formato Spec-Driven. |
| `duck-implement <plan.md>` | Implementa código según el plan. TDD en new-admin; bug fix / mantenimiento en old-admin. |
| `duck-review <KEY>` | Compara código vs AC del ticket. Veredicto 🟢/🟡/🔴. |
| `duck-audit <ruta\|all\|--branch>` | Audit estático + semántico. new-admin: delega en `bin/pre-commit`. old-admin: sentido común. |
| `duck-sync-docs [proyecto]` | Sincroniza docs desde Confluence + analiza el código real. Escribe en `~/.rubber-duck/docs/`. |
| `duck-config {list\|get\|set\|reset\|setup}` | Gestiona la configuración personal. |
| `duck-help [comando\|config.<clave>]` | Ayuda contextual. |
| `duck-onboarding` | Sesión interactiva para devs nuevos. |
| `duck-debug <error\|KEY>` | Diagnóstico de bugs con hipótesis ordenadas. |
| `duck-migrate <ruta-en-old-admin>` | Migra una pieza de old-admin a new-admin. |
| `duck-db "<pregunta>"` | Consultas a la BBDD compartida (modo lectura). |
| `duck-standup` | Genera el resumen del daily desde tu actividad reciente en Jira. |
| `duck-upgrade {plan\|migrate\|status\|check}` | Migración de stack de new-admin (PHP 7→8, Slim→Laravel, Vue 2→3+Vite). |
| `duck-install-hooks [ruta]` | Instala git hooks en un repo (opt-in, desactivados por defecto). |

Detalle de cada comando: `duck-help <comando>` o `/duck-help <comando>`.

---

## Configuración

La configuración personal vive en `~/.rubber-duck/config.json`. Se gestiona con `duck-config`:

```bash
duck-config list                                    # ver todo
duck-config get plan.output_format
duck-config set audit.fail_on warning
duck-config set output.language en
duck-config reset plan.output_format
duck-config reset --all
duck-config setup                                   # relanzar el wizard
```

### Claves más relevantes

| Clave | Default | Para qué |
|---|---|---|
| `output.language` | `es` | Idioma del contenido generado (`es` / `en`). |
| `plan.output_dir` | `.` | Directorio destino de planes (relativo a `$PROJECT_ROOT`). |
| `audit.fail_on` | `error` | Severidad que bloquea (`error` / `warning` / `all`). |
| `audit.export` | `false` | Exportar el informe de audit a archivo. |
| `review.update_jira` | `true` | Ofrecer postear el informe de review como comentario tras confirmación. |
| `git.auto_commit` | `false` | Auto-commit al terminar el paso configurado. |
| `git.hooks.pre_commit_enabled` | `false` | Activa el hook pre-commit instalado por `duck-install-hooks`. |

Ver `duck-help config` para la lista completa con descripciones.

---

## Git hooks

Los hooks están **desactivados por defecto** para no ralentizar tu workflow.

Instalar en un repo:

```bash
cd ~/proyectos/tilt/tilts/new-admin
duck-install-hooks .
```

Activar uno o todos:

```bash
duck-config set git.hooks.pre_commit_enabled true     # audit antes del commit
duck-config set git.hooks.pre_push_enabled true       # review antes del push
duck-config set git.hooks.post_merge_enabled true     # sync-docs tras pull/merge
```

Saltarse un hook puntualmente:

```bash
git commit --no-verify
git push --no-verify
```

---

## Modelo de documentación

`rubber-duck` mantiene una copia local de las normas del equipo en `~/.rubber-duck/docs/<proyecto>/`. Esas son las que consume al planificar/implementar/auditar.

```
$RUBBER_DUCK_HOME/docs/         ← bundle versionado en git (factory default)
       │ copia en primera instalación
       ▼
~/.rubber-duck/docs/            ← copia personal del usuario (la que se usa en runtime)
       ▲
       │ duck-sync-docs la actualiza
```

Actualizar las normas:

```bash
duck-sync-docs all              # ambos proyectos
duck-sync-docs new-admin        # solo backend + frontend standards
duck-sync-docs old-admin        # solo snapshot (sin Confluence — política mantenimiento)
```

---

## Reglas operacionales (importantes)

`rubber-duck` respeta las restricciones definidas por el equipo (detalle en `rules/operational-restrictions.md`):

- **R1 Jira:** lectura libre. Escritura **solo en flujos confirmados** (`duck-analyze`, `duck-review`).
- **R2 BBDD:** **solo lectura.** Queries de mutación se redactan, no se ejecutan.
- **R3-R6 (new-admin):** arquitectura hexagonal, Controllers sin `AbstractController`, códigos HTTP como constantes `StatusCode::HTTP_*`, frontend en Vue 2 Options API.
- **Política old-admin:** modo mantenimiento — solo bug fixes. Para funcionalidad nueva se sugiere `duck-migrate` para llevar la pieza a new-admin.

---

## Desinstalación

```bash
cd ~/proyectos/rubber-duck
./uninstall.sh
```

Elimina los `duck-*` de `~/.local/bin/`, los `/duck-*` de `~/.claude/commands/` y el bloque de tu rcfile. Pregunta antes de borrar `~/.rubber-duck/` (config personal + docs sincronizadas).

---

## Troubleshooting básico

| Síntoma | Solución |
|---|---|
| `duck-help: command not found` | `source ~/.bashrc` o abre terminal nueva tras instalar. |
| `🦆 duck: no se ha detectado ningún proyecto` | Estás fuera de new-admin / civitatis. `cd` al proyecto o configura `duck-config set project.new_admin_path /ruta`. |
| MCP de Atlassian no responde | Verifica `mcp/atlassian/config.json` y reinicia Claude Code. |
| Hook pre-commit lento | Está delegando en `bin/pre-commit` del proyecto (incluye phpstan + tests). Salta puntualmente con `git commit --no-verify`. |
| `duck-sync-docs` falla en Confluence | Lee `~/.rubber-duck/last-post-merge-sync.log` o ejecútalo manualmente para ver el error. |

---

## Para saber más

- [`SPEC.md`](./SPEC.md) — documentación completa del proyecto (estructura, cada skill, cada agente, cada prompt, decisiones de diseño).
- [`rules/`](./rules/) — reglas transversales (paths de export, idioma, detección de proyecto, self-contained, restricciones operacionales).
- [`dev-history/`](./dev-history/) — histórico de planes de implementación.

---

*rubber-duck — porque en vez de contarle tus problemas al pato, él los resuelve.*
