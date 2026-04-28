#!/usr/bin/env bash

set -euo pipefail

echo "🩺 Running environment diagnostics..."

# --------------------------------------------------
# Helpers
# --------------------------------------------------

ok() { echo "✔ $1"; }
warn() { echo "⚠ $1"; }
err() { echo "❌ $1"; }

check_cmd() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "$cmd"
    return 0
  else
    err "$cmd missing"
    return 1
  fi
}

check_cmd_alt() {
  local primary="$1"
  local alt="$2"

  if command -v "$primary" >/dev/null 2>&1; then
    ok "$primary"
  elif command -v "$alt" >/dev/null 2>&1; then
    ok "$primary (via $alt)"
  else
    err "$primary missing"
  fi
}

section() {
  echo ""
  echo "🔹 $1"
}

# --------------------------------------------------
# Platform Detection
# --------------------------------------------------

OS="$(uname -s)"
case "$OS" in
Darwin) PLATFORM="macos" ;;
Linux) PLATFORM="linux" ;;
*) PLATFORM="unknown" ;;
esac

section "Platform"
ok "Detected: $PLATFORM"

# --------------------------------------------------
# Package Manager
# --------------------------------------------------

section "Package Manager"

if command -v brew >/dev/null 2>&1; then
  ok "brew"
elif command -v apt-get >/dev/null 2>&1; then
  ok "apt"
elif command -v dnf >/dev/null 2>&1; then
  ok "dnf"
else
  err "No supported package manager found"
fi

# macOS-specific expectation
if [[ "$PLATFORM" == "macos" ]]; then
  if command -v brew >/dev/null 2>&1; then
    ok "Homebrew available"
  else
    err "Homebrew missing (required on macOS)"
  fi
fi

# --------------------------------------------------
# Core Tools (hard requirements)
# --------------------------------------------------

section "Core Tools"

for cmd in zsh git curl tmux; do
  check_cmd "$cmd"
done

# --------------------------------------------------
# Dev / UX Tools
# --------------------------------------------------

section "Dev Tools"

check_cmd fzf
check_cmd zoxide
check_cmd starship
check_cmd eza
check_cmd rg
check_cmd fd

# bat has edge case on apt
check_cmd_alt bat batcat

# optional but useful
check_cmd direnv || true
check_cmd lazygit || true

# --------------------------------------------------
# Runtime / Shell Integration
# --------------------------------------------------

section "Shell Integration"

if zsh -ic 'echo $ZSH_VERSION' >/dev/null 2>&1; then
  ok "Zsh launches correctly"
else
  err "Zsh failed to start"
fi

# Try loading zim in isolated zsh
if zsh -ic "command -v zimfw" >/dev/null 2>&1; then
  echo "✔ zimfw works in zsh"
else
  echo "❌ zimfw not functional"
fi

# Verify zim init exists somewhere
ZIM_FOUND=false

for dir in \
  "${XDG_CACHE_HOME:-$HOME/.cache}/zim" \
  "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zim"; do
  if [[ -f "$dir/init.zsh" ]]; then
    ok "zim init found: $dir"
    ZIM_FOUND=true
  fi
done

if [[ "$ZIM_FOUND" == false ]]; then
  warn "zim init not found in expected locations"
fi

# --------------------------------------------------
# PATH / Linking
# --------------------------------------------------

section "PATH & Linking"

if echo "$PATH" | grep -q "$HOME/.local/bin"; then
  ok "~/.local/bin in PATH"
else
  warn "~/.local/bin missing from PATH"
fi

check_link() {
  local path="$1"

  if [[ -L "$path" ]]; then
    ok "$path (symlink)"
  elif [[ -e "$path" ]]; then
    warn "$path exists but not a symlink"
  else
    err "$path missing"
  fi
}

check_link "$HOME/.zshrc"
check_link "$HOME/.zprofile"
check_link "$HOME/.config/shell"
check_link "$HOME/.config/tmux"

# --------------------------------------------------
# tmux integration
# --------------------------------------------------

section "tmux"

if command -v tmux >/dev/null 2>&1; then
  ok "tmux installed"
else
  err "tmux missing"
fi

if command -v tmux-start >/dev/null 2>&1; then
  ok "tmux-start in PATH"
elif [[ -x "$HOME/.local/bin/tmux-start" ]]; then
  warn "tmux-start exists but not in PATH"
else
  err "tmux-start missing"
fi

# --------------------------------------------------
# Clipboard (feature check)
# --------------------------------------------------

section "Clipboard"

if command -v pbcopy >/dev/null 2>&1; then
  ok "macOS clipboard (pbcopy)"
elif command -v wl-copy >/dev/null 2>&1; then
  ok "Wayland clipboard (wl-copy)"
elif command -v xclip >/dev/null 2>&1; then
  ok "X11 clipboard (xclip)"
else
  err "No clipboard tool available"
fi

# --------------------------------------------------
# Mise (toolchain manager)
# --------------------------------------------------

section "Mise"

if command -v mise >/dev/null 2>&1; then
  ok "mise installed"

  if mise doctor >/dev/null 2>&1; then
    ok "mise healthy"
  else
    warn "mise reports issues"
  fi
else
  err "mise missing"
fi

# --------------------------------------------------
# Neovim / LazyVim
# --------------------------------------------------

section "Neovim"

if command -v nvim >/dev/null 2>&1; then
  ok "nvim installed"

  if nvim --headless "+qa" >/dev/null 2>&1; then
    ok "nvim launches"
  else
    err "nvim failed to launch"
  fi

  if nvim --headless "+Lazy! health" +qa >/dev/null 2>&1; then
    ok "LazyVim healthy"
  else
    warn "LazyVim health check failed"
  fi
else
  err "nvim missing"
fi

# --------------------------------------------------
# Mermaid (Markdown rendering)
# --------------------------------------------------

section "Mermaid"

if command -v mmdc >/dev/null 2>&1; then
  ok "mermaid-cli installed (mmdc)"
else
  warn "mermaid-cli missing (needed for markdown diagrams)"
  echo "   Install: npm install -g @mermaid-js/mermaid-cli"
fi

# --------------------------------------------------
# Fonts
# --------------------------------------------------

section "Fonts (Nerd Font)"

FONT_FOUND=false

if command -v fc-list >/dev/null 2>&1; then
  if fc-list | grep -qi "nerd"; then
    FONT_FOUND=true
  fi
fi

if [[ "$PLATFORM" == "macos" ]]; then
  if ls "$HOME/Library/Fonts" 2>/dev/null | grep -qi "nerd"; then
    FONT_FOUND=true
  fi
fi

if [[ "$FONT_FOUND" == true ]]; then
  ok "Nerd Font detected"
else
  warn "Nerd Font not detected"
fi

echo ""
echo "👁 Rendering test:"
echo "  Powerline:  "
echo "  Devicons:      "

echo ""
echo "If icons look broken → set terminal font to 'JetBrainsMono Nerd Font'"

# --------------------------------------------------
# Summary
# --------------------------------------------------

echo ""
echo "✅ Diagnostics complete."
