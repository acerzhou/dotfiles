#!/usr/bin/env bash

# Manage dotfile links with macOS's bundled Bash or newer Bash versions.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BACKUP_DIR=""
SOURCES=(zsh/.zshrc zsh/.zprofile zsh/.alias zsh/.tools vim/.vimrc tmux/.tmux.conf git/.gitconfig git/.gitignore_global)
TARGETS=(.zshrc .zprofile .zsh/.alias .zsh/.tools .vimrc .tmux.conf .gitconfig .gitignore_global)

COMMAND="${1:-check}"

backup_target() {
    local target="$1" relative="$2"
    if [ -z "$BACKUP_DIR" ]; then
        mkdir -p "$HOME/.dotfiles-backups"
        BACKUP_DIR="$(mktemp -d "$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)-XXXXXX")"
    fi
    mkdir -p "$(dirname "$BACKUP_DIR/$relative")"
    mv "$target" "$BACKUP_DIR/$relative"
    printf 'Backed up: %s\n' "$target"
}

manage_links() {
    local i source target status
    local ok=0 broken=0 missing=0
    for ((i=0; i<${#SOURCES[@]}; i++)); do
        source="$DOTFILES_DIR/${SOURCES[$i]}"
        target="$HOME/${TARGETS[$i]}"
        case "$COMMAND" in
            install)
                if [ ! -e "$source" ]; then
                    printf 'Missing source: %s\n' "$source" >&2
                    return 1
                fi
                if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
                    printf 'Already linked: %s\n' "$target"
                    continue
                fi
                if [ -e "$target" ] || [ -L "$target" ]; then
                    backup_target "$target" "${TARGETS[$i]}"
                fi
                mkdir -p "$(dirname "$target")"
                ln -s "$source" "$target"
                printf 'Linked: %s -> %s\n' "$target" "$source"
                ;;
            uninstall)
                if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
                    rm "$target"
                    printf 'Removed: %s\n' "$target"
                else
                    printf 'Skipping unmanaged path: %s\n' "$target"
                fi
                ;;
            check)
                if [ ! -e "$source" ]; then
                    status='missing source'; broken=$((broken + 1))
                elif [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
                    status=OK; ok=$((ok + 1))
                elif [ -e "$target" ] || [ -L "$target" ]; then
                    status='unmanaged or incorrect link'; broken=$((broken + 1))
                else
                    status=missing; missing=$((missing + 1))
                fi
                printf '%s: %s\n' "$target" "$status"
                ;;
        esac
    done
    if [ -n "$BACKUP_DIR" ]; then
        printf 'Backup: %s\n' "$BACKUP_DIR"
    fi
    if [ "$COMMAND" = check ]; then
        printf 'Summary: %s OK, %s broken, %s missing (total: %s)\n' "$ok" "$broken" "$missing" "${#SOURCES[@]}"
        [ "$broken" -eq 0 ] && [ "$missing" -eq 0 ]
    fi
}

case "$COMMAND" in
    install|uninstall|check) manage_links ;;
    *) echo "Usage: $0 [install|uninstall|check]" >&2; exit 1 ;;
esac
