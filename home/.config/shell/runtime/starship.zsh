# Initialize Starship if it exists
if command -v starship > /dev/null; then
  eval "$(starship init zsh)"
else
  # Fallback prompt in case installation failed
  PROMPT='%n@%m %1~ %# ' 
fi