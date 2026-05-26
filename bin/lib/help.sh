#!/usr/bin/env bash
# help.sh — renderiza la ayuda de duck-* en tres modos:
#
#   help.sh                       ayuda general (lista de comandos)
#   help.sh <comando>             ayuda detallada del comando
#   help.sh config.<clave>        ayuda detallada de una clave de config
#
# Es invocado por bin/duck.sh cuando el comando es "help".

set -uo pipefail

if [[ -z "${RUBBER_DUCK_HOME:-}" ]]; then
  # bin/lib/help.sh → ../../ = repo root
  RUBBER_DUCK_HOME="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi

# Carga config.sh para reutilizar el schema en duck-help config.<clave>.
# shellcheck source=config.sh
source "$RUBBER_DUCK_HOME/bin/lib/config.sh"

# -----------------------------------------------------------------------------
# Catálogo de comandos.
# Sincronizar con setup.sh COMMANDS y con el README §"Comandos que instala".
# -----------------------------------------------------------------------------

declare -A HELP_SHORT=(
  [analyze]="Lee un ticket de Jira, genera User Story + AC + Consideraciones Técnicas. Pide confirmación antes de actualizar Jira (append idempotente)."
  [plan]="Genera un plan de implementación detallado a partir del ticket. Guarda PROJ-XXX_plan.md (o .html según config)."
  [implement]="Implementa el código a partir del plan indicado. Detecta automáticamente new-admin o old-admin."
  [review]="Revisa que el código implementado cumple los requisitos del ticket. Puede postear el informe como comentario en Jira tras confirmación."
  [audit]="Audita el código contra las normas del proyecto. new-admin: delega en bin/pre-commit (phpstan/php-cs-fixer/phparkitect). old-admin: sentido común."
  [sync-docs]="Sincroniza docs desde Confluence (solo new-admin) y regenera el project-snapshot.md de cada proyecto."
  [config]="Gestiona la configuración personal en ~/.rubber-duck/config.json (list/get/set/reset/setup)."
  [help]="Muestra esta ayuda, o ayuda detallada de un comando o clave de config."
  [onboarding]="Sesión interactiva para developers nuevos. Carga el contexto completo de ambos proyectos."
  [debug]="Diagnostica bugs. Acepta un mensaje de error o una Jira key."
  [migrate]="Migra código de old-admin a new-admin (prioridad estratégica del equipo)."
  [db]="Asistente de base de datos. Modo read-only obligatorio (R2): nunca INSERT/UPDATE/DELETE."
  [standup]="Genera el resumen del daily a partir de tus tickets de Jira con actividad reciente."
  [upgrade]="Gestiona la migración de stack de new-admin (PHP 7.4→8.2, Slim 3→Laravel 11, Vue 2→Vue 3+Vite)."
  [install-hooks]="Instala los git hooks de rubber-duck en el repo indicado."
)

declare -A HELP_USAGE=(
  [analyze]="duck-analyze <JIRA-KEY> [archivo-contexto]"
  [plan]="duck-plan <JIRA-KEY>"
  [implement]="duck-implement <PROJ-XXX_plan.md>"
  [review]="duck-review <JIRA-KEY>"
  [audit]="duck-audit <ruta|all|--branch>   (proyecto detectado por CWD)"
  [sync-docs]="duck-sync-docs [new-admin|old-admin|all]"
  [config]="duck-config {list|get|set|reset|setup} [clave] [valor]"
  [help]="duck-help [comando|config|config.<clave>]"
  [onboarding]="duck-onboarding"
  [debug]="duck-debug <\"mensaje de error\"|JIRA-KEY>"
  [migrate]="duck-migrate <ruta-en-old-admin>"
  [db]="duck-db \"<pregunta o consulta>\"|<JIRA-KEY>"
  [standup]="duck-standup"
  [upgrade]="duck-upgrade {plan|migrate|status|check|--next} [ruta]"
  [install-hooks]="duck-install-hooks [ruta-al-repo]"
)

declare -A HELP_DETAILS
HELP_DETAILS[analyze]="$(cat <<'EOF'
1. Lee el ticket vía MCP Atlassian (incluyendo descripción actual).
2. Genera tres secciones: User Story, Criterios de Aceptación, Consideraciones Técnicas.
3. Muestra el resultado y pide confirmación.
4. Si confirmas, actualiza la descripción del ticket de forma idempotente:
   - Bloque entre marcadores <!-- rubber-duck:start --> / <!-- rubber-duck:end -->
   - Si los marcadores ya existían → reemplaza solo el bloque
   - Si no existían → añade al final preservando el resto

EJEMPLOS
  duck-analyze PANA-123
  duck-analyze PANA-123 ./notas-extra.txt
EOF
)"

HELP_DETAILS[plan]="$(cat <<'EOF'
Genera PROJ-XXX_plan.md a partir del ticket. Detecta dominio consultando
.claude/domain-index.md (new-admin). Sigue el formato del template
templates/planning-template.md (copia local; no depende de paths externos).

Respeta los valores de config:
  plan.output_format  md | html
  plan.output_dir     directorio destino

EJEMPLO
  duck-plan PANA-123      # genera ./PANA-123_plan.md
EOF
)"

HELP_DETAILS[implement]="$(cat <<'EOF'
Lee el plan .md indicado y escribe el código respetando el stack del
proyecto detectado:
  new-admin: PHP 7.4 + Slim 3 + Eloquent + Twig + Vue 2.6 Options API
             Arquitectura hexagonal (R3-R6)
  old-admin: PHP 5.6 + Apache + HTML/jQuery dentro de /admin
             Mantenimiento-only; rechaza nuevas funcionalidades

Si implement.auto_format=true y el proyecto es new-admin, ejecuta
$PROJECT_ROOT/bin/pre-commit php-cs-fixer al terminar.

EJEMPLO
  duck-implement PANA-123_plan.md
EOF
)"

HELP_DETAILS[review]="$(cat <<'EOF'
Compara el código con los AC del ticket original. Genera un informe
estructurado (qué cumple / qué falta / qué corregir).

Si review.update_jira=true (default), tras mostrar el informe pide
confirmación. Si confirmas, postea como comentario en el ticket.
Si rechazas, no toca Jira (el texto sigue disponible para copia manual).

Si review.export=true, también guarda el informe a archivo
(review.export_format, review.export_dir).

EJEMPLO
  duck-review PANA-123
EOF
)"

HELP_DETAILS[audit]="$(cat <<'EOF'
Tres modos:
  duck-audit <ruta>          audita un archivo o directorio concreto
  duck-audit all             audita todo el proyecto
  duck-audit --branch        audita solo archivos modificados vs main/master

new-admin:
  Delega en $PROJECT_ROOT/bin/pre-commit con los archivos relevantes.
  Capas: phpstan, php-cs-fixer, phparkitect + semántica vs docs/.

old-admin:
  Modo "sentido común" (sin phpstan/phparkitect/php-cs-fixer).
  Revisa: SQL injection, XSS, lógica obviamente rota.
  NO reporta estilo legacy (short tags, etc.) — es el estado normal.

EJEMPLOS
  duck-audit src/Services/PaymentService.php
  duck-audit --branch
  duck-audit all
EOF
)"

HELP_DETAILS[sync-docs]="$(cat <<'EOF'
Dos modos en paralelo cuando aplica:

1. Sync Confluence (solo new-admin):
   - Lee mcp/atlassian/page-ids.json
   - new-admin/backend  → docs/new-admin/backend-standards.md
   - new-admin/frontend → docs/new-admin/frontend-standards.md
   - old-admin: skip total (no hay Confluence, política de mantenimiento)

2. Análisis del código real:
   - Lee composer.json + dev/package.json (new-admin) o package.json
   - Genera docs/<proyecto>/project-snapshot.md
   - old-admin: análisis restringido al scope /admin

EJEMPLOS
  duck-sync-docs new-admin
  duck-sync-docs old-admin
  duck-sync-docs all
EOF
)"

HELP_DETAILS[config]="$(cat <<'EOF'
Subcomandos:
  list                        lista todas las claves con valor + default
  get <clave>                 imprime el valor actual (o default)
  set <clave> <valor>         valida y persiste
  reset <clave>               vuelve al default de esa clave
  reset --all                 borra el archivo entero
  setup                       lanza el wizard interactivo (vía Claude)

list/get/set/reset se ejecutan en bash puro (instantáneo).
Solo setup pasa por Claude.

EJEMPLOS
  duck-config list
  duck-config set plan.output_format html
  duck-config reset --all

CONFIGURACIÓN RELACIONADA
  duck-help config            lista todas las claves disponibles
  duck-help config.<clave>    detalle de una clave concreta
EOF
)"

HELP_DETAILS[help]="$(cat <<'EOF'
Tres modos:
  duck-help                       ayuda general (lista de comandos)
  duck-help <comando>             ayuda detallada del comando
  duck-help config                lista todas las claves de configuración
  duck-help config.<clave>        detalle de una clave concreta

EJEMPLOS
  duck-help
  duck-help audit
  duck-help config
  duck-help config.audit.export_format
EOF
)"

HELP_DETAILS[onboarding]="$(cat <<'EOF'
Sesión interactiva. Carga el contexto completo de ambos proyectos
(.claude/project-context.md, domain-index.md, refactoring-state.md
cuando existen) y queda a la espera de tus preguntas sin
necesidad de molestar al equipo.

EJEMPLO
  duck-onboarding
EOF
)"

HELP_DETAILS[debug]="$(cat <<'EOF'
Diagnostica bugs. Acepta dos formas de entrada:
  duck-debug "mensaje de error literal"
  duck-debug PANA-456    (lee el bug report desde Jira)

Hipótesis ordenadas por probabilidad. Para new-admin usa
.claude/agents/incident-analyst.md como base si existe.
EOF
)"

HELP_DETAILS[migrate]="$(cat <<'EOF'
Migra código del módulo /admin de civitatis (old-admin) al stack de
new-admin (PHP 7.4 + Slim 3 + Eloquent + Vue 2 Options API).
Prioridad estratégica del equipo: objetivo a largo plazo es
eliminar old-admin.

EJEMPLO
  duck-migrate application/admin/modules/payments/
EOF
)"

HELP_DETAILS[db]="$(cat <<'EOF'
Asistente de base de datos sobre la BBDD compartida entre new-admin
y old-admin.

MODO READ-ONLY OBLIGATORIO (R2):
  Rechaza INSERT, UPDATE, DELETE, ALTER, DROP, TRUNCATE.
  Si necesitas escritura, te redactará la query exacta para que la
  ejecutes tú manualmente.

EJEMPLOS
  duck-db "cuántos pedidos activos hay"
  duck-db PANA-789    (analiza qué consultas necesita el ticket)
EOF
)"

HELP_DETAILS[standup]="$(cat <<'EOF'
Lee tus tickets de Jira con actividad en las últimas 24h
(filtrados por customfield_11001 = "Civitatis Admin") y genera
un resumen estructurado:
  - Qué hice ayer
  - Qué haré hoy
  - Bloqueos

Listo para copiar al canal del equipo.

EJEMPLO
  duck-standup
EOF
)"

HELP_DETAILS[upgrade]="$(cat <<'EOF'
Gestiona la migración de stack de new-admin en tres frentes:
  PHP 7.4 → 8.2
  Slim 3  → Laravel 11
  Vue 2.6 + Webpack 4 → Vue 3 + Vite

MODOS
  duck-upgrade plan               roadmap completo → upgrade-plan.md
  duck-upgrade migrate <ruta>     migra archivo o carpeta concreta
  duck-upgrade migrate --next     siguiente archivo pendiente del plan
  duck-upgrade status             muestra progreso de la migración
  duck-upgrade check <ruta>       revisa compatibilidad sin modificar

Mantiene estado en ~/.rubber-duck/upgrade-status.json.

EJEMPLO
  duck-upgrade plan
  duck-upgrade migrate app/Services/PaymentService.php
EOF
)"

HELP_DETAILS[install-hooks]="$(cat <<'EOF'
Instala los tres git hooks de rubber-duck en el repo indicado:
  pre-commit   → duck-audit sobre archivos staged
  pre-push     → duck-review sobre la Jira key extraída del nombre de rama
  post-merge   → duck-sync-docs all

Si el repo ya tenía un hook con el mismo nombre, se preserva como .bak.

EJEMPLOS
  duck-install-hooks           (en el directorio actual)
  duck-install-hooks /ruta/al/repo
EOF
)"

# -----------------------------------------------------------------------------
# Renderers
# -----------------------------------------------------------------------------

help_general() {
  cat <<'EOF'
🦆 rubber-duck — asistente de desarrollo para New Admin

COMANDOS

EOF
  # Orden estable (no por hash). Sincronizar con setup.sh COMMANDS.
  for cmd in analyze plan implement review audit sync-docs config help \
             onboarding debug migrate db standup upgrade install-hooks; do
    printf '  duck-%-15s  %s\n' "$cmd" "${HELP_SHORT[$cmd]}"
  done
  cat <<EOF

Configuración actual:  duck-config list
Detalle de comando:    duck-help <comando>
Detalle de config:     duck-help config.<clave>
Versión:               rubber-duck (rama: $(git -C "$RUBBER_DUCK_HOME" rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'desconocida'))
EOF
}

help_command() {
  local cmd="$1"
  if [[ -z "${HELP_SHORT[$cmd]+set}" ]]; then
    echo "🦆 No existe el comando 'duck-$cmd'." >&2
    echo "   Ejecuta 'duck-help' para ver la lista." >&2
    return 2
  fi

  cat <<EOF
🦆 duck-$cmd — ${HELP_SHORT[$cmd]}

USO
  ${HELP_USAGE[$cmd]}

${HELP_DETAILS[$cmd]}
EOF
}

help_config_general() {
  echo "🦆 Configuración de rubber-duck (~/.rubber-duck/config.json)"
  echo
  echo "Claves disponibles:"
  echo
  while IFS= read -r key; do
    local val def
    val="$(config_get "$key")"
    def="$(config_default "$key")"
    printf '  %-32s actual=%-10s default=%-10s\n' "$key" "${val:-(vacío)}" "${def:-(vacío)}"
  done < <(config_keys)
  echo
  echo "Detalle de una clave concreta:"
  echo "  duck-help config.<clave>"
  echo
  echo "Cambiar un valor:"
  echo "  duck-config set <clave> <valor>"
}

help_config_key() {
  local key="$1"
  if ! config_is_valid_key "$key"; then
    echo "🦆 Clave de configuración desconocida: '$key'." >&2
    echo "   Ejecuta 'duck-help config' para ver la lista." >&2
    return 2
  fi
  local desc def allowed val
  desc="$(config_describe "$key")"
  def="$(config_default "$key")"
  allowed="$(config_allowed "$key")"
  val="$(config_get "$key")"

  cat <<EOF
🦆 config  →  $key

DESCRIPCIÓN
  $desc

VALORES POSIBLES
EOF
  if [[ "$allowed" == "*" ]]; then
    echo "  cualquier valor (texto libre)"
  else
    local IFS='|'
    for v in $allowed; do
      printf '  %s\n' "$v"
    done
  fi
  cat <<EOF

DEFAULT
  ${def:-(vacío)}

VALOR ACTUAL
  ${val:-(vacío)}

CÓMO CAMBIARLO
  duck-config set $key <valor>
EOF
}

# -----------------------------------------------------------------------------
# Entry point
# -----------------------------------------------------------------------------

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  arg="${1:-}"
  case "$arg" in
    "")           help_general ;;
    config)       help_config_general ;;
    config.*)     help_config_key "${arg#config.}" ;;
    *)            help_command "$arg" ;;
  esac
fi
