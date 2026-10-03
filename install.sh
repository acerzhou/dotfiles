#!/usr/bin/env bash

#############################################################
# Dotfiles Installation Script
# 
# Package installation, profile-aware dotfile configuration,
# and Hammerspoon setup for macOS.
# Usage: ./install.sh install [--profile NAME] [--dry-run]
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
INSTALL_PROFILE="${PROFILE:-default}"
DRY_RUN=false

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

# Enforce the supported platform before changing the machine.
require_macos() {
    if [[ "${OSTYPE:-}" != darwin* ]]; then
        error "This dotfiles setup requires macOS"
        return 1
    fi
    success "Detected macOS"
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

# Validate manifests before any package-manager changes.
validate_profile() {
    if [[ ! "$INSTALL_PROFILE" =~ ^[a-zA-Z0-9][a-zA-Z0-9_-]*$ ]]; then
        error "Invalid profile name: $INSTALL_PROFILE"
        return 1
    fi
    PROFILE_DIR="$DOTFILES_DIR/profiles/$INSTALL_PROFILE"
    if [ ! -f "$PROFILE_DIR/Brewfile" ]; then
        error "Unknown or incomplete profile: $INSTALL_PROFILE. Run make profiles."
        return 1
    fi
    if [ ! -f "$DOTFILES_DIR/brew/Brewfile.common" ]; then
        error "Shared Brewfile is missing"
        return 1
    fi
}

list_profiles() {
    local directory
    echo "Available profiles (default: default):"
    for directory in "$DOTFILES_DIR"/profiles/*; do
        if [ -f "$directory/Brewfile" ]; then
            printf '  %s\n' "${directory##*/}"
        fi
    done
}

activate_profile() {
    local profile_link="$HOME/.config/dotfiles/profile"
    local current_target=""

    validate_profile
    mkdir -p "$(dirname "$profile_link")"
    if [ -L "$profile_link" ]; then
        current_target="$(readlink "$profile_link")"
        if [ "$current_target" = "$PROFILE_DIR" ]; then
            success "Profile already active: $INSTALL_PROFILE"
            return 0
        fi
        rm "$profile_link"
    elif [ -e "$profile_link" ]; then
        error "Cannot activate profile: $profile_link exists and is not a symlink"
        return 1
    fi

    ln -s "$PROFILE_DIR" "$profile_link"
    success "Active profile: $INSTALL_PROFILE"
}

show_active_profile() {
    local profile_link="$HOME/.config/dotfiles/profile"
    local target
    if [ ! -L "$profile_link" ]; then
        echo "No active configuration profile"
        return 0
    fi
    target="$(readlink "$profile_link")"
    case "$target" in
        "$DOTFILES_DIR"/profiles/*)
            printf '%s\n' "${target##*/}"
            ;;
        *)
            printf 'External profile: %s\n' "$target"
            ;;
    esac
}

# Install shared packages plus the selected profile.
install_packages() {
    info "Installing packages via Homebrew..."
    brew bundle --file="$DOTFILES_DIR/brew/Brewfile.common"
    brew bundle --file="$PROFILE_DIR/Brewfile"
    success "Homebrew packages installed"
}

# Setup ZSH
setup_zsh() {
    info "Setting up ZSH..."

    if [ "${SHELL##*/}" = "zsh" ]; then
        success "ZSH is already the default shell (${SHELL})"
        return 0
    fi

    local preferred_zsh zsh_path="" shell_entry
    preferred_zsh="$(command -v zsh)" || {
        error "ZSH is not installed. Run make install first."
        return 1
    }

    # macOS chsh only accepts entries from /etc/shells. Homebrew's ZSH may
    # appear first in PATH even when the registered /bin/zsh is preferable.
    if [ -r /etc/shells ]; then
        while IFS= read -r shell_entry; do
            case "$shell_entry" in
                ""|\#*) continue ;;
                */zsh)
                    if [ -x "$shell_entry" ] && [ -z "$zsh_path" ]; then
                        zsh_path="$shell_entry"
                    fi
                    if [ "$shell_entry" = "$preferred_zsh" ]; then
                        zsh_path="$preferred_zsh"
                        break
                    fi
                    ;;
            esac
        done < /etc/shells
    else
        zsh_path="$preferred_zsh"
    fi

    if [ -z "$zsh_path" ]; then
        error "No executable ZSH entry was found in /etc/shells"
        return 1
    fi
    if [ "$zsh_path" != "$preferred_zsh" ]; then
        warning "$preferred_zsh is not a registered login shell; using $zsh_path"
    fi

    info "Setting ZSH as default shell..."
    chsh -s "$zsh_path"
    success "ZSH is now the default shell ($zsh_path)"
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

# Setup iTerm2
setup_iterm2() {
    if [ -f "$DOTFILES_DIR/iterm/iterm2-config.json" ]; then
        info "Setting up iTerm2..."
        # This JSON file is a profile export, rather than a preferences folder.
        info "iTerm2 config available at: $DOTFILES_DIR/iterm/iterm2-config.json"
        info "Import it from iTerm2 Settings -> Profiles -> Other Actions -> Import JSON Profiles"
    fi
}

# Configure shared dotfiles
configure_dotfiles() {
    read -r -p "This will symlink dotfiles to your home directory. Continue? (y/n) " -n 1
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        warning "Configuration cancelled"
        return 0
    fi

    activate_profile
    bash "$DOTFILES_DIR/symlink-manager.sh" install
    setup_zsh
    setup_ssh_key
    setup_iterm2

    success "Dotfiles configuration complete (profile: $INSTALL_PROFILE)!"
    info "Please restart your terminal or run: source ~/.zshrc"
}

usage() {
    echo "Usage: $0 install [--profile NAME] [--dry-run]"
    echo "       $0 config|switch [--profile NAME]"
    echo "       $0 [profile|hammerspoon|profiles|help]"
    echo "  install     Install shared and profile packages (default: default)"
    echo "  --profile   Select a package/config profile (default: PROFILE environment variable or default)"
    echo "  --dry-run   Show package manifests without installing anything"
    echo "  profiles    List available profiles"
    echo "  config      Configure shared dotfiles and activate a profile"
    echo "  switch      Change the active profile without relinking"
    echo "  profile     Show the active configuration profile"
    echo "  hammerspoon Install and configure Hammerspoon"
}

main() {
    local command="${1:-install}"
    if [ "$#" -gt 0 ]; then shift; fi
    case "$command" in
        help|-h|--help)
            usage
            return 0
            ;;
        install|config|switch|profile|hammerspoon|profiles) ;;
        *)
            usage
            return 1
            ;;
    esac

    while [ "$#" -gt 0 ]; do
        case "$1" in
            --profile)
                if { [ "$command" != install ] && [ "$command" != config ] && [ "$command" != switch ]; } || [ "$#" -lt 2 ] || [ -z "$2" ]; then
                    error "--profile requires a name and install, config, or switch"
                    return 1
                fi
                INSTALL_PROFILE="$2"
                shift 2
                ;;
            --dry-run)
                if [ "$command" != install ]; then
                    error "--dry-run is only supported for install"
                    return 1
                fi
                DRY_RUN=true
                shift
                ;;
            *) error "Unknown argument: $1"; usage; return 1 ;;
        esac
    done

    if [ "$command" = profiles ]; then
        list_profiles
        return 0
    fi
    if [ "$command" = profile ]; then
        show_active_profile
        return 0
    fi
    if [ "$command" = install ] || [ "$command" = config ] || [ "$command" = switch ]; then
        validate_profile
    fi

    require_macos

    if [ "$command" = switch ]; then
        activate_profile
        info "Run 'exec zsh' and reload Tmux, Vim, and Hammerspoon sessions as needed"
        return 0
    fi

    case "$command" in
        install)
            info "Install profile: $INSTALL_PROFILE"
            if [ "$DRY_RUN" = true ]; then
                info "Shared packages: brew/Brewfile.common"
                cat "$DOTFILES_DIR/brew/Brewfile.common"
                info "Profile packages: profiles/$INSTALL_PROFILE/Brewfile"
                cat "$PROFILE_DIR/Brewfile"
                return 0
            fi
            install_homebrew
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
