# Contributing

## Principles

* Keep login shell minimal (.zprofile)
* Keep runtime modular (.zshrc + runtime/)
* Do not hardcode machine-specific paths
* Prefer package manager installs over curl scripts

## Where things go

* aliases → shell/aliases.zsh
* functions → shell/functions/
* completions → shell/completions/
* OS-specific → shell/os/
* optional tools → shell/tools/

## Rules

* All shell scripts must pass shellcheck
* Do not introduce breaking changes without discussion
* Keep cross-platform compatibility (macOS + Linux)

## Testing

Run:

scripts/doctor.sh
