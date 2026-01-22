# Changelog

## 2026-01-23 - Major Repository Improvements

### 🎉 New Features

#### Installation & Management

- **[install.sh](install.sh)** - Comprehensive installation script with:
  - OS detection (macOS/Linux)
  - Automatic backup of existing dotfiles
  - Interactive installation prompts
  - Package installation support
  - Symlink creation and management

- **[symlink-manager.sh](symlink-manager.sh)** - Dedicated symlink management:
  - Install/uninstall symlinks independently
  - Check symlink status
  - Safe backup before replacing files

- **[backup.sh](backup.sh)** - Backup and restore functionality:
  - Create timestamped backups
  - Restore from any backup
  - List all available backups
  - Cleanup old backups (keep 5 most recent)

- **[Makefile](Makefile)** - Simple command interface:
  - `make install` - Full installation
  - `make check` - Check status
  - `make backup` - Create backup
  - `make update` - Update dotfiles

#### Git Configuration

- **[git/.gitconfig](git/.gitconfig)** - Comprehensive Git configuration with:
  - Color-coded output
  - Useful aliases (50+ shortcuts)
  - Better diff and merge settings
  - Automatic corrections

- **[git/.gitignore_global](git/.gitignore_global)** - Global ignore patterns for:
  - OS-specific files (macOS, Windows, Linux)
  - Editor files (.vscode, .idea, etc.)
  - Build outputs and dependencies

### ✨ Enhancements

#### ZSH Configuration

- **[zsh/.zshrc](zsh/.zshrc)** - Improved with:
  - Better organization and comments
  - Enhanced prompt with Git branch display
  - Support for fzf, autojump, and other tools
  - Proper version manager integration (nvm, jenv, pyenv)
  - Conditional loading based on tool availability

- **[zsh/.alias](zsh/.alias)** - Expanded aliases:
  - Navigation shortcuts
  - Enhanced ls variants
  - Git workflow aliases (50+ commands)
  - Docker shortcuts
  - Safety nets (rm, cp, mv with -i)
  - Network and system monitoring

- **[zsh/.tools](zsh/.tools)** - New utility functions:
  - Weather information
  - IP address lookup
  - UUID generation
  - File extraction (supports 10+ formats)
  - Process management
  - Development utilities
  - macOS-specific helpers

#### Documentation

- **[README.md](README.md)** - Complete rewrite with:
  - Clear installation instructions
  - Visual structure diagram
  - Comprehensive tool listings
  - Customization guide
  - Troubleshooting tips

#### Other Improvements

- **[brew/Brewfile](brew/Brewfile)** - Better organized with:
  - Categorized packages
  - Comments for optional tools
  - Essential development tools

- **[.editorconfig](.editorconfig)** - Added for consistent coding style across editors

### 📝 File Structure

```
dotfiles/
├── README.md              ← Improved documentation
├── Makefile              ← NEW: Quick commands
├── install.sh            ← NEW: Main installer
├── symlink-manager.sh    ← NEW: Link management
├── backup.sh             ← NEW: Backup/restore
├── .editorconfig         ← NEW: Editor config
├── brew/
│   └── Brewfile          ← Enhanced
├── git/                  ← NEW: Git configs
│   ├── .gitconfig
│   └── .gitignore_global
├── iterm/
│   └── iterm2-config.json
├── script/
│   ├── cheatsheet.sh
│   ├── i3.sh
│   ├── mac-clean-up.sh
│   ├── mac-set-up.sh
│   ├── ubuntu-clean-up.sh
│   └── ubuntu-set-up.sh
├── tmux/
│   └── .tmux.conf
├── vim/
│   └── .vimrc
└── zsh/                  ← All enhanced
    ├── .alias
    ├── .tools
    ├── .zprofile
    ├── .zshrc
    ├── README.md
    └── set-up.sh
```

### 🔧 Usage

```bash
# Quick start
git clone <repo> ~/Repos/dotfiles
cd ~/Repos/dotfiles
make install

# Or use individual commands
./install.sh          # Full installation
./backup.sh backup    # Backup current config
./symlink-manager.sh check  # Check status
```

### 🎯 Benefits

1. **Safer**: Automatic backups before any changes
2. **Organized**: Clear separation of concerns
3. **Documented**: Extensive comments and README
4. **Flexible**: Install everything or just what you need
5. **Maintainable**: Easy to add/remove components
6. **Cross-platform**: Works on macOS and Linux
