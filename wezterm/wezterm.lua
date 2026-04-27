-- ╔══════════════════════════════════════════════════╗
-- ║           WezTerm · Gruvbox Dark                 ║
-- ╚══════════════════════════════════════════════════╝
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ── Theme ──────────────────────────────────────────
config.color_scheme = "Gruvbox dark, hard (base16)"

-- ── Font ───────────────────────────────────────────
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font", weight = "Medium" },
	{ family = "JetBrains Mono", weight = "Medium" },
	"Noto Color Emoji",
})
config.font_size = 13.0
config.line_height = 1.2

-- ── Window ─────────────────────────────────────────
config.window_background_opacity = 0.95
config.window_padding = { left = 12, right = 12, top = 12, bottom = 4 }
config.window_decorations = "RESIZE"
config.initial_cols = 140
config.initial_rows = 38
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- Gruvbox Dark colors for the tab bar
config.colors = {
	tab_bar = {
		background = "#1d2021", -- bg0_h (darkest)
		active_tab = {
			bg_color = "#282828", -- bg0
			fg_color = "#ebdbb2", -- fg1
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#1d2021", -- bg0_h
			fg_color = "#928374", -- gray
		},
		inactive_tab_hover = {
			bg_color = "#3c3836", -- bg1
			fg_color = "#ebdbb2", -- fg1
		},
		new_tab = {
			bg_color = "#1d2021",
			fg_color = "#928374",
		},
	},
}

-- ── Cursor ─────────────────────────────────────────
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- ── Scroll ─────────────────────────────────────────
config.scrollback_lines = 10000
config.enable_scroll_bar = false

-- ── Keys ───────────────────────────────────────────
config.keys = {
	{ key = "d", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "e", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },
}

-- ── Misc ───────────────────────────────────────────
config.audible_bell = "Disabled"
config.check_for_updates = false

return config
