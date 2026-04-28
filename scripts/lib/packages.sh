install_packages() {
local mgr="$1"
local root="$2"

case "$mgr" in
brew)
brew update
brew bundle --file="$root/packages/Brewfile"
;;
apt)
sudo apt-get update
xargs -a "$root/packages/apt.txt" sudo apt-get install -y
;;
dnf)
sudo dnf install -y $(cat "$root/packages/dnf.txt")
;;
esac
}
