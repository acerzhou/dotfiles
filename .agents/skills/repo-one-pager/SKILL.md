---
name: repo-one-pager
description: Create or refresh this dotfiles repository's self-contained HTML one-pager from current tracked evidence. Use for repository summaries, status reports, or updates to docs/one-pager.html.
---

# Repository One Pager

Create or update `docs/one-pager.html` as the concise visual summary of this repository.

## Source of truth

Inspect the current repository before editing. Use `README.md`, `Makefile`,
`CHANGELOG.md`, `docs/setup.md`, package manifests, tests, tracked files, recent
commit subjects, and `git status --short`. Report facts from those sources; do
not infer machine state from configuration files.

Use the pre-generation worktree state when reporting repository cleanliness,
because updating the page makes the worktree dirty. Identify the snapshot with
the current branch, short commit, and local calendar date.

## Page requirements

- Keep the report in one responsive, accessible HTML file with inline CSS and no
  network dependencies.
- Preserve the existing visual language when refreshing unless the user asks
  for a redesign.
- Keep the page scannable: purpose, current snapshot, architecture, supported
  Make commands, safeguards, test state, and recent direction.
- Prefer compact cards, tables, and a small flow diagram over long prose.
- Update every stale count, date, status, command, and milestone. Remove obsolete
  claims rather than retaining a historical compatibility note.
- Mention only tracked repository facts. Never include author identities, email
  addresses, account URLs, absolute home paths, untracked pattern contents, or
  other machine-local information.
- Link supporting repository documents with relative paths.

## Verification

Run `make test`, validate the HTML with Python's standard-library `HTMLParser`,
and run `git diff --check`. Confirm that every displayed command exists in the
Makefile and package/test counts match the files that own them. Do not run
machine-inspecting or mutating Make targets for verification.

Summarize what changed and the verification result. Leave committing and
publishing to the user unless explicitly requested.
