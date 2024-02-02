return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "zig" })
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				zls = {
					settings = {
					},
				},
			},
		},
	},
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "zls" })
			end
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			local extra = { zig = { "zigfmt" } }
			if type(opts.formatters_by_ft) == "table" then
				opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft, extra)
			else
				opts.formatters_by_ft = extra
			end
		end,
	},
}
