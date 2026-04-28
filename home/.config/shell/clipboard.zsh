if [[ "$PLATFORM" == "macos" ]]; then
  alias clip="pbcopy"
elif command -v wl-copy >/dev/null 2>&1; then
  alias clip="wl-copy"
elif command -v xclip >/dev/null 2>&1; then
  alias clip="xclip -selection clipboard"
elif command -v xsel >/dev/null 2>&1; then
  alias clip="xsel --clipboard --input"
fi