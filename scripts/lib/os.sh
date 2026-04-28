detect_platform() {
case "$(uname -s)" in
Darwin) echo "macos" ;;
Linux)  echo "linux" ;;
*)      echo "unknown" ;;
esac
}

detect_pkg_manager() {
if command -v brew >/dev/null; then echo "brew"
elif command -v dnf >/dev/null; then echo "dnf"
elif command -v apt-get >/dev/null; then echo "apt"
else echo "none"
fi
}
