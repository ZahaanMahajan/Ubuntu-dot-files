-- lua/zahaan/plugins/editor.lua

return {
	-- Flash (quick navigation)
	{
		"folke/flash.nvim",
		enabled = true,
		opts = {
			search = {
				forward = true,
				multi_window = false,
				wrap = false,
				incremental = true,
			},
		},
	},

	-- Git integration
	{
		"dinhhuy258/git.nvim",
		event = "BufReadPre",
		opts = {
			keymaps = {
				blame = "<Leader>gb",
				browse = "<Leader>go",
			},
		},
	},
}
