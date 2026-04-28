# --- Base environment + XDG ---
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# --- Core environment, order is important ---
source "$XDG_CONFIG_HOME/shell/env.zsh" 
source "$XDG_CONFIG_HOME/shell/path.zsh"

# --- Tool environment (optional tools like SONAR) ---
for file in "$XDG_CONFIG_HOME/shell/tools/"*.zsh; do
  [ -r "$file" ] && source "$file"
done

# --- OS-specific settings ---
case "$PLATFORM" in
  macos)
    source "$XDG_CONFIG_HOME/shell/os/macos.zsh"
    ;;
  linux)
    source "$XDG_CONFIG_HOME/shell/os/linux.zsh"
    ;;
esac

# --- Toolchain manager (mise, etc.) ---
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# --- Secrets last (allow overrides) ---
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"
