alias e="nvim"
alias ef='nvim $(fzf -m)'

alias ls="eza --icons --group-directories-first"
alias ll="eza --icons --group-directories-first -la"

alias dots-term="nvim -p ~/.zshrc $HOME/.config/tmux/tmux.conf ~/.config/alacritty/alacritty.toml"

alias nvupdate='nvim --headless "+Lazy! sync" "+lua require(\"lazy\").load({plugins = {\"mason.nvim\"}}); vim.cmd(\"MasonUpdate\")" "+TSUpdate" +qa'

alias kill-gradle="ps -ef|grep -i gradle|grep -v grep|awk '{print $2}'|grep java|xargs kill -9"

# Mac-only X11 helpers (mostly outdated)
if [[ "$PLATFORM" != "macos" ]]; then
  return
fi

alias startx="/Applications/Utilities/XQuartz.app/Contents/MacOS/X11 &"
alias starty="(ps -ef | grep -v grep | grep X11 || (startx)) 1>/dev/null"
alias sshx="export DISPLAY=:0.0 && (starty) && ssh -Y"
alias killx="killall Xquartz"

#alias nvupdate='nvim --headless "+Lazy! sync" "+MasonUpdate" "+TSUpdate" +qa'
