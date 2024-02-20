local util = require("lspconfig.util")

local create_cmd = vim.api.nvim_create_autocmd

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "angular", "typescript", "javascript", "html", "css" })
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				angularls = {
					root_dir = util.root_pattern("nx.json"),
					settings = {},
				},
				html = {
					settings = {
						html = {
							format = {
								tabSize = 8,
							},
						},
					},
				},
				cssls = {
					settings = {},
				},
			},
		},
	},
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
		"williamboman/mason.nvim",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(
					opts.ensure_installed,
					{ "angular-language-server", "typescript-language-server", "prettier", "html-lsp", "css-lsp" }
				)
			end
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			local extra = { angular = { "prettier" } }
			if type(opts.formatters_by_ft) == "table" then
				vim.list_extend(opts.formatters_by_ft, extra)
			else
				opts.formatters_by_ft = extra
			end
			local formatters = {
				prettier = {
					printWidth = 120,
					useTabs = false,
					semi = true,
					singleQuote = true,
					trailingComma = "all",
					arrowParens = "always",
				},
			}
			if type(opts.formatters) == "table" then
				vim.list_extend(opts.formatters, formatters)
			else
				opts.formatters = formatters
			end
		end,
	},
}
