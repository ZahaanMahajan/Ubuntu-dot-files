# Neovim Configuration

A full-featured Neovim setup built around **lazy.nvim**, the **Gruvbox** colorscheme, and a curated set of LSP, completion, and editing plugins. The leader key is `Space`.

---

## What is Neovim?

**Neovim** is a modern, extensible fork of Vim. It is a modal text editor — you switch between modes (Normal, Insert, Visual, etc.) rather than holding modifier keys. This takes time to learn but is extremely fast once it clicks.

If you are completely new to Vim/Neovim, run the built-in tutorial first:
```bash
nvim +Tutor
```

---

## Requirements

| Dependency | Minimum version | Why |
|---|---|---|
| **Neovim** | 0.10+ | Supports `vim.lsp.config` / `vim.lsp.enable` APIs |
| **git** | any | lazy.nvim uses it to clone plugins |
| **Node.js** | 18+ | Required by several LSP servers (`ts_ls`, `angularls`, etc.) |
| **gcc / make** | any | Builds `telescope-fzf-native` |
| A **Nerd Font** | any | Icons in nvim-tree, lualine, completion menu |
| **ripgrep** (`rg`) | any | Powers Telescope live grep |
| **fd** | any | Speeds up Telescope file search |

### Installing Neovim

**Ubuntu / Debian (via PPA for latest stable):**
```bash
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt update && sudo apt install neovim
```

**Arch Linux:**
```bash
sudo pacman -S neovim
```

**macOS (Homebrew):**
```bash
brew install neovim
```

---

## First Launch

1. Make sure this directory is at `~/.config/nvim/`.
2. Launch Neovim:
   ```bash
   nvim
   ```
3. **lazy.nvim** will automatically bootstrap itself (clones from GitHub) and then install all plugins.
4. Wait for all plugins to finish installing — you will see a progress UI.
5. Quit and reopen Neovim once to let everything initialize cleanly.
6. Mason will auto-install the configured LSP servers and formatters in the background.

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                     # Entry point — loads core & lazy
└── lua/
    └── zahaan/
        ├── core/
        │   ├── init.lua         # Loads settings.lua and keymaps.lua
        │   ├── settings.lua     # Vim options (tabs, search, encoding, etc.)
        │   └── keymaps.lua      # General key mappings (no plugins)
        ├── lazy.lua             # Bootstraps and configures lazy.nvim
        └── plugins/
            ├── colors.lua       # Gruvbox colorscheme
            ├── comment.lua      # Smart commenting
            ├── editor.lua       # Flash, git, Telescope (extended), mini.hipatterns
            ├── indent.lua       # Indent guide lines
            ├── lualine-nvim.lua # Status line
            ├── mason.lua        # LSP server & tool installer
            ├── none-ls.lua      # Formatting (prettierd, stylua)
            ├── nvim-autopairs.lua # Auto-close brackets/quotes
            ├── nvim-cmp.lua     # Completion engine
            ├── nvim-lspconfig.lua # LSP client config
            ├── nvim-tree.lua    # File explorer sidebar
            ├── telescope.lua    # Fuzzy finder (base keybindings)
            └── treesitter.lua   # Syntax highlighting & AST parsing
```

---

## Core Settings (`settings.lua`)

| Setting | Value | Effect |
|---------|-------|--------|
| `mapleader` | `Space` | Leader key for all `<leader>` mappings |
| `number` | `true` | Show line numbers |
| `expandtab` | `true` | Spaces instead of tabs |
| `shiftwidth` | `4` | 4-space indentation |
| `tabstop` | `4` | Tab width displayed as 4 spaces |
| `scrolloff` | `12` | Always keep 12 lines visible above/below cursor |
| `wrap` | `false` | Long lines do not wrap |
| `ignorecase` | `true` | Case-insensitive search … |
| `smartindent` | `true` | … unless you type a capital letter in the query |
| `splitbelow` | `true` | Horizontal splits open below |
| `splitright` | `true` | Vertical splits open to the right |
| `mouse` | `""` | Mouse disabled in Neovim |
| `inccommand` | `"split"` | Live preview of `:substitute` in a split |

---

## Plugin Manager — lazy.nvim

[lazy.nvim](https://github.com/folke/lazy.nvim) is a fast, modern plugin manager. It is bootstrapped automatically (no manual install step).

**Useful lazy.nvim commands:**

| Command | What it does |
|---------|-------------|
| `:Lazy` | Open the plugin UI |
| `:Lazy update` | Update all plugins |
| `:Lazy install` | Install any missing plugins |
| `:Lazy sync` | Update + clean unused plugins |
| `:Lazy clean` | Remove plugins no longer in config |

Lazy loads most plugins only when they are first needed (on events like `BufReadPre`, `InsertEnter`, etc.), which keeps startup fast.

---

## Plugins Overview

### Colorscheme — `gruvbox.nvim`

**File:** `plugins/colors.lua`

The [Gruvbox](https://github.com/ellisonleao/gruvbox.nvim) dark colorscheme is applied at startup with the highest priority (`priority = 1000`) to ensure it loads before any other UI plugin.

---

### Status Line — `lualine.nvim`

**File:** `plugins/lualine-nvim.lua`

A minimal status line showing only:
- **Section A** (left): A `✘` symbol when the buffer has unsaved changes (red background), otherwise blank (teal background).
- **Section B** (left): The file name with full path.

Everything else (mode, git, diagnostics, file type) is intentionally hidden for a clean look.

---

### File Explorer — `nvim-tree.lua`

**File:** `plugins/nvim-tree.lua`

A sidebar file tree with:
- Natural sort order (directories first, files numerically sorted)
- 35-column width
- Indent markers
- LSP diagnostics shown on folders that contain errors
- `netrw` disabled (nvim-tree takes over directory browsing)

**Keybindings:**

| Key | Action |
|-----|--------|
| `<leader>ee` | Toggle file explorer open/closed |
| `<leader>ef` | Open explorer and focus on the current file |
| `<leader>ec` | Collapse all folders in the tree |
| `<leader>er` | Refresh the tree |

---

### Fuzzy Finder — `telescope.nvim`

**File:** `plugins/editor.lua` + `plugins/telescope.lua`

[Telescope](https://github.com/nvim-telescope/telescope.nvim) is a fuzzy-finder overlay for searching files, text, symbols, diagnostics, and more. Extensions installed:
- **fzf-native** — fast C-based sorting
- **file-browser** — browse/create files from within Telescope

**Keybindings:**

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fp` | Find plugin files (inside lazy.nvim root) |
| `;f` | Find files (including hidden, respects `.gitignore`) |
| `;r` | Live grep across the project |
| `;b` | List open buffers |
| `;t` | Search help tags |
| `;;` | Resume the last Telescope picker |
| `;e` | Show LSP diagnostics |
| `;s` | Browse Treesitter symbols |

**Inside the file browser** (normal mode):

| Key | Action |
|-----|--------|
| `N` | Create a new file or directory |
| `h` | Go to parent directory |
| `/` | Enter insert mode to type a filter |
| `Ctrl+U` | Jump 10 entries up |
| `Ctrl+D` | Jump 10 entries down |

---

### Syntax Highlighting — `nvim-treesitter`

**File:** `plugins/treesitter.lua`

[Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) provides accurate, fast syntax highlighting by parsing source code into an AST (abstract syntax tree) instead of using regex patterns.

Languages installed automatically:
`vimdoc`, `javascript`, `typescript`, `lua`, `ruby`, `html`, `tsx`, `bash`, `markdown`, `markdown_inline`

Additional parsers can be installed with `:TSInstall <language>`.

---

### LSP (Language Server Protocol) — `nvim-lspconfig`

**File:** `plugins/nvim-lspconfig.lua`

Enables IDE-like features (go-to-definition, hover docs, rename, diagnostics) by connecting Neovim to language servers.

**Configured servers:**

| Server | Language |
|--------|---------|
| `ts_ls` | TypeScript / JavaScript |
| `html` | HTML |
| `cssls` | CSS / SCSS / Less |
| `angularls` | Angular (detects `angular.json`) |
| `lua_ls` | Lua (with Neovim runtime awareness) |

**Diagnostic signs:**

| Severity | Sign |
|----------|------|
| Error | `✖` |
| Warning | `` |
| Hint | `󰠠` |
| Info | `` |

Virtual text (inline inline error messages) is disabled — diagnostics appear only in the sign column and when you explicitly open a float with `<leader>d`.

**LSP Keybindings** (active when an LSP server is attached):

| Key | Action |
|-----|--------|
| `K` | Show hover documentation |
| `gd` | Go to definition |
| `gf` | Code actions (quick-fixes, imports) |
| `<leader>rn` | Rename symbol under cursor |
| `<leader>d` | Open diagnostics float for current line |

---

### LSP Server Installer — `mason.nvim`

**File:** `plugins/mason.lua`

[Mason](https://github.com/williamboman/mason.nvim) is a package manager for LSP servers, DAP adapters, linters, and formatters. It runs inside Neovim and manages binaries in `~/.local/share/nvim/mason/`.

**Auto-installed LSP servers:** `angularls`, `lua_ls`, `ts_ls`, `cssls`, `html`

**Auto-installed tools:** `prettier`, `stylua`, `eslint_d`, `prettierd`

Manage everything with `:Mason`.

---

### Formatting — `none-ls.nvim`

**File:** `plugins/none-ls.lua`

[none-ls](https://github.com/nvimtools/none-ls.nvim) (formerly null-ls) injects external tools into Neovim's LSP formatting pipeline.

**Formatters configured:**

| Formatter | Languages |
|-----------|---------|
| `prettierd` | JS, TS, HTML, CSS, JSON, YAML, etc. (not Markdown) |
| `stylua` | Lua |

**Auto-format on save:** Yes — a `BufWritePre` autocommand runs the formatter every time you save.

---

### Completion — `nvim-cmp`

**File:** `plugins/nvim-cmp.lua`

[nvim-cmp](https://github.com/hrsh7th/nvim-cmp) is the completion engine. Completion sources (in priority order):

1. **LSP** — symbols from the language server
2. **LuaSnip** — snippet expansion
3. **Buffer** — words already in the current buffer
4. **Path** — file system paths

Completion icons come from `lspkind.nvim` (VS Code-style pictograms).

**Completion keybindings** (active in Insert mode when the menu is open):

| Key | Action |
|-----|--------|
| `Tab` | Select next item / expand snippet |
| `Shift+Tab` | Select previous item / jump backwards in snippet |
| `Ctrl+J` | Select next item |
| `Ctrl+K` | Select previous item |
| `Ctrl+Space` | Force open completion menu |
| `Ctrl+E` | Close completion menu |
| `Enter` | Confirm selected item |
| `Ctrl+B` / `Ctrl+F` | Scroll documentation popup |

---

### Snippets — `LuaSnip` + `friendly-snippets`

Bundled inside `nvim-cmp`. [LuaSnip](https://github.com/L3MON4D3/LuaSnip) handles snippet expansion. [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) provides a large collection of VS Code-compatible snippets for most languages.

---

### Auto-pairs — `nvim-autopairs`

**File:** `plugins/nvim-autopairs.lua`

Automatically inserts the closing bracket/quote when you type an opening one (`(` → `()`, `"` → `""`). Treesitter-aware — for example, it does not auto-pair inside Lua string nodes. Integrates with nvim-cmp so confirming a completion does not double up on closing brackets.

---

### Commenting — `Comment.nvim`

**File:** `plugins/comment.lua`

Smart commenting with Treesitter context awareness (correctly handles JSX/TSX files where comment syntax differs per embedded language).

**Default keybindings (Comment.nvim):**

| Key | Mode | Action |
|-----|------|--------|
| `gcc` | Normal | Toggle comment on current line |
| `gc` | Visual | Toggle comment on selection |
| `gbc` | Normal | Toggle block comment on current line |

---

### Indent Guides — `indent-blankline.nvim`

**File:** `plugins/indent.lua`

Draws a `|` character at each indentation level so you can visually track nested code blocks. Scope highlighting is disabled (no special color on the innermost scope).

---

### Flash Navigation — `flash.nvim`

**File:** `plugins/editor.lua`

[Flash](https://github.com/folke/flash.nvim) provides instant jump-to-anywhere navigation. Type `s` followed by characters and it highlights matching positions with labels you can jump to instantly.

---

### Git Integration — `git.nvim`

**File:** `plugins/editor.lua`

| Key | Action |
|-----|--------|
| `<leader>gb` | Show git blame for current line |
| `<leader>go` | Open current file/line in the browser (GitHub) |

---

### Color Highlighting — `mini.hipatterns`

**File:** `plugins/editor.lua`

Highlights HSL color values in source files (e.g. `hsl(210, 50%, 50%)`) with a background color matching the actual color. Useful when editing CSS or design tokens.

---

## General Keybindings (`keymaps.lua`)

These keybindings are always active (no plugin required).

### Editing

| Key | Mode | Action |
|-----|------|--------|
| `x` | Normal | Delete character without copying to register |
| `dw` | Normal | Delete word backwards without copying to register |
| `+` | Normal | Increment number under cursor (`Ctrl+A`) |
| `-` | Normal | Decrement number under cursor (`Ctrl+X`) |
| `Ctrl+A` | Normal | Select all text in file |

### Tabs

| Key | Mode | Action |
|-----|------|--------|
| `te` | Normal | Open a new tab (`:tabedit`) |
| `Tab` | Normal | Go to next tab |
| `Shift+Tab` | Normal | Go to previous tab |

### Buffers

| Key | Action |
|-----|--------|
| `<leader>bd` | Delete (close) current buffer |
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |
| `<leader>bb` | Switch to last buffer |
| `<leader>ba` | Delete all buffers |

### Window Splits

| Key | Action |
|-----|--------|
| `ss` | Horizontal split |
| `sv` | Vertical split |
| `sh` | Move focus to left window |
| `sl` | Move focus to right window |
| `sk` | Move focus to window above |
| `sj` | Move focus to window below |
| `Ctrl+W + ←` | Shrink window width |
| `Ctrl+W + →` | Grow window width |
| `Ctrl+W + ↑` | Grow window height |
| `Ctrl+W + ↓` | Shrink window height |

### Typing Practice — Typr

| Key | Action |
|-----|--------|
| `ty` | Open Typr typing practice |
| `tys` | Show Typr statistics |

---

## Updating Plugins

```vim
:Lazy update
```

Or open `:Lazy` and press `U`.

## Adding a New Plugin

Create a new file in `lua/zahaan/plugins/`, return a valid lazy.nvim plugin spec table, and reopen Neovim. lazy.nvim will auto-install it.

```lua
-- lua/zahaan/plugins/example.lua
return {
  "author/plugin-name",
  config = function()
    require("plugin-name").setup({})
  end,
}
```
