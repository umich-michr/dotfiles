#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
FORCE=false

if [[ "${1:-}" == "--force" ]]; then
  FORCE=true
fi

run() {
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

export PATH="$HOME/.local/bin:$PATH"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
REPORT=()

log()  { echo -e "$1"; }
ok()   { log "✔ $1"; }
warn() { log "⚠ $1"; }
err()  { log "❌ $1"; }

add_report() {
  REPORT+=("$1")
}

# Detect platform
OS="$(uname -s)"
case "$OS" in
  Darwin) PLATFORM="macos" ;;
  Linux)  PLATFORM="linux" ;;
  *) err "Unsupported OS: $OS"; exit 1 ;;
esac

ok "Platform: $PLATFORM"

# Install Homebrew if missing (macOS)
if [[ "$PLATFORM" == "macos" ]] && ! command -v brew >/dev/null; then
  echo "🍺 Installing Homebrew..."
  run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Detect package manager
if command -v brew >/dev/null 2>&1; then
  PKG="brew"
elif command -v dnf >/dev/null 2>&1; then
  PKG="dnf"
elif command -v apt-get >/dev/null 2>&1; then
  PKG="apt"
else
  err "No supported package manager found"
  exit 1
fi

ok "Package manager: $PKG"

install_pkg_manager() {
  case "$PKG" in
    brew)
      run brew update
      run brew bundle --file="$DOTFILES_DIR/packages/Brewfile"
      ;;
    apt)
      run sudo apt-get update
      run xargs -a "$DOTFILES_DIR/packages/apt.txt" sudo apt-get install -y
      ;;
    dnf)
      run xargs -a "$DOTFILES_DIR/packages/dnf.txt" sudo dnf install -y
      ;;
  esac
}

install_pkg_manager

# Fallback installers
ensure_command() {
  local cmd="$1"
  local install_fn="$2"

  if command -v "$cmd" >/dev/null 2>&1; then
    ok "$cmd installed"
    add_report "$cmd: OK"
  else
    warn "$cmd missing → installing via fallback"
		"$install_fn"

    if command -v "$cmd" >/dev/null 2>&1; then
      ok "$cmd installed via fallback"
      add_report "$cmd: fallback installed"
    else
      err "$cmd failed to install"
      add_report "$cmd: FAILED"
    fi
  fi
}

install_mise() {
  run curl https://mise.run | sh
}

install_starship() {
  run curl -sS https://starship.rs/install.sh | sh -s -- -y
}

install_zoxide() {
  run curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
}

install_fzf() {
  run git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || true
  run ~/.fzf/install --all --no-bash --no-fish
}

ensure_command mise install_mise
ensure_command starship install_starship
ensure_command zoxide install_zoxide
ensure_command fzf install_fzf

# Clipboard check
if command -v wl-copy >/dev/null 2>&1; then
  ok "Clipboard: Wayland (wl-copy)"
  add_report "clipboard: wl-copy"
elif command -v xclip >/dev/null 2>&1; then
  ok "Clipboard: X11 (xclip)"
  add_report "clipboard: xclip"
else
  warn "No clipboard tool available"
  add_report "clipboard: NONE"
fi

# Run link step
ok "Running link step..."
DRY_RUN="$DRY_RUN" FORCE="$FORCE" bash "$DOTFILES_DIR/scripts/link.sh"

# Final report
echo ""
echo "================ INSTALL REPORT ================"
for line in "${REPORT[@]}"; do
  echo "- $line"
done
echo "==============================================="

echo ""
ok "Done. Restart shell: exec zsh"
