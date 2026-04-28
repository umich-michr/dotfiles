# Portable Zsh Environment

A cross-platform, reproducible Zsh environment for macOS and Linux.

---

## Overview

This setup provides:

* XDG-compliant structure
* Clean separation of login vs interactive shell
* Reproducible toolchains via `mise`
* Optional per-directory environments via `direnv`
* Portable behavior across macOS and Linux

---

## Quick Start

```bash
git clone https://github.com/your-org/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash scripts/install.sh
```

Restart shell:

```bash
exec zsh
```

---

## Architecture

| Layer       | File        | Responsibility                          |
| ----------- | ----------- | --------------------------------------- |
| Login       | `.zprofile` | Environment, PATH, toolchain activation |
| Interactive | `.zshrc`    | Prompt, aliases, runtime tools          |

---

## Directory Layout

```
~/.config/shell/
├── env.zsh
├── path.zsh
├── aliases.zsh
├── clipboard.zsh
├── functions/
├── completions/
├── runtime/
├── tools/
└── os/
```

---

## Tooling

* `mise` → language/runtime manager
* `zoxide` → smarter navigation
* `tmux` → persistent sessions
* `starship` → prompt
* `direnv` → optional env loader
* `fzf` → fuzzy finder
* `bat` → improved cat

---

## Zsh Framework (Zim)

Zim is used for modular shell configuration.

* Installed automatically during setup
* Config file: `~/.zimrc`

---

## Fonts (Required)

Install a Nerd Font for icons.

### macOS

```bash
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
```

### Linux

```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip
fc-cache -fv
```

Test:

```bash
echo "✔ Icons:   "
```

---

## mise (Toolchains)

Example:

```toml
[tools]
node = "20"
python = "3.11"
```

Usage:

```bash
mise trust
mise install
```

---

## direnv (Optional)

Enable:

```bash
eval "$(direnv hook zsh)"
```

Example `.envrc`:

```bash
use mise
```

Then:

```bash
direnv allow
```

---

## Clipboard

Auto-detected:

* macOS → `pbcopy`
* Wayland → `wl-copy`
* X11 → `xclip`

---

## Updating

```bash
git -C ~/.dotfiles pull
bash ~/.dotfiles/scripts/install.sh
```

---

## Troubleshooting

```bash
scripts/doctor.sh
```

### Common Issues

**mise not working**

```bash
mise doctor
mise trust
```

**direnv not loading**

```bash
direnv allow
```

**icons not rendering**

* ensure Nerd Font installed
* set terminal font manually

---

## Philosophy

* Minimal login shell
* Modular runtime
* Cross-platform consistency
* No machine-specific assumptions

---

## Result

A portable, predictable, team-ready shell environment.
