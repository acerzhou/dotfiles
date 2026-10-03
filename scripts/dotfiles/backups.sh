#!/usr/bin/env bash

# Create, restore, list, and clean managed dotfile backups.
set -euo pipefail

BACKUP_BASE_DIR="$HOME/.dotfiles-backups"
FILES=(.zshrc .zprofile .zsh .vimrc .tmux.conf .gitconfig .gitignore_global .hammerspoon)
BACKUPS=()

collect_backups() {
    local dir
    BACKUPS=()
    for dir in "$BACKUP_BASE_DIR"/*; do
        if [ -d "$dir" ] && [ ! -L "$dir" ] && [[ "${dir##*/}" =~ ^[0-9]{8}-[0-9]{6}(-[[:alnum:]]+)?$ ]]; then
            BACKUPS+=("$dir")
        fi
    done
}

create_backup() {
    local backup_dir file count=0
    mkdir -p "$BACKUP_BASE_DIR"
    backup_dir="$(mktemp -d "$BACKUP_BASE_DIR/$(date +%Y%m%d-%H%M%S)-XXXXXX")"
    for file in "${FILES[@]}"; do
        if [ -e "$HOME/$file" ]; then
            # Snapshot linked contents, so restoring never depends on the repo.
            cp -RLp "$HOME/$file" "$backup_dir/$file"
            count=$((count + 1))
        elif [ -L "$HOME/$file" ]; then
            cp -Pp "$HOME/$file" "$backup_dir/$file"
            count=$((count + 1))
        fi
    done
    if [ "$count" -eq 0 ]; then
        rmdir "$backup_dir"
        echo "No dotfiles found to back up"
        return 0
    fi
    printf 'Backed up %s paths to: %s\n' "$count" "$backup_dir"
    printf 'Restore with: make restore BACKUP=%s\n' "${backup_dir##*/}"
}

list_backups() {
    local dir
    collect_backups
    if [ "${#BACKUPS[@]}" -eq 0 ]; then
        echo "No backups found"
        return 0
    fi
    for dir in "${BACKUPS[@]}"; do
        printf '%s\n' "${dir##*/}"
    done
}

restore_backup() {
    local name="${1:-}" backup_dir file target answer count=0
    if [[ ! "$name" =~ ^[0-9]{8}-[0-9]{6}(-[[:alnum:]]+)?$ ]]; then
        echo "Usage: $0 restore <backup-name> (see $0 list)" >&2
        return 1
    fi
    backup_dir="$BACKUP_BASE_DIR/$name"
    if [ ! -d "$backup_dir" ] || [ -L "$backup_dir" ]; then
        printf 'Backup not found: %s\n' "$name" >&2
        return 1
    fi
    read -r -p "Restore $name and overwrite matching dotfiles? (y/n) " answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
        echo "Restore cancelled"
        return 0
    fi
    create_backup
    # Explicit paths include hidden files and allow partial installer backups.
    for file in "${FILES[@]}"; do
        if [ -e "$backup_dir/$file" ] || [ -L "$backup_dir/$file" ]; then
            target="$HOME/$file"
            if [ "$file" = .zsh ] && [ -d "$backup_dir/$file" ] && [ ! -L "$backup_dir/$file" ]; then
                # Merge partial shell backups, keeping unrelated local files.
                if [ -L "$target" ] || { [ -e "$target" ] && [ ! -d "$target" ]; }; then
                    rm -f "$target"
                fi
                mkdir -p "$target"
                local entry destination
                for entry in "$backup_dir/$file"/.[!.]* "$backup_dir/$file"/..?* "$backup_dir/$file"/*; do
                    if [ -e "$entry" ] || [ -L "$entry" ]; then
                        destination="$target/${entry##*/}"
                        rm -rf "$destination"
                        cp -RPp "$entry" "$destination"
                    fi
                done
            else
                rm -rf "$target"
                cp -RPp "$backup_dir/$file" "$target"
            fi
            count=$((count + 1))
        fi
    done
    printf 'Restored %s paths. Restart your terminal to load the configuration.\n' "$count"
}

case "${1:-list}" in
    backup) create_backup ;;
    restore) restore_backup "${2:-}" ;;
    list) list_backups ;;
    *) echo "Usage: $0 [backup|restore <backup-name>|list]" >&2; exit 1 ;;
esac
