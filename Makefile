.PHONY: help install uninstall backup restore check update clean

# Default target
help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage:"
	@echo "  make install       - Install dotfiles (symlinks + packages)"
	@echo "  make uninstall     - Remove symlinks"
	@echo "  make backup        - Backup current dotfiles"
	@echo "  make restore       - Restore from backup"
	@echo "  make check         - Check symlink status"
	@echo "  make update        - Pull latest changes and reinstall"
	@echo "  make clean         - Clean old backups"
	@echo ""

# Install everything
install:
	@chmod +x install.sh symlink-manager.sh backup.sh
	@./install.sh

# Install only symlinks (no packages)
install-links:
	@chmod +x symlink-manager.sh
	@./symlink-manager.sh install

# Uninstall symlinks
uninstall:
	@chmod +x symlink-manager.sh
	@./symlink-manager.sh uninstall

# Backup current configuration
backup:
	@chmod +x backup.sh
	@./backup.sh backup

# Restore from backup
restore:
	@chmod +x backup.sh
	@./backup.sh restore

# List backups
list-backups:
	@chmod +x backup.sh
	@./backup.sh list

# Check symlink status
check:
	@chmod +x symlink-manager.sh
	@./symlink-manager.sh check

# Update dotfiles
update:
	@echo "Pulling latest changes..."
	@git pull origin main
	@echo "Reinstalling..."
	@./install.sh

# Clean old backups
clean:
	@chmod +x backup.sh
	@./backup.sh cleanup

# Make all scripts executable
chmod:
	@chmod +x install.sh symlink-manager.sh backup.sh
	@chmod +x script/*.sh
	@echo "Made all scripts executable"
