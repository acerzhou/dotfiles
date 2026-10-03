#!/usr/bin/env bash

# Install the canonical Brewfile and optional package additions.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PROFILE_NAME="${PROFILE:-default}"
PROFILE_BREWFILE=""
DRY_RUN=false

usage() {
    echo "Usage: $0 [--profile NAME] [--dry-run]"
}

require_macos() {
    if [[ "${OSTYPE:-}" != darwin* ]]; then
        echo "This dotfiles setup requires macOS" >&2
        return 1
    fi
    echo "Detected macOS"
}

validate_manifests() {
    if [[ ! "$PROFILE_NAME" =~ ^[a-zA-Z0-9][a-zA-Z0-9_-]*$ ]]; then
        echo "Invalid profile name: $PROFILE_NAME" >&2
        return 1
    fi
    if [ ! -f "$DOTFILES_DIR/brew/Brewfile" ]; then
        echo "Default Brewfile is missing" >&2
        return 1
    fi
    if [ "$PROFILE_NAME" != default ]; then
        PROFILE_BREWFILE="$DOTFILES_DIR/brew/profiles/$PROFILE_NAME.Brewfile"
        if [ ! -f "$PROFILE_BREWFILE" ]; then
            echo "Unknown package profile: $PROFILE_NAME" >&2
            return 1
        fi
    fi
}

ensure_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        local installer
        installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        /bin/bash -c "$installer"
        echo "Homebrew installed"
    else
        echo "Homebrew already installed"
    fi

    if ! command -v brew >/dev/null 2>&1; then
        if [ -x /opt/homebrew/bin/brew ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -x /usr/local/bin/brew ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        else
            echo "Homebrew is not available after installation" >&2
            return 1
        fi
    fi
}

show_plan() {
    echo "Default packages: brew/Brewfile"
    cat "$DOTFILES_DIR/brew/Brewfile"
    if [ -n "$PROFILE_BREWFILE" ]; then
        echo "Additional packages: brew/profiles/$PROFILE_NAME.Brewfile"
        cat "$PROFILE_BREWFILE"
    fi
}

install_packages() {
    echo "Installing packages via Homebrew..."
    brew bundle --file="$DOTFILES_DIR/brew/Brewfile"
    if [ -n "$PROFILE_BREWFILE" ]; then
        brew bundle --file="$PROFILE_BREWFILE"
    fi
    echo "Package installation complete"
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --profile)
            [ "$#" -ge 2 ] && [ -n "$2" ] || { echo "--profile requires a name" >&2; exit 1; }
            PROFILE_NAME="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

validate_manifests
require_macos
echo "Install profile: $PROFILE_NAME"

if [ "$DRY_RUN" = true ]; then
    show_plan
else
    ensure_homebrew
    install_packages
fi
