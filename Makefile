.PHONY: help install install-plan profiles config git-identity hammerspoon install-links uninstall backup restore list-backups check update clean test

PROFILE ?= default

# Default target
help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage:"
	@echo "  make install PROFILE=<name> - Install packages (default: default)"
	@echo "  make install-plan PROFILE=<name> - Preview packages without installing"
	@echo "  make profiles      - List available profiles"
	@echo "  make config        - Configure the default dotfiles"
	@echo "  make git-identity  - Configure machine-local Git identity"
	@echo "  make hammerspoon   - Install and configure Hammerspoon (macOS)"
	@echo "  make install-links - Link default dotfiles without shell setup"
	@echo "  make uninstall     - Remove symlinks"
	@echo "  make backup        - Backup current dotfiles"
	@echo "  make restore       - Restore from backup (BACKUP=<name>)"
	@echo "  make list-backups  - List available backups"
	@echo "  make check         - Check symlink status"
	@echo "  make update        - Pull latest changes and reapply default config"
	@echo "  make test          - Run isolated regression tests"
	@echo "  make clean         - Clean old backups"
	@echo ""

# Install packages
install:
	@bash ./scripts/packages/install.sh install --profile "$(PROFILE)"

# Preview package manifests without installing anything
install-plan:
	@bash ./scripts/packages/install.sh install --profile "$(PROFILE)" --dry-run

profiles:
	@bash ./scripts/packages/install.sh profiles

# Configure default dotfiles
config:
	@bash ./scripts/macos/configure.sh

git-identity:
	@bash ./scripts/git/configure-identity.sh

# Install and configure Hammerspoon independently
hammerspoon:
	@bash ./hammerspoon/install.sh

# Install only symlinks (no packages)
install-links:
	@bash ./scripts/dotfiles/links.sh install

# Uninstall symlinks
uninstall:
	@bash ./scripts/dotfiles/links.sh uninstall

# Backup current configuration
backup:
	@bash ./scripts/dotfiles/backups.sh backup

# Restore from backup
restore:
	@bash ./scripts/dotfiles/backups.sh restore "$(BACKUP)"

# List backups
list-backups:
	@bash ./scripts/dotfiles/backups.sh list

# Check symlink status
check:
	@bash ./scripts/dotfiles/links.sh check

# Update dotfiles
update:
	@echo "Pulling latest changes..."
	@git pull origin main
	@echo "Reapplying default configuration..."
	@bash ./scripts/macos/configure.sh

# Clean old backups
clean:
	@bash ./scripts/dotfiles/backups.sh cleanup

# Test against temporary homes without installing packages
test:
	@python3 -m unittest discover -s tests -v
