# In ~/.config/shell/runtime/zim.zsh
if command -v brew >/dev/null && [ -f "$(brew --prefix)/opt/zimfw/bin/zimfw" ]; then
    # Homebrew path
    export ZIM_HOME="$HOME/.cache/zim"
    source "$(brew --prefix)/opt/zimfw/share/zimfw.zsh" init
else
    # Script/Manual path
    export ZIM_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zim"
    [[ -e "$ZIM_HOME/init.zsh" ]] && source "$ZIM_HOME/init.zsh"
fi
