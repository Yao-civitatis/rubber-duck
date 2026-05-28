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
LOCAL_SLASH="$HOME/.claude/commands"
MARKER_START="# >>> rubber-duck >>>"
MARKER_END="# <<< rubber-duck <<<"
SLASH_MARKER="<!-- rubber-duck-generated -->"

# Carga catálogo (HELP_SHORT, HELP_USAGE) sin ejecutar el modo CLI de help.sh.
# shellcheck source=bin/lib/help.sh
source "$RUBBER_DUCK_HOME/bin/lib/help.sh"

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
# Slash commands de Claude Code (~/.claude/commands/)
# -----------------------------------------------------------------------------

# YAML-safe single-quoted scalar. Escapa apóstrofes duplicándolas.
yaml_escape() {
  local s="${1//\'/\'\'}"
  printf "'%s'" "$s"
}

install_slash_command() {
  local cmd="$1"
  local path="$LOCAL_SLASH/duck-$cmd.md"
  local desc="${HELP_SHORT[$cmd]:-Comando rubber-duck $cmd}"
  local usage="${HELP_USAGE[$cmd]:-}"
  # Quita el prefijo "duck-<cmd>" de HELP_USAGE para usarlo como argument-hint.
  local args="${usage#duck-$cmd}"
  args="${args# }"
  local desc_yaml args_yaml
  desc_yaml="$(yaml_escape "$desc")"
  args_yaml="$(yaml_escape "$args")"

  case "$cmd" in
    help)
      cat > "$path" <<EOF
---
description: $desc_yaml
argument-hint: '[comando|config.<clave>]'
allowed-tools: [Bash(duck-help:*)]
---
$SLASH_MARKER

!duck-help \$ARGUMENTS
EOF
      ;;

    config)
      cat > "$path" <<EOF
---
description: $desc_yaml
argument-hint: '{list|get|set|reset|setup} [clave] [valor]'
allowed-tools: [Bash, Read, Write]
---
$SLASH_MARKER

# /duck-config

Argumentos del usuario: \$ARGUMENTS

Comportamiento según el primer argumento:

- \`list\`, \`get\`, \`set\` o \`reset\` (o sin argumentos): ejecuta \`!duck-config \$ARGUMENTS\` y muestra el output literal del bash. No añadas explicación; la salida ya está formateada.
- \`setup\`: lee \`\$RUBBER_DUCK_HOME/commands/config.md\` y \`\$RUBBER_DUCK_HOME/skills/config/SKILL.md\`. Sigue el wizard al pie de la letra.
- Otro valor: responde con el error \`Subcomando desconocido: <arg>\` y la lista de subcomandos válidos.
EOF
      ;;

    install-hooks)
      cat > "$path" <<EOF
---
description: $desc_yaml
argument-hint: '[ruta-al-repo]'
allowed-tools: [Bash(duck-install-hooks:*)]
---
$SLASH_MARKER

!duck-install-hooks \$ARGUMENTS
EOF
      ;;

    *)
      # Plantilla skill-driven: tres pasos (detección → restricciones → instrucciones).
      cat > "$path" <<EOF
---
description: $desc_yaml
argument-hint: $args_yaml
allowed-tools: [Bash, Read, Edit, Write, Grep, Glob]
---
$SLASH_MARKER

# /duck-$cmd

Argumentos del usuario: \$ARGUMENTS

## Paso 1 — Detección del proyecto

Ejecuta vía Bash:

\`\`\`bash
source "\$RUBBER_DUCK_HOME/bin/lib/detect-project.sh"
detect_project_root || { duck_detection_error; exit 3; }
printf 'PROJECT_ROOT=%s\nPROJECT_TYPE=%s\n' "\$PROJECT_ROOT" "\$PROJECT_TYPE"
\`\`\`

Si la detección falla, muestra el mensaje al usuario y para.

## Paso 2 — Restricciones operacionales (CRÍTICAS)

Siempre activas:

- **R1 (Jira):** escritura SOLO en flujos explícitos con confirmación expresa del usuario (\`duck-analyze\`, \`duck-review\`). Append idempotente entre marcadores \`<!-- rubber-duck:start -->\` … \`<!-- rubber-duck:end -->\`.
- **R2 (BBDD):** nunca \`INSERT\`/\`UPDATE\`/\`DELETE\`/\`ALTER\`/\`DROP\`/\`TRUNCATE\`. La BBDD es compartida entre new-admin y old-admin.

Si \`\$PROJECT_TYPE = new-admin\`:

- **R3 (Arquitectura):** hexagonal validada por \`phparkitect\` (Controllers → Services → Repositories → Models).
- **R4 (Controllers):** sin \`AbstractController\`; inyecta el Service por parámetro.
- **R5 (HTTP codes):** usa \`Slim\\Http\\StatusCode::HTTP_*\`, nunca literales numéricos.
- **R6 (Frontend):** 100% Options API, Container + Presentational, módulos en \`dev/vue/src/modules/\`.
- Carga \`\$PROJECT_ROOT/.claude/domain-index.md\`, \`project-context.md\` y \`refactoring-state.md\` si existen antes de explorar código.
- Toolchain de calidad: usa \`\$PROJECT_ROOT/bin/pre-commit <herramienta>\` (no reimplementes phpstan/php-cs-fixer/phparkitect).

Si \`\$PROJECT_TYPE = old-admin\`:

- **Política mantenimiento-only.** Solo bug fixes y mantenimiento. Si el plan describe funcionalidad nueva → advierte al usuario y propón hacerlo en new-admin.
- **Scope estricto:** solo se tocan rutas del módulo \`/admin\`: \`application/admin/\`, \`application/lib/{Admin,Dao/Admin,Dto/Admin,Queues/Newadmin,NewAdmin}/\`, \`application/templates/admin/\`, \`webroot/(static|dev)/(js|scss|css)/admin/\`, \`dev/src/js/admin/\`, \`application/css_admin/\`. Rechaza cambios fuera.
- Sin estándares formales, sin Confluence, sin herramientas de calidad. Audit = sentido común (seguridad, lógica). No reportes estilo legacy.
- **Stack legacy (PHP 5.6):** no uses syntax post-5.6 (sin spread \`...\`, sin \`??\`, sin typed properties, sin return types nullable). Imita el estilo del archivo editado.
- **Visión:** eliminar old-admin → migrar a new-admin. Cambios no triviales → sugerir \`duck-migrate\`.

## Paso 3 — Instrucciones del comando

Lee \`\$RUBBER_DUCK_HOME/commands/$cmd.md\` y sigue su contenido al pie de la letra, aplicando las restricciones del Paso 2.

Si \`\$RUBBER_DUCK_HOME/commands/$cmd.md\` aún no existe (fase de implementación en curso), informa al usuario y para.
EOF
      ;;
  esac
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
echo "    slash commands   = $LOCAL_SLASH"
echo

echo "1/5 Escribiendo bloque en $RCFILE…"
write_rcfile_block

echo "2/5 Creando wrappers en $LOCAL_BIN…"
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

echo "3/5 Instalando slash commands en $LOCAL_SLASH…"
mkdir -p "$LOCAL_SLASH"
# Aviso si LOCAL_SLASH es un symlink (otra herramienta del usuario ya gestiona ese dir).
if [[ -L "$LOCAL_SLASH" ]]; then
  target="$(readlink -f "$LOCAL_SLASH")"
  echo "    ℹ️  $LOCAL_SLASH es un symlink → $target"
  echo "       Los duck-*.md se escribirán allí. Si ese repo se commitea con git,"
  echo "       considera añadir 'commands/duck-*.md' a su .gitignore."
fi
declare -A VALID_SLASH=()
for cmd in "${COMMANDS[@]}"; do
  VALID_SLASH[$cmd]=1
  install_slash_command "$cmd"
  echo "    ✓ /duck-$cmd"
done
# Prune slash commands huérfanos (mismo mecanismo que para wrappers).
shopt -s nullglob
for path in "$LOCAL_SLASH"/duck-*.md; do
  name="$(basename "$path" .md)"
  cmd="${name#duck-}"
  if [[ -z "${VALID_SLASH[$cmd]:-}" ]] && grep -qF "$SLASH_MARKER" "$path"; then
    rm -f "$path"
    echo "    ✗ borrado huérfano /duck-$cmd"
  fi
done
shopt -u nullglob

echo "4/5 Preparando ~/.rubber-duck/ (docs + mcp)…"
mkdir -p "$HOME/.rubber-duck/mcp/atlassian" "$HOME/.rubber-duck/mcp/database"
echo "    ✓ ~/.rubber-duck/mcp/atlassian/ y ~/.rubber-duck/mcp/database/ creados (vacíos por ahora)."
echo "       Rellena los config.json con 'duck-config setup' o copiando manualmente:"
echo "         cp $RUBBER_DUCK_HOME/mcp/atlassian/config.example.json ~/.rubber-duck/mcp/atlassian/config.json"
echo "         cp $RUBBER_DUCK_HOME/mcp/database/config.example.json ~/.rubber-duck/mcp/database/config.json"
echo
echo "    Sembrando docs en ~/.rubber-duck/docs/…"
USER_DOCS_DIR="$HOME/.rubber-duck/docs"
BUNDLE_DOCS_DIR="$RUBBER_DUCK_HOME/docs"
if [[ -d "$USER_DOCS_DIR" ]]; then
  echo "    ℹ️  $USER_DOCS_DIR ya existe — se preservan las actualizaciones del usuario."
  echo "       (Para refrescar desde el bundle: rm -rf $USER_DOCS_DIR && ./setup.sh)"
elif [[ -d "$BUNDLE_DOCS_DIR" ]]; then
  mkdir -p "$HOME/.rubber-duck"
  cp -R "$BUNDLE_DOCS_DIR" "$USER_DOCS_DIR"
  echo "    ✓ Copiado $BUNDLE_DOCS_DIR/ → $USER_DOCS_DIR/"
else
  echo "    ⚠️  No existe $BUNDLE_DOCS_DIR/ — saltado. Ejecuta duck-sync-docs --bundle para crearlo."
fi

echo "5/5 Configuración personal…"
FIRST_TIME=0
if [[ ! -f "$HOME/.rubber-duck/config.json" ]]; then
  FIRST_TIME=1
  echo "    Primera instalación detectada (~/.rubber-duck/config.json no existe)."
else
  echo "    ✓ ~/.rubber-duck/config.json ya existe."
fi

maybe_install_hooks

# -----------------------------------------------------------------------------
# 7. Aviso final + recarga del shell
# -----------------------------------------------------------------------------

echo
echo "════════════════════════════════════════════════════════════════════"
echo "  ✓ Instalación completada."
echo "════════════════════════════════════════════════════════════════════"

if (( FIRST_TIME )); then
  cat <<'EOF'

  🦆 Primera instalación de rubber-duck en este sistema.

     Próximo paso recomendado: lanza el asistente de configuración
     para definir idioma, paths de proyectos y (opcional) los MCPs de
     Atlassian y de base de datos.

         duck-config setup

EOF
fi

# Recarga del shell (interactivo). Si stdin no es TTY, salta (CI / automation).
if [[ -t 0 && -t 1 ]]; then
  read -r -p "  ¿Recargar el shell ahora para activar los comandos duck-*? [s/N] " RELOAD_ANS
  case "${RELOAD_ANS,,}" in
    s|si|sí|y|yes)
      echo "  🦆 Recargando shell… (los duck-* estarán en \$PATH al volver al prompt)"
      # Reemplaza el proceso actual con un shell de login del usuario.
      # En el nuevo shell, el rcfile se ejecuta y RUBBER_DUCK_HOME + PATH quedan exportados.
      exec "${SHELL:-/bin/bash}" -l
      ;;
    *)
      echo
      echo "  Recarga manualmente con:   source $RCFILE"
      echo "  O abre una terminal nueva."
      echo "  Luego prueba:               duck-help"
      ;;
  esac
else
  echo
  echo "  Recarga el shell manualmente:  source $RCFILE"
  echo "  Luego prueba:                  duck-help"
fi
