#!/usr/bin/env bash
# uninstall.sh — desinstala rubber-duck.
#
# Hace tres cosas:
#   1. Elimina los wrappers duck-* de ~/.local/bin/.
#   2. Quita el bloque delimitado de tu rcfile.
#   3. Pregunta si también quieres borrar ~/.rubber-duck/ (config personal).
#
# No toca el repositorio en sí.

set -euo pipefail

LOCAL_BIN="$HOME/.local/bin"
MARKER_START="# >>> rubber-duck >>>"
MARKER_END="# <<< rubber-duck <<<"

# Comandos instalados por setup.sh. Mantener sincronizada con setup.sh.
COMMANDS=(
  analyze
  plan
  implement
  review
  sync-docs
  audit
  config
  help
  onboarding
  debug
  migrate
  db
  standup
  upgrade
  install-hooks
)

detect_rcfile() {
  local shell_name
  shell_name="$(basename "${SHELL:-bash}")"
  case "$shell_name" in
    zsh)  echo "$HOME/.zshrc" ;;
    bash) echo "$HOME/.bashrc" ;;
    *)    echo "$HOME/.bashrc" ;;
  esac
}

RCFILE="$(detect_rcfile)"

echo "🦆 rubber-duck uninstall"
echo "    rcfile = $RCFILE"
echo "    bin    = $LOCAL_BIN"
echo

# 1. Wrappers
echo "1/3 Eliminando wrappers duck-* de $LOCAL_BIN…"
for cmd in "${COMMANDS[@]}"; do
  if [[ -e "$LOCAL_BIN/duck-$cmd" ]]; then
    rm -f "$LOCAL_BIN/duck-$cmd"
    echo "    ✓ borrado duck-$cmd"
  fi
done

# 2. Bloque del rcfile
echo "2/3 Eliminando bloque de $RCFILE…"
if [[ -f "$RCFILE" ]] && grep -qF "$MARKER_START" "$RCFILE"; then
  tmp="$(mktemp)"
  awk -v s="$MARKER_START" -v e="$MARKER_END" '
    $0 == s { skip = 1 }
    !skip { print }
    $0 == e { skip = 0 }
  ' "$RCFILE" > "$tmp"
  mv "$tmp" "$RCFILE"
  echo "    ✓ bloque eliminado"
else
  echo "    (no había bloque que eliminar)"
fi

# 3. Configuración personal
echo "3/3 Configuración personal…"
if [[ -d "$HOME/.rubber-duck" ]]; then
  echo "    Existe ~/.rubber-duck/ con tu configuración personal."
  read -r -p "    ¿Borrarla también? [s/N] " yn
  case "${yn,,}" in
    s|si|sí|y|yes)
      rm -rf "$HOME/.rubber-duck"
      echo "    ✓ ~/.rubber-duck/ borrado"
      ;;
    *)
      echo "    Preservada. Bórrala manualmente si quieres: rm -rf ~/.rubber-duck"
      ;;
  esac
else
  echo "    No existe ~/.rubber-duck/, nada que borrar."
fi

echo
echo "✓ Desinstalación completada."
echo "  Abre una terminal nueva o ejecuta:"
echo "    source $RCFILE"
