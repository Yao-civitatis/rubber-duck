#!/usr/bin/env bash
# duck.sh — dispatcher central de rubber-duck.
#
# Uso interno: invocado por los wrappers ~/.local/bin/duck-<cmd> que setup.sh crea.
#   bin/duck.sh <comando> [argumentos...]
#
# - Localiza commands/<comando>.md
# - Para comandos que tocan un proyecto, detecta $PROJECT_ROOT y $PROJECT_TYPE
# - Compone un system prompt (contexto + restricciones + instrucciones del comando)
# - Invoca `claude` pasándole los argumentos del usuario como prompt inicial

set -euo pipefail

# -----------------------------------------------------------------------------
# 1. Bootstrap
# -----------------------------------------------------------------------------

# $RUBBER_DUCK_HOME se exporta desde el rcfile por setup.sh. Fallback al
# directorio padre de este script para que pueda ejecutarse antes del install.
if [[ -z "${RUBBER_DUCK_HOME:-}" ]]; then
  RUBBER_DUCK_HOME="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  export RUBBER_DUCK_HOME
fi

# shellcheck source=lib/detect-project.sh
source "$RUBBER_DUCK_HOME/bin/lib/detect-project.sh"

# -----------------------------------------------------------------------------
# 2. Parseo de comando
# -----------------------------------------------------------------------------

if [[ $# -lt 1 ]]; then
  echo "🦆 duck: falta el nombre del comando." >&2
  echo "    Uso: duck-<comando> [argumentos]" >&2
  echo "    Lista de comandos: duck-help" >&2
  exit 2
fi

cmd="$1"
shift
cmd_file="$RUBBER_DUCK_HOME/commands/${cmd}.md"

if [[ ! -f "$cmd_file" ]]; then
  echo "🦆 duck: comando \"$cmd\" no encontrado (esperado en $cmd_file)." >&2
  echo "    Ejecuta 'duck-help' para ver los comandos disponibles." >&2
  exit 2
fi

# -----------------------------------------------------------------------------
# Short-circuit: duck-config {list|get|set|reset} se atiende en bash puro.
# Solo 'duck-config setup' (wizard interactivo) pasa por Claude.
# -----------------------------------------------------------------------------

if [[ "$cmd" == "config" ]]; then
  sub="${1:-list}"
  case "$sub" in
    list|get|set|reset)
      # shellcheck source=lib/config.sh
      exec "$RUBBER_DUCK_HOME/bin/lib/config.sh" "$@"
      ;;
    setup)
      # cae al flujo normal: Claude lanza el wizard via skill.
      ;;
    *)
      echo "Subcomando desconocido: $sub" >&2
      echo "Uso: duck-config {list|get|set|reset|setup} ..." >&2
      exit 2
      ;;
  esac
fi

# -----------------------------------------------------------------------------
# 3. Comandos que NO requieren proyecto
# -----------------------------------------------------------------------------

# Estos comandos no operan sobre un proyecto concreto y no necesitan detección.
PROJECT_AGNOSTIC_CMDS=("config" "help" "install-hooks")

is_project_agnostic() {
  local c="$1"
  for x in "${PROJECT_AGNOSTIC_CMDS[@]}"; do
    [[ "$c" == "$x" ]] && return 0
  done
  return 1
}

# -----------------------------------------------------------------------------
# 4. Detección de proyecto (cuando aplica)
# -----------------------------------------------------------------------------

if ! is_project_agnostic "$cmd"; then
  if ! detect_project_root; then
    duck_detection_error
    exit 3
  fi
fi

# -----------------------------------------------------------------------------
# 5. Construcción del system prompt
# -----------------------------------------------------------------------------

build_system_prompt() {
  echo "# rubber-duck — comando \`$cmd\`"
  echo
  if ! is_project_agnostic "$cmd"; then
    echo "## Contexto del proyecto"
    echo
    echo "- \`\$PROJECT_ROOT\` = \`$PROJECT_ROOT\`"
    echo "- \`\$PROJECT_TYPE\` = \`$PROJECT_TYPE\`"
    echo
    echo "## Restricciones operacionales (CRÍTICAS)"
    echo
    echo "- **R1 (Jira):** escritura permitida SOLO en flujos explícitos con confirmación del usuario (\`duck-analyze\`, \`duck-review\`)."
    echo "- **R2 (BBDD):** nunca ejecutes \`INSERT\`/\`UPDATE\`/\`DELETE\`/\`ALTER\`/\`DROP\`/\`TRUNCATE\`. La BBDD es compartida entre new-admin y old-admin."
    if [[ "$PROJECT_TYPE" == "new-admin" ]]; then
      echo "- **R3 (Arquitectura):** respeta la arquitectura hexagonal validada por \`phparkitect\` (Controllers → Services → Repositories → Models)."
      echo "- **R4 (Controllers):** sin \`AbstractController\`; inyecta el Service por parámetro."
      echo "- **R5 (HTTP codes):** usa \`Slim\\Http\\StatusCode::HTTP_*\`, nunca literales numéricos."
      echo "- **R6 (Frontend):** 100% Options API, Container + Presentational, módulos en \`dev/vue/src/modules/\`."
      echo "- Carga \`$PROJECT_ROOT/.claude/domain-index.md\`, \`project-context.md\` y \`refactoring-state.md\` si existen antes de explorar código."
      echo "- Toolchain de calidad: usa \`$PROJECT_ROOT/bin/pre-commit <herramienta>\` (no reimplementes phpstan/php-cs-fixer/phparkitect)."
    else
      echo "- **Política old-admin (mantenimiento-only):** solo bug fixes y mantenimiento. Si el plan describe funcionalidad nueva → advierte y propone hacerlo en new-admin."
      echo "- **Scope estricto:** solo se tocan rutas del módulo \`/admin\`: \`application/admin/\`, \`application/lib/{Admin,Dao/Admin,Dto/Admin,Queues/Newadmin,NewAdmin}/\`, \`application/templates/admin/\`, \`webroot/(static|dev)/(js|scss|css)/admin/\`, \`dev/src/js/admin/\`, \`application/css_admin/\`. Rechaza cambios fuera."
      echo "- **Sin estándares formales ni Confluence ni herramientas de calidad.** Audit = sentido común (seguridad, lógica). No reportes estilo legacy."
      echo "- **Stack legacy (PHP 5.6):** no uses syntax post-5.6 (sin spread \`...\`, sin \`??\`, sin typed properties, sin return types nullable). Imita el estilo del archivo editado."
      echo "- **Visión:** eliminar old-admin → migrar a new-admin. Cuando un cambio sea no trivial, sugiere usar \`duck-migrate\`."
    fi
    echo
  fi
  echo "## Instrucciones del comando"
  echo
  cat "$cmd_file"
}

system_prompt=$(build_system_prompt)

# -----------------------------------------------------------------------------
# 6. Construcción del prompt inicial del usuario
# -----------------------------------------------------------------------------

if [[ $# -gt 0 ]]; then
  user_prompt="Ejecuta el comando \`duck-$cmd\` con los siguientes argumentos: $*"
else
  user_prompt="Ejecuta el comando \`duck-$cmd\` sin argumentos."
fi

# -----------------------------------------------------------------------------
# 7. Invocación de claude
# -----------------------------------------------------------------------------

if [[ -n "${DUCK_DRY_RUN:-}" ]]; then
  echo "=== DUCK_DRY_RUN (no se invoca claude) ==="
  echo "--- system prompt ---"
  echo "$system_prompt"
  echo "--- user prompt ---"
  echo "$user_prompt"
  exit 0
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "🦆 duck: no se encuentra el binario 'claude' en el PATH." >&2
  echo "    Instala Claude Code y vuelve a ejecutar." >&2
  exit 4
fi

exec claude --append-system-prompt "$system_prompt" "$user_prompt"
