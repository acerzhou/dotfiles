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

# Install shared packages and one profile
make install

# Link the shared configuration and activate the default profile
make config

# Set up Hammerspoon configuration separately
make hammerspoon
```

`make install` uses the `default` profile unless `PROFILE` is supplied. Every profile combines shared packages with its own applications. `make config PROFILE=<name>` links the shared dotfiles, activates that profile's configuration overlays, sets ZSH as your default shell, and optionally creates an SSH key. `make hammerspoon` runs `hammerspoon/install.sh` to install the app via Homebrew if needed and link its configuration to `~/.hammerspoon`, backing up any existing configuration. Homebrew is required if the app is not already installed.

Use `make profiles` to list profiles, `make install-plan PROFILE=personal` to preview packages, and `make switch PROFILE=personal` to change configuration without reinstalling or relinking anything. `make profile` prints the active profile. Running `./install.sh` without arguments installs the `default` profile.

## 📁 Structure

```
dotfiles/
├── brew/              # Shared Homebrew packages and compatibility Brewfile
├── git/               # Git configuration
│   ├── .gitconfig
│   └── .gitignore_global
├── hammerspoon/       # Hammerspoon automation
│   └── init.lua
├── iterm/             # iTerm2 configuration
├── profiles/          # Packages and configuration overlays by situation
│   ├── default/
│   └── personal/
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

The profile Brewfiles install the applications below. Hammerspoon uses its own installer.

| Profile | macOS applications |
| --- | --- |
| `default` | Visual Studio Code, iTerm2, Docker, Firefox, Google Chrome |
| `personal` | Visual Studio Code, iTerm2, Firefox |

### Profiles

The root-level ZSH, Git, Tmux, Vim, and Hammerspoon files form the shared base. The selected directory under `profiles/` loads afterward, and untracked machine-local files load last.

Each profile can contain `Brewfile`, `zsh.zsh`, `gitconfig`, `tmux.conf`, `vimrc`, and `hammerspoon/init.lua`. See [`profiles/README.md`](profiles/README.md) for the loading contract. Installing a different profile adds packages without removing previously installed applications.

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

Edit [`zsh/.zshrc`](zsh/.zshrc) for shared shell settings. Put situation-specific aliases and environment variables in `profiles/<name>/zsh.zsh`.

### Git Configuration

Store identity shared only by one situation in `profiles/<name>/gitconfig`. Keep secrets and machine-only identity in `~/.gitconfig.local`, which loads last:

```bash
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "your.email@example.com"
```

### Vim Configuration

Customize [`vim/.vimrc`](vim/.vimrc) for shared settings and `profiles/<name>/vimrc` for an overlay. Vim starts without optional plugins installed. To enable them, install [vim-plug](https://github.com/junegunn/vim-plug) and run `:PlugInstall` in Vim.

### Tmux Configuration

Modify [`tmux/.tmux.conf`](tmux/.tmux.conf) for shared behavior and `profiles/<name>/tmux.conf` for profile-specific overrides.

### Hammerspoon Configuration

Edit [`hammerspoon/init.lua`](hammerspoon/init.lua) for shared automation and `profiles/<name>/hammerspoon/init.lua` for profile-specific shortcuts. See [hammerspoon/README.md](hammerspoon/README.md) for keybindings and features.

## 🔄 Updating

To update your dotfiles:

```bash
cd ~/Repos/dotfiles
git pull origin main

# Reapply configuration using the desired profile
make config PROFILE=personal

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

Tests use temporary home directories. `make check` reports every shared dotfile link and exits with a nonzero status if any link is missing or incorrect. Hammerspoon remains independent from these commands.

## 🔗 Useful Resources

- [The Art of Command Line](https://github.com/jlevy/the-art-of-command-line)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
- [GNU Coreutils](https://www.gnu.org/software/coreutils/)

## 📄 License

Feel free to use and modify these dotfiles for your own setup.

---

**Note**: Remember to review and customize the configurations before using them, especially the Git config with your personal information.
