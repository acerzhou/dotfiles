# Agent contract

Follow this contract for every change in this repository.

## Core rules

1. Keep code and documentation minimal, clear, and necessary.
2. Give every file, script, and function one responsibility.
3. Maintain one authoritative implementation for each behavior; remove duplication instead of synchronizing copies.
4. Keep content in its owning domain directory. Root is reserved for repository-wide entry points, metadata, and overview documents.
5. Preserve existing user changes and never expose secrets or track machine-local values.
6. Do not track real names, email addresses, usernames, account URLs, absolute home paths, or other personal identifiers; use neutral placeholders.

## Work limits

- Use the fewest tokens, file reads, and tool calls needed for a correct result.
- Before an action expected to exceed 90 seconds, state what will run and ask whether to continue.
- If work unexpectedly reaches 90 seconds, pause at the next safe point, report progress and remaining work, and ask before resuming.
- Keep progress updates brief and limited to outcomes, blockers, or decisions.

## Design

- Prefer deletion and consolidation over wrappers, aliases, compatibility paths, and parallel workflows.
- Keep the Makefile as the single public interface. Domain scripts own implementation.
- Keep command parsing separate from the operation it invokes.
- Prefer short functions, explicit inputs, early returns, and direct control flow.
- Create shared helpers only when multiple active callers need identical behavior.
- Use existing Make targets and scripts instead of recreating their behavior.

## Architecture invariants

- `zsh/`, `git/`, `tmux/`, `vim/`, and `hammerspoon/` contain the single authoritative configuration for their domains.
- Configuration profiles, active-profile links, and alternate setup paths are not supported.
- `brew/Brewfile` is the canonical default package manifest.
- `brew/profiles/personal.Brewfile` contains only additional packages and must not duplicate default entries.
- `PROFILE=personal` affects package installation and preview only.
- Personal and machine-specific configuration belongs in documented files under the user's home directory, not in tracked profiles.

## Directory ownership

- `Makefile`: public task interface.
- `scripts/packages/`: package validation, preview, and installation.
- `scripts/macos/`: interactive macOS configuration workflow.
- `scripts/dotfiles/`: link and backup management.
- `scripts/ssh/`: SSH key operations.
- `scripts/utilities/`: independent helper tools.
- `brew/`: default and additive package manifests.
- `hammerspoon/`, `zsh/`, `git/`, `tmux/`, `vim/`, `iterm/`: tool-owned configuration.
- `git/hooks/pre-commit`: staged secret and personal-information checks.
- `tests/`: isolated regression coverage.
- `docs/`: detailed repository-wide documentation.

Do not place domain implementation at repository root or move domain-specific content into a generic shared folder.

## Documentation ownership

- `README.md`: concise overview, quick start, structure, and documentation index.
- `docs/setup.md`: installation, customization, maintenance, recovery, and troubleshooting.
- Domain `README.md` files: behavior belonging only to that domain.
- `CHANGELOG.md`: historical milestones, not current setup instructions.
- Link to the owning document instead of copying its content elsewhere.

## Workflow

1. Read only relevant files; use `rg` and `rg --files` for discovery.
2. Run `git status --short` before editing and preserve unrelated worktree changes.
3. Make the smallest cohesive patch that fully solves the request.
4. Remove obsolete files and references when replacing an implementation.
5. Update tests and the owning documentation when behavior changes.
6. Check for stale paths, duplicate logic, and broken links before finishing.
7. Scan tracked content for personal identifiers before publishing or handing off identity-related changes.
8. Keep privacy checks generic; store identity-specific patterns only in untracked `.git/info/personal-patterns` files.

## Verification

- Use `make test` for behavior changes.
- Use `make install-plan PROFILE=personal` for package-flow changes.
- Use `bash -n` and ShellCheck for shell changes when available.
- Use `git diff --check` for every patch.
- Do not run `make install`, `make config`, `make hammerspoon`, `make update`, or `make check` merely for verification; they inspect or modify the real machine.

Shell scripts target macOS, use Bash, and should enable `set -euo pipefail` unless a documented reason requires otherwise.
