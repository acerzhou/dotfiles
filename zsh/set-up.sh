#!/usr/bin/env bash

# Compatibility entry point for general dotfile symlinks.
set -euo pipefail
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash "$DOTFILES_DIR/symlink-manager.sh" install
