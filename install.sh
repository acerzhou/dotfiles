#!/usr/bin/env bash

#############################################################
# Dotfiles Installation Script
# 
# This script installs and configures dotfiles for macOS
# and Linux systems. It handles symlinking, backups, and
# initial setup.
#############################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Helper functions
info() {
    printf "${BLUE}==>${NC} %s\n" "$1"
}

success() {
    printf "${GREEN}✓${NC} %s\n" "$1"
}

warning() {
    printf "${YELLOW}!${NC} %s\n" "$1"
}

error() {
    printf "${RED}✗${NC} %s\n" "$1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    else
        error "Unsupported OS: $OSTYPE"
        exit 1
    fi
    success "Detected OS: $OS"
}

# Create backup directory if needed
create_backup_dir() {
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        success "Created backup directory: $BACKUP_DIR"
    fi
}

# Backup existing file
backup_file() {
    local file="$1"
    if [ -f "$file" ] || [ -d "$file" ]; then
        create_backup_dir
        mv "$file" "$BACKUP_DIR/"
        warning "Backed up existing file: $file"
    fi
}

# Create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Backup existing file/directory
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        backup_file "$target"
    elif [ -L "$target" ]; then
        rm "$target"
    fi
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Create symlink
    ln -sf "$source" "$target"
    success "Linked $source -> $target"
}

# Install Homebrew (macOS)
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        success "Homebrew installed"
    else
        success "Homebrew already installed"
    fi
}

# Install packages
install_packages() {
    if [ "$OS" == "macos" ]; then
        info "Installing packages via Homebrew..."
        if [ -f "$DOTFILES_DIR/brew/Brewfile" ]; then
            brew bundle --file="$DOTFILES_DIR/brew/Brewfile"
            success "Homebrew packages installed"
        fi
    elif [ "$OS" == "linux" ]; then
        info "Updating apt packages..."
        sudo apt update && sudo apt upgrade -y
        success "System updated"
    fi
}

# Setup ZSH
setup_zsh() {
    info "Setting up ZSH..."
    
    # Create .zsh directory
    mkdir -p "$HOME/.zsh"
    
    # Link ZSH files
    create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
    create_symlink "$DOTFILES_DIR/zsh/.alias" "$HOME/.zsh/.alias"
    create_symlink "$DOTFILES_DIR/zsh/.tools" "$HOME/.zsh/.tools"
    
    # Set ZSH as default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        info "Setting ZSH as default shell..."
        chsh -s "$(which zsh)"
        success "ZSH is now the default shell"
    fi
}

# Setup Vim
setup_vim() {
    info "Setting up Vim..."
    create_symlink "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
}

# Setup Tmux
setup_tmux() {
    info "Setting up Tmux..."
    create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
}

# Setup Git
setup_git() {
    info "Setting up Git..."
    if [ -f "$DOTFILES_DIR/git/.gitconfig" ]; then
        create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    fi
    if [ -f "$DOTFILES_DIR/git/.gitignore_global" ]; then
        create_symlink "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
    fi
}

# Setup iTerm2 (macOS only)
setup_iterm2() {
    if [ "$OS" == "macos" ] && [ -f "$DOTFILES_DIR/iterm/iterm2-config.json" ]; then
        info "Setting up iTerm2..."
        # iTerm2 preferences are typically loaded via Preferences -> Load preferences from folder
        info "iTerm2 config available at: $DOTFILES_DIR/iterm/iterm2-config.json"
        info "Load it manually from iTerm2 Preferences -> General -> Preferences"
    fi
}

# Setup Hammerspoon (macOS only)
setup_hammerspoon() {
    if [ "$OS" == "macos" ]; then
        info "Setting up Hammerspoon..."
        create_symlink "$DOTFILES_DIR/hammerspoon" "$HOME/.hammerspoon"
    fi
}

# Main installation
main() {
    echo ""
    info "Starting dotfiles installation..."
    echo ""
    
    detect_os
    
    # Ask for confirmation
    read -p "This will symlink dotfiles to your home directory. Continue? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        warning "Installation cancelled"
        exit 0
    fi
    
    # Install Homebrew on macOS
    if [ "$OS" == "macos" ]; then
        install_homebrew
    fi
    
    # Install packages
    read -p "Install packages? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_packages
    fi
    
    # Setup configurations
    setup_zsh
    setup_vim
    setup_tmux
    setup_git
    setup_iterm2
    setup_hammerspoon
    
    echo ""
    success "Dotfiles installation complete!"
    echo ""
    
    if [ -d "$BACKUP_DIR" ]; then
        info "Your old dotfiles have been backed up to: $BACKUP_DIR"
    fi
    
    info "Please restart your terminal or run: source ~/.zshrc"
    echo ""
}

# Run main function
main
