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

log() { echo -e "$1"; }
ok() { log "✔ $1"; }
warn() { log "⚠ $1"; }
err() { log "❌ $1"; }

add_report() {
  REPORT+=("$1")
}

# Detect platform
OS="$(uname -s)"
case "$OS" in
Darwin) PLATFORM="macos" ;;
Linux) PLATFORM="linux" ;;
*)
  err "Unsupported OS: $OS"
  exit 1
  ;;
esac

ok "Platform: $PLATFORM"

# Install Homebrew if missing (macOS)
install_brew() {
  if [[ "$PLATFORM" == "macos" ]] && ! command -v brew >/dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}
run install_brew

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

run install_pkg_manager

install_zsh() {
  if command -v brew >/dev/null 2>&1; then
    brew install zsh
  elif command -v apt >/dev/null 2>&1; then
    sudo apt update && sudo apt install -y zsh
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y zsh
  else
    echo "Unsupported package manager. Install zsh manually."
    return 1
  fi
}

install_zsh

check_zim_doctor() {
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/zim/init.zsh"
  local config="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zim/init.zsh"
  
  if [[ -f "$cache" || -f "$config" ]]; then
    return 0
  elif zsh -ic "command -v zimfw" >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

install_zim() {
  if command -v brew >/dev/null && brew list zimfw >/dev/null 2>&1; then
    ok "zim installed via brew"
    return
  fi

  if [[ -f "${XDG_CACHE_HOME:-$HOME/.cache}/zim/init.zsh" || -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zim/init.zsh" ]]; then
    ok "zim already installed"
    return
  fi

  warn "Installing zimfw..."
  local ZIM_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zim"

  mkdir -p "$ZIM_HOME"
  curl -fsSL -o "$ZIM_HOME/zimfw.zsh" \
    https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh

  zsh "$ZIM_HOME/zimfw.zsh" init -q
}

# Fallback installers
ensure_command() {
  local cmd="$1"
  local install_fn="$2"
  # Use arg 3 as a custom check function, otherwise default to standard 'command -v'
  local check_fn="${3:-command -v $cmd}"

  if eval "$check_fn" >/dev/null 2>&1; then
    ok "$cmd installed"
    add_report "$cmd: OK"
  else
    warn "$cmd missing → installing via fallback"
    $install_fn

    if eval "$check_fn" >/dev/null 2>&1; then
      ok "$cmd installed via fallback"
      add_report "$cmd: fallback installed"
    else
      err "$cmd failed to install"
      add_report "$cmd: FAILED"
    fi
  fi
}

install_mise() {
  curl https://mise.run | sh
}

install_starship() {
  curl -sS https://starship.rs/install.sh | sh -s -- -y
}

install_zoxide() {
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
}

install_fzf() {
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || true
  ~/.fzf/install --all --no-bash --no-fish --key-bindings --completion
}

ensure_command zimfw install_zim check_zim_doctor
ensure_command mise install_mise
ensure_command starship install_starship
ensure_command zoxide install_zoxide
ensure_command fzf install_fzf

# Clipboard check
# Clipboard check
if [[ "$PLATFORM" == "macos" ]]; then
  ok "Clipboard: macOS (pbcopy)"
  add_report "clipboard: pbcopy"
elif command -v wl-copy >/dev/null 2>&1; then
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

ok "Setting up mise toolchains..."

if command -v mise >/dev/null 2>&1; then
  run mise trust
  run mise install
  ok "mise toolchains installed"
else
  warn "mise not available, skipping toolchain install"
fi

if command -v npm >/dev/null 2>&1; then
  ok "Installing global npm tools..."
  run npm install -g @mermaid-js/mermaid-cli@latest
else
  warn "npm not available, skipping mermaid-cli"
fi

# Final report
echo ""
echo "================ INSTALL REPORT ================"
for line in "${REPORT[@]}"; do
  echo "- $line"
done
echo "==============================================="

echo ""
ok "Done. Restart shell: exec zsh"
