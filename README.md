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

---

## Team Operations Toolkit (SSH Fleet + tmux)

This repository includes a lightweight SSH fleet system for managing multiple servers safely and consistently.

It is built around:

* ssh-hosts → host discovery from ~/.ssh/config
* sshp → parallel inspection
* sshm → safe orchestration (serial execution)
* sshmux → tmux war-room mode
* ssh-script → remote script execution
* sshv → remote interactive vim editing

* tmux sync mode (Prefix + S)

---

## Core Idea

We treat infrastructure as a **fleet of hosts**, not individual machines.

Host naming convention:

```
<app-name>[-<adopting-institution>]-<environment>
```

**app-name:** The unique identifier of the application.
**adopting-institution:** Optional. The organization hosting or using the instance.
**environment:** The deployment stage. Must be exactly one of: dev, test, staging, or prod

Examples:

* yhr-umich-test
* yhr-itm-prod
* nabu-test

---

## Available Commands

### Parallel Inspection (sshp)

```bash
sshp '<pattern>' <command>

sshp 'yhr-.*-test' uptime
sshp 'yhr-.*-test' sudo df -h
```

Examples:

## Safe Orchestration (sshm)

Serial execution across hosts:

```bash
sshm '<pattern>' <command>

sshm 'yhr-.*-test' sudo systemctl restart shibd
sshm nabu sudo ls -al /home/michr-developers
```

**Behavior**

* Runs one host at a time
* Safer for destructive operations
* Preserves execution order

## Parallel Inspection (sshp)

Runs commands in parallel across hosts.

```bash
sshp '<pattern>' <command>

sshp 'yhr-.*-test' uptime
sshp 'yhr-.*-test' df -h
sshp nabu sudo ls -al
```

**Behavior**

* Executes in parallel (xargs -P 10)
* Prefixes output with host name
* Read-only safe operations

## Remote Script Execution (ssh-script)

Executes a local script on a remote machine.

```bash
ssh-script <host> <script>

ssh-script yhr-umich-test ./scripts/deploy.sh
```

**Use cases**

* deployments
* migrations
* repeatable admin tasks
* running local tooling remotely without copying files

## Remote Interactive Editing (sshv)

Open remote files using vim over SSH.

```bash
sshv <host> <file>

sshv yhr-umich-test /etc/hosts
```

## Fleet War Room (sshmux)

Launch tmux-based multi-host sessions:

```bash
sshmux '<pattern>'

sshmux 'yhr-.*-test'
```

**Behavior**

* Creates tmux window
* Splits into panes
* Assigns each pane to a host
* Runs ssh host automatically
* Sets pane title to hostname

### tmux Ops Mode

Inside tmux fleet sessions:

Sync Mode (broadcast input)

Toggle:

Prefix + S

Used for synchronized execution across panes.
