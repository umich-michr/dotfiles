# sets the Zsh Line Editor (ZLE) to use Emacs-style keybindings.
# Ctrl + A: Move to the beginning of the line.
# Ctrl + E: Move to the end of the line.
# Ctrl + K: Kill (delete) the text from the cursor to the end of the line.
# Ctrl + R: Search backward through your command history.
# Alt + F / Alt + B: Move forward or backward by one word.
bindkey -e

# order matters
source "$HOME/.config/shell/runtime/zim.zsh"
source "$HOME/.config/shell/runtime/zoxide.zsh"
source "$HOME/.config/shell/runtime/starship.zsh"
source "$HOME/.config/shell/runtime/direnv.zsh"

# user config
source "$HOME/.config/shell/aliases.zsh"
source "$HOME/.config/shell/clipboard.zsh"

# Load local overrides (git-ignored)
[ -f "$HOME/.config/shell/.local.zsh" ] && source "$HOME/.config/shell/.local.zsh"
