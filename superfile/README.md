# Superfile Configuration

A pretty, modern, terminal-based file manager dressed in **Gruvbox Dark Hard** with full Vim-style navigation, pinned shortcuts, image previews, and `cd-on-quit` integration with the parent shell.

---

## What is Superfile?

**Superfile** (`spf`) is a fast, TUI file manager written in Go. It runs entirely inside your terminal but offers a multi-panel layout reminiscent of GUI file managers — sidebar with home shortcuts, multiple file panels you can open side-by-side, a live file/image preview pane, plus a metadata strip, process bar, and clipboard panel. It is configured through plain TOML files and supports custom themes, plugins, and a fully remappable hotkey scheme.

---

## Requirements

| Dependency | Why |
|---|---|
| **Superfile** binary | The file manager itself |
| A **Nerd Font** | Sidebar icons, file-type glyphs, footer symbols |
| **Neovim** | Default editor / dir-editor (configurable) |
| **bat** *(optional)* | Alternative code previewer (built-in chroma used otherwise) |
| **exiftool** *(optional)* | Detailed metadata plugin |
| **zoxide** *(optional)* | Smart directory jumping (`z` key) |

### Installing Superfile

**Universal installer (recommended):**
```bash
bash -c "$(curl -sLo- https://superfile.netlify.app/install.sh)"
```

**Arch Linux (AUR):**
```bash
yay -S superfile
```

**macOS (Homebrew):**
```bash
brew install superfile
```

**Go:**
```bash
go install github.com/yorukot/superfile@latest
```

Verify it works:
```bash
spf --version
```

---

## Setup

Superfile reads its config automatically from `~/.config/superfile/`. If you cloned the dotfiles repo, nothing extra is required — just run:

```bash
spf
```

### `cd on quit` Shell Integration

This config enables `cd_on_quit = true`, which means superfile writes its last directory to a file when you exit. To have your shell actually `cd` there, add a wrapper to your shell config:

```bash
# ~/.bashrc
spf() {
  command spf "$@"
  local last_dir
  last_dir=$(cat ~/.local/state/superfile/lastdir 2>/dev/null)
  [[ -d "$last_dir" ]] && cd "$last_dir"
}
```

Now quitting superfile with `q` drops you into the directory you were browsing.

---

## File Layout

```
~/.config/superfile/
├── config.toml      # Main behavior config — editor, previews, sorting, styling
├── hotkeys.toml     # Every keybinding (global, typing-mode, mode-specific)
└── theme/           # Bundled color themes (gruvbox-dark-hard is active)
    ├── gruvbox-dark-hard.toml
    ├── catppuccin-mocha.toml
    ├── tokyonight.toml
    └── … (20+ more)
```

---

## Configuration Deep Dive

### Editor & Quit Behavior

```toml
editor = "nvim"
dir_editor = "nvim"
cd_on_quit = true
```

- **`editor` / `dir_editor`** — pressing `e` opens the file in Neovim; `E` opens the current directory in Neovim (useful with `nvim-tree`/`oil.nvim`).
- **`cd_on_quit`** — when you press `q`, superfile writes its last directory so your shell can follow you there (see the wrapper above).

### Previews

```toml
default_open_file_preview = true
show_image_preview = true
show_panel_footer_info = true
code_previewer = ""        # "" = built-in chroma, "bat" = use bat
file_preview_width = 0     # 0 = same width as the file panel
```

The right-hand preview pane is always open by default — hover any file and see its contents (or thumbnail for images). Toggle on demand with `f`.

### Sorting

```toml
default_sort_type = 0       # 0=Name, 1=Size, 2=Modified, 3=Type
sort_order_reversed = false
case_sensitive_sort = false
```

Press `o` in-app to open the sort menu and switch on the fly; `R` reverses order.

### Sidebar & Panels

```toml
sidebar_width = 20          # 5–20 recommended; 0 to hide
file_panel_extra_columns = 0
file_panel_name_percent = 50
nerdfont = true
show_select_icons = true
transparent_background = false
```

The sidebar shows **Home**, **Downloads**, **Documents**, **Pictures**, **Videos**, **Music**, **Templates**, **PublicShare**, **Trash**, plus a **Pinned** section and any active disks. Pin the current directory at any time with `P`.

### Borders — Rounded Style

```toml
border_top_left = '╭'
border_top_right = '╮'
border_bottom_left = '╰'
border_bottom_right = '╯'
```

Rounded corners match the visual style used across the rest of the dotfiles (Neovim, tmux).

### Theme

```toml
theme = "gruvbox-dark-hard"
```

Picks `theme/gruvbox-dark-hard.toml`, keeping superfile in lockstep with WezTerm, tmux, Neovim, and Starship. Drop in any other file from `theme/` (e.g. `tokyonight`, `catppuccin-mocha`, `nord`) to retheme — no other change required.

### Plugins (off by default)

```toml
metadata = false             # exiftool — rich metadata in the footer
enable_md5_checksum = false  # md5sum — show hashes
zoxide_support = false       # zoxide — `z` key for smart jumps
```

Flip any of these to `true` once you have the underlying CLI installed.

---

## Keybindings Reference

### Basics

| Key | Action |
|-----|--------|
| `enter` / `l` | Confirm / enter directory |
| `h` / `←` / `bspc` | Parent directory |
| `q` | Quit (and `cd` if shell wrapper is set) |
| `esc` | Force quit / cancel |
| `?` | Open help menu |

### Navigation (Vim-style)

| Key | Action |
|-----|--------|
| `j` / `↓` | Move down |
| `k` / `↑` | Move up |
| `PgDn` | Page down |
| `PgUp` | Page up |
| `/` | Search bar (filter current directory) |
| `z` | Open zoxide picker *(requires `zoxide_support = true`)* |

### File Panels

| Key | Action |
|-----|--------|
| `n` | Open a **new** file panel |
| `w` | **Close** current file panel |
| `tab` / `L` | Next file panel |
| `shift+left` / `H` | Previous file panel |
| `f` | Toggle file preview panel |
| `o` | Open sort options menu |
| `R` | Toggle reverse sort |
| `P` | Pin current directory to sidebar |

### Focus Switching

| Key | Action |
|-----|--------|
| `s` | Focus sidebar |
| `m` | Focus metadata strip |
| `p` | Focus process bar |

### File Operations

| Key | Action |
|-----|--------|
| `ctrl+n` | Create new file/directory |
| `ctrl+r` | Rename selected item |
| `ctrl+c` | Copy |
| `ctrl+x` | Cut |
| `ctrl+v` / `ctrl+w` | Paste |
| `ctrl+d` / `del` | Delete (to trash) |
| `D` | **Permanently** delete (skips trash) |
| `ctrl+a` | Compress into archive |
| `ctrl+e` | Extract archive |

### Editor Actions

| Key | Action |
|-----|--------|
| `e` | Open file in editor (`nvim`) |
| `E` | Open current directory in editor |

### Selection Mode

Press `v` to toggle selection mode, then:

| Key | Action |
|-----|--------|
| `shift+↓` / `J` | Extend selection down |
| `shift+↑` / `K` | Extend selection up |
| `A` | Select all items in panel |

### Other

| Key | Action |
|-----|--------|
| `:` | Open command line |
| `>` | Open spf prompt |
| `c` | Copy present working directory |
| `ctrl+p` | Copy path of selected file |
| `.` | Toggle hidden (dot) files |
| `F` | Toggle footer visibility |

### Typing Mode (rename, search, command line)

| Key | Action |
|-----|--------|
| `enter` | Confirm input |
| `ctrl+c` / `esc` | Cancel input |

---

## Color Theme — Gruvbox Dark Hard

The active theme (`theme/gruvbox-dark-hard.toml`) uses the same palette as the rest of the dotfiles, so superfile blends seamlessly into the WezTerm/tmux/Neovim/Starship visual identity:

| Role | Hex | Gruvbox name |
|------|-----|-------------|
| Background | `#1d2021` | `bg0_h` |
| Foreground | `#ebdbb2` | `fg1` |
| Accent (active border / cursor) | `#fabd2f` | bright yellow |
| Directory | `#83a598` | bright blue |
| Inactive text | `#928374` | gray |

To switch themes, just change `theme = "..."` in `config.toml` to any filename in `theme/` (without the `.toml`).
