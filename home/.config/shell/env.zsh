export EDITOR=vim

case "$(uname -s)" in
Darwin) export PLATFORM="macos" ;;
Linux) export PLATFORM="linux" ;;
*) export PLATFORM="unknown" ;;
esac

# Setup shell functions
fpath=(
  ~/.config/shell/completions
  ~/.config/shell/functions
  $fpath
)

# Autoload (lazy load) all files in that directory. This magically picks up any new files you drop in there later
autoload -Uz $fpath[1,2]/*(:t)

export ORACLE_HOME="$HOME/development/database/oracle"
export TNS_ADMIN="$HOME/development/database/oracle/network/admin"
