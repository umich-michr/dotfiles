#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
FORCE="${FORCE:-false}"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="${HOME}/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

log()  { echo -e "$1"; }
ok()   { log "✔ $1"; }
warn() { log "⚠ $1"; }

run() {
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

backup_file() {
  local target="$1"
  run mkdir -p "$BACKUP_DIR"
  run mv "$target" "$BACKUP_DIR/"
  warn "Backed up $target → $BACKUP_DIR"
}

link() {
  local src="$1"
  local dest="$2"

  run mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    ok "Already linked: $dest"
    return
  fi

  if [[ -e "$dest" ]]; then
    if [[ "$FORCE" == "true" ]]; then
      backup_file "$dest"
    else
      warn "Skipping existing file: $dest"
      return
    fi
  fi

  run ln -sf "$src" "$dest"
  ok "Linked $dest"
}

echo "🔗 Linking dotfiles..."

link "$DOTFILES_DIR/home/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_DIR/home/.zprofile" "$HOME/.zprofile"
link "$DOTFILES_DIR/home/.config/shell" "$HOME/.config/shell"
link "$DOTFILES_DIR/home/.config/tmux" "$HOME/.config/tmux"
link "$DOTFILES_DIR/home/.config/alacritty" "$HOME/.config/alacritty"
link "$DOTFILES_DIR/home/.local/bin/tmux-start" "$HOME/.local/bin/tmux-start"

run chmod +x "$HOME/.local/bin/tmux-start"

echo "✅ Linking complete"