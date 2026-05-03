# Portable Zsh Environment

A cross-platform, reproducible Zsh environment for macOS and Linux.

---

## Overview

This setup provides:

* XDG-compliant structure: Ypur home directory stays clean.
* Clean separation of login vs interactive shell
* Reproducible toolchains via `mise`: Toolchains (Node, Python, Java, Rust) are sandboxed per-project
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

## Extending & Customizing (The Rules)

### 1. Personal Customizatons (Do NOT Commit)

Need a quick alias, a custom function, or a temporary environment variable?
**Do not edit the core files.** Instead, use the local override file:

```bash
touch ~/.config/shell/.local.zsh
```

Add your personal settings here. This file is ignored by Git, ensuring you will never get merge conflicts when the team updates the core dotfiles. For sensitive tokens, use ~/.secrets.

### 2. Team-Wide Customizations (Please Coomit & PR)

If a tool or alias benefits the whole team:

* **Aliases:** Add to ~/.config/shell/clipboard.zsh
* **Global Functions:** Drop a new file in ~/.config/shell/functions/ (It autoloads, no sourcing required!)
* **Package Depenedencies**: Add to packages/Brewfile, apt.txt, or dnf.txt

---

## Keeping Updated

To get the latest team standards, simply pull the repository and run the installer again. It will safely link new files and install new dependencies.

```bash
cd ~/.dotfiles
git pull origin main
./scripts/install.sh
```

We also provide a global update utility. Running update-all anywhere in your terminal will upgrade Homebrew, Apt/Dnf, Zim modules, and Mise toolchains instantly.

---

### Per-Project Toolchains (mise)

We do not install languages globally. To use Node, Python, Java, or Rust:

1. Ensure your project has a ```mise.toml``` defining the versions.
2. Run ```mise``` install inside that directory.
3. The tools will instantly activate when you enter the directory.

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
