-- Noice (Command Line)
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify", -- optional
	},
	opts = {
		cmdline = {
			view = "cmdline_popup", -- popup instead of bottom bar
		},
		views = {
			cmdline_popup = {
				position = {
					row = "20%", -- vertical 20%
					col = "50%", -- horizontal center
				},
				size = {
					width = 100,
					height = "auto",
				},
			},
		},
	},
}
