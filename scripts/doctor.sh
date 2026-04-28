#!/usr/bin/env bash

echo "🩺 Running environment diagnostics..."

check() {
  if command -v "$1" >/dev/null; then
    echo "✔ $1"
  else
    echo "❌ $1 missing"
  fi
}

for cmd in zsh tmux mise starship zoxide fzf bat; do
  check "$cmd"
done

if command -v wl-copy >/dev/null; then
  echo "✔ Wayland clipboard"
elif command -v xclip >/dev/null; then
  echo "✔ X11 clipboard"
else
  echo "❌ No clipboard tool"
fi

echo ""
echo "📦 Checking PATH..."

if echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo "✔ ~/.local/bin in PATH"
else
  echo "⚠ ~/.local/bin missing from PATH"
fi

echo ""
echo "🔗 Checking symlinks..."

check_link() {
  local path="$1"

  if [[ -L "$path" ]]; then
    echo "✔ $path (symlink)"
  elif [[ -e "$path" ]]; then
    echo "⚠ $path exists but is not a symlink"
  else
    echo "❌ $path missing"
  fi
}

check_link "$HOME/.zshrc"
check_link "$HOME/.zprofile"
check_link "$HOME/.config/shell"
check_link "$HOME/.config/tmux"


echo "Done."