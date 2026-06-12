local MatchTree = {}

local capture_kinds = {
	main = "main",
	comment = "comment",
	string = "string",
	keyword = "keyword",
	container = "container",
}

local function node_contains(parent, child)
	if parent.start_row > child.start_row then
		return false
	end

	if parent.start_row == child.start_row and parent.start_col > child.start_col then
		return false
	end

	if parent.end_row < child.end_row then
		return false
	end

	if parent.end_row == child.end_row and parent.end_col < child.end_col then
		return false
	end

	return true
end

local function compare_nodes(left, right)
	-- Earlier nodes come first.
	if left.start_row ~= right.start_row then
		return left.start_row < right.start_row
	end

	if left.start_col ~= right.start_col then
		return left.start_col < right.start_col
	end

	-- For nodes starting at the same position, parents come before children.
	if left.end_row ~= right.end_row then
		return left.end_row > right.end_row
	end

	if left.end_col ~= right.end_col then
		return left.end_col > right.end_col
	end

	-- Ensure the translation-unit root is considered first for equal ranges.
	if left.kind == "main" and right.kind ~= "main" then
		return true
	end

	return false
end

local function new_match_node(node, kind)
	local start_row, start_col, end_row, end_col = node:range()

	return {
		node = node,
		kind = kind,
		start_row = start_row,
		start_col = start_col,
		end_row = end_row,
		end_col = end_col,
		children = {},
	}
end

function MatchTree.collect(query, root, bufnr, start_row, end_row)
	local nodes = {}

	for _, match in query:iter_matches(root, bufnr, start_row, end_row) do
		for capture_id, captured_nodes in pairs(match) do
			local capture_name = query.captures[capture_id]
			local kind = capture_kinds[capture_name]

			if kind then
				for _, node in ipairs(captured_nodes) do
					nodes[#nodes + 1] = new_match_node(node, kind)
				end
			end
		end
	end

	table.sort(nodes, compare_nodes)

	return nodes
end

function MatchTree.build(nodes)
	local root = {
		children = {},
	}

	local stack = { root }

	for _, current in ipairs(nodes) do
		while #stack > 1 and not node_contains(stack[#stack], current) do
			table.remove(stack)
		end

		local parent = stack[#stack]
		parent.children[#parent.children + 1] = current
		stack[#stack + 1] = current
	end

	return root
end

function MatchTree.print(tree, indent)
	indent = indent or 0

	for _, child in ipairs(tree.children) do
		local node = child.node

		vim.print(string.rep("  ", indent) .. node:type() .. " " .. vim.inspect({ node:range() }) .. " " .. child.kind)

		MatchTree.print(child, indent + 1)
	end
end

local ns_ids = setmetatable({}, {
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

local priorities = (vim.hl or vim.highlight).priorities

vim.pack.add({ "https://github.com/catppuccin/nvim" })

local latte = require("catppuccin.palettes").get_palette("latte")

local colors = {
	"DepthColor0",
	"DepthColor1",
	"DepthColor2",
	"DepthColor3",
	"DepthColor4",
}

local function hlgroup_at(i)
	local hlgroups = colors
	return hlgroups[i % #hlgroups + 1]
end

local function highlight(bufnr, lang, node, level, kind_opts)
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		return
	end

	local start_row, start_col, end_row, end_col = node:range()

	if end_row == start_row and end_col <= start_col then
		return
	end

	local hl = vim.hl or vim.highlight
	local priority = math.floor((priorities.semantic_tokens + priorities.treesitter) / 2)

	local hlgroup = hlgroup_at(level)

	if kind_opts.is_comment then
		hlgroup = "Comment" .. hlgroup
	elseif kind_opts.is_keyword then
		hlgroup = "Keyword" .. hlgroup
	elseif kind_opts.is_string then
		hlgroup = "String" .. hlgroup
	end

	hl.range(bufnr, ns_ids[lang], hlgroup, { start_row, start_col }, { end_row, end_col - 1 }, {
		regtype = "v",
		inclusive = true,
		priority = priority + level,
	})
end

function MatchTree.highlight(tree, bufnr, lang, level)
	for _, child in ipairs(tree.children) do
		highlight(bufnr, lang, child.node, level, {
			is_comment = child.kind == "comment",
			is_string = child.kind == "string",
			is_keyword = child.kind == "keyword",
		})

		MatchTree.highlight(child, bufnr, lang, level + 1)
	end
end

local function for_each_child(parent_lang, lang, language_tree, thunk)
	thunk(language_tree, lang, parent_lang)
	local children = language_tree:children()
	for child_lang, child in pairs(children) do
		for_each_child(lang, child_lang, child, thunk)
	end
end

local augroup = vim.api.nvim_create_augroup("Prism", {})

local query_cache = {}

local function load_query(lang)
	if query_cache[lang] ~= nil then
		return query_cache[lang] or nil
	end

	local ok, query = pcall(vim.treesitter.query.get, lang, "prism")
	query_cache[lang] = ok and query or false

	return query_cache[lang] or nil
end

local function normalize_change(change)
	if #change == 4 then
		return {
			start_row = change[1],
			end_row = change[3] + 1,
		}
	end

	if #change == 6 then
		return {
			start_row = change[1],
			end_row = math.max(change[3], change[5]) + 1,
		}
	end

	return nil
end

local M = {}

local function merge_ranges(changes)
	local ranges = {}

	for _, change in ipairs(changes) do
		local normalized = normalize_change(change)

		if normalized then
			ranges[#ranges + 1] = normalized
		end
	end

	table.sort(ranges, function(left, right)
		return left.start_row < right.start_row
	end)

	local merged = {}

	for _, range in ipairs(ranges) do
		local previous = merged[#merged]

		if previous and range.start_row <= previous.end_row + 1 then
			previous.end_row = math.max(previous.end_row, range.end_row)
		else
			merged[#merged + 1] = range
		end
	end

	return merged
end

local function update_range(bufnr, changes, tree, lang)
	if vim.fn.pumvisible() ~= 0 then
		return
	end

	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local query = load_query(lang)
	if not query then
		return
	end

	local root = tree:root()
	local ranges = merge_ranges(changes)

	for _, range in ipairs(ranges) do
		M.clear_namespace(bufnr, lang, range.start_row, range.end_row)

		local matches = MatchTree.collect(query, root, bufnr, range.start_row, range.end_row)

		if #matches > 0 then
			local match_tree = MatchTree.build(matches)
			MatchTree.highlight(match_tree, bufnr, lang, 0)
		end
	end
end

local function full_update(bufnr, parser)
	parser:parse()

	local function callback(tree, sub_parser)
		local changes = { { tree:root():range() } }
		update_range(bufnr, changes, tree, sub_parser:lang())
	end

	parser:for_each_tree(callback)
end

local function setup_parser(bufnr, parser, start_parent_lang)
	local function f(p, lang, parent_lang)
		if not load_query(lang) then
			return
		end

		local function on_changedtree(changes, tree)
			if not M.buffers[bufnr] then
				return
			end

			if parent_lang ~= nil and parent_lang ~= lang and changes[1] then
				changes = { tree:root():range() }
			elseif parent_lang ~= nil then
				changes = {}
			end

			if changes[1] then
				update_range(bufnr, changes, tree, lang)
			end
		end

		local function on_child_added(child)
			setup_parser(bufnr, child, lang)
		end

		p:register_cbs({
			on_changedtree = on_changedtree,
			on_child_added = on_child_added,
		})
	end

	for_each_child(start_parent_lang, parser:lang(), parser, f)

	full_update(bufnr, parser)
end

M.buffers = {}

function M.attach(bufnr)
	local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].ft)
	if not lang then
		return
	end

	local settings = M.buffers[bufnr]
	if settings then
		if settings.lang == lang then
			local parser = vim.treesitter.get_parser(bufnr, lang)
			parser:invalidate(true)
			parser:parse()
		end
		M.detach(bufnr)
	end

	local parser
	do
		local success
		success, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
		if not success or not parser then
			return
		end
	end

	local function f(child)
		if child:lang() ~= lang then
			M.clear_namespace(bufnr, child:lang())
		end
	end

	parser:register_cbs({
		on_detach = function(bnr)
			if not M.buffers[bnr] then
				return
			end
			M.detach(bufnr)
		end,
		on_child_removed = f,
	})

	settings = {
		parser = parser,
		lang = lang,
	}
	M.buffers[bufnr] = settings

	local success, error = pcall(M.on_attach, bufnr, settings)
	if not success then
		-- log.error('Error attaching strategy to buffer %d: %s', bufnr, error)
		M.buffers[bufnr] = nil
	end
end

function M.detach(bufnr)
	local settings = M.buffers[bufnr]

	if not settings then
		return
	end

	M.buffers[bufnr] = nil

	for_each_child(nil, settings.parser:lang(), settings.parser, function(_, lang)
		M.clear_namespace(bufnr, lang)
	end)

	settings.parser:destroy()

	local ok, err = pcall(M.on_detach, bufnr)
	if not ok then
		vim.notify(
			("DepthColor detach failed: %s"):format(err),
			vim.log.levels.WARN
		)
	end
end

function M.clear_namespace(bufnr, lang, line_start, line_end)
	local ns_id = ns_ids[lang]
	if vim.api.nvim_buf_is_valid(bufnr) then
		vim.api.nvim_buf_clear_namespace(bufnr, ns_id, line_start or 0, line_end or -1)
	end
end

function M.on_detach(bufnr)
	vim.api.nvim_clear_autocmds({
		buffer = bufnr,
		group = augroup,
	})
end

local function schedule_parse(bufnr)
	local settings = M.buffers[bufnr]

	if not settings or settings.parse_scheduled then
		return
	end

	settings.parse_scheduled = true

	vim.defer_fn(function()
		local current = M.buffers[bufnr]

		if not current then
			return
		end

		current.parse_scheduled = false

		if vim.api.nvim_buf_is_valid(bufnr) then
			current.parser:parse()
		end
	end, 25)
end

function M.on_attach(bufnr, settings)
	setup_parser(bufnr, settings.parser, nil)

	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		group = augroup,
		buffer = bufnr,
		callback = function()
			schedule_parse(bufnr)
		end,
	})
end

local function define_hlgroups()
	vim.api.nvim_set_hl(0, "DepthColor0", { default = true, fg = latte.mauve })
	vim.api.nvim_set_hl(0, "DepthColor1", { default = true, fg = latte.green })
	vim.api.nvim_set_hl(0, "DepthColor2", { default = true, fg = latte.flamingo })
	vim.api.nvim_set_hl(0, "DepthColor3", { default = true, fg = latte.blue })
	vim.api.nvim_set_hl(0, "DepthColor4", { default = true, fg = latte.yellow })

	vim.api.nvim_set_hl(0, "KeywordDepthColor1", { bold = true, fg = latte.mauve })
	vim.api.nvim_set_hl(0, "KeywordDepthColor2", { bold = true, fg = latte.green })
	vim.api.nvim_set_hl(0, "KeywordDepthColor3", { bold = true, fg = latte.flamingo })
	vim.api.nvim_set_hl(0, "KeywordDepthColor4", { bold = true, fg = latte.blue })
	vim.api.nvim_set_hl(0, "KeywordDepthColor0", { bold = true, fg = latte.yellow })

	vim.api.nvim_set_hl(0, "StringDepthColor1", { bold = true, fg = latte.pink })
	vim.api.nvim_set_hl(0, "StringDepthColor2", { bold = true, fg = latte.pink })
	vim.api.nvim_set_hl(0, "StringDepthColor3", { bold = true, fg = latte.pink })
	vim.api.nvim_set_hl(0, "StringDepthColor4", { bold = true, fg = latte.pink })
	vim.api.nvim_set_hl(0, "StringDepthColor0", { bold = true, fg = latte.pink })

	vim.api.nvim_set_hl(0, "CommentDepthColor0", { bold = true, fg = latte.overlay0 })
	vim.api.nvim_set_hl(0, "CommentDepthColor1", { bold = true, fg = latte.overlay0 })
	vim.api.nvim_set_hl(0, "CommentDepthColor2", { bold = true, fg = latte.overlay0 })
	vim.api.nvim_set_hl(0, "CommentDepthColor3", { bold = true, fg = latte.overlay0 })
	vim.api.nvim_set_hl(0, "CommentDepthColor4", { bold = true, fg = latte.overlay0 })
end

define_hlgroups()

local rb_augroup = vim.api.nvim_create_augroup("DepthColor", {})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Attach to a new buffer",
	group = rb_augroup,
	callback = function(args)
		M.attach(args.buf)
	end,
})

vim.api.nvim_create_autocmd("BufUnload", {
	desc = "Detach from the current buffer",
	group = rb_augroup,
	callback = function(args)
		M.detach(args.buf)
	end,
})
