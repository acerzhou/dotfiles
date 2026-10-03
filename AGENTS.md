# Agent guide

Use this file as the default operating contract for AI-assisted work in this repository.

## Priorities

1. Use the fewest tokens and tool calls needed for a correct change.
2. Preserve user changes; the worktree may already be dirty.
3. Prefer small, focused patches over broad refactors.
4. Never expose secrets or add machine-local configuration.

## Time boundary

- Before starting an action expected to take more than 90 seconds, state what the agent or process will do and ask the user whether to continue.
- If an action unexpectedly reaches 90 seconds, pause at the next safe point, report current progress and remaining work, and ask whether to continue.
- Do not start or resume that long-running action without confirmation.

## Efficient workflow

- Read only files relevant to the request. Use `rg` and `rg --files` for discovery.
- Check `git status --short` before editing. Do not revert or overwrite unrelated changes.
- Use existing scripts and Make targets instead of duplicating their behavior.
- Avoid network access, dependency installation, and machine-wide changes unless the task requires them and the user approves.
- Keep updates brief: outcome, blocker, or decision needed. Do not narrate routine commands.
- Test the narrowest relevant surface first; run the full suite only when warranted.

## Repository map

- `install.sh`: profile-aware package installation and configuration entry point.
- `symlink-manager.sh`: install, check, and remove managed dotfile links.
- `backup.sh`: snapshot, restore, list, and clean backups.
- `Makefile`: supported user commands.
- `brew/`: shared package manifest.
- `profiles/`: `default` and `personal` package/config overlays; see `profiles/README.md`.
- `zsh/`, `git/`, `tmux/`, `vim/`: shared dotfiles.
- `hammerspoon/`: separately installed macOS automation.
- `tests/test_management.py`: isolated regression tests using temporary home directories.

## Verification

Use the command that matches the change:

```sh
make test                 # isolated regression suite
make install-plan PROFILE=personal  # package/profile preview
make profiles             # profile discovery
```

Do not run `make install`, `make config`, `make switch`, `make hammerspoon`, `make update`, or other commands that alter the real machine merely to verify a change. `make check` inspects the real home directory, so use it only when that is explicitly intended.

## Change conventions

- Shell scripts target macOS and use `bash` with `set -euo pipefail` where already established.
- Keep shared behavior in root component directories; put situation-specific behavior in `profiles/<name>/`.
- Keep local-only configuration under ignored `profiles/local/` or the documented files in the user's home directory.
- Add or update regression tests for behavior changes.
- Update documentation when commands, profiles, loading order, or user-visible behavior changes.
