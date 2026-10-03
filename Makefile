.PHONY: help install install-plan profiles config switch profile hammerspoon install-links uninstall backup restore list-backups check update clean chmod test

PROFILE ?= default

# Default target
help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage:"
	@echo "  make install PROFILE=<name> - Install packages (default: default)"
	@echo "  make install-plan PROFILE=<name> - Preview packages without installing"
	@echo "  make profiles      - List available profiles"
	@echo "  make config PROFILE=<name> - Configure shared dotfiles + profile"
	@echo "  make switch PROFILE=<name> - Change the active config profile"
	@echo "  make profile       - Show the active config profile"
	@echo "  make hammerspoon   - Install and configure Hammerspoon (macOS)"
	@echo "  make install-links - Link shared dotfiles without shell setup"
	@echo "  make uninstall     - Remove symlinks"
	@echo "  make backup        - Backup current dotfiles"
	@echo "  make restore       - Restore from backup (BACKUP=<name>)"
	@echo "  make list-backups  - List available backups"
	@echo "  make check         - Check symlink status"
	@echo "  make update        - Pull latest changes and reapply shared config"
	@echo "  make test          - Run isolated regression tests"
	@echo "  make clean         - Clean old backups"
	@echo ""

# Install packages
install:
	@bash ./install.sh install --profile "$(PROFILE)"

# Preview package manifests without installing anything
install-plan:
	@bash ./install.sh install --profile "$(PROFILE)" --dry-run

profiles:
	@bash ./install.sh profiles

# Configure shared dotfiles
config:
	@bash ./install.sh config --profile "$(PROFILE)"

# Switch overlays without reinstalling packages or relinking shared files
switch:
	@bash ./install.sh switch --profile "$(PROFILE)"

# Show the currently active configuration profile
profile:
	@bash ./install.sh profile

# Install and configure Hammerspoon independently
hammerspoon:
	@bash ./hammerspoon/install.sh

# Install only symlinks (no packages)
install-links:
	@bash ./symlink-manager.sh install

# Uninstall symlinks
uninstall:
	@bash ./symlink-manager.sh uninstall

# Backup current configuration
backup:
	@bash ./backup.sh backup

# Restore from backup
restore:
	@bash ./backup.sh restore "$(BACKUP)"

# List backups
list-backups:
	@bash ./backup.sh list

# Check symlink status
check:
	@bash ./symlink-manager.sh check

# Update dotfiles
update:
	@echo "Pulling latest changes..."
	@git pull origin main
	@echo "Reapplying shared configuration..."
	@bash ./install.sh config --profile "$(PROFILE)"

# Clean old backups
clean:
	@bash ./backup.sh cleanup

# Make all scripts executable
chmod:
	@chmod +x install.sh symlink-manager.sh backup.sh
	@chmod +x script/*.sh
	@chmod +x hammerspoon/install.sh
	@echo "Made all scripts executable"

# Test against temporary homes without installing packages
test:
	@python3 -m unittest discover -s tests -v
