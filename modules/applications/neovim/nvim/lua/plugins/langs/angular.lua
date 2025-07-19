vim.lsp.config("cssls", {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
	root_markers = { "package.json", ".git" },
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
})
vim.lsp.config("html", {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "templ" },
	root_markers = { "package.json", ".git" },
	settings = {},
	init_options = {
		provideFormatter = true,
		embeddedLanguages = { css = true, javascript = true },
		configurationSection = { "html", "css", "javascript" },
	},
})
vim.lsp.enable({ "cssls", "html" })

-- local util = require("lspconfig.util")

local create_cmd = vim.api.nvim_create_autocmd

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "angular", "typescript", "javascript", "html", "css" })
		end,
	},
	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	opts = {
	-- 		servers = {
	-- 			angularls = {
	-- 				root_dir = util.root_pattern("nx.json"),
	-- 				settings = {},
	-- 			},
	-- 			html = {
	-- 				settings = {
	-- 					html = {
	-- 						format = {
	-- 							tabSize = 8,
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 			cssls = {
	-- 				settings = {},
	-- 			},
	-- 		},
	-- 	},
	-- },
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
		config = function()
			require("typescript-tools").setup({
				settings = {
					tsserver_format_options = {
						tabSize = 2,
						indentSize = 2,
						convertTabsToSpaces = true,
						trimTrailingWhitespace = true,
						insertSpaceAfterCommaDelimiter = true,
						insertSpaceAfterSemicolonInForStatements = true,
						insertSpaceBeforeAndAfterBinaryOperators = true,
						insertSpaceAfterConstructor = false,
						insertSpaceAfterKeywordsInControlFlowStatements = true,
						insertSpaceAfterFunctionKeywordForAnonymousFunctions = false,
						insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
						insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
						insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
						insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = true,
						insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
						insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
						insertSpaceAfterTypeAssertion = false,
						insertSpaceBeforeFunctionParenthesis = false,
						insertSpaceBeforeTypeAnnotation = false,
						insertSpaceAfterTypeAnnotation = false,
						placeOpenBraceOnNewLineForFunctions = false,
						placeOpenBraceOnNewLineForControlBlocks = false,
						semicolons = "insert",
					},
					tsserver_file_preferences = {
						quotePreference = "single",
						importModuleSpecifierPreference = "non-relative",
						allowTextChangesInNewFiles = true,
						allowRenameOfImportPath = true,
					},
				},
			})
			vim.keymap.set("n", "<leader>lio", ":TSToolsOrganizeImports<cr>", { desc = "[O]rganise Imports" })
			vim.keymap.set("n", "<leader>lim", ":TSToolsAddMissingImports<cr>", { desc = "Add [M]issing Imports" })
			vim.keymap.set("n", "<leader>liu", ":TSToolsRemoveUnusedImports<cr>", { desc = "Remove [U]nused Imports" })
			create_cmd({ "BufRead", "BufEnter" }, {
				pattern = "*.component.html",
				callback = function()
					vim.api.nvim_command("set filetype=angular")
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft, { angular = { "prettier" } })

			opts.formatters = opts.formatters or {}
			opts.formatters = vim.tbl_extend("force", opts.formatters, {
				prettier = {
					printWidth = 120,
					useTabs = false,
					semi = true,
					singleQuote = true,
					trailingComma = "all",
					arrowParens = "always",
				},
			})
		end,
	},
}
