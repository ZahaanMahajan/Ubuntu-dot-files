return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	enabled = true,
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Diagnostics config
		vim.diagnostic.config({
			virtual_text = false,
			float = { border = "single" },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "✖",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "󰠠",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
		})

		-- Float window transparency
		local set_hl_for_floating_window = function()
			vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
		end
		set_hl_for_floating_window()
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = set_hl_for_floating_window,
		})

		-- Keymaps on LSP attach
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover docs" })
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Smart rename" })
				vim.keymap.set({ "n", "v" }, "gf", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code actions" })
				vim.keymap.set(
					"n",
					"<leader>d",
					vim.diagnostic.open_float,
					{ buffer = bufnr, desc = "Line diagnostics" }
				)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
			end,
		})

		-- Server configs using new vim.lsp.config API
		local servers = {
			ts_ls = {},
			html = {},
			angularls = {
				root_markers = { "angular.json", "project.json", "nx.json" },
			},
			cssls = {},
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			},
		}

		for server, config in pairs(servers) do
			config.capabilities = capabilities
			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end
	end,
}
