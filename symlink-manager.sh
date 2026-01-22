#!/usr/bin/env bash

#############################################################
# Symlink Manager
# 
# This script helps manage symlinks for dotfiles.
# Usage: ./symlink-manager.sh [install|uninstall|check]
#############################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

info() { printf "${BLUE}==>${NC} %s\n" "$1"; }
success() { printf "${GREEN}✓${NC} %s\n" "$1"; }
warning() { printf "${YELLOW}!${NC} %s\n" "$1"; }
error() { printf "${RED}✗${NC} %s\n" "$1"; }

# Define symlinks: source -> target
declare -A SYMLINKS=(
    ["$DOTFILES_DIR/zsh/.zshrc"]="$HOME/.zshrc"
    ["$DOTFILES_DIR/zsh/.zprofile"]="$HOME/.zprofile"
    ["$DOTFILES_DIR/zsh/.alias"]="$HOME/.zsh/.alias"
    ["$DOTFILES_DIR/zsh/.tools"]="$HOME/.zsh/.tools"
    ["$DOTFILES_DIR/vim/.vimrc"]="$HOME/.vimrc"
    ["$DOTFILES_DIR/tmux/.tmux.conf"]="$HOME/.tmux.conf"
    ["$DOTFILES_DIR/git/.gitconfig"]="$HOME/.gitconfig"
    ["$DOTFILES_DIR/git/.gitignore_global"]="$HOME/.gitignore_global"
    ["$DOTFILES_DIR/hammerspoon"]="$HOME/.hammerspoon"
)

# Check symlink status
check_symlink() {
    local source="$1"
    local target="$2"
    
    if [ ! -e "$source" ]; then
        error "Source does not exist: $source"
        return 1
    fi
    
    if [ -L "$target" ]; then
        local link_target=$(readlink "$target")
        if [ "$link_target" = "$source" ]; then
            success "$target -> $source (OK)"
            return 0
        else
            warning "$target -> $link_target (points to wrong location)"
            return 2
        fi
    elif [ -e "$target" ]; then
        warning "$target exists but is not a symlink"
        return 3
    else
        info "$target does not exist"
        return 4
    fi
}

# Install symlinks
install_symlinks() {
    info "Installing symlinks..."
    echo ""
    
    for source in "${!SYMLINKS[@]}"; do
        target="${SYMLINKS[$source]}"
        
        # Create parent directory if needed
        mkdir -p "$(dirname "$target")"
        
        # Remove existing symlink or file
        if [ -L "$target" ]; then
            rm "$target"
        elif [ -e "$target" ]; then
            warning "File exists: $target"
            read -p "Backup and replace? (y/n) " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mv "$target" "${target}.backup"
                success "Backed up to ${target}.backup"
            else
                warning "Skipping $target"
                continue
            fi
        fi
        
        # Create symlink
        ln -sf "$source" "$target"
        success "Linked: $target -> $source"
    done
    
    echo ""
    success "All symlinks installed!"
}

# Uninstall symlinks
uninstall_symlinks() {
    info "Uninstalling symlinks..."
    echo ""
    
    for source in "${!SYMLINKS[@]}"; do
        target="${SYMLINKS[$source]}"
        
        if [ -L "$target" ]; then
            local link_target=$(readlink "$target")
            if [ "$link_target" = "$source" ]; then
                rm "$target"
                success "Removed: $target"
            else
                warning "Skipping $target (points to different location)"
            fi
        else
            info "$target is not a symlink (skipping)"
        fi
    done
    
    echo ""
    success "Symlinks removed!"
}

# Check all symlinks
check_all_symlinks() {
    info "Checking symlink status..."
    echo ""
    
    local total=0
    local ok=0
    local broken=0
    local missing=0
    
    for source in "${!SYMLINKS[@]}"; do
        target="${SYMLINKS[$source]}"
        check_symlink "$source" "$target"
        status=$?
        
        total=$((total + 1))
        case $status in
            0) ok=$((ok + 1)) ;;
            1|2|3) broken=$((broken + 1)) ;;
            4) missing=$((missing + 1)) ;;
        esac
    done
    
    echo ""
    info "Summary: $ok OK, $broken broken, $missing missing (total: $total)"
}

# Main
case "${1:-check}" in
    install)
        install_symlinks
        ;;
    uninstall)
        uninstall_symlinks
        ;;
    check)
        check_all_symlinks
        ;;
    *)
        echo "Usage: $0 [install|uninstall|check]"
        echo ""
        echo "Commands:"
        echo "  install   - Create symlinks for all dotfiles"
        echo "  uninstall - Remove symlinks"
        echo "  check     - Check status of symlinks (default)"
        exit 1
        ;;
esac
