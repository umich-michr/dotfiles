if [[ "$PLATFORM" != "macos" ]]; then
  return
fi

# Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# GNU coreutils
COREUTILS_BIN="/opt/homebrew/opt/coreutils/libexec/gnubin"
[ -d "$COREUTILS_BIN" ] && export PATH="$COREUTILS_BIN:$PATH"
