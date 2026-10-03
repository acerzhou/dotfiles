#!/usr/bin/env bash

# Link the repository configuration and perform interactive macOS setup.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

info() { printf '\033[0;34m==>\033[0m %s\n' "$1"; }
success() { printf '\033[0;32m✓\033[0m %s\n' "$1"; }
warning() { printf '\033[1;33m!\033[0m %s\n' "$1"; }
error() { printf '\033[0;31m✗\033[0m %s\n' "$1" >&2; }

require_macos() {
    if [[ "${OSTYPE:-}" != darwin* ]]; then
        error "This dotfiles setup requires macOS"
        return 1
    fi
    success "Detected macOS"
}

configure_login_shell() {
    info "Setting up ZSH..."
    if [ "${SHELL##*/}" = zsh ]; then
        success "ZSH is already the default shell (${SHELL})"
        return 0
    fi

    local preferred_zsh zsh_path="" shell_entry
    preferred_zsh="$(command -v zsh)" || {
        error "ZSH is not installed. Run make install first."
        return 1
    }

    if [ -r /etc/shells ]; then
        while IFS= read -r shell_entry; do
            case "$shell_entry" in
                ""|\#*) continue ;;
                */zsh)
                    [ -n "$zsh_path" ] || [ ! -x "$shell_entry" ] || zsh_path="$shell_entry"
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

offer_ssh_key() {
    read -r -p "Create an SSH key now? (y/n) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bash "$DOTFILES_DIR/script/create-ssh-key.sh"
    else
        info "Skipping SSH key setup"
    fi
}

show_iterm_import_help() {
    local config="$DOTFILES_DIR/iterm/iterm2-config.json"
    [ -f "$config" ] || return 0
    info "iTerm2 config available at: $config"
    info "Import it from iTerm2 Settings -> Profiles -> Other Actions -> Import JSON Profiles"
}

require_macos
read -r -p "This will symlink dotfiles to your home directory. Continue? (y/n) " -n 1
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    warning "Configuration cancelled"
    exit 0
fi

bash "$DOTFILES_DIR/symlink-manager.sh" install
configure_login_shell
offer_ssh_key
show_iterm_import_help
success "Dotfiles configuration complete"
info "Restart your terminal or run: source ~/.zshrc"
