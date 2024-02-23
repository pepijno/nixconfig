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
Atom.__index = Atom

function Atom.Blankline()
	local atom = Atom
	atom.type = "Blankline"
	return atom
end

function Atom.Empty()
	local atom = Atom
	atom.type = "Empty"
	return atom
end

function Atom.Hardline()
	local atom = Atom
	atom.type = "Hardline"
	return atom
end

function Atom.IndentStart()
	local atom = Atom
	atom.type = "IndentStart"
	return atom
end

function Atom.Leaf(content, id, original_position, single_line_no_indent, multi_line_indent_all)
	local atom = Atom
	atom.type = "Leaf"
	atom.content = content
	atom.id = id
	atom.original_position = original_position
	atom.single_line_no_indent = single_line_no_indent
	atom.multi_line_indent_all = multi_line_indent_all
	return atom
end

function Atom.Literal(literal)
	local atom = Atom
	atom.type = "Literal"
	atom.literal = literal
	return atom
end

function Atom.IndentEnd()
	local atom = Atom
	atom.type = "IndentEnd"
	return atom
end

function Atom.Softline(spaced)
	local atom = Atom
	atom.type = "Softline"
	atom.spaced = spaced
	return atom
end

function Atom.Space()
	local atom = Atom
	atom.type = "Space"
	return atom
end

function Atom.Antispace()
	local atom = Atom
	atom.type = "Antispace"
	return atom
end

function Atom.DeleteBegin()
	local atom = Atom
	atom.type = "DeleteBegin"
	return atom
end

function Atom.DeleteEnd()
	local atom = Atom
	atom.type = "DeleteEnd"
	return atom
end

function Atom.ScopeBegin(line_number, scope_id)
	local atom = Atom
	atom.type = "ScopeBegin"
	atom.line_number = line_number
	atom.scope_id = scope_id
	return atom
end

function Atom.ScopeEnd(line_number, scope_id)
	local atom = Atom
	atom.type = "ScopeEnd"
	atom.line_number = line_number
	atom.scope_id = scope_id
	return atom
end

function Atom.ScopedSoftLine(id, scope_id, spaced)
	local atom = Atom
	atom.type = "ScopedSoftLine"
	atom.id = id
	atom.scope_id = scope_id
	atom.spaced = spaced
	return atom
end

local ScopedCondition = {}
ScopedCondition.SingleLineOnly = "SingleLineOnly"
ScopedCondition.MultiLineOnly = "MultiLineOnly"

function Atom.ScopedConditional(id, scope_id, condition, atom)
	local a = Atom
	a.type = "ScopedConditional"
	a.id = id
	a.scope_id = scope_id
	a.condition = condition
	a.atom = atom
	return a
end

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

---@param name string
---@param node TSNode
---@param predicates any
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
		self:append(Atom.Literal(predicates.delimiter), node, predicates)
	elseif name == "append_empty_softline" then
		self:append(Atom.Softline(false), node, predicates)
	elseif name == "append_hardline" then
		self:append(Atom.Hardline(), node, predicates)
	elseif name == "append_indent_start" then
		self:append(Atom.IndentStart(), node, predicates)
	elseif name == "append_indent_end" then
		self:append(Atom.IndentEnd(), node, predicates)
	elseif name == "append_input_softline" then
		local space = {}
		if self.line_break_after[node:id()] then
			space = Atom.Hardline()
		else
			space = Atom.Space()
		end
		self:append(space, node, predicates)
	elseif name == "append_space" then
		self:append(Atom.Space(), node, predicates)
	elseif name == "append_antispace" then
		self:append(Atom.Antispace(), node, predicates)
	elseif name == "append_empty_softline" then
	elseif name == "append_empty_softline" then
	elseif name == "append_empty_softline" then
	elseif name == "append_empty_softline" then
	elseif name == "append_empty_softline" then
	elseif name == "append_empty_softline" then
	elseif name == "append_empty_softline" then
	elseif name == "append_empty_softline" then
	elseif name == "append_empty_softline" then
	elseif name == "prepend_spaced_softline" then
		self:append(Atom.Softline(true), node, predicates)
	elseif name == "leaf" then
	elseif name == "delete" then
		self:prepend(Atom.DeleteBegin(), node, predicates)
		self:append(Atom.DeleteEnd(), node, predicates)
	elseif name == "prepend_begin_scope" then
		local ranges = { node:range() }
		self:prepend(Atom.ScopeBegin(ranges[1], predicates.scope_id), node, predicates)
	elseif name == "append_begin_scope" then
		local ranges = { node:range() }
		self:append(Atom.ScopeBegin(ranges[3], predicates.scope_id), node, predicates)
	elseif name == "prepend_end_scope" then
		local ranges = { node:range() }
		self:prepend(Atom.ScopeEnd(ranges[1], predicates.scope_id), node, predicates)
	elseif name == "append_end_scope" then
		local ranges = { node:range() }
		self:append(Atom.ScopeEnd(ranges[3], predicates.scope_id), node, predicates)
	elseif name == "append_empty_scoped_softline" then
		self:append(Atom.ScopedSoftLine(self:next_id(), predicates.scope_id, false), node, predicates)
	elseif name == "append_spaced_scoped_softline" then
		self:append(Atom.ScopedSoftLine(self:next_id(), predicates.scope_id, true), node, predicates)
	elseif name == "prepend_empty_scoped_softline" then
		self:prepend(Atom.ScopedSoftLine(self:next_id(), predicates.scope_id, false), node, predicates)
	elseif name == "prepend_spaced_scoped_softline" then
		self:prepend(Atom.ScopedSoftLine(self:next_id(), predicates.scope_id, true), node, predicates)
	elseif name == "single_line_no_indent" then
		for _, n in ipairs(self.atoms) do
			if n.type == "Leaf" then
				if n.id == node:id() then
					n.single_line_no_indent = true
				end
			end
		end
	elseif name == "multi_line_indent_all" then
		for _, n in ipairs(self.atoms) do
			if n.type == "Leaf" then
				if n.id == node:id() then
					n.multi_line_indent_all = true
				end
			end
		end
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

function Atoms:expand_multi_line(atom, node)
	if atom.type == "Softline" then
		local spaced = atom.spaced
		local parent = node:parent()
		if parent ~= nil then
			local parent_id = parent:id()

			if self.multiline_nodes[parent_id] ~= nil then
				return Atom.Hardline()
			elseif spaced then
				return Atom.Space()
			else
				return Atom.Empty()
			end
		else
			return Atom.Empty()
		end
	else
		return atom
	end
end

function Atoms:wrap(atom, predicates)
	if predicates.single_line_scope_only ~= nil then
		local id = self:next_id()
		return Atom.ScopedConditional(id, predicates.single_line_scope_only, ScopedCondition.SingleLineOnly, atom)
	elseif predicates.multi_line_scope_only then
		local id = self:next_id()
		return Atom.ScopedConditional(id, predicates.multi_line_scope_only, ScopedCondition.MultiLineOnly, atom)
	else
		return atom
	end
end

function Atoms:next_id()
	self.counter = self.counter + 1
	return self.counter
end

function Atoms:first_leaf(node)
	if node:child_count() == 0 or self.leaf_nodes[node:id()] ~= nil then
		return node
	else
		local n = node:child(0)
		return self:first_leaf(n)
	end
end

function Atoms:last_leaf(node)
	local nr_children = node:child_count()
	if nr_children == 0 or self.leaf_nodes[node:id()] ~= nil then
		return node
	else
		local n = node:child(nr_children - 1)
		return self:last_leaf(n)
	end
end

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
	end, true)
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
	end, true)
	vim.treesitter.query.add_directive("single_line_only!", function(_, _, _, _, metadata)
		if metadata.custom == nil then
			metadata.custom = QueryDirectives
		end
		metadata.custom.single_line_only = true
		return true
	end, true)
	vim.treesitter.query.add_directive("multi_line_only!", function(_, _, _, _, metadata)
		if metadata.custom == nil then
			metadata.custom = QueryDirectives
		end
		metadata.custom.multi_line_only = true
		return true
	end, true)
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
	end, true)
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
	end, true)

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

	for pattern, match, metadata in query:iter_matches(root, bufnr, 0, -1) do
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
