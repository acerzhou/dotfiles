# Setup Guide

## New Machine

```bash
git clone https://github.com/acerzhou/dotfiles.git ~/Repos/dotfiles
cd ~/Repos/dotfiles
make install
make config

# macOS: install and configure Hammerspoon separately
make hammerspoon
```

`make install` installs Homebrew and the Brewfile packages on macOS, or core command-line tools via apt on Ubuntu. It does not link configuration files.

`make config` links ZSH, Vim, Tmux, and Git configuration, backs up replaced paths, sets ZSH as your default shell, and offers SSH key creation. Hammerspoon has its own installer at `hammerspoon/install.sh`.

Set your Git identity in a local file to avoid changing tracked dotfiles:

```bash
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "your.email@example.com"
exec zsh
```

The shared Git configuration includes `~/.gitconfig.local` automatically. Personal shell settings belong in `~/.zshrc.local`, loaded by the interactive shell.

## Optional Setup

The shell configuration works without Oh My Zsh. Install language runtimes and version managers separately; NVM, jenv, pyenv, Go, and Rust integrations load when available.

Vim starts with built-in settings when plugins are missing. Install [vim-plug](https://github.com/junegunn/vim-plug), then run `:PlugInstall` in Vim to enable the configured plugins. CoC also requires Node.js.

For iTerm2, import `iterm/iterm2-config.json` using Settings → Profiles → Other Actions → Import JSON Profiles. This file is a profile export.

For Hammerspoon, open the app, enable Accessibility access when prompted, and reload its configuration from the menu. See [hammerspoon/README.md](hammerspoon/README.md) for shortcuts and optional Karabiner setup.

## Commands

| Command | Purpose |
| --- | --- |
| `make install` | Install packages |
| `make config` | Apply general configuration and shell setup |
| `make install-links` | Apply general symlinks only |
| `make hammerspoon` | Install and configure Hammerspoon on macOS |
| `make check` | Report all managed link statuses |
| `make backup` | Snapshot current dotfiles |
| `make list-backups` | List available backups |
| `make restore BACKUP=<name>` | Restore a backup after confirmation |
| `make uninstall` | Remove links pointing to this repository |
| `make update` | Pull changes and reapply general configuration |
| `make clean` | Keep the five newest backups |
| `make test` | Run isolated regression tests |

You can run `bash install.sh install`, `bash install.sh config`, or `bash hammerspoon/install.sh` directly. The legacy `script/mac-set-up.sh`, `script/ubuntu-set-up.sh`, and `zsh/set-up.sh` delegate to the maintained scripts.

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

# Reapply general links and Hammerspoon independently
make install-links
make hammerspoon

# Check shell syntax
zsh -n ~/.zshrc

# Reload interactive settings
source ~/.zshrc
```

`make uninstall` removes general dotfile links that point to this repository. It preserves unrelated files, links, and the separately managed Hammerspoon configuration. The optional `script/*-clean-up.sh` scripts remove applications explicitly listed in those files; review them before running.
