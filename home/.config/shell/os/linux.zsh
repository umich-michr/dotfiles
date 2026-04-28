if [[ "$PLATFORM" != "linux" ]]; then
  return
fi

# Debian/Ubuntu baseline tools (safe assumptions)
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"