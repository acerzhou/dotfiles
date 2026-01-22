# Hammerspoon Configuration

Hammerspoon configuration for macOS automation and window management.

## Installation

Hammerspoon will be installed automatically via the main installation script, or you can install it manually:

```bash
brew install --cask hammerspoon
```

Then create a symlink:

```bash
ln -sf ~/Repos/dotfiles/hammerspoon ~/.hammerspoon
```

## Keybindings

All keybindings use the **Hyper** key: `Cmd + Ctrl + Alt + Shift`

### Window Management

| Keybinding  | Action                       |
| ----------- | ---------------------------- |
| `Hyper + M` | Maximize window              |
| `Hyper + C` | Center window                |
| `Hyper + ←` | Move to left half            |
| `Hyper + →` | Move to right half           |
| `Hyper + ↑` | Move to top half             |
| `Hyper + ↓` | Move to bottom half          |
| `Hyper + 1` | Move to top-left quarter     |
| `Hyper + 2` | Move to top-right quarter    |
| `Hyper + 3` | Move to bottom-left quarter  |
| `Hyper + 4` | Move to bottom-right quarter |

### Monitor Management

| Keybinding  | Action                          |
| ----------- | ------------------------------- |
| `Hyper + N` | Move window to next monitor     |
| `Hyper + P` | Move window to previous monitor |

### Application Launcher

| Keybinding  | Application |
| ----------- | ----------- |
| `Hyper + T` | iTerm       |
| `Hyper + B` | Firefox     |
| `Hyper + E` | VS Code     |
| `Hyper + S` | Slack       |
| `Hyper + N` | Notion      |

### Utilities

| Keybinding  | Action                 |
| ----------- | ---------------------- |
| `Hyper + L` | Lock screen            |
| `Hyper + V` | Show clipboard history |
| `Hyper + W` | Show WiFi network      |
| `Hyper + A` | Toggle audio output    |

### Menu Bar

- **☕** - Caffeine is active (preventing sleep)
- **💤** - Caffeine is inactive

Click the menu bar icon to toggle.

## Customization

Edit [`init.lua`](init.lua) to customize:

- Change keybindings
- Add more applications to the launcher
- Modify window positions
- Add custom automation

## Tips

### Setting up Hyper Key

Since `Hyper` requires 4 modifiers, you might want to map a single key (like Caps Lock) to act as Hyper using [Karabiner-Elements](https://karabiner-elements.pqrs.org/):

```bash
brew install --cask karabiner-elements
```

### Auto-start Hammerspoon

Hammerspoon can be set to start automatically on login from System Preferences → Users & Groups → Login Items.

## Features

- ✅ Window management (halves, quarters, maximize)
- ✅ Multi-monitor support
- ✅ Quick application launcher
- ✅ Caffeine (prevent sleep)
- ✅ Clipboard history
- ✅ Audio device switcher
- ✅ System information display
- ✅ Auto-reload configuration

## Learn More

- [Hammerspoon Documentation](http://www.hammerspoon.org/docs/)
- [Hammerspoon API](http://www.hammerspoon.org/docs/index.html)
- [Sample Configs](https://github.com/Hammerspoon/hammerspoon/wiki/Sample-Configurations)
