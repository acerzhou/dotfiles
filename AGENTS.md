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

## Architecture contract

- There is one configuration path: the root Zsh, Git, Tmux, Vim, and Hammerspoon files are the default and authoritative configuration.
- Do not introduce configuration profiles, profile switching, active-profile symlinks, or duplicate setup paths.
- `brew/Brewfile` is the complete canonical package manifest and is always installed first.
- `profiles/personal/Brewfile` is additive. It must contain only packages absent from `brew/Brewfile`; never copy default packages into it.
- `PROFILE=personal` affects package installation and preview only. It must not alter dotfile configuration.
- Keep `profiles/personal/` Brew-only unless the user explicitly changes this architecture.
- Prefer direct manifests and commands over compatibility wrappers such as split common/default Brewfiles.
- Machine-specific configuration belongs in documented local files in the user's home directory, never in tracked profiles.

## Code design

- Give each script one domain: dispatch, packages, machine configuration, links, backups, SSH keys, or Hammerspoon.
- Keep `install.sh` as a thin public dispatcher; put implementation in the domain script that owns it.
- Do not add compatibility entry points, duplicate command paths, or hard-coded package lists outside Brewfiles.
- Prefer short functions with explicit inputs and early returns. Keep command parsing separate from the operation it invokes.
- Share code only after multiple active callers need the same behavior; avoid helper layers for one-off logic.
- Delete obsolete code instead of retaining aliases or wrappers unless backward compatibility is explicitly required.

## Documentation

- Keep `README.md` as a concise overview, quick start, structure map, and documentation index.
- Keep detailed installation, customization, maintenance, and recovery guidance in `docs/setup.md`.
- Keep domain-specific documentation beside its code, such as `hammerspoon/README.md`.
- Keep `CHANGELOG.md` historical; do not use it as current setup documentation.
- Link to the owning document instead of copying instructions between files.

## Repository map

- `install.sh`: thin public command dispatcher.
- `scripts/packages/install.sh`: package validation, preview, and installation.
- `scripts/macos/configure.sh`: dotfile linking and interactive macOS configuration.
- `scripts/dotfiles/links.sh`: install, check, and remove managed dotfile links.
- `scripts/dotfiles/backups.sh`: snapshot, restore, list, and clean backups.
- `scripts/ssh/` and `scripts/utilities/`: focused supporting tools.
- `Makefile`: supported user commands.
- `README.md`: repository overview and documentation index.
- `docs/setup.md`: detailed user operations.
- `brew/Brewfile`: canonical default package manifest.
- `profiles/personal/Brewfile`: personal-only package additions.
- `zsh/`, `git/`, `tmux/`, `vim/`: canonical default dotfiles.
- `hammerspoon/`: separately installed macOS automation.
- `tests/test_management.py`: isolated regression tests using temporary home directories.

## Verification

Use the command that matches the change:

```sh
make test                 # isolated regression suite
make install-plan PROFILE=personal  # package/profile preview
make profiles             # profile discovery
```

Do not run `make install`, `make config`, `make hammerspoon`, `make update`, or other commands that alter the real machine merely to verify a change. `make check` inspects the real home directory, so use it only when that is explicitly intended.

## Change conventions

- Shell scripts target macOS and use `bash` with `set -euo pipefail` where already established.
- Keep configuration in the root component directories. Profiles contain package additions only.
- Keep local-only configuration in the documented files in the user's home directory.
- Add or update regression tests for behavior changes.
- Update documentation when commands, profiles, loading order, or user-visible behavior changes.
