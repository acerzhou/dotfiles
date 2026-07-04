#!/usr/bin/env bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DEFAULT_KEY_PATH="$HOME/.ssh/id_ed25519"

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

prompt_email() {
    local email
    while true; do
        read -r -p "Enter the email for your SSH key: " email
        if [ -n "$email" ]; then
            SSH_KEY_EMAIL="$email"
            return 0
        fi
        warning "Email cannot be empty."
    done
}

prompt_passphrase() {
    local passphrase
    local confirm_passphrase

    while true; do
        read -r -s -p "Enter a passphrase for the SSH key (leave blank for none): " passphrase
        echo ""
        read -r -s -p "Confirm the passphrase: " confirm_passphrase
        echo ""

        if [ "$passphrase" = "$confirm_passphrase" ]; then
            SSH_KEY_PASSPHRASE="$passphrase"
            return 0
        fi

        warning "Passphrases do not match. Please try again."
    done
}

create_ssh_key() {
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

    if [ -f "$DEFAULT_KEY_PATH" ] || [ -f "$DEFAULT_KEY_PATH.pub" ]; then
        read -r -p "SSH key already exists at $DEFAULT_KEY_PATH. Overwrite it? (y/n) " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            warning "Skipping SSH key creation."
            return 0
        fi

        rm -f "$DEFAULT_KEY_PATH" "$DEFAULT_KEY_PATH.pub"
    fi

    ssh-keygen -t ed25519 -C "$SSH_KEY_EMAIL" -f "$DEFAULT_KEY_PATH" -N "$SSH_KEY_PASSPHRASE"
    success "SSH key created at $DEFAULT_KEY_PATH"

    if command -v ssh-add >/dev/null 2>&1; then
        if [ "$(uname -s)" = "Darwin" ]; then
            ssh-add --apple-use-keychain "$DEFAULT_KEY_PATH" >/dev/null 2>&1 || true
        else
            ssh-add "$DEFAULT_KEY_PATH" >/dev/null 2>&1 || true
        fi
    fi

    info "Public key:"
    printf "%s\n" "$DEFAULT_KEY_PATH.pub"
}

main() {
    if ! command -v ssh-keygen >/dev/null 2>&1; then
        error "ssh-keygen is not available on this system."
        exit 1
    fi

    prompt_email
    prompt_passphrase
    create_ssh_key
}

main "$@"
