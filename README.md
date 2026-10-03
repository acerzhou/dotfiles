# 🔧 dotfiles

> Personal development environment configuration for macOS and Linux (Ubuntu)

This repository contains my personal dotfiles and automated setup scripts to quickly configure a new machine with my preferred development environment.

## 💡 Philosophy

1. **Cross-platform**: Works on both macOS and Linux (Ubuntu)
2. **Keyboard-first**: Minimize mouse usage with efficient keybindings
3. **Unified shortcuts**: Consistent experience across all environments
4. **Minimalist approach**: Only include essential and highly useful tools

## 📦 What's Included

- **Shell**: ZSH configuration with custom aliases and tools
- **Editor**: Vim configuration with sensible defaults
- **Terminal**: Tmux configuration for terminal multiplexing
- **Git**: Global Git config with useful aliases
- **iTerm2**: Custom iTerm2 configuration (macOS)
- **Hammerspoon**: Window management and automation (macOS)
- **Package Management**: Brewfile for macOS dependencies
- **Scripts**: Automated setup and cleanup scripts

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/acerzhou/dotfiles.git ~/Repos/dotfiles
cd ~/Repos/dotfiles

# Install packages
make install

# Configure ZSH, Vim, Tmux, Git, SSH, and iTerm2
make config

# Set up Hammerspoon configuration separately (macOS)
make hammerspoon
```

`make install` installs Homebrew and Brewfile packages on macOS, or installs core command-line tools via apt on Ubuntu. `make config` backs up existing dotfiles, creates general configuration symlinks, sets ZSH as your default shell, and optionally creates an SSH key. `make hammerspoon` runs `hammerspoon/install.sh` to install the app via Homebrew if needed and link its configuration to `~/.hammerspoon`, backing up any existing configuration. Homebrew is required if the app is not already installed.

You can also run `./install.sh install`, `./install.sh config`, or `./install.sh hammerspoon` directly. Running `./install.sh` without arguments installs packages only.

## 📁 Structure

```
dotfiles/
├── brew/              # Homebrew bundle file
├── git/               # Git configuration
│   ├── .gitconfig
│   └── .gitignore_global
├── hammerspoon/       # Hammerspoon automation (macOS)
│   └── init.lua
├── iterm/             # iTerm2 configuration
├── script/            # Setup and maintenance scripts
├── tmux/              # Tmux configuration
├── vim/               # Vim configuration
├── zsh/               # ZSH configuration
│   ├── .zshrc
│   ├── .zprofile
│   ├── .alias
│   └── .tools
└── install.sh         # Main installation script
```

## 🛠️ Tools & Applications

### GUI Applications

The macOS Brewfile installs the applications below. Hammerspoon uses its own installer. The Ubuntu installer installs command-line tools only.

| Purpose | macOS application |
| --- | --- |
| Browsers | Firefox, Google Chrome |
| Terminal | iTerm2 |
| Editor | Visual Studio Code |
| Containers | Docker |
| Automation | Hammerspoon (separate command) |

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

Edit [`zsh/.zshrc`](zsh/.zshrc) for shell settings and [`zsh/.alias`](zsh/.alias) for custom aliases.

### Git Configuration

Store your name and email in `~/.gitconfig.local`, which the shared Git configuration includes automatically:

```bash
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "your.email@example.com"
```

### Vim Configuration

Customize [`vim/.vimrc`](vim/.vimrc) for your preferred Vim settings. Vim starts without optional plugins installed. To enable them, install [vim-plug](https://github.com/junegunn/vim-plug) and run `:PlugInstall` in Vim.

### Tmux Configuration

Modify [`tmux/.tmux.conf`](tmux/.tmux.conf) for custom tmux keybindings and behavior.

### Hammerspoon Configuration (macOS)

Edit [`hammerspoon/init.lua`](hammerspoon/init.lua) to customize window management and automation. See [hammerspoon/README.md](hammerspoon/README.md) for keybindings and features.

## 🔄 Updating

To update your dotfiles:

```bash
cd ~/Repos/dotfiles
git pull origin main

# Reapply general configuration if needed
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

Tests use temporary home directories. `make check` reports every general dotfile link and exits with a nonzero status if any link is missing or incorrect. Hammerspoon remains independent from these commands.

## 🔗 Useful Resources

- [The Art of Command Line](https://github.com/jlevy/the-art-of-command-line)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
- [GNU Coreutils](https://www.gnu.org/software/coreutils/)

## 📄 License

Feel free to use and modify these dotfiles for your own setup.

---

**Note**: Remember to review and customize the configurations before using them, especially the Git config with your personal information.
