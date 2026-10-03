# Profiles

The repository's root configuration and `brew/Brewfile` are the default. Directories here are optional, additive overlays; `personal` must contain only settings and packages that differ from the default.

An add-on profile may provide:

- `Brewfile` — packages installed after the default `brew/Brewfile`.
- `zsh.zsh` — shell environment, aliases, and functions.
- `gitconfig` — Git settings such as identity or signing configuration.
- `tmux.conf` — Tmux overrides.
- `vimrc` — Vim overrides.
- `hammerspoon/init.lua` — Hammerspoon shortcuts or modules.

Omitting `PROFILE` uses the default with no overlay. Activate personal additions with `make config PROFILE=personal`, or switch an already configured machine with `make switch PROFILE=personal`. Return to the base with `make switch PROFILE=default`. Default configuration loads first, the active overlay loads second, and untracked machine-local files load last.

Use `profiles/local/` for an untracked profile. It must contain a `Brewfile` so it passes the same validation as tracked profiles.
