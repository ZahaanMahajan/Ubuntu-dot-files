-- lua/zahaan/plugins/colors.lua --
return {
	"craftzdog/solarized-osaka.nvim",
	priority = 1000,
	config = function()
		require("solarized-osaka").setup({
			transparent_mode = false,
		})
		vim.cmd([[
      colorscheme solarized-osaka
    ]])
	end,
}
