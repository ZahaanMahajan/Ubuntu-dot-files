# Starship Configuration

A Gruvbox-themed Starship prompt with a powerline-style segmented layout, showing OS, user, directory, git state, active language runtimes, container context, and a live clock.

---

## What is Starship?

**Starship** is a fast, cross-shell prompt written in Rust. It works with Bash, Zsh, Fish, PowerShell, and more — a single config file (`starship.toml`) works everywhere. It reads your environment in milliseconds and renders a rich, informative prompt without slowing down the shell.

---

## Requirements

| Dependency | Why |
|---|---|
| **Starship** binary | The prompt renderer |
| A **Nerd Font** | Required to render OS icons and segment arrows |
| **Bash 4+** | Shell integration |

### Installing Starship

**Recommended (universal installer):**
```bash
curl -sS https://starship.rs/install.sh | sh
```

**Ubuntu / Debian (via Homebrew):**
```bash
brew install starship
```

**Arch Linux:**
```bash
sudo pacman -S starship
```

**macOS (Homebrew):**
```bash
brew install starship
```

---

## Setup

Starship is initialized at the bottom of `~/.bashrc` with:

```bash
eval "$(starship init bash)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
```

The `STARSHIP_CONFIG` variable points explicitly to this file, so Starship does not fall back to its default location. If you cloned the dotfiles repo and both lines are already in your `~/.bashrc`, no further setup is needed.

---

## File Layout

```
~/.config/starship/
└── starship.toml    # Full prompt config — palette, format, and all module settings
```

---

## Prompt Layout

The prompt is a single-line powerline strip rendered left-to-right, followed by a second line with the input character:

```
█  ubuntu  zahaan  ~/Developer/project   main ✓   Node v20   14:32  
❯
```

Each segment is separated by a powerline arrow (``) that transitions background colors:

| Segment | Background | Content |
|---------|-----------|---------|
| OS icon | `color_cream` (`#ebdbb2`) | Distro/OS icon (Ubuntu , macOS , etc.) |
| Username | `color_cream` (`#ebdbb2`) | Current user |
| Directory | `color_tan` (`#bdae93`) | Current path, truncated to 3 parts |
| Git branch + status | `color_yellow` (`#d79921`) | Branch name and change indicators |
| Language runtimes | `color_gray` (`#928374`) | Active runtime versions (Node, Python, Rust, Go, etc.) |
| Container context | `color_bg3` (`#665c54`) | Docker context, Conda env, or Pixi env |
| Time | `color_bg1` (`#3c3836`) | Current time in `HH:MM` |

The second line shows the **character** module:

| Symbol | Color | Meaning |
|--------|-------|---------|
| `❯` | Green | Last command succeeded |
| `❯` | Red | Last command failed |
| `❮` | Green | Vim normal mode |
| `❮` | Purple | Vim replace mode |
| `❮` | Yellow | Vim visual mode |

---

## Configuration Deep Dive

### Palette — Gruvbox Dark

All colors are defined in a named palette so you change a single value to retheme the entire prompt:

```toml
[palettes.gruvbox_dark]
color_cream  = '#ebdbb2'   # light foreground — OS/user background
color_tan    = '#bdae93'   # directory background
color_yellow = '#d79921'   # git segment background
color_gray   = '#928374'   # language runtimes background
color_bg3    = '#665c54'   # container context background
color_bg1    = '#3c3836'   # time segment background
color_bg0    = '#282828'   # terminal background (reference only)
color_green  = '#98971a'   # success character
color_red    = '#cc241d'   # error character
color_purple = '#b16286'   # vim replace mode character
```

### Directory

```toml
[directory]
truncation_length = 3
truncation_symbol = "…/"
```

Paths longer than 3 components are truncated from the left with `…/`. Common directories are substituted with icons:

| Directory | Icon |
|-----------|------|
| `Documents` | `󰈙 ` |
| `Downloads` | ` ` |
| `Music` | `󰝚 ` |
| `Pictures` | ` ` |
| `Developer` | `󰲹 ` |

### Git

```toml
[git_branch]
format = '[[ $symbol $branch ](fg:color_bg0 bg:color_yellow)]($style)'

[git_status]
format = '[[($all_status$ahead_behind )](fg:color_bg0 bg:color_yellow)]($style)'
```

Both the branch name and status indicators appear on the same yellow segment. Status characters follow Starship defaults (e.g. `✓` clean, `!` modified, `?` untracked, `⇡` ahead).

### Language Runtimes

All language modules share the same `color_gray` segment. They appear **only when their runtime is active** in the current directory (e.g. a `package.json` makes the Node module appear). Supported languages:

`C`, `C++`, `Rust`, `Go`, `Node.js`, `PHP`, `Java`, `Kotlin`, `Haskell`, `Python`

### Time

```toml
[time]
disabled = false
time_format = "%R"   # HH:MM (24-hour)
```

The clock updates every time the prompt is redrawn (i.e. after each command).

---

## OS Icons Reference

The `[os.symbols]` table maps OS names to Nerd Font icons. A few notable ones:

| OS | Icon |
|----|------|
| Ubuntu | `󰕈` |
| macOS | `󰀵` |
| Arch | `󰧇` |
| Debian | `󰧚` |
| Fedora | `󰧛` |
| Windows | `󰍲` |

---

## Color Theme — Gruvbox Dark

All colors derive from the [Gruvbox](https://github.com/morhetz/gruvbox) dark palette, matching the WezTerm, tmux, and Neovim themes used in the rest of these dotfiles.

| Role | Hex | Gruvbox name |
|------|-----|-------------|
| OS / username background | `#ebdbb2` | `fg1` / cream |
| Directory background | `#bdae93` | `fg3` / tan |
| Git segment | `#d79921` | bright yellow |
| Language runtimes | `#928374` | gray |
| Container context | `#665c54` | `bg3` |
| Time segment | `#3c3836` | `bg1` |
| Success prompt | `#98971a` | bright green |
| Error prompt | `#cc241d` | bright red |
