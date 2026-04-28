#!/usr/bin/env bash
set -e

REPO="https://github.com/your-org/dotfiles.git"
TARGET="$HOME/.dotfiles"

echo "📦 Cloning dotfiles..."

if [ -d "$TARGET" ]; then
echo "🔄 Updating existing repo..."
git -C "$TARGET" pull
else
git clone "$REPO" "$TARGET"
fi

echo "🚀 Running installer..."
bash "$TARGET/scripts/install.sh"
