#!/usr/bin/env bash
# install-hooks.sh — copia los hooks de rubber-duck a <repo>/.git/hooks/.
#
# Uso:
#   install-hooks.sh                 # directorio actual
#   install-hooks.sh /ruta/al/repo
#
# Comportamiento:
#   - Verifica que el destino es un repo git válido (<dest>/.git existe).
#   - Para cada hook (pre-commit, pre-push, post-merge):
#     * Si ya existe un hook con ese nombre y NO tiene el sello rubber-duck,
#       lo preserva como <hook>.bak.<timestamp> antes de sobrescribir.
#     * Si ya existe con el sello rubber-duck, lo sobrescribe sin backup
#       (versiones antiguas se reemplazan).
#   - Imprime al final el recordatorio de los flags de activación.
#
# Idempotente: ejecutar varias veces produce el mismo estado.

set -euo pipefail

HOOKS_SRC_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/git" && pwd)"
DEST_REPO="${1:-$PWD}"
DEST_REPO="$(cd -P "$DEST_REPO" && pwd)"
DEST_HOOKS="$DEST_REPO/.git/hooks"
SELLO="rubber-duck git hook"
TS="$(date +%Y%m%d-%H%M%S)"

HOOKS=(pre-commit pre-push post-merge)

# 1. Validar destino
if [[ ! -d "$DEST_REPO/.git" ]]; then
  echo "🦆 install-hooks: '$DEST_REPO' no es un repo git (no existe .git/)." >&2
  exit 2
fi
mkdir -p "$DEST_HOOKS"

echo "🦆 Instalando rubber-duck hooks en: $DEST_HOOKS"

# 2. Por cada hook
for hook in "${HOOKS[@]}"; do
  src="$HOOKS_SRC_DIR/$hook"
  dst="$DEST_HOOKS/$hook"

  if [[ ! -f "$src" ]]; then
    echo "    ⚠️  $src no existe — saltado."
    continue
  fi

  if [[ -e "$dst" ]]; then
    if grep -qF "$SELLO" "$dst" 2>/dev/null; then
      # Reemplazar versión anterior nuestra sin backup
      cp -f "$src" "$dst"
      chmod +x "$dst"
      echo "    ↻ $hook (actualizado)"
    else
      # Hook ajeno: preservar
      bak="$dst.bak.$TS"
      mv "$dst" "$bak"
      cp -f "$src" "$dst"
      chmod +x "$dst"
      echo "    ✓ $hook (anterior preservado como $(basename "$bak"))"
    fi
  else
    cp -f "$src" "$dst"
    chmod +x "$dst"
    echo "    ✓ $hook"
  fi
done

# 3. Recordatorio
cat <<'EOF'

✓ Hooks instalados (DESACTIVADOS por defecto).

  Para activar uno o todos:
    duck-config set git.hooks.pre_commit_enabled true
    duck-config set git.hooks.pre_push_enabled true
    duck-config set git.hooks.post_merge_enabled true

  Activación/desactivación es instantánea — los scripts leen el flag
  en cada ejecución, no a la hora de instalar.

  Para saltarse un hook puntualmente:
    git commit --no-verify
    git push --no-verify
EOF
