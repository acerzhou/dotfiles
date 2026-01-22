#!/usr/bin/env bash

#############################################################
# Backup & Restore Script
# 
# Backup or restore your dotfiles
# Usage: ./backup.sh [backup|restore|list]
#############################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_BASE_DIR="$HOME/.dotfiles-backups"

info() { printf "${BLUE}==>${NC} %s\n" "$1"; }
success() { printf "${GREEN}✓${NC} %s\n" "$1"; }
warning() { printf "${YELLOW}!${NC} %s\n" "$1"; }
error() { printf "${RED}✗${NC} %s\n" "$1"; }

# Files to backup
FILES_TO_BACKUP=(
    "$HOME/.zshrc"
    "$HOME/.zprofile"
    "$HOME/.zsh"
    "$HOME/.vimrc"
    "$HOME/.tmux.conf"
    "$HOME/.gitconfig"
    "$HOME/.gitignore_global"
    "$HOME/.hammerspoon"
)

# Create backup
create_backup() {
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local backup_dir="$BACKUP_BASE_DIR/$timestamp"
    
    info "Creating backup at: $backup_dir"
    mkdir -p "$backup_dir"
    
    local backed_up=0
    
    for file in "${FILES_TO_BACKUP[@]}"; do
        if [ -e "$file" ]; then
            local filename=$(basename "$file")
            cp -r "$file" "$backup_dir/$filename"
            success "Backed up: $file"
            backed_up=$((backed_up + 1))
        fi
    done
    
    if [ $backed_up -eq 0 ]; then
        warning "No files found to backup"
        rmdir "$backup_dir"
        return 1
    fi
    
    echo ""
    success "Backup created: $backup_dir"
    success "Backed up $backed_up files"
    echo ""
    echo "To restore this backup later, run:"
    echo "  ./backup.sh restore $timestamp"
}

# List backups
list_backups() {
    if [ ! -d "$BACKUP_BASE_DIR" ]; then
        warning "No backups found"
        return 1
    fi
    
    info "Available backups:"
    echo ""
    
    local count=0
    for backup in "$BACKUP_BASE_DIR"/*; do
        if [ -d "$backup" ]; then
            local name=$(basename "$backup")
            local size=$(du -sh "$backup" | cut -f1)
            printf "  %s (%s)\n" "$name" "$size"
            count=$((count + 1))
        fi
    done
    
    if [ $count -eq 0 ]; then
        warning "No backups found"
        return 1
    fi
    
    echo ""
    info "Total backups: $count"
}

# Restore backup
restore_backup() {
    local timestamp="$1"
    
    if [ -z "$timestamp" ]; then
        error "Please specify a backup timestamp"
        echo "Available backups:"
        list_backups
        return 1
    fi
    
    local backup_dir="$BACKUP_BASE_DIR/$timestamp"
    
    if [ ! -d "$backup_dir" ]; then
        error "Backup not found: $backup_dir"
        echo ""
        list_backups
        return 1
    fi
    
    info "Restoring from: $backup_dir"
    echo ""
    
    warning "This will overwrite your current dotfiles!"
    read -p "Continue? (y/n) " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        warning "Restore cancelled"
        return 0
    fi
    
    # Create a safety backup before restoring
    info "Creating safety backup before restore..."
    create_backup
    
    local restored=0
    
    for file in "$backup_dir"/*; do
        if [ -e "$file" ]; then
            local filename=$(basename "$file")
            local target="$HOME/$filename"
            
            # Remove existing file/symlink
            if [ -e "$target" ] || [ -L "$target" ]; then
                rm -rf "$target"
            fi
            
            # Restore from backup
            cp -r "$file" "$target"
            success "Restored: $target"
            restored=$((restored + 1))
        fi
    done
    
    echo ""
    success "Restored $restored files from backup"
    info "Please restart your shell or run: source ~/.zshrc"
}

# Delete old backups
cleanup_backups() {
    local keep=5
    
    if [ ! -d "$BACKUP_BASE_DIR" ]; then
        info "No backups to clean"
        return 0
    fi
    
    local total=$(find "$BACKUP_BASE_DIR" -maxdepth 1 -type d | tail -n +2 | wc -l)
    
    if [ "$total" -le "$keep" ]; then
        info "Only $total backups found, keeping all"
        return 0
    fi
    
    info "Found $total backups, keeping $keep most recent"
    
    # Delete oldest backups
    find "$BACKUP_BASE_DIR" -maxdepth 1 -type d | tail -n +2 | sort | head -n -"$keep" | while read dir; do
        local name=$(basename "$dir")
        rm -rf "$dir"
        info "Deleted old backup: $name"
    done
    
    success "Cleanup complete"
}

# Main
case "${1:-list}" in
    backup)
        create_backup
        ;;
    restore)
        restore_backup "$2"
        ;;
    list)
        list_backups
        ;;
    cleanup)
        cleanup_backups
        ;;
    *)
        echo "Usage: $0 [backup|restore|list|cleanup]"
        echo ""
        echo "Commands:"
        echo "  backup         - Create a new backup"
        echo "  restore <name> - Restore from a backup"
        echo "  list           - List all backups (default)"
        echo "  cleanup        - Delete old backups (keep 5 most recent)"
        exit 1
        ;;
esac
