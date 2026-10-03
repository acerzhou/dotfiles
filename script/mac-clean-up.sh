#!/usr/bin/env bash

# Optional removal of the applications and tools listed below.
set -euo pipefail

echo "uninstall Apps"
brew uninstall --cask firefox
brew uninstall --cask google-chrome
brew uninstall --cask slack
brew uninstall --cask zoom
brew uninstall --cask iterm2
brew uninstall --cask visual-studio-code
brew uninstall --cask docker
brew uninstall --cask notion

echo "uninstall Terminal Tools"
brew uninstall git
brew uninstall gh
brew uninstall shellcheck
brew uninstall jq
brew uninstall yq 
brew uninstall htop
brew uninstall tmux
brew uninstall autojump
