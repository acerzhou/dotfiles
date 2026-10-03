# ZSH Configuration

- `.zprofile` sets environment paths for login shells.
- `.zshrc` configures interactive shells, the prompt, and optional tool integrations.
- `.alias` defines shortcuts, with platform-specific `ls` and local-IP commands.
- `.tools` defines utility functions. Use `fdir` to find directories; `fd` remains available for the installed search tool.

Run `make config` from the repository root. Add personal settings to `~/.zshrc.local`.

Optional Homebrew, NVM, jenv, pyenv, Go, Rust, fzf, and autojump integrations load when available. The configuration does not require Oh My Zsh.
