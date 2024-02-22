local util = require("lspconfig.util")

local create_cmd = vim.api.nvim_create_autocmd

local get_query = function()
	return vim.treesitter.query.parse(
		"typescript",
		[[
(string_fragment) @leaf

(object
  .
  "{" @append_spaced_softline @append_indent_start
  (_)
  "}" @prepend_spaced_softline @prepend_indent_end
  .
)

(array
  .
  "[" @append_spaced_softline @append_indent_start
  (_)
  "]" @prepend_spaced_softline @prepend_indent_end
  .
)

(object
  "," @append_spaced_softline
)

(array
  "," @append_spaced_softline
)

((identifier) @foo (#delimiter! ";"))
	]]
	)
end

local Atom = {}
Atom.Blankline = "Blankline"
Atom.Empty = "Empty"
Atom.Hardline = "Hardline"
Atom.IndentEnd = "IndentEnd"

local get_root = function(bufnr)
	local parser = vim.treesitter.get_parser(bufnr, "typescript", {})
	local tree = parser:parse()[1]
	return tree:root()
end

local tablelength = function(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

local function dfs_flatten(node)
	local dfs_nodes = {}

	table.insert(dfs_nodes, node)

	for n in node:iter_children() do
		vim.list_extend(dfs_nodes, dfs_flatten(n))
	end

	return dfs_nodes
end

local detect_multiline_nodes = function(nodes)
	nodes = nodes or {}

	local multiline_nodes = {}

	for _, k in ipairs(nodes) do
		-- { start row, start col, end row, end col }
		local range = { k:range() }
		if range[3] > range[1] then
			table.insert(multiline_nodes, k)
		end
	end

	return multiline_nodes
end

local detect_linebreaks = function(nodes, minimum_line_breaks)
	nodes = nodes or {}
	minimum_line_breaks = minimum_line_breaks or 1

	local before = {}
	local after = {}

	local length = tablelength(nodes)

	for i, k in ipairs(nodes) do
		if i >= length - 1 then
			break
		end

		local range_left = { k:range() }
		local range_right = { nodes[i + 1]:range() }

		if range_right[1] >= range_left[3] + minimum_line_breaks then
			table.insert(before, nodes[i + 1]:id())
			table.insert(after, k:id())
		end
	end

	return {
		before = before,
		after = after,
	}
end

local QueryDirectives = {
	delimeter = nil,
	scope_id = nil,
	single_line_only = false,
	multi_line_only = false,
	single_line_scope_only = nil,
	multi_line_scope_only = nil,
}
QueryDirectives.__index = QueryDirectives

function QueryDirectives:validate()
	local incompatible_predicates = 0
	if self.single_line_only then
		incompatible_predicates = incompatible_predicates + 1
	end
	if self.multi_line_only then
		incompatible_predicates = incompatible_predicates + 1
	end
	if self.single_line_scope_only ~= nil then
		incompatible_predicates = incompatible_predicates + 1
	end
	if self.multi_line_scope_only ~= nil then
		incompatible_predicates = incompatible_predicates + 1
	end

	if incompatible_predicates > 1 then
		error("A query can contain at most one #single/multi_line[_scope]_only! directive")
	end
end

local Atoms = {
	atoms = {}, --list atom
	prepend = {}, --hash_map of lists atom
	append = {}, --hash_map of lists atom
	leaf_nodes = {}, --hash_set int
	parent_leaf_nodes = {}, --hash_map int int
	multiline_nodes = {}, --hash_set int
	blank_lines_before = {}, --hash_set int
	line_break_before = {}, --hash_set int
	line_break_after = {}, --hash_set int
	counter = 0,
}
Atoms.__index = Atoms

function Atoms.init(leaf_nodes, multiline_nodes, blank_line_nodes, line_break_nodes)
	local self = setmetatable({}, Atoms)

	self.leaf_nodes = leaf_nodes
	self.multiline_nodes = multiline_nodes
	self.blank_lines_before = blank_line_nodes.before
	self.line_break_before = line_break_nodes.before
	self.line_break_after = line_break_nodes.after

	return self
end

function Atoms:mark_leaf_parent(node, id)
	self.parent_leaf_nodes[node:id()] = id
	for n in node:iter_children() do
		self:mark_leaf_parent(n, id)
	end
end

function Atoms:collect_leafs_inner(bufnr, node, parent_ids, level)
	local id = node:id()
	parent_ids = parent_ids or {}
	parent_ids = table.insert(parent_ids, id)

	if node:byte_length() == 0 then
	elseif node:child_count() == 0 or self.leaf_nodes[id] ~= nil or node:has_error() then
		table.insert(self.atoms, {
			content = vim.treesitter.get_node_text(node, bufnr),
			id = id,
			original_position = { node:range() },
			single_line_no_indent = false,
			multi_line_no_indent = false,
		})

		self:mark_leaf_parent(node, id)
	else
		for n in node:iter_children() do
			self:collect_leafs_inner(bufnr, n, parent_ids, level + 1)
		end
	end
end

function Atoms:resolve_capture(name, node, predicates)
	local is_multi_line = false
	local parent = node:parent()
	if parent ~= nil then
		local parent_id = parent:id()
		if self.multiline_nodes[parent_id] ~= nil then
			is_multi_line = true
		end
	end

	if is_multi_line and predicates.single_line_only then
		vim.print("Skipping because context is multi-line and #single_line_only! is set")
		return
	end

	if not is_multi_line and predicates.multi_line_only then
		vim.print("Skipping because context is single-line and #multi_line_only! is set")
		return
	end

	local parent_leaf_node = self.parent_leaf_nodes[node:id()]
	if parent_leaf_node ~= nil then
		if parent_leaf_node ~= node:id() then
			vim.print("Skipping because the match occurred below a leaf node: {}")
			return
		end
	end

	if name == "allow_blank_line_before" then
		if self.blank_lines_before[node:id()] ~= nil then
			self:prepend(Atom.Blankline, node, predicates)
		end
	elseif name == "append_delimiter" then
		self:append(Atom.literal(), node, predicates)
	end
end

function Atoms:prepend(atom, node, predicates)
	atom = self:expand_multi_line(atom, node)
	atom = self:wrap(atom, predicates)
	local target_node = self:first_leaf(node)

	local a = self.prepend[target_node:id()]
	if a == nil then
		a = {}
		self.prepend[target_node:id()] = a
	end
	table.insert(a, atom)
end

function Atoms:append(atom, node, predicates)
	atom = self:expand_multi_line(atom, node)
	atom = self:wrap(atom, predicates)
	local target_node = self:last_leaf(node)

	local a = self.append[target_node:id()]
	if a == nil then
		a = {}
		self.append[target_node:id()] = a
	end
	table.insert(a, atom)
end

function

local collect_leafs = function(bufnr, root, leaf_nodes)
	local dfs_nodes = dfs_flatten(root)

	local multiline_nodes = detect_multiline_nodes(dfs_nodes)
	local blank_line_nodes = detect_linebreaks(dfs_nodes, 2)
	local line_break_nodes = detect_linebreaks(dfs_nodes, 1)

	local atoms = Atoms.init(leaf_nodes, multiline_nodes, blank_line_nodes, line_break_nodes)

	atoms:collect_leafs_inner(bufnr, root, {}, 0)

	return atoms
end

local format = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	if vim.bo[bufnr].filetype ~= "typescript" then
		vim.notify("Can only be used in typescript")
		return
	end

	local root = get_root(bufnr)

	local query = get_query()

	vim.treesitter.query.add_directive("delimiter!", function(_, _, _, pred, metadata)
		local arg_count = #pred - 1
		if arg_count < 1 then
			error(string.format("%s must have 1 argument", "delimiter!"))
			return false
		end
		local delimiter = pred[2]

		if metadata.custom == nil then
			metadata.custom = QueryDirectives
		end
		metadata.custom.delimiter = delimiter
		return true
	end, {})
	vim.treesitter.query.add_directive("scope_id!", function(_, _, _, pred, metadata)
		local arg_count = #pred - 1
		if arg_count ~= 1 then
			error(string.format("%s must have 1 argument", "scope_id!"))
			return false
		end
		local scope_id = pred[2]

		if metadata.custom == nil then
			metadata.custom = QueryDirectives
		end
		metadata.custom.scope_id = scope_id
		return true
	end, {})
	vim.treesitter.query.add_directive("single_line_only!", function(_, _, _, _, metadata)
		if metadata.custom == nil then
			metadata.custom = QueryDirectives
		end
		metadata.custom.single_line_only = true
		return true
	end, {})
	vim.treesitter.query.add_directive("multi_line_only!", function(_, _, _, _, metadata)
		if metadata.custom == nil then
			metadata.custom = QueryDirectives
		end
		metadata.custom.multi_line_only = true
		return true
	end, {})
	vim.treesitter.query.add_directive("single_line_scope_only!", function(_, _, _, pred, metadata)
		local arg_count = #pred - 1
		if arg_count ~= 1 then
			error(string.format("%s must have 1 argument", "single_line_scope_only!"))
			return false
		end
		local single_line_scope_only = pred[2]

		if metadata.custom == nil then
			metadata.custom = QueryDirectives
		end
		metadata.custom.single_line_scope_only = single_line_scope_only
		return true
	end, {})
	vim.treesitter.query.add_directive("multi_line_scope_only!", function(_, _, _, pred, metadata)
		local arg_count = #pred - 1
		if arg_count ~= 1 then
			error(string.format("%s must have 1 argument", "multi_line_scope_only!"))
			return false
		end
		local multi_line_scope_only = pred[2]

		if metadata.custom == nil then
			metadata.custom = QueryDirectives
		end
		metadata.custom.multi_line_scope_only = multi_line_scope_only
		return true
	end, {})

	local changes = {}
	local leaf_ids = {}

	for id, node in query:iter_captures(root, bufnr, 0, -1) do
		-- { start row, start col, end row, end col }
		local range = { node:range() }
		local name = query.captures[id]
		if name == "leaf" then
			leaf_ids[id] = {}
		end
	end

	local atoms = collect_leafs(bufnr, root, leaf_ids)

	for pattern, match, metadata in query:iter_matches(root, bufnr, 0, -1, { all = true }) do
		if metadata.custom ~= nil then
			metadata.custom:validate()
		end

		for id, _ in pairs(match) do
			local name = query.captures[id]
			if name == "do_nothing" then
				goto continue
			end
		end

		for id, node in pairs(match) do
			local name = query.captures[id]
			atoms:resolve_capture(name, node, metadata.custom or QueryDirectives)
		end
		::continue::
	end

	atoms:apply_prepends_and_appends()
end

vim.keymap.set("n", "<leader>tt", function()
	format()
end, { noremap = true })

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "angular", "typescript", "javascript", "html", "css", "json" })
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
				vim.list_extend(opts.ensure_installed, {
					"angular-language-server",
					"typescript-language-server",
					"eslint_d",
					"prettier",
					"html-lsp",
					"css-lsp",
				})
			end
		end,
	},
	-- {
	-- 	"stevearc/conform.nvim",
	-- 	opts = function(_, opts)
	-- 		local extra = { typescript = { "prettier", "eslint_d" }, angular = { "prettier", "eslint_d" } }
	-- 		if type(opts.formatters_by_ft) == "table" then
	-- 			vim.list_extend(opts.formatters_by_ft, extra)
	-- 		else
	-- 			opts.formatters_by_ft = extra
	-- 		end
	-- 		local formatters = {
	-- 			prettier = {
	-- 				printWidth = 40,
	-- 				useTabs = false,
	-- 				semi = true,
	-- 				singleQuote = true,
	-- 				jsxSingleQuote = true,
	-- 				trailingComma = "none",
	-- 				arrowParens = "always",
	-- 				bracketSpacing = true,
	-- 				bracketSameLine = true,
	-- 				singleAttributePerLine = true,
	-- 			},
	-- 		}
	-- 		if type(opts.formatters) == "table" then
	-- 			vim.list_extend(opts.formatters, formatters)
	-- 		else
	-- 			opts.formatters = formatters
	-- 		end
	-- 	end,
	-- },
}
