# Hammerspoon

Keyboard-driven window management, app launching, layouts, clipboard history, text expansion, and system controls.

## Setup

From the repository root:

```sh
make hammerspoon
```

The installer installs Hammerspoon through Homebrew when necessary, backs up an existing `~/.hammerspoon`, and links this directory in its place. Open Hammerspoon afterward, grant Accessibility access, and reload the configuration.

Hyper shortcuts require Karabiner-Elements with Caps Lock mapped to F18:

```sh
brew install --cask karabiner-elements
```

Set `MY_EMAIL` in `~/.zshrc.local` to customize the `@@` text expansion.

## Shortcuts

### Windows

| Shortcut | Action |
| --- | --- |
| <kbd>⌘⌥⌃</kbd> + <kbd>←/→</kbd> | Left or right half |
| <kbd>⌘⌥⌃</kbd> + <kbd>↑</kbd> | Maximize |
| <kbd>⌘⌥⌃</kbd> + <kbd>↓</kbd> | Center at 70% |
| <kbd>⌘⌥⌃⇧</kbd> + <kbd>←/→/↑/↓</kbd> | Screen quarters |
| <kbd>⌘⌥⌃</kbd> + <kbd>N/P</kbd> | Next or previous display |
| <kbd>⌘⌥⌃</kbd> + <kbd>Space</kbd> | Window hints |
| <kbd>Hyper</kbd> + <kbd>H/J/K/L</kbd> | Left, center, maximize, right |
| <kbd>Hyper</kbd> + <kbd>1/2/3</kbd> | Left, center, or right third |

### Applications

| Shortcut | Application |
| --- | --- |
| <kbd>⌥⇧</kbd> + <kbd>1/2/3/4</kbd> | Firefox, Calendar, Reminders, Notes |
| <kbd>⌥⇧</kbd> + <kbd>9/0</kbd> | Finder or Chrome |
| <kbd>⌥⇧</kbd> + <kbd>T/C/M/N</kbd> | iTerm, VS Code, Mail, Notion |
| <kbd>⌥⇧</kbd> + <kbd>P</kbd> | Previous application |
| <kbd>Hyper</kbd> + <kbd>T/B/E/N/M</kbd> | iTerm, Chrome, VS Code, Notion, Mail |

### Layouts and utilities

| Shortcut | Action |
| --- | --- |
| <kbd>⌘⌥⌃</kbd> + <kbd>1</kbd> | Development layout |
| <kbd>⌘⌥⌃</kbd> + <kbd>2</kbd> | Writing layout |
| <kbd>⌘⌥⌃</kbd> + <kbd>3</kbd> | Communication layout |
| <kbd>⌘⌥</kbd> + <kbd>V</kbd> | Clipboard history |
| <kbd>⌘⌥⌃</kbd> + <kbd>R</kbd> | Reload configuration |
| <kbd>⌘⌥⌃</kbd> + <kbd>O</kbd> | Open configuration in VS Code |
| <kbd>⌘⌥⌃</kbd> + <kbd>C</kbd> | Toggle display caffeination |
| <kbd>⌘⌥⌃</kbd> + <kbd>H</kbd> | Show shortcut help |

## Text expansion

| Trigger | Result |
| --- | --- |
| `@@` | `MY_EMAIL` value |
| `ddate` | Current date |
| `ttime` | Current time |
| `dts` | Current date and time |
| `shrug`, `lenny` | Text faces |
| `check`, `arrow`, `lambda` | `✓`, `→`, `λ` |

## Code structure

- `init.lua` initializes each module.
- `modules/window-management.lua` owns window movement.
- `modules/app-launcher.lua` owns application shortcuts.
- `modules/hyper-key.lua` owns Hyper bindings.
- `modules/layouts.lua` owns multi-application layouts.
- `modules/clipboard.lua` owns clipboard history.
- `modules/text-expansion.lua` owns expansions.
- `modules/system.lua` owns reload, editor, caffeination, and help actions.

## Troubleshooting

- Missing hotkeys: confirm Accessibility permission for Hammerspoon.
- Missing Hyper shortcuts: confirm Caps Lock maps to F18 in Karabiner-Elements.
- Configuration not reloading: open the Hammerspoon console and check Lua errors.
