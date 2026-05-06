-- Noice (Command Line + LSP UI)
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			opts = {
				background_colour = "#282828",
			},
		},
	},
	opts = {
		-- ----- Cmdline (the : popup) -----
		cmdline = {
			view = "cmdline_popup",
		},
		-- ----- View definitions -----
		views = {
			cmdline_popup = {
				position = { row = "20%", col = "50%" },
				size = { width = 70, height = "auto" },
				border = { style = "rounded" },
			},
			hover = {
				border = { style = "rounded" },
				size = { max_width = 80, max_height = 20 },
			},
		},
		-- ----- Routes (suppress noisy messages) -----
		routes = {
			{
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			},
		},
	},
}
