#!/usr/bin/env bash

# Install the canonical Brewfile and optional package additions.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE_NAME="${PROFILE:-default}"
PROFILE_BREWFILE=""
DRY_RUN=false

info() { printf '\033[0;34m==>\033[0m %s\n' "$1"; }
success() { printf '\033[0;32m✓\033[0m %s\n' "$1"; }
error() { printf '\033[0;31m✗\033[0m %s\n' "$1"; }

usage() {
    echo "Usage: $0 install [--profile NAME] [--dry-run]"
    echo "       $0 profiles"
}

require_macos() {
    if [[ "${OSTYPE:-}" != darwin* ]]; then
        error "This dotfiles setup requires macOS"
        return 1
    fi
    success "Detected macOS"
}

validate_manifests() {
    if [[ ! "$PROFILE_NAME" =~ ^[a-zA-Z0-9][a-zA-Z0-9_-]*$ ]]; then
        error "Invalid profile name: $PROFILE_NAME"
        return 1
    fi
    if [ ! -f "$DOTFILES_DIR/brew/Brewfile" ]; then
        error "Default Brewfile is missing"
        return 1
    fi
    if [ "$PROFILE_NAME" != default ]; then
        PROFILE_BREWFILE="$DOTFILES_DIR/profiles/$PROFILE_NAME/Brewfile"
        if [ ! -f "$PROFILE_BREWFILE" ]; then
            error "Unknown or incomplete profile: $PROFILE_NAME. Run make profiles."
            return 1
        fi
    fi
}

list_profiles() {
    local directory
    echo "Available profiles (default: default):"
    echo "  default"
    for directory in "$DOTFILES_DIR"/profiles/*; do
        [ -f "$directory/Brewfile" ] && printf '  %s\n' "${directory##*/}"
    done
    return 0
}

ensure_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        info "Installing Homebrew..."
        local installer
        installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        /bin/bash -c "$installer"
        success "Homebrew installed"
    else
        success "Homebrew already installed"
    fi

    if ! command -v brew >/dev/null 2>&1; then
        if [ -x /opt/homebrew/bin/brew ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -x /usr/local/bin/brew ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        else
            error "Homebrew is not available after installation"
            return 1
        fi
    fi
}

show_plan() {
    info "Default packages: brew/Brewfile"
    cat "$DOTFILES_DIR/brew/Brewfile"
    if [ -n "$PROFILE_BREWFILE" ]; then
        info "Additional packages: profiles/$PROFILE_NAME/Brewfile"
        cat "$PROFILE_BREWFILE"
    fi
}

install_packages() {
    info "Installing packages via Homebrew..."
    brew bundle --file="$DOTFILES_DIR/brew/Brewfile"
    if [ -n "$PROFILE_BREWFILE" ]; then
        brew bundle --file="$PROFILE_BREWFILE"
    fi
    success "Package installation complete"
}

command="${1:-install}"
if [ "$#" -gt 0 ]; then
    shift
fi

if [ "$command" = profiles ]; then
    [ "$#" -eq 0 ] || { usage >&2; exit 1; }
    list_profiles
    exit 0
fi
if [ "$command" != install ]; then
    usage >&2
    exit 1
fi

while [ "$#" -gt 0 ]; do
    case "$1" in
        --profile)
            [ "$#" -ge 2 ] && [ -n "$2" ] || { error "--profile requires a name"; exit 1; }
            PROFILE_NAME="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            error "Unknown argument: $1"
            usage >&2
            exit 1
            ;;
    esac
done

validate_manifests
require_macos
info "Install profile: $PROFILE_NAME"

if [ "$DRY_RUN" = true ]; then
    show_plan
else
    ensure_homebrew
    install_packages
fi
