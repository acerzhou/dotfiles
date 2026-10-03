#!/usr/bin/env bash

# Link the repository configuration and perform interactive macOS setup.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

require_macos() {
    if [[ "${OSTYPE:-}" != darwin* ]]; then
        echo "This dotfiles setup requires macOS" >&2
        return 1
    fi
    echo "Detected macOS"
}

configure_login_shell() {
    echo "Setting up ZSH..."
    if [ "${SHELL##*/}" = zsh ]; then
        echo "ZSH is already the default shell (${SHELL})"
        return 0
    fi

    local preferred_zsh zsh_path="" shell_entry
    preferred_zsh="$(command -v zsh)" || {
        echo "ZSH is not installed. Run make install first." >&2
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
        echo "No executable ZSH entry was found in /etc/shells" >&2
        return 1
    fi
    if [ "$zsh_path" != "$preferred_zsh" ]; then
        echo "$preferred_zsh is not a registered login shell; using $zsh_path"
    fi

    echo "Setting ZSH as default shell..."
    chsh -s "$zsh_path"
    echo "ZSH is now the default shell ($zsh_path)"
}

offer_ssh_key() {
    read -r -p "Create an SSH key now? (y/n) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bash "$DOTFILES_DIR/scripts/ssh/create-key.sh"
    else
        echo "Skipping SSH key setup"
    fi
}

offer_git_identity() {
    read -r -p "Configure machine-local Git identity now? (y/n) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bash "$DOTFILES_DIR/scripts/git/configure-identity.sh"
    else
        echo "Skipping Git identity setup"
    fi
}

show_iterm_import_help() {
    local config="$DOTFILES_DIR/iterm/iterm2-config.json"
    [ -f "$config" ] || return 0
    echo "iTerm2 config available at: $config"
    echo "Import it from iTerm2 Settings -> Profiles -> Other Actions -> Import JSON Profiles"
}

require_macos
read -r -p "This will symlink dotfiles to your home directory. Continue? (y/n) " -n 1
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Configuration cancelled"
    exit 0
fi

bash "$DOTFILES_DIR/scripts/dotfiles/links.sh" install
configure_login_shell
offer_git_identity
offer_ssh_key
show_iterm_import_help
echo "Dotfiles configuration complete"
echo "Restart your terminal or run: source ~/.zshrc"
