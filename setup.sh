#!/usr/bin/env bash
# setup.sh — instalador de rubber-duck.
#
# Hace tres cosas (idempotentes):
#   1. Exporta RUBBER_DUCK_HOME y añade ~/.local/bin al PATH en tu rcfile,
#      dentro de un bloque delimitado por marcadores.
#   2. Crea wrappers duck-* en ~/.local/bin/ que delegan a bin/duck.sh.
#   3. Pregunta opcionalmente si quieres instalar git hooks en algún repo.
#
# Re-ejecutable: no duplica entradas en el rcfile ni en ~/.local/bin/.

set -euo pipefail

# -----------------------------------------------------------------------------
# 1. Variables
# -----------------------------------------------------------------------------

RUBBER_DUCK_HOME="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_BIN="$HOME/.local/bin"
MARKER_START="# >>> rubber-duck >>>"
MARKER_END="# <<< rubber-duck <<<"

# Comandos que se exponen como binarios globales.
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

# -----------------------------------------------------------------------------
# 2. Detección del rcfile
# -----------------------------------------------------------------------------

detect_rcfile() {
  local shell_name
  shell_name="$(basename "${SHELL:-bash}")"
  case "$shell_name" in
    zsh)  echo "$HOME/.zshrc" ;;
    bash) echo "$HOME/.bashrc" ;;
    *)    echo "$HOME/.bashrc" ;;  # fallback
  esac
}

RCFILE="$(detect_rcfile)"
touch "$RCFILE"

# -----------------------------------------------------------------------------
# 3. Bloque idempotente en el rcfile
# -----------------------------------------------------------------------------

write_rcfile_block() {
  local tmp
  tmp="$(mktemp)"

  # Borra cualquier bloque previo de rubber-duck.
  awk -v s="$MARKER_START" -v e="$MARKER_END" '
    $0 == s { skip = 1 }
    !skip { print }
    $0 == e { skip = 0 }
  ' "$RCFILE" > "$tmp"

  # Añade el bloque nuevo al final.
  {
    echo ""
    echo "$MARKER_START"
    echo "# Generado por rubber-duck/setup.sh — no edites entre los marcadores."
    echo "export RUBBER_DUCK_HOME=\"$RUBBER_DUCK_HOME\""
    echo "case \":\$PATH:\" in"
    echo "  *\":\$HOME/.local/bin:\"*) ;;"
    echo "  *) export PATH=\"\$HOME/.local/bin:\$PATH\" ;;"
    echo "esac"
    echo "$MARKER_END"
  } >> "$tmp"

  mv "$tmp" "$RCFILE"
}

# -----------------------------------------------------------------------------
# 4. Wrappers en ~/.local/bin/
# -----------------------------------------------------------------------------

mkdir -p "$LOCAL_BIN"

install_wrapper() {
  local cmd="$1"
  local path="$LOCAL_BIN/duck-$cmd"
  cat > "$path" <<EOF
#!/usr/bin/env bash
# Generado por rubber-duck/setup.sh — no editar (se sobrescribe).
exec "\$RUBBER_DUCK_HOME/bin/duck.sh" $cmd "\$@"
EOF
  chmod +x "$path"
}

# -----------------------------------------------------------------------------
# 5. Instalación de git hooks (opcional)
# -----------------------------------------------------------------------------

maybe_install_hooks() {
  echo
  read -r -p "¿Quieres instalar los git hooks de rubber-duck en algún repo ahora? [s/N] " yn
  case "${yn,,}" in
    s|si|sí|y|yes)
      read -r -p "Ruta al repo (enter = directorio actual): " path
      path="${path:-$PWD}"
      if [[ -x "$RUBBER_DUCK_HOME/hooks/install-hooks.sh" ]]; then
        "$RUBBER_DUCK_HOME/hooks/install-hooks.sh" "$path"
      else
        echo "⚠️  $RUBBER_DUCK_HOME/hooks/install-hooks.sh aún no existe (fase F9.4 pendiente)."
        echo "    Cuando esté listo, ejecuta:  duck-install-hooks $path"
      fi
      ;;
    *) echo "Saltado. Puedes instalarlos más tarde con: duck-install-hooks /ruta/al/repo" ;;
  esac
}

# -----------------------------------------------------------------------------
# 6. Ejecución
# -----------------------------------------------------------------------------

echo "🦆 rubber-duck setup"
echo "    RUBBER_DUCK_HOME = $RUBBER_DUCK_HOME"
echo "    rcfile           = $RCFILE"
echo "    bin              = $LOCAL_BIN"
echo

echo "1/3 Escribiendo bloque en $RCFILE…"
write_rcfile_block

echo "2/3 Creando wrappers en $LOCAL_BIN…"
# Construye un set rápido con los comandos válidos para detectar huérfanos.
declare -A VALID_CMDS=()
for cmd in "${COMMANDS[@]}"; do
  VALID_CMDS[$cmd]=1
  install_wrapper "$cmd"
  echo "    ✓ duck-$cmd"
done

# Prune wrappers huérfanos (comandos eliminados o renombrados en versiones previas).
# Solo se borran si el contenido fue generado por setup.sh (sello en el comentario).
shopt -s nullglob
for path in "$LOCAL_BIN"/duck-*; do
  name="$(basename "$path")"
  cmd="${name#duck-}"
  if [[ -z "${VALID_CMDS[$cmd]:-}" ]] && head -n 2 "$path" 2>/dev/null | grep -qF "Generado por rubber-duck/setup.sh"; then
    rm -f "$path"
    echo "    ✗ borrado huérfano duck-$cmd"
  fi
done
shopt -u nullglob

echo "3/3 Configuración personal…"
if [[ ! -f "$HOME/.rubber-duck/config.json" ]]; then
  echo "    No existe ~/.rubber-duck/config.json. El asistente de configuración"
  echo "    se lanzará automáticamente la primera vez que ejecutes un comando duck-*."
else
  echo "    ✓ ~/.rubber-duck/config.json ya existe."
fi

maybe_install_hooks

echo
echo "✓ Instalación completada."
echo "  Abre una terminal nueva o ejecuta:"
echo "    source $RCFILE"
echo "  Luego prueba:"
echo "    duck-help"
