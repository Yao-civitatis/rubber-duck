#!/usr/bin/env bash
# db-env.sh — Loader y gates de seguridad para duck-db multi-entorno.
#
# Carga ~/.rubber-duck/mcp/database/config.json (schema v2) y aplica gates
# anti-mutacion escalonadas por danger_level antes de ejecutar queries.
#
# Funciones publicas:
#   db_env_path                       imprime ruta al config.json
#   db_env_exists                     0 si existe, 1 si no
#   db_env_schema_version             imprime _version del config
#   db_env_list                       lista los entornos definidos (uno por linea)
#   db_env_default                    imprime el env por defecto (debe ser "dev")
#   db_env_resolve <env>              imprime el bloque JSON del env
#   db_env_field <env> <campo>        imprime un campo del env (host/port/.../danger_level)
#   db_env_require_explicit <env> <flag_passed>
#                                     0 si env=dev o flag_passed=1; ≠0 en caso contrario
#   db_env_gate_query_regex <query>   0 si query es SELECT/SHOW/EXPLAIN/DESCRIBE; ≠0 si muta
#   db_env_gate_pre_query <env>       ejecuta gates por danger_level. Banner + exit ≠0 si falla.
#
# Stubs para tests (no usar en produccion):
#   MYSQL_CMD_STUB           path a script que reemplaza la ejecucion de mysql
#   DUCK_DB_CONFIRM_STUB     valor a devolver en la confirmacion interactiva (saltea read)
#
# Exit codes:
#   0   OK
#   2   uso incorrecto (env no existe, etc.)
#   3   config v1 detectado (requiere migracion manual)
#   10  gate (a) config.read_only=false
#   11  gate (b) servidor no es read_only
#   12  gate (c) usuario MySQL tiene privilegios de mutacion
#   13  gate (d) regex de mutacion en query
#   14  gate (e) confirmacion fallida
#
# Requiere jq.

set -uo pipefail

DB_ENV_DIR="${RUBBER_DUCK_CONFIG_DIR:-$HOME/.rubber-duck}/mcp/database"
DB_ENV_FILE="$DB_ENV_DIR/config.json"
DB_ENV_SCHEMA_VERSION_EXPECTED=2

# Colores para banner. Desactivables con DUCK_DB_NO_COLOR=1.
if [[ -t 1 && -z "${DUCK_DB_NO_COLOR:-}" ]]; then
  _C_RED=$'\033[0;31m'
  _C_YEL=$'\033[0;33m'
  _C_GRN=$'\033[0;32m'
  _C_RST=$'\033[0m'
else
  _C_RED=""; _C_YEL=""; _C_GRN=""; _C_RST=""
fi

# -----------------------------------------------------------------------------
# Lectura del config
# -----------------------------------------------------------------------------

db_env_path() { printf '%s\n' "$DB_ENV_FILE"; }

db_env_exists() {
  [[ -f "$DB_ENV_FILE" ]]
}

db_env_schema_version() {
  if ! db_env_exists; then
    echo "Error: $DB_ENV_FILE no existe. Ejecuta 'duck-config setup' o copia config.example.json." >&2
    return 2
  fi
  jq -r '._version // 1' "$DB_ENV_FILE"
}

# Comprueba que el archivo es v2; si es v1, aborta con guia.
db_env_assert_v2() {
  local v
  v="$(db_env_schema_version)" || return $?
  if [[ "$v" != "$DB_ENV_SCHEMA_VERSION_EXPECTED" ]]; then
    cat >&2 <<EOF
${_C_RED}Error: schema v$v detectado, se esperaba v$DB_ENV_SCHEMA_VERSION_EXPECTED.${_C_RST}

Migracion manual requerida:
  1) Renombra $DB_ENV_FILE a $DB_ENV_FILE.v1.bak
  2) Copia la plantilla nueva: $RUBBER_DUCK_HOME/mcp/database/config.example.json
  3) Rellena las credenciales por entorno (dev/qa/slave/prod)
  4) chmod 600 $DB_ENV_FILE

duck-db NO migra el archivo automaticamente para no tocar credenciales personales.
EOF
    return 3
  fi
}

db_env_list() {
  db_env_assert_v2 || return $?
  jq -r '.environments | keys_unsorted[]' "$DB_ENV_FILE"
}

db_env_default() {
  db_env_assert_v2 || return $?
  jq -r '.default // "dev"' "$DB_ENV_FILE"
}

db_env_resolve() {
  local env="$1"
  db_env_assert_v2 || return $?
  if ! jq -e --arg e "$env" '.environments[$e]' "$DB_ENV_FILE" >/dev/null 2>&1; then
    echo "Error: entorno \"$env\" no configurado en $DB_ENV_FILE." >&2
    echo "Disponibles: $(db_env_list | tr '\n' ' ')" >&2
    return 2
  fi
  jq -c --arg e "$env" '.environments[$e]' "$DB_ENV_FILE"
}

db_env_field() {
  local env="$1" field="$2"
  local block
  block="$(db_env_resolve "$env")" || return $?
  jq -r --arg f "$field" '.[$f] // ""' <<<"$block"
}

# -----------------------------------------------------------------------------
# Validacion de uso explicito
# -----------------------------------------------------------------------------
#
# db_env_require_explicit <env> <flag_passed>
#   env         nombre del entorno resuelto
#   flag_passed "1" si el usuario paso --env=, "0" si se uso el default
#
# Regla: si env != dev, flag_passed DEBE ser 1.
db_env_require_explicit() {
  local env="$1" flag_passed="${2:-0}"
  if [[ "$env" == "dev" ]]; then
    return 0
  fi
  if [[ "$flag_passed" != "1" ]]; then
    cat >&2 <<EOF
${_C_RED}Error: entorno "$env" requiere --env=$env explicito.${_C_RST}

Solo "dev" puede operar de forma implicita. Para usar $env:
  duck-db --env=$env "<query>"
EOF
    return 2
  fi
  return 0
}

# -----------------------------------------------------------------------------
# Gate (d) — regex anti-mutacion sobre la query
# -----------------------------------------------------------------------------
#
# Rechaza si la query empieza con un statement de mutacion (tras quitar
# whitespace y comentarios SQL iniciales).
db_env_gate_query_regex() {
  local query="$1"
  # Strip comentarios SQL al inicio y espacios.
  local stripped
  stripped="$(sed -E 's|^[[:space:]]*(/\*[^*]*\*+([^/*][^*]*\*+)*/[[:space:]]*)*||; s|^[[:space:]]*(--[^\n]*)*[[:space:]]*||' <<<"$query")"
  # Tambien tolera leading "-- ..." en linea propia.
  stripped="$(printf '%s' "$stripped" | sed -E ':a;s/^[[:space:]]*--[^\n]*//;ta')"
  shopt -s nocasematch
  local re='^[[:space:]]*(insert|update|delete|alter|drop|truncate|create|rename|grant|revoke|replace|merge|call)\b'
  local re_set='^[[:space:]]*set[[:space:]]+(@?@?global|@?@?persist|@?[a-zA-Z_]+[[:space:]]*=)'
  if [[ "$stripped" =~ $re ]]; then
    shopt -u nocasematch
    echo "${_C_RED}Gate (d) FAIL: query empieza con statement de mutacion.${_C_RST}" >&2
    return 13
  fi
  # Bloquea SET salvo autocommit/session/transaction simples.
  if [[ "$stripped" =~ ^[[:space:]]*set[[:space:]] ]]; then
    if ! [[ "$stripped" =~ ^[[:space:]]*set[[:space:]]+(autocommit|session|transaction|names|character) ]]; then
      shopt -u nocasematch
      echo "${_C_RED}Gate (d) FAIL: SET no permitido (solo autocommit/session/transaction/names/character).${_C_RST}" >&2
      return 13
    fi
  fi
  shopt -u nocasematch
  return 0
}

# -----------------------------------------------------------------------------
# Ejecucion de query auxiliar (para gates b y c).
#
# En tests, override via MYSQL_CMD_STUB (script que recibe env_name + query
# en argv y devuelve el resultado por stdout).
# -----------------------------------------------------------------------------
_db_env_run_aux_query() {
  local env="$1" query="$2"
  if [[ -n "${MYSQL_CMD_STUB:-}" ]]; then
    "$MYSQL_CMD_STUB" "$env" "$query"
    return $?
  fi
  if ! command -v mysql >/dev/null 2>&1; then
    echo "Error: cliente mysql no encontrado en PATH (necesario para gates b y c)." >&2
    return 1
  fi
  local host port user pass db
  host="$(db_env_field "$env" host)"
  port="$(db_env_field "$env" port)"
  user="$(db_env_field "$env" user)"
  pass="$(db_env_field "$env" password)"
  db="$(db_env_field "$env" database)"
  MYSQL_PWD="$pass" mysql -h "$host" -P "$port" -u "$user" -N -B -e "$query" "$db"
}

# -----------------------------------------------------------------------------
# Confirmacion interactiva
#
# DUCK_DB_CONFIRM_STUB: si esta seteada, se usa su valor en lugar de leer.
# -----------------------------------------------------------------------------
_db_env_read_confirm() {
  local prompt="$1"
  if [[ -n "${DUCK_DB_CONFIRM_STUB+set}" ]]; then
    printf '%s' "$DUCK_DB_CONFIRM_STUB"
    return 0
  fi
  local reply
  if [[ -r /dev/tty ]]; then
    read -r -p "$prompt" reply </dev/tty
  else
    read -r -p "$prompt" reply
  fi
  printf '%s' "$reply"
}

# -----------------------------------------------------------------------------
# Banner por env
# -----------------------------------------------------------------------------
_db_env_banner() {
  local env="$1" level="$2"
  case "$level" in
    low)
      echo "${_C_GRN}🦆 duck-db [env=$env] read-only mode (low).${_C_RST}" >&2
      ;;
    medium)
      echo "${_C_YEL}🦆 duck-db [env=$env] ⚠️  READ-ONLY (medium). Confirmacion requerida.${_C_RST}" >&2
      ;;
    high)
      echo "${_C_RED}🦆 duck-db [env=$env] ⚠️  READ-ONLY ENFORCED (high). Gates (a)(b)(c)(e).${_C_RST}" >&2
      ;;
    critical)
      cat >&2 <<EOF
${_C_RED}========================================================
🦆 duck-db [env=$env] 🚨 PRODUCCION 🚨
   READ-ONLY ENFORCED — Gates (a)(b)(c)(e) + tipear "prod"
========================================================${_C_RST}
EOF
      ;;
  esac
}

# -----------------------------------------------------------------------------
# Gate (a) — config.read_only debe ser true
# -----------------------------------------------------------------------------
_db_env_gate_a() {
  local env="$1"
  local ro
  ro="$(db_env_field "$env" read_only)"
  if [[ "$ro" != "true" ]]; then
    echo "${_C_RED}Gate (a) FAIL: environments.$env.read_only != true (valor: '$ro').${_C_RST}" >&2
    return 10
  fi
  return 0
}

# -----------------------------------------------------------------------------
# Gate (b) — servidor MySQL en read_only + super_read_only
# -----------------------------------------------------------------------------
_db_env_gate_b() {
  local env="$1"
  local out
  out="$(_db_env_run_aux_query "$env" "SELECT @@global.read_only, @@global.super_read_only;" 2>/dev/null)"
  local rc=$?
  if (( rc != 0 )); then
    echo "${_C_RED}Gate (b) FAIL: no se pudo consultar @@global.read_only (rc=$rc).${_C_RST}" >&2
    return 11
  fi
  # Espera "1\t1" (modo batch -B usa tab). Aceptar tambien "1 1".
  if ! [[ "$out" =~ ^[[:space:]]*1[[:space:]]+1[[:space:]]*$ ]]; then
    echo "${_C_RED}Gate (b) FAIL: servidor NO es read_only. @@global.read_only,@@global.super_read_only='$out'.${_C_RST}" >&2
    return 11
  fi
  return 0
}

# -----------------------------------------------------------------------------
# Gate (c) — usuario MySQL sin privilegios de mutacion
# -----------------------------------------------------------------------------
_db_env_gate_c() {
  local env="$1"
  local grants
  grants="$(_db_env_run_aux_query "$env" "SHOW GRANTS FOR CURRENT_USER;" 2>/dev/null)"
  local rc=$?
  if (( rc != 0 )); then
    echo "${_C_RED}Gate (c) FAIL: no se pudo consultar SHOW GRANTS (rc=$rc).${_C_RST}" >&2
    return 12
  fi
  # Buscar privilegios peligrosos. ALL PRIVILEGES tambien rechaza.
  local danger='ALL[[:space:]]+PRIVILEGES|INSERT|UPDATE|DELETE|ALTER|DROP|TRUNCATE|CREATE|GRANT[[:space:]]+OPTION|REVOKE|RENAME|REPLACE|MERGE|CALL|SUPER|RELOAD|FILE|PROCESS'
  if grep -qiE "$danger" <<<"$grants"; then
    echo "${_C_RED}Gate (c) FAIL: usuario tiene privilegios de mutacion. Grants:${_C_RST}" >&2
    echo "$grants" >&2
    return 12
  fi
  return 0
}

# -----------------------------------------------------------------------------
# Gate (e) — confirmacion interactiva (slave: y/N, prod: tipear "prod")
# -----------------------------------------------------------------------------
_db_env_gate_e() {
  local env="$1" level="$2"
  local reply
  if [[ "$level" == "critical" ]]; then
    reply="$(_db_env_read_confirm 'Escribe literalmente "prod" para confirmar la ejecucion: ')"
    if [[ "$reply" != "prod" ]]; then
      echo "${_C_RED}Gate (e) FAIL: confirmacion incorrecta para prod (recibido: '$reply').${_C_RST}" >&2
      return 14
    fi
  else
    reply="$(_db_env_read_confirm "Confirmar ejecucion en env=$env (y/N): ")"
    case "$reply" in
      y|Y|yes|YES|s|S|si|SI|sí|Sí|SÍ) ;;
      *)
        echo "${_C_RED}Gate (e) FAIL: confirmacion negativa para env=$env (recibido: '$reply').${_C_RST}" >&2
        return 14
        ;;
    esac
  fi
  return 0
}

# -----------------------------------------------------------------------------
# Orquestador — db_env_gate_pre_query <env>
#
# Ejecuta las gates correspondientes al danger_level del env.
# Imprime banner. Devuelve 0 si todas pasan; 10/11/12/14 segun la primera que falle.
# (La gate (d) regex se invoca por query desde el agente, no aqui.)
# -----------------------------------------------------------------------------
db_env_gate_pre_query() {
  local env="$1"
  local level
  level="$(db_env_field "$env" danger_level)" || return $?
  if [[ -z "$level" ]]; then
    echo "Error: environments.$env.danger_level vacio." >&2
    return 2
  fi

  _db_env_banner "$env" "$level"

  case "$level" in
    low)
      _db_env_gate_a "$env" || return $?
      ;;
    medium)
      _db_env_gate_a "$env" || return $?
      _db_env_gate_e "$env" "$level" || return $?
      ;;
    high)
      _db_env_gate_a "$env" || return $?
      _db_env_gate_b "$env" || return $?
      _db_env_gate_c "$env" || return $?
      _db_env_gate_e "$env" "$level" || return $?
      ;;
    critical)
      _db_env_gate_a "$env" || return $?
      _db_env_gate_b "$env" || return $?
      _db_env_gate_c "$env" || return $?
      _db_env_gate_e "$env" "$level" || return $?
      ;;
    *)
      echo "Error: danger_level desconocido '$level' para env=$env." >&2
      return 2
      ;;
  esac

  echo "${_C_GRN}✓ Gates PASS para env=$env (level=$level).${_C_RST}" >&2
  return 0
}

# -----------------------------------------------------------------------------
# Standalone CLI (debug):
#   bin/lib/db-env.sh list
#   bin/lib/db-env.sh default
#   bin/lib/db-env.sh resolve <env>
#   bin/lib/db-env.sh field <env> <campo>
#   bin/lib/db-env.sh regex "<query>"
#   bin/lib/db-env.sh gate <env>
# -----------------------------------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq no esta instalado." >&2
    exit 5
  fi
  sub="${1:-list}"
  shift || true
  case "$sub" in
    list)     db_env_list ;;
    default)  db_env_default ;;
    resolve)  [[ $# -ge 1 ]] || { echo "Uso: db-env.sh resolve <env>" >&2; exit 2; }
              db_env_resolve "$1" ;;
    field)    [[ $# -ge 2 ]] || { echo "Uso: db-env.sh field <env> <campo>" >&2; exit 2; }
              db_env_field "$1" "$2" ;;
    regex)    [[ $# -ge 1 ]] || { echo "Uso: db-env.sh regex \"<query>\"" >&2; exit 2; }
              db_env_gate_query_regex "$1" ;;
    gate)     [[ $# -ge 1 ]] || { echo "Uso: db-env.sh gate <env>" >&2; exit 2; }
              db_env_gate_pre_query "$1" ;;
    require)  [[ $# -ge 2 ]] || { echo "Uso: db-env.sh require <env> <flag_passed>" >&2; exit 2; }
              db_env_require_explicit "$1" "$2" ;;
    *)
      echo "Subcomando desconocido: $sub" >&2
      echo "Uso: db-env.sh {list|default|resolve|field|regex|gate|require}" >&2
      exit 2
      ;;
  esac
fi
