local util = require("lspconfig.util")

local create_cmd = vim.api.nvim_create_autocmd

function table.copy(t)
	local u = {}
	for k, v in pairs(t) do
		u[k] = v
	end
	return setmetatable(u, getmetatable(t))
end

local get_query_ts = function()
	return vim.treesitter.query.parse(
		"typescript",
		[[
[
  "export"
] @leaf

[
  (class_body)
  (statement_block)
] @append_hardline
		]]
	)
end

local get_query_json = function()
	return vim.treesitter.query.parse(
		"json",
		[[
; Sometimes we want to indicate that certain parts of our source text should
; not be formatted, but taken as is. We use the leaf capture name to inform the
; tool of this.
(string) @leaf

; Append space after colons
":" @append_space

; We want every object and array to have the { start a softline and an indented
; block. So we match on the named object/array followed by the first anonymous
; node { or [.

; We do not want to add spaces or newlines in empty objects and arrays,
; so we add the newline and the indentation block only if there is a pair in
; the object (or a value in the array).
(object
  .
  "{" @append_spaced_softline @append_indent_start
  (pair)
  "}" @prepend_spaced_softline @prepend_indent_end
  .
)

(array
  .
  "[" @append_spaced_softline @append_indent_start
  (_value)
  "]" @prepend_spaced_softline @prepend_indent_end
  .
)

; Pairs should always end with a softline.
; Pairs come in two kinds, ones with a trailing comma, and those without.
; Those without are the last pair of an object,
; and the line is already added by the closing curly brace of the object.
(object
  "," @append_spaced_softline
)

; Items in an array must have a softline after. See also the pairs above.
(array
  "," @append_spaced_softline
)
	]]
	)
end

local Atom = {}
Atom.__index = Atom

function Atom.Blankline()
	local atom = table.copy(Atom)
	atom.type = "Blankline"
	return atom
end

function Atom.Empty()
	local atom = table.copy(Atom)
	atom.type = "Empty"
	return atom
end

function Atom.Hardline()
	local atom = table.copy(Atom)
	atom.type = "Hardline"
	return atom
end

function Atom.IndentStart()
	local atom = table.copy(Atom)
	atom.type = "IndentStart"
	return atom
end

function Atom.Leaf(content, id, original_position, single_line_no_indent, multi_line_indent_all)
	local atom = table.copy(Atom)
	atom.type = "Leaf"
	atom.content = content
	atom.id = id
	atom.original_position = original_position
	atom.single_line_no_indent = single_line_no_indent
	atom.multi_line_indent_all = multi_line_indent_all
	return atom
end

function Atom.Literal(literal)
	local atom = table.copy(Atom)
	atom.type = "Literal"
	atom.literal = literal
	return atom
end

function Atom.IndentEnd()
	local atom = table.copy(Atom)
	atom.type = "IndentEnd"
	return atom
end

function Atom.Softline(spaced)
	local atom = table.copy(Atom)
	atom.type = "Softline"
	atom.spaced = spaced
	return atom
end

function Atom.Space()
	local atom = table.copy(Atom)
	atom.type = "Space"
	return atom
end

function Atom.Antispace()
	local atom = table.copy(Atom)
	atom.type = "Antispace"
	return atom
end

function Atom.DeleteBegin()
	local atom = table.copy(Atom)
	atom.type = "DeleteBegin"
	return atom
end

function Atom.DeleteEnd()
	local atom = table.copy(Atom)
	atom.type = "DeleteEnd"
	return atom
end

function Atom.ScopeBegin(line_number, scope_id)
	local atom = table.copy(Atom)
	atom.type = "ScopeBegin"
	atom.line_number = line_number
	atom.scope_id = scope_id
	return atom
end

function Atom.ScopeEnd(line_number, scope_id)
	local atom = table.copy(Atom)
	atom.type = "ScopeEnd"
	atom.line_number = line_number
	atom.scope_id = scope_id
	return atom
end

function Atom.ScopedSoftLine(id, scope_id, spaced)
	local atom = table.copy(Atom)
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
	local parser = vim.treesitter.get_parser(bufnr, "json", {})
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

local function detect_multiline_nodes(nodes)
	nodes = nodes or {}

	local multiline_nodes = {}

	for _, k in ipairs(nodes) do
		-- { start row, start col, end row, end col }
		local range = { k:range() }
		if range[3] > range[1] then
			multiline_nodes[k:id()] = k:id()
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
	prepend_map = {}, --hash_map of lists atom
	append_map = {}, --hash_map of lists atom
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

	self.atoms = {}
	self.prepend_map = {}
	self.append_map = {}
	self.leaf_nodes = table.copy(leaf_nodes)
	self.parent_leaf_nodes = {}
	self.multiline_nodes = table.copy(multiline_nodes)
	self.blank_lines_before = blank_line_nodes.before
	self.line_break_before = line_break_nodes.before
	self.line_break_after = line_break_nodes.after
	self.counter = 0

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
	elseif node:child_count() == 0 or self.leaf_nodes[id] ~= nil then
		-- vim.print(node:child_count())
		-- vim.print(self.leaf_nodes[id])
		-- vim.print(node:has_error())
		-- vim.print(vim.treesitter.get_node_text(node, bufnr))
		table.insert(
			self.atoms,
			Atom.Leaf(vim.treesitter.get_node_text(node, bufnr), id, { node:range() }, false, false)
		)
		self:mark_leaf_parent(node, id)
	else
		for n in node:iter_children() do
			self:collect_leafs_inner(bufnr, n, parent_ids, level + 1)
		end
	end
end

local function require_delimiters(name, predicates)
	if predicates.delimiter == nil then
		error(string.format("%q requires a #delimiter! directive", name))
	end
	return predicates.delimiter
end

local function require_scope_id(name, predicates)
	if predicates.scope_id == nil then
		error(string.format("%q requires a #scope_id! directive", name))
	end
	return predicates.scope_id
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

	vim.print(name)

	if is_multi_line and predicates.single_line_only then
		vim.print("Skipping because context is multi-line and #single_line_only! is set")
		return
	end

	if not is_multi_line and predicates.multi_line_only then
		vim.print("Skipping because context is single-line and #multi_line_only! is set")
		return
	end

	local parent_leaf_node = self.parent_leaf_nodes[node:id()]
	if parent_leaf_node ~= nil and parent_leaf_node ~= node:id()then
		vim.print("Skipping because the match occurred below a leaf node: {}")
		return
	end

	if name == "allow_blank_line_before" then
		vim.print("yo!")
		if self.blank_lines_before[node:id()] ~= nil then
			self:prepend(Atom.Blankline, node, predicates)
		end
	elseif name == "append_delimiter" then
		self:append(Atom.Literal(require_delimiters(name, predicates)), node, predicates)
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
	elseif name == "append_spaced_softline" then
		self:append(Atom.Softline(true), node, predicates)
	elseif name == "prepend_delimiter" then
		self:prepend(Atom.Literal(require_delimiters(name, predicates)), node, predicates)
	elseif name == "prepend_empty_softline" then
		self:prepend(Atom.Softline(false), node, predicates)
	elseif name == "prepend_hardline" then
		self:prepend(Atom.Hardline(), node, predicates)
	elseif name == "prepend_indent_start" then
		self:prepend(Atom.IndentStart(), node, predicates)
	elseif name == "prepend_indent_end" then
		self:prepend(Atom.IndentEnd(), node, predicates)
	elseif name == "prepend_input_softline" then
		local space = {}
		if self.line_break_before[node:id()] then
			space = Atom.Hardline()
		else
			space = Atom.Space()
		end
		self:prepend(space, node, predicates)
	elseif name == "prepend_space" then
		self:prepend(Atom.Space(), node, predicates)
	elseif name == "prepend_antispace" then
		self:prepend(Atom.Antispace(), node, predicates)
	elseif name == "prepend_spaced_softline" then
		self:prepend(Atom.Softline(true), node, predicates)
	elseif name == "leaf" then
	elseif name == "delete" then
		self:prepend(Atom.DeleteBegin(), node, predicates)
		self:append(Atom.DeleteEnd(), node, predicates)
	elseif name == "prepend_begin_scope" then
		local ranges = { node:range() }
		self:prepend(Atom.ScopeBegin(ranges[1], require_scope_id(name, predicates)), node, predicates)
	elseif name == "append_begin_scope" then
		local ranges = { node:range() }
		self:append(Atom.ScopeBegin(ranges[3], require_scope_id(name, predicates)), node, predicates)
	elseif name == "prepend_end_scope" then
		local ranges = { node:range() }
		self:prepend(Atom.ScopeEnd(ranges[1], require_scope_id(name, predicates)), node, predicates)
	elseif name == "append_end_scope" then
		local ranges = { node:range() }
		self:append(Atom.ScopeEnd(ranges[3], require_scope_id(name, predicates)), node, predicates)
	elseif name == "append_empty_scoped_softline" then
		self:append(Atom.ScopedSoftLine(self:next_id(), require_scope_id(name, predicates), false), node, predicates)
	elseif name == "append_spaced_scoped_softline" then
		self:append(Atom.ScopedSoftLine(self:next_id(), require_scope_id(name, predicates), true), node, predicates)
	elseif name == "prepend_empty_scoped_softline" then
		self:prepend(Atom.ScopedSoftLine(self:next_id(), require_scope_id(name, predicates), false), node, predicates)
	elseif name == "prepend_spaced_scoped_softline" then
		self:prepend(Atom.ScopedSoftLine(self:next_id(), require_scope_id(name, predicates), true), node, predicates)
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
	else
		error(string.format("Unknown capture name: %q", name))
	end
end

function Atoms:prepend(atom, node, predicates)
	atom = self:expand_multi_line(atom, node)
	atom = self:wrap(atom, predicates)
	local target_node = self:first_leaf(node)

	if self.prepend_map[target_node:id()] == nil then
		self.prepend_map[target_node:id()] = {}
	end
	table.insert(self.prepend_map[target_node:id()], atom)
end

function Atoms:append(atom, node, predicates)
	atom = self:expand_multi_line(atom, node)
	atom = self:wrap(atom, predicates)
	local target_node = self:last_leaf(node)

	if self.append_map[target_node:id()] == nil then
		self.append_map[target_node:id()] = {}
	end
	table.insert(self.append_map[target_node:id()], atom)
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
		local n = node:child(nr_children)
		return self:last_leaf(n)
	end
end

function Atoms:apply_prepends_and_appends()
	local expanded = {}

	for _, atom in pairs(self.atoms) do
		if atom.type == "Leaf" then
			local id = atom.id
			local prepends = self.prepend_map[id] or {}
			local appends = self.append_map[id] or {}

			vim.list_extend(expanded, prepends)
			table.insert(expanded, atom)
			vim.list_extend(expanded, appends)
		else
			table.insert(expanded, atom)
		end
	end

	self.atoms = expanded
end

local function collapse_spaces_before_antispace(v)
	local antispace_mode = false

	for i = #v, 1, -1 do
		local a = v[i]
		if a.type == "Antispace" then
			v[i] = Atom.Empty()
		elseif a.type == "Space" and antispace_mode then
			v[i] = Atom.Empty()
		else
			antispace_mode = false
		end
	end
end

function Atoms:post_process()
	self:post_process_scopes()
	self:post_process_deletes()
	self:post_process_inner()

	collapse_spaces_before_antispace(self.atoms)

	self:post_process_inner()
end

function Atoms:post_process_scopes()
	local opened_scopes = {} -- hash_map of lists of index-list pairs
	local modifications = {} -- hash_map of node ids and atoms

	local force_apply_modifications = false

	for i, atom in pairs(self.atoms) do
		if atom.type == "ScopeBegin" then
			local scope_id = atom.scope_id
			if opened_scopes[scope_id] == nil then
				opened_scopes[scope_id] = {}
			end
			local opened_scope = opened_scopes[scope_id]
			table.insert(opened_scope, { fst = atom.line_number, snd = {} })
		elseif atom.type == "ScopeEnd" then
			local line_end = atom.line_number
			local scope_id = atom.scope_id
			local list = opened_scopes[scope_id]
			if list ~= nil and #list ~= 0 then
				local pair = list[#list]
				local line_start = pair.fst
				local atoms = pair.snd
				table.remove(list, #list)
				local multi_line = line_start ~= line_end
				for n, a in pairs(atoms) do
					if a.type == "ScopedSoftLine" then
						local new_atom = nil
						if multi_line then
							new_atom = Atom.Hardline()
						elseif a.spaced then
							new_atom = Atom.Space()
						else
							new_atom = Atom.Empty()
						end
						modifications[atom.id] = new_atom
					elseif a.type == "ScopedConditional" then
						local multi_line_only = a.condition == ScopedCondition.MultiLineOnly
						local new_atom = nil
						if multi_line == multi_line_only then
							new_atom = table.copy(a.atom)
						else
							new_atom = Atom.Empty()
						end
						modifications[atom.id] = new_atom
					end
				end
			else
				warn(string.format("Closing unopened scope %q", scope_id))
				force_apply_modifications = true
			end
		elseif atom.type == "ScopedSoftLine" then
			local list = opened_scopes[atom.scope_id].snd or {}
			if #list ~= 0 then
				table.insert(list, atom)
			else
				warn(string.format("Found scoped soft line %q outside of its scope", vim.inspect(atom)))
				force_apply_modifications = true
			end
		elseif atom.type == "ScopedConditional" then
			local list = opened_scopes[atom.scope_id].snd or {}
			if #list ~= 0 then
				table.insert(list, atom)
			else
				warn(string.format("Found scoped conditional %q outside of its scope", vim.inspect(atom.type)))
				force_apply_modifications = true
			end
		end
	end

	local still_opened = {}
	for _, list in pairs(opened_scopes) do
		for n in list do
			if #n.snd ~= 0 then
				table.insert(still_opened, n.fst)
			end
		end
	end

	if #still_opened ~= 0 then
		warn(string.format("Some scopes have been left opened: %q", vim.inspect(still_opened)))
		force_apply_modifications = true
	end

	for i, atom in pairs(self.atoms) do
		if atom.type == "ScopeBegin" or atom.type == "ScopeEnd" then
			self.atoms[i] = Atom.Empty()
		end
	end

	if #modifications ~= 0 or force_apply_modifications then
		for i, atom in pairs(self.atoms) do
			if atom.type == "ScopedSoftLine" then
				local replacement = modifications[atom.id]
				modifications[atom.id] = nil
				if replacement ~= nil then
					self.atoms[i] = replacement
				else
					warn(string.format("Found scoped softline %q, but was unable to replace it.", vim.inspect(atom)))
					self.atoms[i] = Atom.Empty()
				end
			elseif atom.type == "ScopedConditional" then
				local replacement = modifications[atom.id]
				modifications[atom.id] = nil
				if replacement ~= nil then
					self.atoms[i] = replacement
				else
					warn(string.format("Found scoped conditional %q, but was unable to replace it.", vim.inspect(atom)))
					self.atoms[i] = Atom.Empty()
				end
			end
		end
	end
end

function Atoms:post_process_deletes()
	local delete_level = 0
	for i, atom in pairs(self.atoms) do
		if atom.type == "DeleteBegin" then
			delete_level = delete_level + 1
			self.atoms[i] = Atom.Empty()
		elseif atom.type == "DeleteEnd" then
			delete_level = delete_level - 1
			self.atoms[i] = Atom.Empty()
		elseif delete_level > 0 then
			self.atoms[i] = Atom.Empty()
		end
	end
end

local function is_dominant(next, prev)
	if next.type == "Empty" then
		return false
	elseif next.type == "Space" then
		return prev.type == "Empty"
	elseif next.type == "Hardline" then
		return prev.type == "Space" or prev.type == "Empty"
	elseif next.type == "Blankline" then
		return prev.type ~= "Blankline"
	else
		error("Unexpected character in is_dominant!")
	end
end

function Atoms:post_process_inner()
	local prev = nil
	local prev_index = nil
	for i, next in pairs(self.atoms) do
		if prev ~= nil then
			if prev.type == "Antispace" then
				if next.type == "Space" or next.type == "Antispace" then
					self.atoms[i] = Atom.Empty()
					next = self.atoms[i]
				end
			elseif
				prev.type == "Empty"
				or prev.type == "Space"
				or prev.type == "Hardline"
				or prev.type == "Blankline"
			then
				if
					next.type == "Empty"
					or next.type == "Space"
					or next.type == "Hardline"
					or next.type == "Blankline"
				then
					if is_dominant(next, prev) then
						self.atoms[prev_index] = Atom.Empty()
						prev = self.atoms[prev_index]
					else
						self.atoms[i] = Atom.Empty()
						next = self.atoms[i]
					end
				elseif next.type == "IndentStart" or next.type == "IndentEnd" then
					local old_prev = table.copy(prev)
					self.atoms[prev_index] = table.copy(next)
					prev = self.atoms[prev_index]
					self.atoms[i] = old_prev
					next = self.atoms[i]
				end
			end
		else
			if
				next.type == "Empty"
				or next.type == "Space"
				or next.type == "Antispace"
				or next.type == "Hardline"
				or next.type == "Blankline"
			then
				self.atoms[i] = Atom.Empty()
				next = self.atoms[i]
			end
		end

		if next.type ~= "Empty" then
			prev = next
			prev_index = i
		end
	end
end

local function collect_leafs(bufnr, root, leaf_nodes)
	local dfs_nodes = dfs_flatten(root)

	local multiline_nodes = detect_multiline_nodes(dfs_nodes)
	local blank_line_nodes = detect_linebreaks(dfs_nodes, 2)
	local line_break_nodes = detect_linebreaks(dfs_nodes, 1)

	local atoms = Atoms.init(leaf_nodes, multiline_nodes, blank_line_nodes, line_break_nodes)

	atoms:collect_leafs_inner(bufnr, root, {}, 0)

	return atoms
end

local function apply_query(bufnr, query, root)
	local leaf_ids = {}

	for id, node in query:iter_captures(root, bufnr, 0, -1) do
		-- { start row, start col, end row, end col }
		-- local range = { node:range() }
		local name = query.captures[id]
		-- vim.print("here i a ma " .. name .. " l")
		if name == "leaf" then
			leaf_ids[node:id()] = node:id()
		end
	end

	local atoms = collect_leafs(bufnr, root, leaf_ids)

	-- vim.print(atoms)

	for _, match, metadata in query:iter_matches(root, bufnr, 0, -1) do

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

	return atoms
end

local function current_column(str)
	local c = 1
	for i = str:len(), 1, -1 do
		if str:sub(i, i) == "\n" then
			return c
		end
		c = c + 1
	end
	return c
end

local function add_spaces_after_newlines(str, n)
	local result = ""
	for i = 1, str:len() do
		result = result .. str:sub(i, i)
		if str:sub(i, i) == "\n" then
			str = str .. string.rep(" ", n)
		end
	end
	return result
end

local function try_removing_spaces_after_newlines(str, n)
	local result = ""

	for i = 1, str:len() do
		result = result .. str:sub(i, i)
		if str:sub(i, i) == "\n" then
			for j = 1, n do
				if str:sub(i + 1, i + 1) == " " then
					i = i + 1
				else
					break
				end
			end
		end
	end

	return result
end

local function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

local function render(atoms, indent)
	local buffer = ""
	local indent_level = 0

	for _, atom in pairs(atoms) do
		if atom.type == "Blankline" then
			buffer = buffer .. "\n\n" .. indent:rep(indent_level)
		elseif atom.type == "Empty" then
		elseif atom.type == "Hardline" then
			buffer = buffer .. "\n" .. indent:rep(indent_level)
		elseif atom.type == "IndentEnd" then
			if indent_level == 0 then
				error("Trying to close an unopened indentation block")
			end
			indent_level = indent_level - 1
		elseif atom.type == "IndentStart" then
			indent_level = indent_level + 1
		elseif atom.type == "Leaf" then
			if atom.single_line_no_indent then
				buffer = buffer .. "\n"
			end

			local content = string.gsub(atom.content, "\n+$", "")

			if atom.multi_line_indent_all then
				local cursor = current_column(buffer)
				local original_column = atom.original_position[2]
				local indenting = cursor - original_column
				if indenting > 0 then
					content = add_spaces_after_newlines(content, indenting)
				elseif indenting < 0 then
					content = try_removing_spaces_after_newlines(content, -indenting)
				end
			end

			buffer = buffer .. content
		elseif atom.type == "Literal" then
			buffer = buffer .. atom.literal
		elseif atom.type == "Space" then
			buffer = buffer .. " "
		else
			error(
				string.format(
					"Found atom that should have been removed before rendering %s %q",
					atom.type,
					vim.inspect(atom)
				)
			)
		end
	end

	return split(buffer, "\n")
end

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

local format = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	-- if vim.bo[bufnr].filetype ~= "typescript" then
	-- 	vim.notify("Can only be used in typescript")
	-- 	return
	-- end

	local root = get_root(bufnr)

	local query = get_query_ts()

	local atoms = apply_query(bufnr, query, root)

	atoms:post_process()

	local rendered = render(atoms.atoms, "  ")

	vim.print(rendered)

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, rendered)
end

vim.keymap.set("n", "<leader>tt", function()
	format()
end, { noremap = true, silent = true })

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
