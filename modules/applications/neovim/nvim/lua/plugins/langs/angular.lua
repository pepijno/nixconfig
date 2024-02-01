return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "angular", "typescript", "javascript" })
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				angularls = {
					settings = {},
				},
				tsserver = {
					init_options = {
						hostInfo = "neovim",
						preferences = {
							includeCompletionsForModuleExports = true,
							includeCompletionsForImportStatements = true,
							importModuleSpecifierPreference = "non-relative",
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
				vim.list_extend(
					opts.ensure_installed,
					{ "angular-language-server", "typescript-language-server", "prettier" }
				)
			end
		end,
	},
	-- {
	-- 	"stevearc/conform.nvim",
	-- 	opts = function(_, opts)
	-- 		local extra = { typescript = { "prettier" } }
	-- 		if type(opts.formatters_by_ft) == "table" then
	-- 			vim.list_extend(opts.formatters_by_ft, extra)
	-- 		else
	-- 			opts.formatters_by_ft = extra
	-- 		end
	-- 		-- local formatters = {
	-- 		-- 	prettier = {
	-- 		-- 		printWidth = 1000,
	-- 		-- 		useTabs = false,
	-- 		-- 		semi = true,
	-- 		-- 		singleQuote = true,
	-- 		-- 		trailingComma = "all",
	-- 		-- 		arrowParens = "always",
	-- 		-- 	},
	-- 		-- }
	-- 		-- if type(opts.formatters) == "table" then
	-- 		-- 	vim.list_extend(opts.formatters, formatters)
	-- 		-- else
	-- 		-- 	opts.formatters = formatters
	-- 		-- end
	-- 	end,
	-- },
}
