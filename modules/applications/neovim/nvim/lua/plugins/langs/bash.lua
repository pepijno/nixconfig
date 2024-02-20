return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "bash" })
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				bashls = {
					settings = {},
				},
			},
		},
	},
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "bash-language-server" })
			end
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			local extra = {
				bash = { "beautysh" },
				sh = { "beautysh" },
			}
			if type(opts.formatters_by_ft) == "table" then
				opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft, extra)
			else
				opts.formatters_by_ft = extra
			end
		end,
	},
}
