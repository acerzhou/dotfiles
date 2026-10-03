# dotfiles

Minimal macOS development environment configuration with one default setup path and optional personal package additions.

## Principles

- Keep one authoritative configuration for each tool.
- Keep package declarations in Brewfiles.
- Keep scripts small and grouped by domain.
- Keep machine-specific values outside the repository.

## Quick start

```sh
git clone https://github.com/acerzhou/dotfiles.git ~/Repos/dotfiles
cd ~/Repos/dotfiles
make install
make config
make hammerspoon
```

Use `make install PROFILE=personal` to install the default packages followed by `brew/profiles/personal.Brewfile`. Package profiles do not change configuration.

## Structure

```text
dotfiles/
├── brew/          # Canonical package manifest
├── docs/          # Detailed repository documentation
├── git/           # Git configuration
├── hammerspoon/   # Hammerspoon configuration and installer
├── iterm/         # iTerm2 profile export
├── scripts/       # Operational scripts grouped by domain
├── tests/         # Isolated regression tests
├── tmux/          # Tmux configuration
├── vim/           # Vim configuration
├── zsh/           # ZSH configuration
├── AGENTS.md      # AI operating contract
├── CHANGELOG.md   # Project history
└── Makefile       # Public commands
```

## Common commands

| Command | Purpose |
| --- | --- |
| `make install` | Install default packages |
| `make install PROFILE=personal` | Install default and personal packages |
| `make install-plan PROFILE=personal` | Preview package manifests |
| `make config` | Link and configure default dotfiles |
| `make hammerspoon` | Install and link Hammerspoon configuration |
| `make check` | Check managed links |
| `make test` | Run isolated regression tests |

Run `make help` for all supported commands.

## Documentation

- [Setup, customization, and recovery](docs/setup.md)
- [Hammerspoon shortcuts](hammerspoon/README.md)
- [ZSH configuration](zsh/README.md)
- [Project history](CHANGELOG.md)

Machine-local Git identity belongs in `~/.gitconfig.local`; shell customizations belong in `~/.zshrc.local`. Neither file is tracked.
