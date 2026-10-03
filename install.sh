#!/usr/bin/env bash

# Public command dispatcher. Each delegated script owns one responsibility.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
    cat <<'EOF'
Usage: ./install.sh install [--profile NAME] [--dry-run]
       ./install.sh config
       ./install.sh [hammerspoon|profiles|help]

Commands:
  install      Install default packages and optional profile additions
  config       Link and configure the default dotfiles
  hammerspoon  Install and configure Hammerspoon
  profiles     List available package profiles
EOF
}

command="${1:-install}"
if [ "$#" -gt 0 ]; then
    shift
fi

case "$command" in
    install|profiles)
        exec bash "$DOTFILES_DIR/script/install-packages.sh" "$command" "$@"
        ;;
    config)
        [ "$#" -eq 0 ] || { usage >&2; exit 1; }
        exec bash "$DOTFILES_DIR/script/configure-macos.sh"
        ;;
    hammerspoon)
        [ "$#" -eq 0 ] || { usage >&2; exit 1; }
        exec bash "$DOTFILES_DIR/hammerspoon/install.sh"
        ;;
    help|-h|--help)
        usage
        ;;
    *)
        usage >&2
        exit 1
        ;;
esac
