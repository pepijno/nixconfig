return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "c" })
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				clangd = {
					filetypes = { "c" },
					settings = {},
				},
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
			-- opts["format_on_save"] = {
			-- 	-- These options will be passed to conform.format()
			-- 	timeout_ms = 500,
			-- 	lsp_fallback = true,
			-- }
			local extra = { c = { "clang_format" } }
			if type(opts.formatters_by_ft) == "table" then
				opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft, extra)
			else
				opts.formatters_by_ft = extra
			end
		end,
	},
}
