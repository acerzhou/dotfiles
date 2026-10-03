#!/usr/bin/env bash

# Compatibility entry point; use make install and make config for new setups.
set -euo pipefail
if [[ "$OSTYPE" != linux-gnu* ]]; then
    echo "This script requires linux-gnu" >&2
    exit 1
fi
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash "$DOTFILES_DIR/install.sh" install
bash "$DOTFILES_DIR/install.sh" config
