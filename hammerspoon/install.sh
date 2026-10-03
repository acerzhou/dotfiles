#!/usr/bin/env bash

# Install Hammerspoon and link this directory as its configuration.
set -euo pipefail

HAMMERSPOON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.hammerspoon"

if [[ "${OSTYPE:-}" != darwin* ]]; then
    echo "Hammerspoon setup is only supported on macOS" >&2
    exit 1
fi

if [ -d /Applications/Hammerspoon.app ] || [ -d "$HOME/Applications/Hammerspoon.app" ]; then
    echo "Hammerspoon is already installed"
else
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew is required to install Hammerspoon. Run make install first, then retry." >&2
        exit 1
    fi
    if brew list --cask hammerspoon >/dev/null 2>&1; then
        echo "Hammerspoon is already installed via Homebrew"
    else
        echo "Installing Hammerspoon..."
        brew install --cask hammerspoon
    fi
fi

if [ -L "$CONFIG_DIR" ] && [ "$(readlink "$CONFIG_DIR")" = "$HAMMERSPOON_DIR" ]; then
    echo "Hammerspoon configuration is already linked"
else
    if [ -e "$CONFIG_DIR" ] || [ -L "$CONFIG_DIR" ]; then
        mkdir -p "$HOME/.dotfiles-backups"
        BACKUP_DIR="$(mktemp -d "$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)-XXXXXX")"
        mv "$CONFIG_DIR" "$BACKUP_DIR/.hammerspoon"
        echo "Existing configuration backed up to: $BACKUP_DIR/.hammerspoon"
    fi
    ln -s "$HAMMERSPOON_DIR" "$CONFIG_DIR"
    echo "Linked $CONFIG_DIR -> $HAMMERSPOON_DIR"
fi

echo "Open Hammerspoon, enable Accessibility access when prompted, and reload its configuration from the menu."
