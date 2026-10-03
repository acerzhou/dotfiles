# 🔧 dotfiles

> Personal development environment configuration for macOS

This repository contains my personal dotfiles and automated setup scripts to quickly configure a new machine with my preferred development environment.

## 💡 Philosophy

1. **Keyboard-first**: Minimize mouse usage with efficient keybindings
2. **Unified shortcuts**: Keep shortcuts consistent across applications
3. **Minimalist approach**: Only include essential and highly useful tools

## 📦 What's Included

- **Shell**: ZSH configuration with custom aliases and tools
- **Editor**: Vim configuration with sensible defaults
- **Terminal**: Tmux configuration for terminal multiplexing
- **Git**: Global Git config with useful aliases
- **iTerm2**: Custom iTerm2 configuration
- **Hammerspoon**: Window management and automation
- **Package Management**: Shared and profile-specific package manifests
- **Scripts**: Automated setup and cleanup scripts

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/acerzhou/dotfiles.git ~/Repos/dotfiles
cd ~/Repos/dotfiles

# Install the default packages
make install

# Link the default configuration
make config

# Set up Hammerspoon configuration separately
make hammerspoon
```

`make install` installs the canonical `brew/Brewfile`. Supplying `PROFILE=personal` installs that file first and then the small personal add-on manifest. `make config` always links the default dotfiles, sets ZSH as your default shell, and optionally creates an SSH key. `make hammerspoon` runs `hammerspoon/install.sh` separately.

Use `make profiles` to list package choices and `make install-plan PROFILE=personal` to preview the default packages plus personal additions. Running `./install.sh` without arguments installs only the default packages.

## 📁 Structure

```
dotfiles/
├── brew/              # Canonical default Homebrew manifest
├── git/               # Git configuration
│   ├── .gitconfig
│   └── .gitignore_global
├── hammerspoon/       # Hammerspoon automation
│   └── init.lua
├── iterm/             # iTerm2 configuration
├── profiles/          # Optional package additions
│   └── personal/
├── script/            # Focused package, configuration, and utility scripts
├── tmux/              # Tmux configuration
├── vim/               # Vim configuration
├── zsh/               # ZSH configuration
│   ├── .zshrc
│   ├── .zprofile
│   ├── .alias
│   └── .tools
└── install.sh         # Thin command dispatcher
```

## 🛠️ Tools & Applications

### GUI Applications

The default Brewfile installs the applications below. Personal installs inherit all of them before applying personal-only additions. Hammerspoon uses its own installer.

| Profile | macOS applications |
| --- | --- |
| `default` | Visual Studio Code, iTerm2, Docker, Firefox, Google Chrome |
| `personal` | Default applications plus personal additions (currently none) |

### Profiles

The root-level ZSH, Git, Tmux, Vim, and Hammerspoon files are the single default configuration. Machine-local files load last where supported.

The personal profile contains only a `Brewfile` with packages added after the default manifest. See [`profiles/README.md`](profiles/README.md) for the loading contract.

### Command Line Tools

Available tools and optional integrations include:

| Tool         | Description                           |
| ------------ | ------------------------------------- |
| **zsh**      | Shell with custom configuration          |
| **tmux**     | Terminal multiplexer                  |
| **vim**      | Text editor                           |
| **git**      | Version control                       |
| **gh**       | GitHub CLI                            |
| **htop**     | System monitoring                     |
| **fzf**      | Fuzzy finder                          |
| **autojump** | Quick directory navigation            |
| **jq**       | JSON processor                        |
| **yq**       | YAML processor                        |
| **bat**      | Better `cat` with syntax highlighting |

### Development Environments

Install language runtimes separately; shell integrations load when available.

- **Node.js** (via nvm)
- **Python**
- **Go**
- **Java** (via jenv)
- **Rust**
- **.NET Core**

## 📝 Customization

### ZSH Configuration

Edit [`zsh/.zshrc`](zsh/.zshrc) for tracked shell settings. Put machine-specific aliases and environment variables in `~/.zshrc.local`.

### Git Configuration

Keep secrets and machine-only identity in `~/.gitconfig.local`, which loads last:

```bash
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "your.email@example.com"
```

### Vim Configuration

Customize [`vim/.vimrc`](vim/.vimrc) for tracked settings and `~/.vimrc.local` for machine-specific overrides. Vim starts without optional plugins installed. To enable them, install [vim-plug](https://github.com/junegunn/vim-plug) and run `:PlugInstall` in Vim.

### Tmux Configuration

Modify [`tmux/.tmux.conf`](tmux/.tmux.conf) for tracked behavior and `~/.tmux.conf.local` for machine-specific overrides.

### Hammerspoon Configuration

Edit [`hammerspoon/init.lua`](hammerspoon/init.lua) for automation. See [hammerspoon/README.md](hammerspoon/README.md) for keybindings and features.

## 🔄 Updating

To update your dotfiles:

```bash
cd ~/Repos/dotfiles
git pull origin main

# Reapply the default configuration
make config

# Reapply Hammerspoon configuration independently
make hammerspoon
```

## 🗑️ Uninstallation

Installer backups and manual snapshots are stored in `~/.dotfiles-backups/<backup-name>/`. Automatic backups preserve replaced paths; `make backup` snapshots the current contents, including symlinked configuration.

```bash
make list-backups
make restore BACKUP=<backup-name>

# Remove this repository's symlinks
make uninstall
```

Restore creates a safety backup first and restores only paths present in the chosen backup. `make clean` keeps the five newest backups. Older backups created under `~/.dotfiles-backup-*` are left in place and can be restored manually.

## Verification

```bash
make test
make check
```

Tests use temporary home directories. `make check` reports every default dotfile link and exits with a nonzero status if any link is missing or incorrect. Hammerspoon remains independent from these commands.

## 🔗 Useful Resources

- [The Art of Command Line](https://github.com/jlevy/the-art-of-command-line)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
- [GNU Coreutils](https://www.gnu.org/software/coreutils/)

## 📄 License

Feel free to use and modify these dotfiles for your own setup.

---

**Note**: Remember to review and customize the configurations before using them, especially the Git config with your personal information.
