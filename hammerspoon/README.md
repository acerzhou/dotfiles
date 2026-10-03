# Hammerspoon Configuration

A comprehensive Hammerspoon configuration with window management, app launching, clipboard history, text expansion, and more.

---

## Table of Contents

1. [Window Management](#window-management)
2. [App Launcher & Switching](#app-launcher--switching)
3. [Hyper Key (Vim-style Navigation)](#hyper-key-vim-style-navigation)
4. [Clipboard Manager](#clipboard-manager)
5. [Text Expansion](#text-expansion)
6. [Window Layouts (Workspaces)](#window-layouts-workspaces)
7. [System Utilities](#system-utilities)

---

## Window Management

Position and resize the focused window with keyboard shortcuts.

| Shortcut                          | Function                              |
| --------------------------------- | ------------------------------------- |
| <kbd>⌘⌥⌃</kbd> + <kbd>←</kbd>     | Move window to left half              |
| <kbd>⌘⌥⌃</kbd> + <kbd>→</kbd>     | Move window to right half             |
| <kbd>⌘⌥⌃</kbd> + <kbd>↑</kbd>     | Maximize window                       |
| <kbd>⌘⌥⌃</kbd> + <kbd>↓</kbd>     | Center window (70% of screen)         |
| <kbd>⌘⌥⌃⇧</kbd> + <kbd>←</kbd>    | Move to top-left quarter              |
| <kbd>⌘⌥⌃⇧</kbd> + <kbd>→</kbd>    | Move to top-right quarter             |
| <kbd>⌘⌥⌃⇧</kbd> + <kbd>↓</kbd>    | Move to bottom-right quarter          |
| <kbd>⌘⌥⌃⇧</kbd> + <kbd>↑</kbd>    | Move to bottom-left quarter           |
| <kbd>⌘⌥⌃</kbd> + <kbd>N</kbd>     | Move window to next screen            |
| <kbd>⌘⌥⌃</kbd> + <kbd>P</kbd>     | Move window to previous screen        |
| <kbd>⌘⌥⌃</kbd> + <kbd>Space</kbd> | Show window hints for quick switching |

---

## App Launcher & Switching

Quick launch and switch between applications.

| Shortcut                     | Application            |
| ---------------------------- | ---------------------- |
| <kbd>⌥⇧</kbd> + <kbd>1</kbd> | Firefox                |
| <kbd>⌥⇧</kbd> + <kbd>2</kbd> | Calendar               |
| <kbd>⌥⇧</kbd> + <kbd>3</kbd> | Reminders              |
| <kbd>⌥⇧</kbd> + <kbd>4</kbd> | Notes                  |
| <kbd>⌥⇧</kbd> + <kbd>9</kbd> | Finder                 |
| <kbd>⌥⇧</kbd> + <kbd>0</kbd> | Google Chrome          |
| <kbd>⌥⇧</kbd> + <kbd>T</kbd> | iTerm                  |
| <kbd>⌥⇧</kbd> + <kbd>C</kbd> | Visual Studio Code     |
| <kbd>⌥⇧</kbd> + <kbd>M</kbd> | Mail                   |
| <kbd>⌥⇧</kbd> + <kbd>N</kbd> | Notion                 |
| <kbd>⌥⇧</kbd> + <kbd>P</kbd> | Switch to previous app |

---

## Hyper Key (Vim-style Navigation)

Uses Caps Lock as Hyper key (requires Karabiner-Elements to map Caps Lock → F18).

### Window Movement (Vim-style)

| Shortcut                        | Function          |
| ------------------------------- | ----------------- |
| <kbd>Hyper</kbd> + <kbd>H</kbd> | Left half screen  |
| <kbd>Hyper</kbd> + <kbd>L</kbd> | Right half screen |
| <kbd>Hyper</kbd> + <kbd>K</kbd> | Full screen       |
| <kbd>Hyper</kbd> + <kbd>J</kbd> | Center window     |

### Screen Thirds

| Shortcut                        | Function     |
| ------------------------------- | ------------ |
| <kbd>Hyper</kbd> + <kbd>1</kbd> | Left third   |
| <kbd>Hyper</kbd> + <kbd>2</kbd> | Center third |
| <kbd>Hyper</kbd> + <kbd>3</kbd> | Right third  |

### Quick App Access

| Shortcut                        | Application        |
| ------------------------------- | ------------------ |
| <kbd>Hyper</kbd> + <kbd>T</kbd> | iTerm              |
| <kbd>Hyper</kbd> + <kbd>B</kbd> | Google Chrome      |
| <kbd>Hyper</kbd> + <kbd>E</kbd> | Visual Studio Code |
| <kbd>Hyper</kbd> + <kbd>N</kbd> | Notion             |
| <kbd>Hyper</kbd> + <kbd>M</kbd> | Mail               |

---

## Clipboard Manager

Quick access to clipboard history with preview.

| Shortcut                     | Function                               |
| ---------------------------- | -------------------------------------- |
| <kbd>⌘⌥</kbd> + <kbd>V</kbd> | Show clipboard history (last 50 items) |

**Features:**

- Automatically tracks clipboard changes
- Shows item preview and position in history
- Click to paste item automatically
- Maximum history size: 50 items

---

## Text Expansion

Auto-expand shortcuts to commonly used text and symbols.

| Trigger  | Expansion                                    |
| -------- | -------------------------------------------- |
| `@@`     | Your email address (from `MY_EMAIL` env var) |
| `ddate`  | Current date (YYYY-MM-DD)                    |
| `ttime`  | Current time (HH:MM)                         |
| `dts`    | Date + time (YYYY-MM-DD HH:MM:SS)            |
| `shrug`  | ¯\\_(ツ)_/¯                                  |
| `lenny`  | ( ͡° ͜ʖ ͡°)                                  |
| `check`  | ✓                                            |
| `arrow`  | →                                            |
| `lambda` | λ                                            |

**Features:**

- Real-time text replacement as you type
- Resets word tracking on space/enter
- Add custom expansions via `M.addExpansion(trigger, replacement)`

---

## Window Layouts (Workspaces)

Apply predefined window arrangements for different work contexts.

| Shortcut                      | Layout            | Applications                                                           |
| ----------------------------- | ----------------- | ---------------------------------------------------------------------- |
| <kbd>⌘⌥⌃</kbd> + <kbd>1</kbd> | **Dev**           | VS Code (60%), iTerm (40% top), Firefox (40% mid), Docker (40% bottom) |
| <kbd>⌘⌥⌃</kbd> + <kbd>2</kbd> | **Writing**       | Notion or Notes (70% centered)                                         |
| <kbd>⌘⌥⌃</kbd> + <kbd>3</kbd> | **Communication** | Mail (50% left), Calendar (50% top-right), Slack (50% bottom-right)    |

**Features:**

- Automatically launches apps if not running
- Positions windows with smooth animation (0.15s)
- Add custom layouts via `M.addLayout(name, layout)`

---

## System Utilities

System-level utilities and configuration management.

| Shortcut                      | Function                               |
| ----------------------------- | -------------------------------------- |
| <kbd>⌘⌥⌃</kbd> + <kbd>R</kbd> | Reload Hammerspoon configuration       |
| <kbd>⌘⌥⌃</kbd> + <kbd>O</kbd> | Open config folder in VS Code          |
| <kbd>⌘⌥⌃</kbd> + <kbd>C</kbd> | Toggle caffeinate mode (prevent sleep) |
| <kbd>⌘⌥⌃</kbd> + <kbd>H</kbd> | Show help/available hotkeys            |

**Features:**

- Auto-reload configuration on file changes
- Caffeinate toggle prevents display sleep
- Quick access to config files
- Help display with keyboard shortcuts

---

## Configuration Files

```text
~/.hammerspoon/
├── init.lua                      # Main entry point
├── README.md                     # This file
└── modules/
    ├── window-management.lua     # Window positioning and layouts
    ├── app-launcher.lua          # Application launcher and switcher
    ├── hyper-key.lua             # Hyper key bindings
    ├── clipboard.lua             # Clipboard history manager
    ├── text-expansion.lua        # Text expansion engine
    ├── layouts.lua               # Workspace layouts
    └── system.lua                # System utilities
```

---

## Installation & Setup

### Prerequisites

- macOS
- Homebrew (to install Hammerspoon if it is not already installed)
- [Karabiner-Elements](https://karabiner-elements.pica4.jp/) (for Hyper key support)

### Installation Steps

1. **Install and configure Hammerspoon** from the repository root:

   ```bash
   make hammerspoon
   # Or run the standalone installer from any directory
   bash /path/to/dotfiles/hammerspoon/install.sh
   ```

   The installer installs Hammerspoon via Homebrew if needed and links this directory to `~/.hammerspoon`. Existing configuration is backed up to a unique `~/.dotfiles-backups/<backup-name>/.hammerspoon` path. Repeated runs keep the correct symlink in place. If Homebrew is missing, run `make install` first.

2. **Install Karabiner-Elements** (optional, for Hyper key):

   ```bash
   brew install --cask karabiner-elements
   ```

   Configure Caps Lock → F18 in Karabiner.

3. **Open Hammerspoon**, enable Accessibility access when prompted, and reload the configuration from its menu.

4. **Set environment variable** (for email expansion):

   ```bash
   export MY_EMAIL="your.email@example.com"
   ```

---

## Customization

### Add Custom Text Expansions

```lua
local textExpansion = require("modules.text-expansion")
textExpansion.addExpansion("brb", "Be right back!")
```

### Add Custom Window Layouts

```lua
local layouts = require("modules.layouts")
layouts.addLayout("custom", {
    {"App Name", nil, nil, {0, 0, 0.5, 1}},
})
```

---

## Troubleshooting

| Issue                 | Solution                                                                                   |
| --------------------- | ------------------------------------------------------------------------------------------ |
| Hotkeys not working   | Ensure Hammerspoon has accessibility permissions (System Preferences → Security & Privacy) |
| Hyper key not working | Install and configure Karabiner-Elements, map Caps Lock to F18                             |
| Config not reloading  | Check file permissions and ensure `.lua` files are in correct directory                    |

---

## Tips & Tricks

- Use window management shortcuts in combination for complex layouts
- Clipboard history shows 50 recent items by default
- Text expansion works globally across all applications
- Layouts automatically launch and position apps
- Check `hs.logger.setLogLevel()` in console for debugging

---

## License

Personal configuration. Modify as needed.
