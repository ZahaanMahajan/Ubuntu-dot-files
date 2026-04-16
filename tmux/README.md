# Tmux Configuration

A minimal, Gruvbox-themed tmux setup tuned for WezTerm and a Vim-style keyboard workflow.

---

## What is tmux?

**tmux** is a *terminal multiplexer* — it lets you run multiple terminal sessions inside a single window, split your screen into independent panes, and keep sessions alive even after you disconnect (great for remote work over SSH). Think of it as a tiling window manager that lives entirely inside your terminal.

---

## Requirements

| Dependency | Minimum version | Why it is needed |
|---|---|---|
| **tmux** | 3.2 | Core application |
| **WezTerm** | any recent | True-color & undercurl passthrough |
| A **Nerd Font** | any | Status-line icons render correctly |

### Installing tmux

**Ubuntu / Debian:**
```bash
sudo apt install tmux
```

**Arch Linux:**
```bash
sudo pacman -S tmux
```

**macOS (Homebrew):**
```bash
brew install tmux
```

---

## Setup

1. Make sure this directory is at `~/.config/tmux/` (it should already be if you cloned the dotfiles repo).
2. Launch tmux for the first time:
   ```bash
   tmux
   ```
   tmux reads `~/.config/tmux/tmux.conf` automatically (tmux 3.1+).
3. **Reload config inside a running session** at any time:
   ```
   prefix + r
   ```
   You will see a brief `Reloaded!` message.

> **What is the prefix key?**
> The prefix is `Ctrl+B`. You press it first, release it, and then press the next key. Almost every tmux command starts this way.

---

## File Layout

```
~/.config/tmux/
├── tmux.conf          # Main config — terminal, keys, theme
└── statusline.conf    # Status bar layout & colors (sourced by tmux.conf)
```

---

## Configuration Deep Dive

### Terminal & True Color

```conf
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",tmux-256color:Tc"
set -ga terminal-overrides ",tmux-256color:Su=\e[4:%p1%dm"
```

- **`tmux-256color`** — WezTerm understands this terminal type natively. Never use `xterm-256color` inside tmux or colors will look wrong.
- **`Tc`** override — enables 24-bit *true color* (16 million colors instead of 256), so your colorschemes look exactly right.
- **`Su`** override — enables *undercurl* rendering (the wavy red/yellow underlines that LSP diagnostic plugins use).

### Image Preview Passthrough (Yazi)

```conf
set -g allow-passthrough on
set -ga update-environment TERM
set -ga update-environment TERM_PROGRAM
```

`allow-passthrough` lets terminal escape sequences flow through tmux to WezTerm unchanged, which is required for inline image rendering in tools like the [Yazi](https://github.com/sxyazi/yazi) file manager.

### Escape Time

```conf
set -sg escape-time 10
```

Reduces the delay tmux waits after `Esc` before deciding it is not part of a key sequence. Without this, pressing `Esc` in Neovim feels sluggish.

### History

```conf
set-option -g history-limit 64096
```

Stores up to ~64 000 lines of scrollback per pane.

---

## Keybindings Reference

### General

| Key | Action |
|-----|--------|
| `prefix r` | Reload `tmux.conf` |
| `prefix o` | Open the current pane's directory in the OS file manager |
| `prefix e` | Kill every pane **except** the active one |

### Creating & Splitting Panes

| Key | Action |
|-----|--------|
| `prefix \|` | Split pane **horizontally** (left/right) |
| `prefix -` | Split pane **vertically** (top/bottom) |

> Mnemonic: `|` looks like a vertical divider → panes sit side by side. `-` looks like a horizontal divider → panes stack above/below.

### Navigating Between Panes (Vim-style)

| Key | Action |
|-----|--------|
| `prefix h` | Focus pane to the **left** |
| `prefix l` | Focus pane to the **right** |
| `prefix k` | Focus pane **above** |
| `prefix j` | Focus pane **below** |

### Resizing Panes

All of these are *repeatable* — hold the prefix and keep pressing the key to keep resizing.

| Key | Action |
|-----|--------|
| `prefix Ctrl+h` | Shrink pane **leftward** by 5 columns |
| `prefix Ctrl+l` | Grow pane **rightward** by 5 columns |
| `prefix Ctrl+k` | Grow pane **upward** by 5 rows |
| `prefix Ctrl+j` | Shrink pane **downward** by 5 rows |
| `prefix m` | **Zoom** active pane to fullscreen (press again to unzoom) |

### Managing Windows (Tabs)

| Key | Action |
|-----|--------|
| `prefix c` | Create a new window |
| `prefix n` | Go to the **next** window |
| `prefix p` | Go to the **previous** window |
| `Ctrl+Shift+Left` | Move the current window **left** in the tab bar |
| `Ctrl+Shift+Right` | Move the current window **right** in the tab bar |

### Copy Mode (Vi-style)

Enter copy mode with `prefix [`, navigate with standard Vi keys, then:

| Key | Action |
|-----|--------|
| `v` | Start a selection |
| `y` | Yank (copy) the selection to the tmux clipboard |
| `q` | Exit copy mode |

### Mouse Support

Mouse is fully enabled. You can:
- **Click** a pane to give it focus
- **Scroll** to browse pane history
- **Drag** a pane border to resize

---

## Status Line

The status bar refreshes every **1 second** and follows this layout:

```
 session  username          window1  [ACTIVE WINDOW]  window3          2025-01-15  14:32:07  hostname
```

| Region | Background color | Content |
|--------|-----------------|---------|
| Far left | Bright yellow `#fabd2f` | Session name |
| Left pill | Warm yellow `#d79921` | Current username |
| Inactive windows | Muted `bg1 #3c3836` | Window index + current directory basename |
| Active window | Bright yellow `#fabd2f` | Window index + current directory basename |
| Right — date | Dark gray `#504945` | `YYYY-MM-DD` |
| Right — time | Medium gray `#665c54` | `HH:MM:SS` |
| Far right | Light gray `#928374` | Hostname |

---

## Color Theme — Gruvbox Dark

All colors come from the [Gruvbox](https://github.com/morhetz/gruvbox) dark palette. Here is a quick reference for the roles used in this config:

| Role | Hex | Gruvbox name |
|------|-----|-------------|
| Main background | `#282828` | `bg0` |
| Active pane border | `#fabd2f` | bright yellow |
| Inactive border | `#3c3836` | `bg1` |
| Active text | `#ebdbb2` | `fg` |
| Inactive / muted text | `#a89984` | `fg4` |
| Copy-mode highlight | `#fabd2f` on `#282828` | — |
| Message bar | `#ebdbb2` on `#3c3836` | — |
