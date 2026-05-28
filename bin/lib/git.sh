#!/usr/bin/env bash
# git.sh — helper de auto-commit / auto-push para skills downstream.
#
# Se invoca al final de duck-implement / duck-review / duck-audit para hacer
# un commit (y opcionalmente push) dentro de $PROJECT_ROOT según la
# configuración de ~/.rubber-duck/config.json.
#
# Uso (como CLI, llamado vía Bash desde skills):
#   git.sh <step> <jira_key> <title> <summary> [archivo1 archivo2 ...]
#
#   step       = implement | review | audit
#   jira_key   = "PANA-123" o "" si no aplica
#   title      = título corto del cambio (1 línea)
#   summary    = resumen para el body del commit (opcional, "" si no)
#   archivos   = lista a stagear; si está vacía, asume que el caller ya
#                hizo git add y solo se commitea lo staged.
#
# Comportamiento:
#   - Lee git.auto_commit. Si false → exit 0 sin hacer nada.
#   - Lee git.auto_commit_after. Si != <step> → exit 0 sin hacer nada.
#   - Construye mensaje según git.commit_message_format (jira/conventional/custom).
#   - git add (si hay archivos) + git commit -m <msg> en $PROJECT_ROOT.
#   - Si git.auto_push = true → git push.
#
# Variables de entorno necesarias:
#   PROJECT_ROOT   — exportado por el dispatcher tras detect-project.sh.

set -uo pipefail

CONFIG="$HOME/.rubber-duck/config.json"
CUSTOM_TEMPLATE="$HOME/.rubber-duck/commit-template.txt"

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

# Lee una clave anidada de config.json. "" si no existe.
duck_config_read() {
  local key="$1"
  [[ -f "$CONFIG" ]] || { printf ''; return; }
  command -v jq >/dev/null 2>&1 || { printf ''; return; }
  jq -r --arg k "$key" '(getpath($k | split(".")) // "") | tostring' "$CONFIG" 2>/dev/null
}

build_message() {
  local fmt="$1" step="$2" jira_key="$3" title="$4" summary="$5"
  case "$fmt" in
    jira)
      if [[ -n "$jira_key" ]]; then
        printf '%s: %s\n' "$jira_key" "${title:-${summary:-update}}"
      else
        printf '%s\n' "${title:-${summary:-update}}"
      fi
      ;;
    conventional)
      local type="chore"
      case "$step" in
        implement) type="feat" ;;
        review)    type="docs" ;;
        audit)     type="chore" ;;
      esac
      if [[ -n "$jira_key" ]]; then
        printf '%s: %s %s\n' "$type" "$jira_key" "${title:-${summary:-update}}"
      else
        printf '%s: %s\n' "$type" "${title:-${summary:-update}}"
      fi
      ;;
    custom)
      if [[ ! -f "$CUSTOM_TEMPLATE" ]]; then
        echo "🦆 git.sh: commit_message_format=custom pero $CUSTOM_TEMPLATE no existe. Fallback a 'jira'." >&2
        build_message jira "$step" "$jira_key" "$title" "$summary"
        return
      fi
      local tpl
      tpl="$(cat "$CUSTOM_TEMPLATE")"
      tpl="${tpl//\{jira_key\}/$jira_key}"
      tpl="${tpl//\{title\}/$title}"
      tpl="${tpl//\{summary\}/$summary}"
      tpl="${tpl//\{step\}/$step}"
      printf '%s\n' "$tpl"
      ;;
    *)
      printf '%s\n' "${title:-${summary:-update}}"
      ;;
  esac
}

# -----------------------------------------------------------------------------
# Función principal
# -----------------------------------------------------------------------------

duck_git_auto_commit() {
  local step="$1" jira_key="$2" title="$3" summary="$4"
  shift 4 || true
  local files=("$@")

  # 1. Gates de configuración
  local enabled after fmt push
  enabled="$(duck_config_read git.auto_commit)"
  [[ "$enabled" == "true" ]] || return 0

  after="$(duck_config_read git.auto_commit_after)"
  [[ "$after" == "$step" ]] || return 0

  fmt="$(duck_config_read git.commit_message_format)"
  [[ -n "$fmt" ]] || fmt="jira"
  push="$(duck_config_read git.auto_push)"

  # 2. PROJECT_ROOT requerido
  if [[ -z "${PROJECT_ROOT:-}" ]]; then
    echo "🦆 git.sh: PROJECT_ROOT no definido. Auto-commit saltado." >&2
    return 0
  fi
  if [[ ! -d "$PROJECT_ROOT/.git" ]]; then
    echo "🦆 git.sh: $PROJECT_ROOT no es un repo git. Auto-commit saltado." >&2
    return 0
  fi

  # 3. Stagear archivos si se proporcionaron
  if (( ${#files[@]} > 0 )); then
    git -C "$PROJECT_ROOT" add -- "${files[@]}"
  fi

  # 4. ¿Hay algo staged?
  if git -C "$PROJECT_ROOT" diff --cached --quiet; then
    echo "🦆 git.sh: nada staged en $PROJECT_ROOT, no se hace commit." >&2
    return 0
  fi

  # 5. Construir mensaje
  local msg
  msg="$(build_message "$fmt" "$step" "$jira_key" "$title" "$summary")"

  # 6. Commit
  if ! git -C "$PROJECT_ROOT" commit -m "$msg"; then
    echo "🦆 git.sh: commit falló." >&2
    return 1
  fi
  echo "✓ Commit creado en $PROJECT_ROOT:"
  printf '   %s\n' "$msg"

  # 7. Push opcional
  if [[ "$push" == "true" ]]; then
    if ! git -C "$PROJECT_ROOT" push; then
      echo "🦆 git.sh: push falló. El commit está local." >&2
      return 1
    fi
    echo "✓ Push hecho."
  fi

  return 0
}

# -----------------------------------------------------------------------------
# CLI
# -----------------------------------------------------------------------------

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if [[ $# -lt 4 ]]; then
    cat >&2 <<EOF
Uso: git.sh <step> <jira_key> <title> <summary> [archivo1 archivo2 ...]
  step      implement | review | audit
  jira_key  "PANA-123" o "" si no aplica
  title     título corto (1 línea)
  summary   resumen (puede ser "")
  archivos  opcional; si se omite, se commitea lo ya staged
EOF
    exit 2
  fi
  duck_git_auto_commit "$@"
fi
