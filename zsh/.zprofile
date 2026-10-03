# Environment shared by login shells. Interactive setup belongs in .zshrc.
typeset -U path
path=("$HOME/.local/bin" "$HOME/bin" $path)
export PATH
