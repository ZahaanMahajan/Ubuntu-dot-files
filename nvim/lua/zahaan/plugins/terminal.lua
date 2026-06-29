return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = { "ToggleTerm", "TermExec" },
	keys = {
		{ "<C-/>", desc = "Toggle terminal" },
		{ "<C-_>", desc = "Toggle terminal (fallback)" },

		-- Moved the leader mappings here so they trigger the plugin to load!
		{ "<leader>th", "<cmd>1ToggleTerm direction=horizontal<cr>", desc = "Horizontal terminal" },
		{ "<leader>tf", "<cmd>2ToggleTerm direction=float<cr>", desc = "Float terminal" },
		{ "<leader>tv", "<cmd>3ToggleTerm direction=vertical<cr>", desc = "Vertical terminal" },
	},
	opts = {
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
		open_mapping = [[<c-/>]], -- the main toggle key
		shade_terminals = true, -- slightly darker bg for terminal windows
		start_in_insert = true, -- already typing when terminal opens
		insert_mappings = true, -- open_mapping works in insert mode too
		terminal_mappings = true, -- and inside the terminal itself
		persist_size = true,
		persist_mode = true,
		direction = "horizontal", -- bottom split by default
		close_on_exit = true, -- auto-close when shell exits
		shell = vim.o.shell,
		float_opts = {
			border = "rounded",
		},
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)

		-- Ctrl+_ fallback for terminals that don't send Ctrl+/
		vim.keymap.set({ "n", "t" }, "<C-_>", "<Cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })

		-- Double-Esc to exit terminal mode
		vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

		-- Direction-locked terminals (each one its own ID so they don't overwrite each other)
		vim.keymap.set("n", "<leader>th", "<cmd>1ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
		vim.keymap.set("n", "<leader>tf", "<cmd>2ToggleTerm direction=float<cr>", { desc = "Float terminal" })
		vim.keymap.set("n", "<leader>tv", "<cmd>3ToggleTerm direction=vertical<cr>", { desc = "Vertical terminal" })
	end,
}
