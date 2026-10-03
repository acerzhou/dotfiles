#!/usr/bin/env bash

# Select a command or language for use with an external cheatsheet client.

set -euo pipefail

command -v fzf >/dev/null 2>&1 || {
    echo "fzf is required" >&2
    exit 1
}

printf '%s\n' golang c cpp typescript rust find xargs sed awk | fzf
