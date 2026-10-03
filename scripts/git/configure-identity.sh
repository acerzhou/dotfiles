#!/usr/bin/env bash

# Store machine-local Git identity outside the tracked configuration.
set -euo pipefail

IDENTITY_FILE="$HOME/.gitconfig.local"

prompt_value() {
    local label="$1" current="$2" value
    while true; do
        if [ -n "$current" ]; then
            read -r -p "$label [$current]: " value
            value="${value:-$current}"
        else
            read -r -p "$label: " value
        fi
        if [ -n "$value" ]; then
            printf '%s' "$value"
            return 0
        fi
        echo "$label cannot be empty." >&2
    done
}

current_name="$(git config --file "$IDENTITY_FILE" --get user.name 2>/dev/null || true)"
current_email="$(git config --file "$IDENTITY_FILE" --get user.email 2>/dev/null || true)"

name="$(prompt_value "Git user name" "$current_name")"
while true; do
    email="$(prompt_value "Git user email" "$current_email")"
    case "$email" in
        *@*.*) break ;;
        *) echo "Enter a valid email address." >&2 ;;
    esac
done

git config --file "$IDENTITY_FILE" user.name "$name"
git config --file "$IDENTITY_FILE" user.email "$email"
chmod 600 "$IDENTITY_FILE"

echo "Git identity saved to $IDENTITY_FILE"
