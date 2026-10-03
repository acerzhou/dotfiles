.PHONY: help install install-plan config git-identity hammerspoon check uninstall backup list-backups restore test

PROFILE ?= default

help:
	@printf '%s\n' \
		'make install [PROFILE=personal]  Install packages' \
		'make install-plan [PROFILE=personal]  Preview packages' \
		'make config                    Configure dotfiles' \
		'make git-identity              Configure Git identity' \
		'make hammerspoon               Configure Hammerspoon' \
		'make check                     Check managed links' \
		'make uninstall                 Remove managed links' \
		'make backup                    Create a backup' \
		'make list-backups              List backups' \
		'make restore BACKUP=<name>     Restore a backup' \
		'make test                      Run regression tests'

install:
	@bash ./scripts/packages/install.sh --profile "$(PROFILE)"

install-plan:
	@bash ./scripts/packages/install.sh --profile "$(PROFILE)" --dry-run

config:
	@bash ./scripts/macos/configure.sh

git-identity:
	@bash ./scripts/git/configure-identity.sh

hammerspoon:
	@bash ./hammerspoon/install.sh

check:
	@bash ./scripts/dotfiles/links.sh check

uninstall:
	@bash ./scripts/dotfiles/links.sh uninstall

backup:
	@bash ./scripts/dotfiles/backups.sh backup

list-backups:
	@bash ./scripts/dotfiles/backups.sh list

restore:
	@bash ./scripts/dotfiles/backups.sh restore "$(BACKUP)"

test:
	@python3 -m unittest discover -s tests -v
