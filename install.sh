#!/usr/bin/env bash
# install.sh — bootstrap installer for rubber-duck.
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/Yao-civitatis/rubber-duck/main/install.sh | bash
#
# What it does:
#   1. Verifies required deps (git, bash, jq).
#   2. Clones the repo to RUBBER_DUCK_DIR (default: $HOME/proyectos/rubber-duck).
#      If the dir already exists and is a git checkout of this repo, it does
#      `git pull` on the configured branch instead of re-cloning.
#   3. Executes setup.sh inside the cloned repo, which installs duck-* into
#      ~/.local/bin and /duck-* into ~/.claude/commands.
#
# Env overrides:
#   RUBBER_DUCK_DIR   target install directory (default $HOME/proyectos/rubber-duck)
#   RUBBER_DUCK_REPO  git URL (default https://github.com/Yao-civitatis/rubber-duck.git)
#   RUBBER_DUCK_REF   branch/tag/ref to checkout (default main)
#   SKIP_SETUP=1      clone only, do not run setup.sh

set -euo pipefail

REPO_URL="${RUBBER_DUCK_REPO:-https://github.com/Yao-civitatis/rubber-duck.git}"
REF="${RUBBER_DUCK_REF:-main}"
TARGET_DIR="${RUBBER_DUCK_DIR:-$HOME/proyectos/rubber-duck}"

c_green='\033[0;32m'; c_yellow='\033[1;33m'; c_red='\033[0;31m'; c_reset='\033[0m'
info()  { printf "${c_green}✓${c_reset} %s\n" "$*"; }
warn()  { printf "${c_yellow}⚠${c_reset} %s\n" "$*"; }
err()   { printf "${c_red}✗${c_reset} %s\n" "$*" >&2; }

# -----------------------------------------------------------------------------
# 1. Dependencies
# -----------------------------------------------------------------------------
missing=()
for bin in git bash jq curl; do
  command -v "$bin" >/dev/null 2>&1 || missing+=("$bin")
done

if [[ ${#missing[@]} -gt 0 ]]; then
  err "Faltan dependencias: ${missing[*]}"
  err "Instálalas y vuelve a lanzar el instalador."
  exit 1
fi

# bash >= 4
bash_major="${BASH_VERSINFO[0]:-0}"
if [[ "$bash_major" -lt 4 ]]; then
  err "Bash >= 4 requerido (detectado $BASH_VERSION)."
  exit 1
fi

info "Dependencias OK (git, bash $BASH_VERSION, jq, curl)."

# -----------------------------------------------------------------------------
# 2. Clone or update
# -----------------------------------------------------------------------------
mkdir -p "$(dirname "$TARGET_DIR")"

if [[ -d "$TARGET_DIR/.git" ]]; then
  existing_url=$(git -C "$TARGET_DIR" remote get-url origin 2>/dev/null || echo "")
  if [[ "$existing_url" != "$REPO_URL" ]]; then
    err "$TARGET_DIR ya existe y apunta a otro remote: $existing_url"
    err "Mueve/borra ese directorio o exporta RUBBER_DUCK_DIR a otra ruta."
    exit 1
  fi
  info "Repo ya clonado en $TARGET_DIR — actualizando ($REF)."
  git -C "$TARGET_DIR" fetch --tags origin
  git -C "$TARGET_DIR" checkout "$REF"
  git -C "$TARGET_DIR" pull --ff-only origin "$REF" || warn "pull no fast-forward; revisa manualmente."
elif [[ -e "$TARGET_DIR" ]]; then
  err "$TARGET_DIR existe y no es un git checkout. Aborto."
  exit 1
else
  info "Clonando $REPO_URL → $TARGET_DIR (ref: $REF)"
  git clone --branch "$REF" "$REPO_URL" "$TARGET_DIR"
fi

# -----------------------------------------------------------------------------
# 3. Run setup.sh
# -----------------------------------------------------------------------------
if [[ "${SKIP_SETUP:-0}" == "1" ]]; then
  info "SKIP_SETUP=1 — clonado pero no se ejecuta setup.sh."
  echo
  echo "Próximo paso manual:"
  echo "  cd $TARGET_DIR && ./setup.sh"
  exit 0
fi

chmod +x "$TARGET_DIR/setup.sh"

# Pipe-friendly: re-attach stdin to /dev/tty if available so setup.sh prompts
# work even when this script was launched via `curl … | bash`.
if [[ ! -t 0 && -e /dev/tty ]]; then
  exec < /dev/tty
fi

info "Lanzando setup.sh…"
echo
cd "$TARGET_DIR"
exec ./setup.sh
