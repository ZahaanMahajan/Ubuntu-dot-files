return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	enabled = true,
	opts = {
		ensure_installed = {
			"vimdoc",
			"javascript",
			"typescript",
			"lua",
			"ruby",
			"html",
			"tsx",
			"bash",
			"markdown",
			"markdown_inline",
		},
		indent = { enable = true },
		highlight = {
			enable = true,
		},
	},
}
