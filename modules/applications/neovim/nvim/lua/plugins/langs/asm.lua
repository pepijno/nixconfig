return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "asm" })
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				asm_lsp = {},
			},
		},
	},
	-- {
	-- 	"williamboman/mason.nvim",
	-- 	opts = function(_, opts)
	-- 		if type(opts.ensure_installed) == "table" then
	-- 			vim.list_extend(opts.ensure_installed, { "clangd", "clang-format" })
	-- 		end
	-- 	end,
	-- },
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts["format_on_save"] = nil
			local extra = { asm = { "asmfmt" } }
			if type(opts.formatters_by_ft) == "table" then
				opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft, extra)
			else
				opts.formatters_by_ft = extra
			end
		end,
	},
}
