#!/usr/bin/env bash

# Create the user's default Ed25519 SSH key.

set -euo pipefail

DEFAULT_KEY_PATH="$HOME/.ssh/id_ed25519"

prompt_email() {
    local email
    while true; do
        read -r -p "Enter the email for your SSH key: " email
        if [ -n "$email" ]; then
            SSH_KEY_EMAIL="$email"
            return 0
        fi
        echo "Email cannot be empty."
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

        echo "Passphrases do not match. Please try again."
    done
}

create_ssh_key() {
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

    if [ -f "$DEFAULT_KEY_PATH" ] || [ -f "$DEFAULT_KEY_PATH.pub" ]; then
        read -r -p "SSH key already exists at $DEFAULT_KEY_PATH. Overwrite it? (y/n) " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            echo "Skipping SSH key creation."
            return 0
        fi

        rm -f "$DEFAULT_KEY_PATH" "$DEFAULT_KEY_PATH.pub"
    fi

    ssh-keygen -t ed25519 -C "$SSH_KEY_EMAIL" -f "$DEFAULT_KEY_PATH" -N "$SSH_KEY_PASSPHRASE"
    echo "SSH key created at $DEFAULT_KEY_PATH"

    if command -v ssh-add >/dev/null 2>&1; then
        if [ "$(uname -s)" = "Darwin" ]; then
            ssh-add --apple-use-keychain "$DEFAULT_KEY_PATH" >/dev/null 2>&1 || true
        else
            ssh-add "$DEFAULT_KEY_PATH" >/dev/null 2>&1 || true
        fi
    fi

    echo "Public key:"
    printf "%s\n" "$DEFAULT_KEY_PATH.pub"
}

main() {
    if ! command -v ssh-keygen >/dev/null 2>&1; then
        echo "ssh-keygen is not available on this system." >&2
        exit 1
    fi

    prompt_email
    prompt_passphrase
    create_ssh_key
}

main "$@"
