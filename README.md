# Portable Zsh Environment

A cross-platform, reproducible Zsh environment for macOS (Apple Silicon) and Linux (Fedora, Ubuntu, Mint).

This repository provides a consistent developer shell experience with:

* XDG-compliant layout
* Strict separation of login vs interactive shell
* Per-project toolchains via `mise`
* Cross-platform clipboard support (Wayland + X11 + macOS)
* Reproducible installs via package manifests

---

## Quick Start (Recommended)

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

## What This Sets Up

### Shell Architecture

| Layer       | File        | Responsibility                          |
| ----------- | ----------- | --------------------------------------- |
| Login shell | `.zprofile` | Environment, PATH, toolchain activation |
| Interactive | `.zshrc`    | UI, prompt, aliases, runtime tools      |

---

### Directory Layout

```text
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

### Included Tools

* `mise` — language/runtime manager
* `zoxide` — smarter directory navigation
* `tmux` — persistent sessions
* `starship` — prompt
* `direnv` — per-directory environment loading
* `fzf` — fuzzy finder
* `bat` — improved `cat`

---

## Platform Support

### macOS

* Uses Homebrew

### Linux

* Fedora → `dnf`
* Ubuntu / Mint → `apt`

---

## Installation Details

The installer will:

1. Detect platform and package manager
2. Install dependencies from:

   * `packages/Brewfile`
   * `packages/apt.txt`
   * `packages/dnf.txt`
3. Fallback to upstream installers if needed
4. Configure clipboard support:

   * Wayland → `wl-copy`
   * X11 → `xclip`
5. Symlink configuration into `$HOME`
6. Output an install report

---

## Fonts (Required)

Install a Nerd Font for proper rendering:

* Recommended: JetBrainsMono Nerd Font

Verify:

```bash
echo "✔ Icons:   "
```

---

## Per-Project Toolchains (mise)

Example `mise.toml`:

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

## Clipboard Behavior

Automatically selects:

* macOS → `pbcopy`
* Wayland → `wl-copy`
* X11 → `xclip`

---

## Developer Commands

```bash
scripts/doctor.sh   # validate environment
scripts/install.sh  # reinstall / update
```

---

## Updating

```bash
git -C ~/.dotfiles pull
bash ~/.dotfiles/scripts/install.sh
```

---

## Extending

| Add               | Location             |
| ----------------- | -------------------- |
| aliases           | `shell/aliases.zsh`  |
| functions         | `shell/functions/`   |
| completions       | `shell/completions/` |
| OS-specific logic | `shell/os/`          |
| integrations      | `shell/tools/`       |

---

## Secrets

Store machine-specific values in:

```text
~/.secrets
```

Not tracked in git.

---

## Troubleshooting

```bash
echo $PATH
mise doctor
direnv status
which proj
```

---

## Philosophy

* Minimal login shell
* Modular runtime
* Cross-platform first
* No machine-specific assumptions
* Reproducible installs

---

## Contributing

See `CONTRIBUTING.md`.

---

## Result

A portable, predictable, team-ready shell environment.
