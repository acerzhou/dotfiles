.PHONY: help install config hammerspoon install-links uninstall backup restore list-backups check update clean chmod test

# Default target
help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage:"
	@echo "  make install       - Install packages (Homebrew/apt)"
	@echo "  make config        - Configure general dotfiles"
	@echo "  make hammerspoon   - Install and configure Hammerspoon (macOS)"
	@echo "  make install-links - Link general dotfiles without shell setup"
	@echo "  make uninstall     - Remove symlinks"
	@echo "  make backup        - Backup current dotfiles"
	@echo "  make restore       - Restore from backup (BACKUP=<name>)"
	@echo "  make list-backups  - List available backups"
	@echo "  make check         - Check symlink status"
	@echo "  make update        - Pull latest changes and reapply general config"
	@echo "  make test          - Run isolated regression tests"
	@echo "  make clean         - Clean old backups"
	@echo ""

# Install packages
install:
	@bash ./install.sh install

# Configure general dotfiles
config:
	@bash ./install.sh config

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
	@echo "Reapplying general configuration..."
	@bash ./install.sh config

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
