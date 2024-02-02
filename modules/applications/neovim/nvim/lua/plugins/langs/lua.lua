return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "lua" })
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				lua_ls = {
					mason = false,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								library = {
									[vim.fn.expand("$VIMRUNTIME/lua")] = true,
									[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
									[vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types"] = true,
									[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
								},
								maxPreload = 100000,
								preloadFileSize = 10000,
							},
						},
					},
				},
			},
		},
	},
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "lua-language-server", "stylua" })
			end
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			local extra = { lua = { "stylua" } }
			if type(opts.formatters_by_ft) == "table" then
				opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft, extra)
			else
				opts.formatters_by_ft = extra
			end
		end,
	},
}
