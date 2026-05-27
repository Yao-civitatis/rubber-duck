#!/usr/bin/env bash
# config.sh — CRUD para ~/.rubber-duck/config.json.
#
# Funciones publicas:
#   config_path                       imprime la ruta del config.json
#   config_init                       crea ~/.rubber-duck/ si falta
#   config_exists                     0 si existe, 1 si no
#   config_keys                       imprime todas las claves validas
#   config_default <key>              imprime el default de la clave
#   config_allowed <key>              imprime valores permitidos ('*' = libre)
#   config_describe <key>             imprime descripcion humana
#   config_get <key>                  imprime valor actual (o default si no fijado)
#   config_get_raw                    imprime el JSON completo (o defaults si no existe)
#   config_set <key> <value>          valida y persiste
#   config_reset <key|--all>          borra clave (o todo) -> vuelve a defaults
#   config_list                       muestra todas las claves con valor + default
#   config_schema_version             imprime version del schema (1)
#
# Requiere jq.

set -uo pipefail

CONFIG_DIR="${RUBBER_DUCK_CONFIG_DIR:-$HOME/.rubber-duck}"
CONFIG_FILE="$CONFIG_DIR/config.json"
CONFIG_SCHEMA_VERSION=1

# -----------------------------------------------------------------------------
# Schema. Sincronizar con README §"Opciones disponibles" y wizard del skill.
# -----------------------------------------------------------------------------

declare -A CONFIG_DEFAULTS=(
  ["analyze.export_format"]="md"
  ["analyze.export_dir"]="."
  ["plan.output_format"]="md"
  ["plan.output_dir"]="."
  ["project.new_admin_path"]=""
  ["project.old_admin_path"]=""
  ["implement.auto_format"]="false"
  ["audit.default_mode"]="branch"
  ["audit.fail_on"]="error"
  ["audit.export"]="false"
  ["audit.export_format"]="md"
  ["audit.export_dir"]="."
  ["review.export"]="false"
  ["review.export_format"]="md"
  ["review.export_dir"]="."
  ["review.update_jira"]="true"
  ["git.auto_commit"]="false"
  ["git.auto_commit_after"]="audit"
  ["git.commit_message_format"]="jira"
  ["git.auto_push"]="false"
  ["git.hooks.pre_commit_enabled"]="false"
  ["git.hooks.pre_push_enabled"]="false"
  ["git.hooks.post_merge_enabled"]="false"
  ["output.language"]="es"
)

declare -A CONFIG_ALLOWED=(
  ["analyze.export_format"]="md|html|json|txt"
  ["analyze.export_dir"]="*"
  ["plan.output_format"]="md|html"
  ["plan.output_dir"]="*"
  ["project.new_admin_path"]="*"
  ["project.old_admin_path"]="*"
  ["implement.auto_format"]="true|false"
  ["audit.default_mode"]="branch|all"
  ["audit.fail_on"]="error|warning|all"
  ["audit.export"]="true|false"
  ["audit.export_format"]="md|html|json|txt"
  ["audit.export_dir"]="*"
  ["review.export"]="true|false"
  ["review.export_format"]="md|html|json|txt"
  ["review.export_dir"]="*"
  ["review.update_jira"]="true|false"
  ["git.auto_commit"]="true|false"
  ["git.auto_commit_after"]="implement|review|audit"
  ["git.commit_message_format"]="jira|conventional|custom"
  ["git.auto_push"]="true|false"
  ["git.hooks.pre_commit_enabled"]="true|false"
  ["git.hooks.pre_push_enabled"]="true|false"
  ["git.hooks.post_merge_enabled"]="true|false"
  ["output.language"]="es|en"
)

declare -A CONFIG_DESCRIPTIONS=(
  ["analyze.export_format"]="Formato del archivo exportado por duck-analyze (opcion 'e' en la confirmacion)"
  ["analyze.export_dir"]="Dir destino duck-analyze (relativo a \$PROJECT_ROOT si no empieza por '/' o '~'). Path final: <resolved>/<JIRA-KEY>/<JIRA-KEY>_analyze.<ext>"
  ["plan.output_format"]="Formato del archivo generado por duck-plan"
  ["plan.output_dir"]="Dir destino duck-plan (relativo a \$PROJECT_ROOT si no empieza por '/' o '~'). Path final: <resolved>/<JIRA-KEY>/<JIRA-KEY>_plan.<ext>"
  ["project.new_admin_path"]="Ruta al codigo de new-admin (opcional: la detecta el dispatcher)"
  ["project.old_admin_path"]="Ruta al codigo de old-admin/civitatis (opcional: la detecta el dispatcher)"
  ["implement.auto_format"]="Ejecuta php-cs-fixer automaticamente tras implementar"
  ["audit.default_mode"]="Modo por defecto de duck-audit sin argumentos"
  ["audit.fail_on"]="Que nivel de problema bloquea el proceso"
  ["audit.export"]="Exporta el informe de auditoria a un archivo"
  ["audit.export_format"]="Formato del archivo exportado"
  ["audit.export_dir"]="Dir destino duck-audit (relativo a \$PROJECT_ROOT si no empieza por '/' o '~')"
  ["review.export"]="Exporta el informe de revision a un archivo"
  ["review.export_format"]="Formato del archivo exportado"
  ["review.export_dir"]="Dir destino duck-review (relativo a \$PROJECT_ROOT si no empieza por '/' o '~')"
  ["review.update_jira"]="Ofrece anadir el resultado del review al ticket en Jira (siempre con confirmacion)"
  ["git.auto_commit"]="Hace commit automatico al terminar el paso indicado"
  ["git.auto_commit_after"]="En que paso se dispara el commit automatico"
  ["git.commit_message_format"]="Formato del mensaje de commit. jira='KEY: title'. conventional='type: KEY title'. custom=usa ~/.rubber-duck/commit-template.txt con variables {jira_key} {title} {summary} {step} (ver templates/commit-template.example.txt)."
  ["git.auto_push"]="Hace push automatico tras el commit"
  ["git.hooks.pre_commit_enabled"]="Activa el hook git pre-commit instalado en el repo del proyecto (corre duck-audit / bin/pre-commit sobre los staged). Default off para no ralentizar commits."
  ["git.hooks.pre_push_enabled"]="Activa el hook git pre-push (corre duck-review sobre la JIRA-KEY inferida de la rama). Default off."
  ["git.hooks.post_merge_enabled"]="Activa el hook git post-merge (corre duck-sync-docs all tras pull/merge). Default off."
  ["output.language"]="Idioma de los textos y reportes generados"
)

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

config_path() { printf '%s\n' "$CONFIG_FILE"; }
config_schema_version() { printf '%s\n' "$CONFIG_SCHEMA_VERSION"; }

config_init() {
  [[ -d "$CONFIG_DIR" ]] || mkdir -p "$CONFIG_DIR"
}

config_exists() {
  [[ -f "$CONFIG_FILE" ]]
}

config_keys() {
  printf '%s\n' "${!CONFIG_DEFAULTS[@]}" | sort
}

config_is_valid_key() {
  [[ -n "${CONFIG_DEFAULTS[$1]+set}" ]]
}

config_default() {
  printf '%s\n' "${CONFIG_DEFAULTS[$1]:-}"
}

config_allowed() {
  printf '%s\n' "${CONFIG_ALLOWED[$1]:-}"
}

config_describe() {
  printf '%s\n' "${CONFIG_DESCRIPTIONS[$1]:-}"
}

# Convierte "foo.bar.baz" en filtro jq ".foo.bar.baz".
_jq_path() {
  local key="$1" filter="."
  IFS='.' read -ra parts <<< "$key"
  for p in "${parts[@]}"; do
    filter+="[\"$p\"]"
  done
  printf '%s' "$filter"
}

# Devuelve "string" | "bool" | "raw" segun valor permitido.
_value_type() {
  local key="$1"
  local allowed="${CONFIG_ALLOWED[$key]:-}"
  case "$allowed" in
    "true|false") echo "bool" ;;
    *)            echo "string" ;;
  esac
}

# -----------------------------------------------------------------------------
# Validacion
# -----------------------------------------------------------------------------

config_validate() {
  local key="$1" value="$2"
  if ! config_is_valid_key "$key"; then
    echo "Error: clave desconocida '$key'." >&2
    echo "Lista de claves validas: duck-config list" >&2
    return 2
  fi
  local allowed="${CONFIG_ALLOWED[$key]}"
  if [[ "$allowed" == "*" ]]; then
    return 0  # acepta cualquier string
  fi
  local IFS='|'
  local ok=0
  for v in $allowed; do
    [[ "$value" == "$v" ]] && { ok=1; break; }
  done
  if (( ! ok )); then
    echo "Error: valor '$value' no permitido para '$key'." >&2
    echo "Permitidos: ${allowed//|/, }" >&2
    return 2
  fi
  return 0
}

# -----------------------------------------------------------------------------
# Lectura
# -----------------------------------------------------------------------------

config_get() {
  local key="$1"
  if ! config_is_valid_key "$key"; then
    echo "Error: clave desconocida '$key'." >&2
    return 2
  fi
  if ! config_exists; then
    config_default "$key"
    return 0
  fi
  local filter raw
  filter="$(_jq_path "$key")"
  raw="$(jq -r "$filter // empty" "$CONFIG_FILE" 2>/dev/null)"
  if [[ -z "$raw" || "$raw" == "null" ]]; then
    config_default "$key"
  else
    printf '%s\n' "$raw"
  fi
}

config_get_raw() {
  if config_exists; then
    cat "$CONFIG_FILE"
  else
    # JSON minimo con _version + defaults reflejados.
    local out='{"_version":'"$CONFIG_SCHEMA_VERSION"'}'
    for key in "${!CONFIG_DEFAULTS[@]}"; do
      local v="${CONFIG_DEFAULTS[$key]}"
      local type
      type="$(_value_type "$key")"
      if [[ "$type" == "bool" ]]; then
        out="$(jq --arg k "$key" --argjson v "$v" 'setpath($k|split("."); $v)' <<< "$out")"
      else
        out="$(jq --arg k "$key" --arg v "$v" 'setpath($k|split("."); $v)' <<< "$out")"
      fi
    done
    printf '%s\n' "$out"
  fi
}

config_list() {
  printf '%-32s %-12s %-12s %s\n' "CLAVE" "VALOR" "DEFAULT" "DESCRIPCION"
  printf '%-32s %-12s %-12s %s\n' "-----" "-----" "-------" "-----------"
  while IFS= read -r key; do
    local val def desc
    val="$(config_get "$key")"
    def="${CONFIG_DEFAULTS[$key]}"
    desc="${CONFIG_DESCRIPTIONS[$key]}"
    printf '%-32s %-12s %-12s %s\n' "$key" "${val:-(vacio)}" "${def:-(vacio)}" "$desc"
  done < <(config_keys)
  echo
  echo "Archivo: $(config_path)"
  if config_exists; then
    echo "Schema:  _version = $(jq -r '._version // "?"' "$CONFIG_FILE" 2>/dev/null) (actual: $CONFIG_SCHEMA_VERSION)"
  else
    echo "Schema:  (archivo aun no creado; defaults en uso)"
  fi
}

# -----------------------------------------------------------------------------
# Escritura
# -----------------------------------------------------------------------------

config_set() {
  local key="$1" value="$2"
  config_validate "$key" "$value" || return $?

  config_init
  local current type filter
  if config_exists; then
    current="$(cat "$CONFIG_FILE")"
  else
    current="{\"_version\": $CONFIG_SCHEMA_VERSION}"
  fi

  type="$(_value_type "$key")"
  local tmp
  tmp="$(mktemp)"
  if [[ "$type" == "bool" ]]; then
    jq --argjson v "$value" --arg path "$key" 'setpath($path|split("."); $v)' <<< "$current" > "$tmp"
  else
    jq --arg v "$value" --arg path "$key" 'setpath($path|split("."); $v)' <<< "$current" > "$tmp"
  fi

  # Garantiza _version siempre presente.
  jq --argjson v "$CONFIG_SCHEMA_VERSION" '._version = $v' "$tmp" > "$CONFIG_FILE"
  rm -f "$tmp"
  echo "$key = $value"
}

config_reset() {
  local arg="$1"
  if [[ "$arg" == "--all" ]]; then
    if config_exists; then
      rm -f "$CONFIG_FILE"
      echo "Configuracion eliminada. Defaults activos. El asistente se relanza con: duck-config setup"
    else
      echo "Ya estabas en defaults."
    fi
    return 0
  fi

  if ! config_is_valid_key "$arg"; then
    echo "Error: clave desconocida '$arg'." >&2
    return 2
  fi

  if ! config_exists; then
    echo "$arg ya estaba en default (${CONFIG_DEFAULTS[$arg]})."
    return 0
  fi

  local tmp
  tmp="$(mktemp)"
  jq --arg path "$arg" 'delpaths([$path|split(".")])' "$CONFIG_FILE" > "$tmp"
  mv "$tmp" "$CONFIG_FILE"
  echo "$arg reseteado al default (${CONFIG_DEFAULTS[$arg]})."
}

# -----------------------------------------------------------------------------
# Standalone CLI
# -----------------------------------------------------------------------------

# Si se invoca directamente (no source), opera como CLI minimo:
#   bin/lib/config.sh list
#   bin/lib/config.sh get <key>
#   bin/lib/config.sh set <key> <val>
#   bin/lib/config.sh reset <key|--all>

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq no esta instalado." >&2
    exit 5
  fi
  sub="${1:-list}"
  shift || true
  case "$sub" in
    list)   config_list ;;
    get)    [[ $# -ge 1 ]] || { echo "Uso: duck-config get <clave>" >&2; exit 2; }
            config_get "$1" ;;
    set)    [[ $# -ge 2 ]] || { echo "Uso: duck-config set <clave> <valor>" >&2; exit 2; }
            config_set "$1" "$2" ;;
    reset)  [[ $# -ge 1 ]] || { echo "Uso: duck-config reset <clave|--all>" >&2; exit 2; }
            config_reset "$1" ;;
    setup)  echo "El wizard interactivo se ejecuta vía Claude (skill config). Llama 'duck-config setup' a través del dispatcher." >&2
            exit 1 ;;
    *)      echo "Subcomando desconocido: $sub" >&2
            echo "Uso: duck-config {list|get|set|reset|setup}" >&2
            exit 2 ;;
  esac
fi
