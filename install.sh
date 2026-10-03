#!/usr/bin/env bash

#############################################################
# Dotfiles Installation Script
# 
# Separate package installation, dotfile configuration,
# and Hammerspoon setup for macOS and Linux systems.
# Usage: ./install.sh [install|config|hammerspoon|help]
#############################################################

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
    if [[ "${OSTYPE:-}" == "darwin"* ]]; then
        OS="macos"
    elif [[ "${OSTYPE:-}" == "linux-gnu"* ]]; then
        OS="linux"
    else
        error "Unsupported OS: ${OSTYPE:-unknown}"
        exit 1
    fi
    success "Detected OS: $OS"
}

# Install Homebrew (macOS)
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        info "Installing Homebrew..."
        local installer
        installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        /bin/bash -c "$installer"
        success "Homebrew installed"
    else
        success "Homebrew already installed"
    fi
    # Make newly installed Homebrew available in this process.
    if ! command -v brew >/dev/null 2>&1; then
        if [ -x /opt/homebrew/bin/brew ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -x /usr/local/bin/brew ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        else
            error "Homebrew is not available after installation"
            return 1
        fi
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
        if ! command -v apt >/dev/null 2>&1; then
            error "This Linux installer requires apt (Ubuntu or Debian)"
            return 1
        fi
        info "Installing core command-line tools via apt..."
        sudo apt update
        sudo apt install -y zsh vim tmux git curl ripgrep fzf autojump jq tree wget htop shellcheck python3
        success "Core command-line tools installed"
    fi
}

# Setup ZSH
setup_zsh() {
    info "Setting up ZSH..."
    
    # Set ZSH as default shell
    local zsh_path
    zsh_path="$(command -v zsh)" || { error "ZSH is not installed. Run make install first."; return 1; }
    if [ "${SHELL:-}" != "$zsh_path" ]; then
        info "Setting ZSH as default shell..."
        chsh -s "$zsh_path"
        success "ZSH is now the default shell"
    fi
}

# Setup SSH key
setup_ssh_key() {
    local ssh_key_script="$DOTFILES_DIR/script/create-ssh-key.sh"

    if [ ! -f "$ssh_key_script" ]; then
        warning "SSH key setup script not found: $ssh_key_script"
        return 0
    fi

    read -r -p "Create an SSH key now? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bash "$ssh_key_script"
    else
        info "Skipping SSH key setup"
    fi
}

# Setup iTerm2 (macOS only)
setup_iterm2() {
    if [ "$OS" == "macos" ] && [ -f "$DOTFILES_DIR/iterm/iterm2-config.json" ]; then
        info "Setting up iTerm2..."
        # This JSON file is a profile export, rather than a preferences folder.
        info "iTerm2 config available at: $DOTFILES_DIR/iterm/iterm2-config.json"
        info "Import it from iTerm2 Settings -> Profiles -> Other Actions -> Import JSON Profiles"
    fi
}

# Configure general dotfiles
configure_dotfiles() {
    read -r -p "This will symlink dotfiles to your home directory. Continue? (y/n) " -n 1
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        warning "Configuration cancelled"
        return 0
    fi

    bash "$DOTFILES_DIR/symlink-manager.sh" install
    setup_zsh
    setup_ssh_key
    setup_iterm2

    success "Dotfiles configuration complete!"
    info "Please restart your terminal or run: source ~/.zshrc"
}

usage() {
    echo "Usage: $0 [install|config|hammerspoon|help]"
    echo "  install     Install packages (default)"
    echo "  config      Configure ZSH, Vim, Tmux, Git, SSH, and iTerm2"
    echo "  hammerspoon Install and configure Hammerspoon (macOS only)"
}

main() {
    local command="${1:-install}"
    case "$command" in
        help|-h|--help)
            usage
            return 0
            ;;
        install|config|hammerspoon) ;;
        *)
            usage
            return 1
            ;;
    esac

    detect_os
    case "$command" in
        install)
            if [ "$OS" == "macos" ]; then
                install_homebrew
            fi
            install_packages
            success "Package installation complete!"
            ;;
        config)
            configure_dotfiles
            ;;
        hammerspoon)
            bash "$DOTFILES_DIR/hammerspoon/install.sh"
            ;;
    esac
}

main "$@"
