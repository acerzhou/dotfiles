# Profiles

The root-level ZSH, Git, Tmux, Vim, and Hammerspoon files are the shared base. The `default` and `personal` directories contain package choices and optional configuration overrides.

An active profile may provide:

- `Brewfile` — packages added to the shared Brewfile.
- `zsh.zsh` — shell environment, aliases, and functions.
- `gitconfig` — Git settings such as identity or signing configuration.
- `tmux.conf` — Tmux overrides.
- `vimrc` — Vim overrides.
- `hammerspoon/init.lua` — Hammerspoon shortcuts or modules.

Omitting `PROFILE` selects `default`. Activate another profile with `make config PROFILE=personal`, or switch an already configured machine with `make switch PROFILE=personal`. Shared configuration loads first, the active profile loads second, and untracked machine-local files load last.

Use `profiles/local/` for an untracked profile. It must contain a `Brewfile` so it passes the same validation as tracked profiles.
