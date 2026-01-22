# Quick Setup Guide

## 🚀 New Machine Setup (5 minutes)

### 1. Clone Repository

```bash
# Create Repos directory if it doesn't exist
mkdir -p ~/Repos

# Clone dotfiles
git clone https://github.com/yourusername/dotfiles.git ~/Repos/dotfiles
cd ~/Repos/dotfiles
```

### 2. Run Installation

```bash
# Full installation (recommended for new machines)
make install

# Or run the script directly
./install.sh
```

The installer will:

- ✅ Backup your existing dotfiles
- ✅ Install Homebrew (macOS) or update apt (Linux)
- ✅ Install packages from Brewfile
- ✅ Create symlinks for all configurations
- ✅ Set ZSH as default shell

### 3. Customize Git Config

```bash
# Set your name and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 4. Restart Terminal

```bash
# Restart your terminal or reload ZSH
exec zsh
```

---

## 🔧 Individual Component Installation

### Install Only Symlinks (No Packages)

```bash
make install-links
# or
./symlink-manager.sh install
```

### Install Only Homebrew Packages

```bash
brew bundle --file=brew/Brewfile
```

### Check Symlink Status

```bash
make check
# or
./symlink-manager.sh check
```

---

## 📦 Recommended Additional Setup

### 1. Install Oh My Zsh (Optional but Recommended)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 2. Install Node.js via nvm

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Install latest LTS
nvm install --lts
nvm use --lts
```

### 3. Install Python via pyenv (Optional)

```bash
# macOS
brew install pyenv

# Install Python
pyenv install 3.11.0
pyenv global 3.11.0
```

### 4. Configure iTerm2 (macOS)

1. Open iTerm2
2. Go to Preferences → General → Preferences
3. Check "Load preferences from a custom folder"
4. Select `~/Repos/dotfiles/iterm`

---

## 🔄 Keeping Dotfiles Updated

### Pull Latest Changes

```bash
cd ~/Repos/dotfiles
make update

# Or manually
git pull origin main
./install.sh
```

### Backup Before Major Changes

```bash
make backup
# Your files will be backed up to ~/.dotfiles-backups/
```

---

## 🛠️ Customization

### Add Personal Aliases

Create `~/.zshrc.local` for personal customization (not tracked in git):

```bash
# ~/.zshrc.local
export MY_CUSTOM_VAR="value"
alias myalias='command'
```

### Add Personal Git Config

Use `~/.gitconfig.local` for machine-specific settings:

```bash
# ~/.gitconfig.local
[user]
    signingkey = YOUR_GPG_KEY
[commit]
    gpgsign = true
```

Then in your `.gitconfig`:

```ini
[include]
    path = ~/.gitconfig.local
```

---

## 📋 Common Commands

### Using Make

```bash
make help          # Show all available commands
make install       # Full installation
make check         # Check symlink status
make backup        # Create backup
make restore       # Restore from backup
make update        # Update dotfiles
make clean         # Clean old backups
```

### Using Scripts Directly

```bash
./install.sh                  # Install everything
./symlink-manager.sh check    # Check symlinks
./symlink-manager.sh install  # Install symlinks
./symlink-manager.sh uninstall # Remove symlinks
./backup.sh backup            # Create backup
./backup.sh list              # List backups
./backup.sh restore <date>    # Restore backup
./backup.sh cleanup           # Clean old backups
```

---

## 🐛 Troubleshooting

### Symlinks Not Working?

```bash
# Check what's wrong
./symlink-manager.sh check

# Force reinstall
./symlink-manager.sh uninstall
./symlink-manager.sh install
```

### ZSH Not Loading Properly?

```bash
# Check for syntax errors
zsh -n ~/.zshrc

# Reload configuration
source ~/.zshrc
```

### Permission Issues?

```bash
# Make scripts executable
make chmod
```

### Restore Original Files

```bash
# List available backups
./backup.sh list

# Restore from specific backup
./backup.sh restore 20260123-140530
```

---

## 📚 Learning Resources

- [The Art of Command Line](https://github.com/jlevy/the-art-of-command-line)
- [ZSH Documentation](https://zsh.sourceforge.io/Doc/)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
- [Git Aliases](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases)

---

## 🤝 Contributing

Found a useful alias or function? Add it to your fork and share!

1. Edit the appropriate file ([zsh/.alias](zsh/.alias) or [zsh/.tools](zsh/.tools))
2. Test your changes
3. Commit and push

---

## 💡 Tips

- Use `fzf` for fuzzy finding: `Ctrl+R` for history, `Ctrl+T` for files
- Use `autojump` with `j <directory>` to jump to frequently used directories
- Check out all Git aliases with: `git config --get-regexp alias`
- Use `tldr <command>` instead of `man <command>` for quick examples
