#!/usr/bin/env bash
# db-env.test.sh — Tests bash para bin/lib/db-env.sh.
#
# Uso:
#   bin/lib/db-env.test.sh
#
# Crea un RUBBER_DUCK_CONFIG_DIR temporal con un config.json controlado,
# usa MYSQL_CMD_STUB y DUCK_DB_CONFIRM_STUB para forzar resultados de las
# gates (b)(c)(e) sin depender de un servidor MySQL real.
#
# Convencion: cada test imprime "PASS <nombre>" o "FAIL <nombre>: <motivo>".
# Exit 0 si todos pasan, 1 si alguno falla.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB="$SCRIPT_DIR/db-env.sh"

if [[ ! -f "$LIB" ]]; then
  echo "FATAL: no encuentro $LIB" >&2
  exit 2
fi

TESTS_PASSED=0
TESTS_FAILED=0
TMPROOT="$(mktemp -d -t duck-db-env-test.XXXXXX)"
trap 'rm -rf "$TMPROOT"' EXIT

export DUCK_DB_NO_COLOR=1

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

# write_config <_version> <default> <env_block_json>
# Ejemplo: write_config 2 dev '{"dev":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":true,"danger_level":"low"}}'
write_config() {
  local version="$1" default="$2" envs="$3"
  local d="$TMPROOT/.rubber-duck/mcp/database"
  mkdir -p "$d"
  cat > "$d/config.json" <<EOF
{
  "_version": $version,
  "default": "$default",
  "environments": $envs
}
EOF
}

# Crea un MYSQL_CMD_STUB que responde fijo segun la query recibida.
# Argumentos: <output_readonly> <output_grants>
# Si el stub recibe una query con "@@global.read_only" → devuelve $1.
# Si recibe "SHOW GRANTS"                              → devuelve $2.
# Cualquier otra → exit 1.
make_stub() {
  local readonly_out="$1" grants_out="$2"
  local stub="$TMPROOT/mysql_stub_$$_$RANDOM.sh"
  cat > "$stub" <<EOF
#!/usr/bin/env bash
# argv: <env_name> <query>
query="\$2"
case "\$query" in
  *@@global.read_only*) printf '%s\n' '$readonly_out'; exit 0 ;;
  *SHOW\ GRANTS*)       printf '%s\n' '$grants_out';   exit 0 ;;
  *)                    echo "stub: query inesperada: \$query" >&2; exit 1 ;;
esac
EOF
  chmod +x "$stub"
  printf '%s' "$stub"
}

assert_rc() {
  local name="$1" expected="$2" actual="$3" stderr="${4:-}"
  if [[ "$actual" == "$expected" ]]; then
    echo "PASS $name"
    TESTS_PASSED=$((TESTS_PASSED+1))
  else
    echo "FAIL $name: esperaba rc=$expected, recibido rc=$actual"
    [[ -n "$stderr" ]] && echo "       stderr: $stderr"
    TESTS_FAILED=$((TESTS_FAILED+1))
  fi
}

# Lanza el lib via subshell con RUBBER_DUCK_CONFIG_DIR apuntando al tmp.
# Uso: run_lib <funcion> [args...]
run_lib() {
  (
    export RUBBER_DUCK_CONFIG_DIR="$TMPROOT/.rubber-duck"
    export RUBBER_DUCK_HOME="$SCRIPT_DIR/../.."
    # shellcheck disable=SC1090
    source "$LIB"
    "$@"
  )
}

# -----------------------------------------------------------------------------
# Tests — descubrimiento basico
# -----------------------------------------------------------------------------

t_list_envs() {
  write_config 2 dev '{
    "dev":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":true,"danger_level":"low"},
    "qa":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":true,"danger_level":"medium"},
    "slave":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":true,"danger_level":"high"},
    "prod":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":true,"danger_level":"critical"}
  }'
  local out
  out="$(run_lib db_env_list | sort | tr '\n' ',')"
  if [[ "$out" == "dev,prod,qa,slave," ]]; then
    echo "PASS list_envs"; TESTS_PASSED=$((TESTS_PASSED+1))
  else
    echo "FAIL list_envs: salida='$out'"; TESTS_FAILED=$((TESTS_FAILED+1))
  fi
}

t_default_is_dev() {
  local out
  out="$(run_lib db_env_default)"
  if [[ "$out" == "dev" ]]; then
    echo "PASS default_is_dev"; TESTS_PASSED=$((TESTS_PASSED+1))
  else
    echo "FAIL default_is_dev: salida='$out'"; TESTS_FAILED=$((TESTS_FAILED+1))
  fi
}

t_v1_detected() {
  write_config 1 dev '{}'
  set +e
  run_lib db_env_list 2>/dev/null
  local rc=$?
  set -e
  assert_rc "v1_detected_rc3" "3" "$rc"
}

# -----------------------------------------------------------------------------
# Tests — require_explicit
# -----------------------------------------------------------------------------

t_require_explicit_dev_implicit_ok() {
  set +e; run_lib db_env_require_explicit dev 0 2>/dev/null; local rc=$?; set -e
  assert_rc "require_explicit_dev_implicit_ok" "0" "$rc"
}

t_require_explicit_prod_implicit_fails() {
  set +e; run_lib db_env_require_explicit prod 0 2>/dev/null; local rc=$?; set -e
  assert_rc "require_explicit_prod_implicit_fails" "2" "$rc"
}

t_require_explicit_prod_with_flag_ok() {
  set +e; run_lib db_env_require_explicit prod 1 2>/dev/null; local rc=$?; set -e
  assert_rc "require_explicit_prod_with_flag_ok" "0" "$rc"
}

# -----------------------------------------------------------------------------
# Tests — gate (d) regex
# -----------------------------------------------------------------------------

t_regex_select_ok() {
  set +e; run_lib db_env_gate_query_regex "SELECT * FROM bookings WHERE id=1" 2>/dev/null; local rc=$?; set -e
  assert_rc "regex_select_ok" "0" "$rc"
}

t_regex_update_blocked() {
  set +e; run_lib db_env_gate_query_regex "UPDATE bookings SET status='x' WHERE id=1" 2>/dev/null; local rc=$?; set -e
  assert_rc "regex_update_blocked" "13" "$rc"
}

t_regex_delete_blocked() {
  set +e; run_lib db_env_gate_query_regex "DELETE FROM bookings WHERE id=1" 2>/dev/null; local rc=$?; set -e
  assert_rc "regex_delete_blocked" "13" "$rc"
}

t_regex_drop_blocked() {
  set +e; run_lib db_env_gate_query_regex "  DROP TABLE bookings" 2>/dev/null; local rc=$?; set -e
  assert_rc "regex_drop_blocked" "13" "$rc"
}

t_regex_set_session_ok() {
  set +e; run_lib db_env_gate_query_regex "SET SESSION sql_mode='STRICT_ALL_TABLES'" 2>/dev/null; local rc=$?; set -e
  assert_rc "regex_set_session_ok" "0" "$rc"
}

t_regex_set_global_blocked() {
  set +e; run_lib db_env_gate_query_regex "SET GLOBAL read_only=0" 2>/dev/null; local rc=$?; set -e
  assert_rc "regex_set_global_blocked" "13" "$rc"
}

t_regex_explain_ok() {
  set +e; run_lib db_env_gate_query_regex "EXPLAIN SELECT * FROM bookings" 2>/dev/null; local rc=$?; set -e
  assert_rc "regex_explain_ok" "0" "$rc"
}

t_regex_show_ok() {
  set +e; run_lib db_env_gate_query_regex "SHOW TABLES" 2>/dev/null; local rc=$?; set -e
  assert_rc "regex_show_ok" "0" "$rc"
}

# -----------------------------------------------------------------------------
# Tests — gate (a) config.read_only
# -----------------------------------------------------------------------------

t_gate_a_dev_ok() {
  write_config 2 dev '{
    "dev":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":true,"danger_level":"low"}
  }'
  set +e; run_lib db_env_gate_pre_query dev 2>/dev/null; local rc=$?; set -e
  assert_rc "gate_a_dev_ok" "0" "$rc"
}

t_gate_a_dev_readonly_false_blocked() {
  write_config 2 dev '{
    "dev":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":false,"danger_level":"low"}
  }'
  set +e; run_lib db_env_gate_pre_query dev 2>/dev/null; local rc=$?; set -e
  assert_rc "gate_a_dev_readonly_false_blocked" "10" "$rc"
}

# -----------------------------------------------------------------------------
# Tests — gate (b) servidor read_only (prod)
# -----------------------------------------------------------------------------

t_gate_b_prod_server_writable_blocked() {
  write_config 2 dev '{
    "prod":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":true,"danger_level":"critical"}
  }'
  local stub
  stub="$(make_stub $'0\t0' 'GRANT SELECT ON *.* TO u')"
  set +e
  ( export MYSQL_CMD_STUB="$stub" DUCK_DB_CONFIRM_STUB="prod"; run_lib db_env_gate_pre_query prod 2>/dev/null )
  local rc=$?
  set -e
  assert_rc "gate_b_prod_server_writable_blocked" "11" "$rc"
}

# -----------------------------------------------------------------------------
# Tests — gate (c) grants con mutacion (prod)
# -----------------------------------------------------------------------------

t_gate_c_prod_grants_with_insert_blocked() {
  write_config 2 dev '{
    "prod":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":true,"danger_level":"critical"}
  }'
  local stub
  stub="$(make_stub $'1\t1' 'GRANT SELECT, INSERT ON civitatis.* TO u')"
  set +e
  ( export MYSQL_CMD_STUB="$stub" DUCK_DB_CONFIRM_STUB="prod"; run_lib db_env_gate_pre_query prod 2>/dev/null )
  local rc=$?
  set -e
  assert_rc "gate_c_prod_grants_with_insert_blocked" "12" "$rc"
}

t_gate_c_prod_grants_all_privileges_blocked() {
  write_config 2 dev '{
    "prod":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":true,"danger_level":"critical"}
  }'
  local stub
  stub="$(make_stub $'1\t1' 'GRANT ALL PRIVILEGES ON *.* TO u')"
  set +e
  ( export MYSQL_CMD_STUB="$stub" DUCK_DB_CONFIRM_STUB="prod"; run_lib db_env_gate_pre_query prod 2>/dev/null )
  local rc=$?
  set -e
  assert_rc "gate_c_prod_grants_all_privileges_blocked" "12" "$rc"
}

# -----------------------------------------------------------------------------
# Tests — gate (e) confirmacion (prod)
# -----------------------------------------------------------------------------

t_gate_e_prod_wrong_typed_blocked() {
  write_config 2 dev '{
    "prod":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":true,"danger_level":"critical"}
  }'
  local stub
  stub="$(make_stub $'1\t1' 'GRANT SELECT ON *.* TO u')"
  set +e
  ( export MYSQL_CMD_STUB="$stub" DUCK_DB_CONFIRM_STUB="PROD"; run_lib db_env_gate_pre_query prod 2>/dev/null )
  local rc=$?
  set -e
  assert_rc "gate_e_prod_wrong_typed_blocked" "14" "$rc"
}

t_gate_e_prod_correct_typed_passes() {
  write_config 2 dev '{
    "prod":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":true,"danger_level":"critical"}
  }'
  local stub
  stub="$(make_stub $'1\t1' 'GRANT SELECT ON *.* TO u')"
  set +e
  ( export MYSQL_CMD_STUB="$stub" DUCK_DB_CONFIRM_STUB="prod"; run_lib db_env_gate_pre_query prod 2>/dev/null )
  local rc=$?
  set -e
  assert_rc "gate_e_prod_correct_typed_passes" "0" "$rc"
}

# -----------------------------------------------------------------------------
# Tests — qa (sin gates b/c, solo a+e)
# -----------------------------------------------------------------------------

t_gate_qa_confirm_yes_passes() {
  write_config 2 dev '{
    "qa":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":true,"danger_level":"medium"}
  }'
  set +e
  ( export DUCK_DB_CONFIRM_STUB="y"; run_lib db_env_gate_pre_query qa 2>/dev/null )
  local rc=$?
  set -e
  assert_rc "gate_qa_confirm_yes_passes" "0" "$rc"
}

t_gate_qa_confirm_no_blocked() {
  write_config 2 dev '{
    "qa":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":true,"danger_level":"medium"}
  }'
  set +e
  ( export DUCK_DB_CONFIRM_STUB="n"; run_lib db_env_gate_pre_query qa 2>/dev/null )
  local rc=$?
  set -e
  assert_rc "gate_qa_confirm_no_blocked" "14" "$rc"
}

# -----------------------------------------------------------------------------
# Tests — slave (gates a+b+c+e)
# -----------------------------------------------------------------------------

t_gate_slave_all_pass() {
  write_config 2 dev '{
    "slave":{"host":"h","port":3306,"database":"d","user":"u","password":"p","read_only":true,"danger_level":"high"}
  }'
  local stub
  stub="$(make_stub $'1\t1' 'GRANT SELECT ON *.* TO u')"
  set +e
  ( export MYSQL_CMD_STUB="$stub" DUCK_DB_CONFIRM_STUB="y"; run_lib db_env_gate_pre_query slave 2>/dev/null )
  local rc=$?
  set -e
  assert_rc "gate_slave_all_pass" "0" "$rc"
}

# -----------------------------------------------------------------------------
# Runner
# -----------------------------------------------------------------------------

main() {
  echo "=== db-env.sh tests ==="
  t_list_envs
  t_default_is_dev
  t_v1_detected
  t_require_explicit_dev_implicit_ok
  t_require_explicit_prod_implicit_fails
  t_require_explicit_prod_with_flag_ok
  t_regex_select_ok
  t_regex_update_blocked
  t_regex_delete_blocked
  t_regex_drop_blocked
  t_regex_set_session_ok
  t_regex_set_global_blocked
  t_regex_explain_ok
  t_regex_show_ok
  t_gate_a_dev_ok
  t_gate_a_dev_readonly_false_blocked
  t_gate_b_prod_server_writable_blocked
  t_gate_c_prod_grants_with_insert_blocked
  t_gate_c_prod_grants_all_privileges_blocked
  t_gate_e_prod_wrong_typed_blocked
  t_gate_e_prod_correct_typed_passes
  t_gate_qa_confirm_yes_passes
  t_gate_qa_confirm_no_blocked
  t_gate_slave_all_pass
  echo
  echo "=== RESULT: $TESTS_PASSED passed, $TESTS_FAILED failed ==="
  (( TESTS_FAILED == 0 ))
}

main "$@"
