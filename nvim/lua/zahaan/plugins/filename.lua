-- filename indicator (top-right corner of each window)
return {
	"b0o/incline.nvim",
	event = "BufReadPre",
	priority = 1200,
	config = function()
		local gruvbox = {
			bg0 = "#282828",
			bg1 = "#3c3836",
			bg2 = "#504945",
			fg1 = "#ebdbb2",
			gray = "#928374",
			yellow = "#fabd2f",
			aqua = "#8ec07c",
			orange = "#fe8019",
		}

		require("incline").setup({
			highlight = {
				groups = {
					-- active window: aqua block with dark text — pops without shouting
					InclineNormal = { guibg = gruvbox.aqua, guifg = gruvbox.bg0 },
					-- inactive windows: muted gray on dark bg
					InclineNormalNC = { guibg = gruvbox.bg1, guifg = gruvbox.gray },
				},
			},
			window = { margin = { vertical = 0, horizontal = 1 } },
			hide = {
				cursorline = true,
			},
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				if filename == "" then
					filename = "[No Name]"
				end
				if vim.bo[props.buf].modified then
					filename = "[+] " .. filename
				end
				local icon, color = require("nvim-web-devicons").get_icon_color(filename)
				return { { icon, guifg = color }, { " " }, { filename } }
			end,
		})
	end,
}
