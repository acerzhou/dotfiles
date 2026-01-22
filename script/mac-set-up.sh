#/bin/sh

echo Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Prepare console to execute and ignore comments"
set -k

echo "Install Apps"
brew install --cask firefox
brew install --cask google-chrome
brew install --cask slack
brew install --cask zoom
brew install --cask iterm2
brew install --cask visual-studio-code
brew install --cask docker
brew install --cask notion

echo "Install Terminal Tools"
brew install git
brew install gh
brew install shellcheck
brew install jq
brew install yq 
brew install htop
brew install tmux
brew install autojump

