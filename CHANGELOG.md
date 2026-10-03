# Changelog

## 2026-10-03 - Repository Cleanup

- Added layered `general`, `personal`, and `work` profiles for packages plus ZSH, Git, Tmux, Vim, and Hammerspoon overrides.
- Added `make switch PROFILE=<name>` and `make profile`; the active profile is selected through `~/.config/dotfiles/profile`.
- Fixed backup restore for hidden files, partial installer backups, and empty homes.
- Added unique backup names, consistent backup storage, and portable retention of the newest five backups.
- Made symlink management compatible with macOS Bash 3.2, idempotent, and independent of Hammerspoon installation.
- Consolidated general symlink setup and retained legacy setup commands as wrappers.
- Focused installation on macOS, removed apt and Linux-only scripts, and made newly installed Homebrew available to the current process.
- Removed obsolete Homebrew taps and corrected optional application and iTerm2 setup documentation.
- Consolidated shell startup, removed conflicting aliases, and moved Git identity into local configuration.
- Guarded optional Vim plugins and created persistent undo and swap directories.
- Retained Hammerspoon timer and watcher references and corrected text expansion deletion counts.
- Added isolated backup, restore, link, and installer regression tests through `make test`.
- Fixed `make config` selecting an unregistered Homebrew ZSH for `chsh`; it now keeps an existing ZSH default or selects an executable entry from `/etc/shells`.

## 2026-10-03 - Separate Installation and Configuration

- `make install` installs packages only.
- `make config` applies general dotfile configuration without installing packages.
- `make hammerspoon` runs the standalone `hammerspoon/install.sh` to install and configure Hammerspoon independently on macOS, backing up existing configuration.
- `install.sh` supports matching subcommands and defaults to package installation.
- `make update` pulls changes and reapplies general configuration.
- Removed the Hammerspoon weather menubar module and its documentation.


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
