# Setup Guide

## New Machine

```bash
git clone https://github.com/acerzhou/dotfiles.git ~/Repos/dotfiles
cd ~/Repos/dotfiles
make install
make config

# Install and configure Hammerspoon separately
make hammerspoon
```

`make install` installs the canonical `brew/Brewfile`. `PROFILE=personal` installs the default manifest first and then the personal additions. It does not link configuration files.

Preview or list profiles before installing:

```bash
make profiles
make install-plan PROFILE=personal
```

Default packages are in `brew/Brewfile`; optional additions are in `brew/profiles/<name>.Brewfile`.

`make config` links the default ZSH, Vim, Tmux, and Git configuration, backs up replaced paths, sets ZSH as your default shell, and offers SSH key creation. Configuration does not vary by package profile. Hammerspoon still has its own installer at `hammerspoon/install.sh`.

If Homebrew's ZSH appears first in `PATH`, configuration still uses a registered login shell from `/etc/shells` (normally `/bin/zsh` on macOS). If ZSH is already your default, it leaves the setting unchanged.

Set your Git identity in a local file to avoid changing tracked dotfiles:

```bash
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "your.email@example.com"
exec zsh
```

The default Git configuration includes `~/.gitconfig.local` automatically. Machine-local shell settings belong in `~/.zshrc.local`, loaded by the interactive shell.

## Optional Setup

The shell configuration works without Oh My Zsh. Install language runtimes and version managers separately; NVM, jenv, pyenv, Go, and Rust integrations load when available.

Vim starts with built-in settings when plugins are missing. Install [vim-plug](https://github.com/junegunn/vim-plug), then run `:PlugInstall` in Vim to enable the configured plugins. CoC also requires Node.js.

For iTerm2, import `iterm/iterm2-config.json` using Settings → Profiles → Other Actions → Import JSON Profiles. This file is a profile export.

For Hammerspoon, open the app, enable Accessibility access when prompted, and reload its configuration from the menu. See [the Hammerspoon guide](../hammerspoon/README.md) for shortcuts and optional Karabiner setup.

## Commands

| Command | Purpose |
| --- | --- |
| `make install [PROFILE=<name>]` | Install default packages and optional additions |
| `make install-plan [PROFILE=<name>]` | Preview packages without installing |
| `make profiles` | List available profiles |
| `make config` | Apply the default configuration |
| `make install-links` | Apply default symlinks only |
| `make hammerspoon` | Install and configure Hammerspoon |
| `make check` | Report all managed link statuses |
| `make backup` | Snapshot current dotfiles |
| `make list-backups` | List available backups |
| `make restore BACKUP=<name>` | Restore a backup after confirmation |
| `make uninstall` | Remove links pointing to this repository |
| `make update` | Pull changes and reapply default configuration |
| `make clean` | Keep the five newest backups |
| `make test` | Run isolated regression tests |

The Makefile is the supported interface. Package profiles apply only to `make install` and `make install-plan`.

## Backups and Restore

All new backups live in `~/.dotfiles-backups/<backup-name>/`. Installer backups hold replaced paths; manual snapshots copy the contents of linked configuration. Restore creates a safety snapshot and supports partial installer backups without removing unrelated shell files.

```bash
make list-backups
make restore BACKUP=20261003-120000-AbCd12
```

Use the exact name shown by `make list-backups`. Backups from older installers under `~/.dotfiles-backup-*` are left in place; restore those manually if needed.

## Troubleshooting

```bash
# Inspect every managed link; missing/incorrect links produce a nonzero exit
make check

# Reapply default links and Hammerspoon independently
make install-links
make hammerspoon

# Check shell syntax
zsh -n ~/.zshrc

# Reload interactive settings
source ~/.zshrc
```

`make uninstall` removes default dotfile links that point to this repository. It preserves unrelated files, links, installed packages, and the separately managed Hammerspoon configuration.
