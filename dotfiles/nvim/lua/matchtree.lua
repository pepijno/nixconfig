local M = {}

local Set = require("set")
local priorities = (vim.hl or vim.highlight).priorities

M.nsids = setmetatable({}, {
	__index = function(t, k)
		local result = rawget(t, k)
		if result == nil then
			result = vim.api.nvim_create_namespace("")
			rawset(t, k, result)
		end
		return result
	end,
	-- Note: this will only catch new indices, not assignment to an already
	-- existing key
	__newindex = function(_, _, _)
		error("Table is immutable")
	end,
})

local function highlight(bufnr, lang, node, hlgroup)
	-- range of the capture, zero-indexed
	local startRow, startCol, endRow, endCol = node:range()
	vim.print({ startRow, startCol, endRow, endCol })

	local start, finish = { startRow, startCol }, { endRow, endCol - 1 }
	local opts = {
		regtype = "v",
		inclusive = true,
		priority = math.floor((priorities.semantic_tokens + priorities.treesitter) / 2),
	}

	local nsid = M.nsids[lang]

	if vim.api.nvim_buf_is_loaded(bufnr) then
		(vim.hl or vim.highlight).range(bufnr, nsid, hlgroup, start, finish, opts)
	end
end

---Get the appropriate highlight group for the given level of nesting.
---@param i integer  One-based index into the highlight groups
---@return string hlgroup  Name of the highlight groups
local function hlgroup_at(i)
	-- local hlgroups = config.highlight
	-- return hlgroups[(i - 1) % #hlgroups + 1]
	return "PrismDepth0"
end

local match_mt = {
	__tostring = function(self)
		return string.format("{container = %s, delimiters = %s}", tostring(self.container), tostring(self.delimiters))
	end,
}

local tree_mt = {
	---@param m1 rainbow_delimiters.MatchTree
	---@param m2 rainbow_delimiters.MatchTree
	---@return boolean
	__lt = function(m1, m2)
		local c1 = m1.match.container
		local r2 = { m2.match.container:range() }
		return vim.treesitter.node_contains(c1, r2)
	end,
	---Appends the given match tree `m2` to this match tree.  Will traverse
	---through the descendants until it finds the most appropriate one.
	---@return boolean success  Whether appending was successfull
	__call = function(self, other)
		if not (self < other) then
			return false
		end
		for child in self.children:items() do
			if child < other then
				return child(other)
			end
		end
		self.children:add(other)
		return true
	end,
	__tostring = function(self)
		return string.format("{match = %s, children = %s}", tostring(self.match), tostring(self.children))
	end,
}

---Instantiate a new match tree node without children based on the results of
---the `iter_matches` method of a query.
---@param query vim.treesitter.Query
---@param match Table<integer, vim.treesitter.TSNode[]>
---@return rainbow_delimiters.MatchTree
function M.assemble(query, match)
	local result = {delimiters = Set.new()}
	for id, nodes in pairs(match) do
		local capture = query.captures[id]
		if capture == 'delimiter' then
			-- It is expected for a match to contain any number of delimiters
			for _, node in ipairs(nodes) do
				result.delimiters:add(node)
			end
		else
			-- We assume that there is only ever exactly one node per
			-- non-delimiter capture
			result[capture] = nodes[1]
		end
	end

	---@type rainbow_delimiters.MatchTree
	local matchtree = {
		match = setmetatable(result, match_mt),
		children = Set.new(),
	}
	return setmetatable(matchtree, tree_mt)
end

---Apply highlighting to a given match tree at a given level
---@param bufnr integer
---@param lang  string
---@param tree  rainbow_delimiters.MatchTree
---@param level integer  Highlight level of this tree
---@param pred  (fun(rainbow_delimiters): boolean)?  Predicate function, will abort highlighting if it evaluates to `false` at any point down the tree for that branch only.
function M.highlight(tree, bufnr, lang, level, pred)
	-- if pred and not pred(tree) then
	-- 	return
	-- end
	local hlgroup = hlgroup_at(level)
	vim.print(tree.match.delimiters)
	for delimiter in tree.match.delimiters:items() do
		highlight(bufnr, lang, delimiter, hlgroup)
	end
	for child in tree.children:items() do
		M.highlight(child, bufnr, lang, level + 1, pred)
	end
end

return M
