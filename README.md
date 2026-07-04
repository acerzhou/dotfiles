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
git clone https://github.com/yourusername/dotfiles.git ~/Repos/dotfiles
cd ~/Repos/dotfiles

# Make the install script executable
chmod +x install.sh

# Run the installation
./install.sh
```

The installation script will:

- ✅ Detect your operating system
- ✅ Backup existing dotfiles
- ✅ Create symbolic links to dotfiles
- ✅ Optionally install packages (Homebrew/apt)
- ✅ Set up ZSH, Vim, Tmux, and Git configurations
- ✅ Optionally create an SSH key with interactive email and passphrase prompts

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

| Function           | macOS             | Ubuntu          |
| ------------------ | ----------------- | --------------- |
| Package Manager    | Homebrew          | apt & snap      |
| Browser            | Firefox, Chrome   | Firefox, Chrome |
| Communication      | Slack             | Slack           |
| Email              | Mail              | Thunderbird     |
| Video Conferencing | Zoom              | Zoom            |
| Terminal           | iTerm2            | Terminal        |
| Notes              | Notion            | Notion          |
| Editor             | VS Code, Vim      | VS Code, Vim    |
| Containers         | Docker            | Docker          |
| Window Manager     | Yabai/Hammerspoon | i3wm            |
| Automation         | Hammerspoon       | -               |

### Command Line Tools

| Tool         | Description                           |
| ------------ | ------------------------------------- |
| **zsh**      | Default shell with Oh My Zsh          |
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
| **ffmpeg**   | Media processing                      |
| **tldr**     | Simplified man pages                  |

### Development Environments

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

Update [`git/.gitconfig`](git/.gitconfig) with your name and email:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Vim Configuration

Customize [`vim/.vimrc`](vim/.vimrc) for your preferred Vim settings.

### Tmux Configuration

Modify [`tmux/.tmux.conf`](tmux/.tmux.conf) for custom tmux keybindings and behavior.

### Hammerspoon Configuration (macOS)

Edit [`hammerspoon/init.lua`](hammerspoon/init.lua) to customize window management and automation. See [hammerspoon/README.md](hammerspoon/README.md) for keybindings and features.

## 🔄 Updating

To update your dotfiles:

```bash
cd ~/Repos/dotfiles
git pull origin main

# Re-run installation if needed
./install.sh
```

## 🗑️ Uninstallation

Your original dotfiles are backed up to `~/.dotfiles-backup-<timestamp>/`. To restore:

```bash
# Find your backup directory
ls -la ~ | grep dotfiles-backup

# Restore from backup
cp ~/.dotfiles-backup-YYYYMMDD-HHMMSS/.zshrc ~/
# ... restore other files as needed
```

## 🔗 Useful Resources

- [The Art of Command Line](https://github.com/jlevy/the-art-of-command-line)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
- [GNU Coreutils](https://www.gnu.org/software/coreutils/)

## 📄 License

Feel free to use and modify these dotfiles for your own setup.

---

**Note**: Remember to review and customize the configurations before using them, especially the Git config with your personal information.
