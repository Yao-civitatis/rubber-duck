#!/usr/bin/env bash
# detect-project.sh
#
# Walks up from $PWD looking for project markers and exports:
#   PROJECT_ROOT  — absolute path to the project root (symlinks resolved)
#   PROJECT_TYPE  — "new-admin" | "old-admin"
#
# Detection order (first match wins):
#   1. new-admin:  composer.json contains "name": "civitatis/newadmin"
#   2. new-admin:  .claude/domain-index.md exists (and not an old-admin root)
#   3. old-admin:  directory has application/admin/ AND webroot/ (civitatis root)
#   4. Fallback:   ~/.rubber-duck/config.json project.new_admin_path / old_admin_path
#                  matches a prefix of $PWD
#
# Returns 0 on success (with PROJECT_ROOT/PROJECT_TYPE exported), 1 on failure.
# When sourced, errors are printed to stderr but do not exit the caller.
#
# Usage:
#   source "$RUBBER_DUCK_HOME/bin/lib/detect-project.sh"
#   if detect_project_root; then
#     echo "$PROJECT_ROOT ($PROJECT_TYPE)"
#   else
#     duck_detection_error
#   fi

detect_project_root() {
  local dir
  dir=$(cd -P "$PWD" 2>/dev/null && pwd) || return 1

  while [[ "$dir" != "/" && -n "$dir" ]]; do
    # new-admin: composer.json with civitatis/newadmin
    if [[ -f "$dir/composer.json" ]] && \
       grep -q '"name"[[:space:]]*:[[:space:]]*"civitatis/newadmin"' "$dir/composer.json" 2>/dev/null; then
      export PROJECT_ROOT="$dir"
      export PROJECT_TYPE="new-admin"
      return 0
    fi

    # new-admin (secondary): .claude/domain-index.md present, not an old-admin root
    if [[ -f "$dir/.claude/domain-index.md" ]] && \
       [[ ! -d "$dir/application/admin" ]]; then
      export PROJECT_ROOT="$dir"
      export PROJECT_TYPE="new-admin"
      return 0
    fi

    # old-admin: civitatis root (application/admin/ and webroot/ both exist)
    if [[ -d "$dir/application/admin" ]] && [[ -d "$dir/webroot" ]]; then
      export PROJECT_ROOT="$dir"
      export PROJECT_TYPE="old-admin"
      return 0
    fi

    dir=$(dirname "$dir")
  done

  # Fallback: ~/.rubber-duck/config.json
  local cfg="$HOME/.rubber-duck/config.json"
  if [[ -f "$cfg" ]] && command -v jq >/dev/null 2>&1; then
    local cur cfg_new cfg_old
    cur=$(cd -P "$PWD" && pwd)
    cfg_new=$(jq -r '.project.new_admin_path // empty' "$cfg" 2>/dev/null)
    cfg_old=$(jq -r '.project.old_admin_path // empty' "$cfg" 2>/dev/null)

    if [[ -n "$cfg_new" && -d "$cfg_new" ]] && [[ "$cur" == "$cfg_new"* ]]; then
      export PROJECT_ROOT="$cfg_new"
      export PROJECT_TYPE="new-admin"
      return 0
    fi
    if [[ -n "$cfg_old" && -d "$cfg_old" ]] && [[ "$cur" == "$cfg_old"* ]]; then
      export PROJECT_ROOT="$cfg_old"
      export PROJECT_TYPE="old-admin"
      return 0
    fi
  fi

  return 1
}

duck_detection_error() {
  cat >&2 <<'EOF'
🦆 rubber-duck: no se ha detectado ningún proyecto.

Ejecuta el comando desde dentro del directorio de new-admin o del módulo /admin
de civitatis (o cualquier subdirectorio de estos).

Marcadores buscados:
  new-admin:  composer.json con "name": "civitatis/newadmin"
              o .claude/domain-index.md
  old-admin:  application/admin/ + webroot/ (raíz de civitatis)

Alternativa: configura los paths explícitamente:
  duck-config set project.new_admin_path /ruta/a/new-admin
  duck-config set project.old_admin_path /ruta/a/civitatis
EOF
}

# When the script is executed directly (not sourced) → run detection and print.
# Useful for `duck-help` or debugging from any shell.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if detect_project_root; then
    echo "PROJECT_ROOT=$PROJECT_ROOT"
    echo "PROJECT_TYPE=$PROJECT_TYPE"
    exit 0
  else
    duck_detection_error
    exit 1
  fi
fi
