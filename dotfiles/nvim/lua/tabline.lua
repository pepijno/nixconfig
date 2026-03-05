vim.pack.add({ "https://github.com/catppuccin/nvim" })

local latte = require("catppuccin.palettes").get_palette("latte")

local aug = vim.api.nvim_create_augroup("term_mode_restore", { clear = true })

local last_tab = nil

vim.api.nvim_create_autocmd("TabLeave", {
	group = aug,
	pattern = "*",
	callback = function()
		last_tab = vim.fn.tabpagenr()
	end,
})

local set_binding = function(binding)
	local options = { silent = true }

	if type(binding[3]) == "function" then
		vim.keymap.set(binding[1], "<C-a>" .. binding[2], binding[3], options)
	elseif type(binding[3]) == "string" then
		local suffix = ""

		if binding.suffix == nil then
			-- TODO revisit
			suffix = string.sub(binding[3], 1, 1) == ":" and "<CR>" or ""
		else
			suffix = binding.suffix
		end

		if string.lower(string.sub(binding[3], 1, 5)) ~= "<cmd>" then
			if vim.tbl_contains(binding[1], "t") then
				binding[1] = vim.tbl_filter(function(mode)
					return mode ~= "t"
				end, binding[1])
				vim.keymap.set("t", "<C-a>" .. binding[2], "<C-\\><C-n>" .. binding[3] .. suffix, options)
			elseif vim.tbl_contains(binding[1], "i") then
				binding[1] = vim.tbl_filter(function(mode)
					return mode ~= "i"
				end, binding[1])
				vim.keymap.set("i", "<C-a>" .. binding[2], "<ESC>" .. binding[3] .. suffix, options)
			end
		end

		vim.keymap.set(binding[1], "<C-a>" .. binding[2], binding[3] .. suffix, options)
	end
end

vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>", { noremap = true })
set_binding({
	{ "t", "v", "n", "i" },
	"<C-a>",
	function()
		vim.cmd((last_tab or 1) .. "tabn")
	end,
})

local go_to_tab = function(number)
	return function()
		local current_tabs = vim.api.nvim_list_tabpages()
		vim.api.nvim_set_current_tabpage(current_tabs[number])
	end
end

set_binding({ { "t", "v", "n", "i" }, "1", go_to_tab(1) })
set_binding({ { "t", "v", "n", "i" }, "2", go_to_tab(2) })
set_binding({ { "t", "v", "n", "i" }, "3", go_to_tab(3) })
set_binding({ { "t", "v", "n", "i" }, "4", go_to_tab(4) })
set_binding({ { "t", "v", "n", "i" }, "5", go_to_tab(5) })
set_binding({ { "t", "v", "n", "i" }, "6", go_to_tab(6) })
set_binding({ { "t", "v", "n", "i" }, "7", go_to_tab(7) })
set_binding({ { "t", "v", "n", "i" }, "8", go_to_tab(8) })
set_binding({ { "t", "v", "n", "i" }, "9", go_to_tab(9) })
set_binding({
	{ "t", "v", "n", "i" },
	"c",
	function()
		vim.cmd("tab term")
	end,
})
set_binding({ { "t" }, ":", ":", suffix = "" })
set_binding({ { "n", "v", "i" }, "x", "<Cmd>bdelete %<CR>" })
set_binding({
	{ "t" },
	"x",
	function()
		vim.api.nvim_buf_delete(0, { force = true })
	end,
})

local new_tabs = function(tabs, opt)
	return {
		tabs = tabs,
		foreach = function(fn, attrs)
			local nodes = {}
			for i, tab in ipairs(tabs) do
				local node = fn(tab, i, #tabs)
				if node ~= nil and node ~= "" then
					nodes[#nodes + 1] = wrap_tab_node(node, tab.id)
				end
			end
			if attrs ~= nil then
				nodes = vim.tbl_extend("keep", nodes, attrs)
			end
			return nodes
		end,
	}
end

local ensure_hl_obj = function(hl)
	if type(hl) == 'string' then
		return highlight.extract(hl)
	end
	return hl
end

local get_lines = function(opt)
	opt = opt or {}
	return {
		tabs = function()
			local ts = vim.tbl_map(function(tabid)
				return tabs.new_tab(tabid, opt)
			end, vim.api.nvim_list_tabpages())
			return tabs.new_tabs(ts, opt)
		end,
		sep = function(symbol, cur_hl, back_hl)
			local cur_hl_obj = ensure_hl_obj(cur_hl)
			local back_hl_obj = ensure_hl_obj(back_hl)
			return {
				symbol,
				hl = {
					fg = cur_hl_obj.bg,
					bg = back_hl_obj.bg,
				},
			}
		end,
		spacer = function()
			return "%="
		end,
	}
end

local LineBuilder = {}

function LineBuilder:new()
	local o = { strs = {}, current_hl = "" }
	setmetatable(o, { __index = LineBuilder })
	return o
end

local parse_highlight = function(hl)
	vim.validate("hl", hl, { "string", "table" })
	local group
	if type(hl) == "string" then
		group = hl
	elseif type(hl) == "table" then
		-- group = highlight.register(hl)
	end
	return group
end

function LineBuilder:render_element(element, heads)
	local hl_group = parse_highlight(element.hl)
	local tails = {}
	local head_added = false
	local add = function(s, hl)
		if not head_added then
			for i, fn in ipairs(heads) do
				fn()
				heads[i] = nil
			end
			head_added = true
		end
		self:add(s, hl)
	end

	local begin = #self.strs
	local has_margin = false

	for i, node in ipairs(element) do
		if type(node) == "string" and node ~= "" then
			add(node, hl_group)
		elseif type(node) == "number" then
			add(tostring(node), hl_group)
		elseif type(node) == "table" then
			if node.hl == nil then
				node.hl = hl_group
			end
			local n = self:render_element(node, heads)
			if n > 0 then
				has_margin = false
			end
		end
	end

	for i = #tails, 1, -1 do
		tails[i]()
	end
	return #self.strs - begin
end

function LineBuilder:build()
	local line = table.concat(self.strs, "")
	self.strs = {}
	self.current_hl = ""
	return line
end

local preset_head = function(line)
	return {
		{ " tabs: ", hl = "TabLine" },
		line.sep("\238\130\180", "TabLine", "TabLineFill"),
	}
end

local preset_tail = function(line)
	return {
		line.sep("\238\130\182", "TabLine", "TabLineFill"),
		{ " ", hl = "TabLine" },
	}
end

local preset_tab = function(line, tab)
	local hl = tab.is_current() and "TabLineSel" or "TabLine"
	local status_icon = { "+", "" }
	return {
		line.sep("\238\130\182", hl, "TabLineFill"),
		{
			tab.is_current() and status_icon[1] or status_icon[2],
			tab.number(),
			margin = " ",
		},
		tab.name(),
		tab.close_btn("(x)"),
		line.sep("\238\130\180", hl, "TabLineFill"),
		hl = hl,
		margin = " ",
	}
end

local render = function()
	local line = get_lines()
	local element = {
		preset_head(line),
		line.tabs().foreach(function(tab)
			return preset_tab(line, tab)
		end),
		line.spacer(),
		preset_tail(line),
		hl = "TabLineFill",
	}
	if element.hl == nil or element.hl == "" then
		element.hl = "TabLineFill"
	end
	local b = LineBuilder:new()
	b:render_element(element, {})
	return b:build()
end

vim.o.tabline = "%{%luaeval('require(\"tabline\").render()')%}"

return { render = render }
