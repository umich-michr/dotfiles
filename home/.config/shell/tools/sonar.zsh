# -----------------------------
# SONAR (optional)
# -----------------------------
export SONAR_SCANNER_VERSION=5.0.1.3006
export SONAR_SCANNER_HOME="$HOME/.sonar/sonar-scanner-$SONAR_SCANNER_VERSION"
export SONAR_SCANNER_OPTS="-server"

[ -d "$SONAR_SCANNER_HOME/bin" ] && export PATH="$SONAR_SCANNER_HOME/bin:$PATH"