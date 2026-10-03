# Changelog

## 2026-10-03

### Simplified architecture

- Established one default ZSH, Git, Tmux, Vim, and Hammerspoon configuration.
- Consolidated default packages into `brew/Brewfile`.
- Moved personal package additions to `brew/profiles/personal.Brewfile`.
- Removed profile switching, compatibility setup wrappers, Linux-only scripts, and duplicated package cleanup lists.
- Made the Makefile the sole public interface over focused package and macOS configuration scripts.
- Grouped operational scripts under `scripts/` by domain.

### Documentation

- Added `AGENTS.md` as the repository operating contract for AI-assisted work.
- Reduced the root README to an overview and documentation index.
- Moved detailed operational guidance to `docs/setup.md`.
- Kept Hammerspoon and ZSH documentation beside their domains.

### Reliability

- Made symlink management idempotent and compatible with macOS Bash 3.2.
- Added unique backups and partial restore support.
- Kept Hammerspoon installation and backup independent from general dotfile linking.
- Selected login shells only from executable entries in `/etc/shells`.
- Guarded optional shell and Vim integrations.
- Added isolated regression coverage for packages, links, backups, configuration, Vim, and Hammerspoon.

## 2026-01-23

- Introduced the Make-based management interface and installer.
- Added managed symlinks, backup and restore commands, and global Git configuration.
- Organized the initial Homebrew, ZSH, Tmux, Vim, iTerm2, and Hammerspoon configuration.
