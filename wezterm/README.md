# WezTerm Configuration

A clean, Gruvbox-themed WezTerm setup with a JetBrains Mono Nerd Font and minimal UI chrome.

---

## What is WezTerm?

**WezTerm** is a modern, GPU-accelerated terminal emulator written in Rust. It supports true color, ligatures, image protocols, multiplexing (built-in tabs and panes), and is configured entirely in Lua. It works on Linux, macOS, and Windows.

---

## Requirements

| Dependency | Why |
|---|---|
| **WezTerm** | The terminal itself |
| **JetBrainsMono Nerd Font** | Primary font — provides programming ligatures and Nerd Font icons |
| `Noto Color Emoji` | Fallback font for emoji rendering |

### Installing WezTerm

**Ubuntu / Debian (official .deb):**
```bash
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update && sudo apt install wezterm
```

**Arch Linux:**
```bash
sudo pacman -S wezterm
```

**macOS (Homebrew):**
```bash
brew install --cask wezterm
```

### Installing JetBrainsMono Nerd Font

Download from [nerdfonts.com](https://www.nerdfonts.com/font-downloads), extract, and copy the `.ttf` files to `~/.local/share/fonts/`, then run:
```bash
fc-cache -fv
```

Or on Ubuntu, the package `fonts-jetbrains-mono` provides the base font (without Nerd Font icons). For the full Nerd Font version, manual installation is required.

---

## Setup

WezTerm automatically reads its config from `~/.config/wezterm/wezterm.lua`. If you have cloned the dotfiles repo, nothing extra is needed — just launch WezTerm.

---

## Configuration Overview

### Theme

```lua
config.color_scheme = "Gruvbox dark, hard (base16)"
```

Uses the **Gruvbox dark hard** variant, which has a slightly darker background (`#1d2021`) than the standard dark theme. This gives extra contrast for long coding sessions.

### Font

```lua
config.font = wezterm.font_with_fallback({
  { family = "JetBrainsMono Nerd Font", weight = "Medium" },
  { family = "JetBrains Mono",          weight = "Medium" },
  "Noto Color Emoji",
})
config.font_size = 13.0
config.line_height = 1.2
```

- **JetBrainsMono Nerd Font** is tried first; if not installed, it falls back to the plain **JetBrains Mono**, and finally to **Noto Color Emoji** for emoji glyphs.
- Font size `13.0` at line height `1.2` gives comfortable vertical spacing without wasting screen space.

### Window

```lua
config.window_background_opacity = 0.95
config.window_padding = { left = 12, right = 12, top = 12, bottom = 4 }
config.window_decorations = "RESIZE"
config.initial_cols = 140
config.initial_rows = 38
```

| Setting | Value | Effect |
|---------|-------|--------|
| `window_background_opacity` | `0.95` | Slight transparency — you can see the desktop behind the terminal |
| `window_padding` | `12 / 12 / 12 / 4` | Comfortable inner margin; less bottom padding because the tab bar sits there |
| `window_decorations` | `"RESIZE"` | Removes the standard title bar but keeps resize handles — gives a cleaner look |
| `initial_cols / rows` | `140 × 38` | Default window size when WezTerm opens |

### Tab Bar

```lua
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
```

- The tab bar is hidden when there is only **one tab** — no visual clutter for single-tab workflows.
- `use_fancy_tab_bar = false` uses the plain retro tab bar, which respects the custom Gruvbox colors defined below.
- The tab bar lives at the **bottom** of the window, keeping the content area at the top (matches most IDE conventions).

**Tab bar colors** are manually set to Gruvbox tones:

| State | Background | Foreground |
|-------|-----------|-----------|
| Active tab | `#282828` (bg0) | `#ebdbb2` (fg1), **bold** |
| Inactive tab | `#1d2021` (bg0_h) | `#928374` (gray) |
| Inactive (hover) | `#3c3836` (bg1) | `#ebdbb2` (fg1) |
| New-tab button | `#1d2021` | `#928374` |

### Cursor

```lua
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
```

A thin blinking bar cursor with a constant (non-eased) blink rhythm — blinks every 500 ms. The `Constant` ease avoids the fade-in/fade-out effect some terminals apply.

### Scrollback

```lua
config.scrollback_lines = 10000
config.enable_scroll_bar = false
```

10 000 lines of scrollback history are kept. The visual scroll bar is hidden to keep the UI clean; use the mouse wheel or keyboard shortcuts to scroll.

---

## Keybindings

These are *additions* to WezTerm's built-in defaults (which include things like `Ctrl+Shift+T` for a new tab, `Ctrl+Shift+W` to close, etc.).

| Key | Action |
|-----|--------|
| `Ctrl+Shift+D` | Split pane **horizontally** (new pane on the right) |
| `Ctrl+Shift+E` | Split pane **vertically** (new pane below) |
| `Ctrl+=` | Increase font size |
| `Ctrl+-` | Decrease font size |
| `Ctrl+0` | Reset font size to default |

### Useful built-in defaults (no config needed)

| Key | Action |
|-----|--------|
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Shift+W` | Close tab |
| `Ctrl+Tab` | Next tab |
| `Ctrl+Shift+Tab` | Previous tab |
| `Ctrl+Shift+C` | Copy selection |
| `Ctrl+Shift+V` | Paste |
| `Ctrl+Shift+F` | Search scrollback |
| `Ctrl+Shift+Space` | Quick-select mode (auto-highlight URLs, paths, etc.) |

---

## Miscellaneous

```lua
config.audible_bell = "Disabled"
config.check_for_updates = false
```

- The audible bell (terminal `\a` beep) is silenced.
- Automatic update checks are disabled — update WezTerm manually when you want to.
