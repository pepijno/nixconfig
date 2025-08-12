local latte = require("catppuccin.palettes").get_palette("latte")

local current_scope = {}

local ns_id = vim.api.nvim_create_namespace("Indentscope")

local function get_line_indent(line)
	local prev_nonblank = vim.fn.prevnonblank(line)
	local res = vim.fn.indent(prev_nonblank)

	if line ~= prev_nonblank then
		local next_indent = vim.fn.indent(vim.fn.nextnonblank(line))
		res = math.max(res, next_indent)
	end

	return res
end

local function cast_ray(line, indent, direction)
	local final_line, increment = 1, -1
	if direction == "down" then
		final_line, increment = vim.fn.line("$"), 1
	end

	local is_incomplete
	if math.abs(line - final_line) > 10000 then
		final_line, is_incomplete = line + increment * 10000, true
	end

	local min_indent = math.huge
	for l = line, final_line, increment do
		local new_indent = get_line_indent(l + increment)
		if new_indent < indent then
			return l, min_indent, nil
		end
		if new_indent < min_indent then
			min_indent = new_indent
		end
	end

	return final_line, min_indent, is_incomplete
end

local function get_scope()
	local curpos = vim.fn.getcurpos()
	local line = curpos[2]
	local col = curpos[5] or math.huge

	local line_indent = get_line_indent(line)
	local indent = math.min(col, line_indent)

	local body = { indent = indent }
	if indent <= 0 then
		body.top, body.bottom, body.indent = 1, vim.fn.line("$"), line_indent
	else
		local up_line, up_min_indent, up_is_incomplete = cast_ray(line, indent, "up")
		local down_line, down_min_indent, down_is_incomplete = cast_ray(line, indent, "down")
		body.top, body.bottom = up_line, down_line
		body.indent = math.min(line_indent, up_min_indent, down_min_indent)
		body.is_incomplete = up_is_incomplete or down_is_incomplete
	end

	return {
		body = body,
		border_indent = math.max(get_line_indent(body.top - 1), get_line_indent(body.bottom + 1)),
		buf_id = vim.api.nvim_get_current_buf(),
	}
end

local function indicator_compute(scope)
	scope = scope or current_scope
	local indent = scope.border_indent or (scope.body.indent - 1)

	if indent < 0 then
		return {}
	end

	local col = indent - vim.fn.winsaveview().leftcol
	if col < 0 then
		return {}
	end

	local hl_group = (indent % vim.fn.shiftwidth() == 0) and "IndentscopeSymbol" or "IndentscopeSymbolOff"
	local virt_text = { { "╎", hl_group } }

	return {
		buf_id = vim.api.nvim_get_current_buf(),
		virt_text = virt_text,
		virt_text_win_col = col,
		top = scope.body.top,
		bottom = scope.body.bottom,
	}
end

local function draw_scope(scope)
	scope = scope or {}

	local indicator = indicator_compute(scope)

	local extmark_opts = {
		hl_mode = "combine",
		right_gravity = false,
		virt_text = indicator.virt_text,
		virt_text_win_col = indicator.virt_text_win_col,
		virt_text_pos = "overlay",
	}
	if vim.wo.breakindent and vim.wo.showbreak == "" then
		extmark_opts.virt_text_repeat_linebreak = true
	end

	local top, bottom = indicator.top, indicator.bottom

	if top ~= nil and bottom ~= nil then
		for i = top, bottom, 1 do
			if indicator.top <= i and i <= indicator.bottom then
				vim.api.nvim_buf_set_extmark(indicator.buf_id, ns_id, i - 1, 0, extmark_opts)
			end
		end
	end
end

local function undraw_scope()
	pcall(vim.api.nvim_buf_clear_namespace, current_scope.buf_id or 0, ns_id, 0, -1)

	current_scope = {}
end

local function draw()
	local scope = get_scope()

	undraw_scope()

	current_scope = scope
	draw_scope(scope)
end

local function create_default_hl()
	vim.api.nvim_set_hl(0, "IndentscopeSymbol", { bold = true, fg = latte.green })
	vim.api.nvim_set_hl(0, "IndentscopeSymbolOff", { link = "IndentscopeSymbol" })
end

local function create_autocommands()
	local gr = vim.api.nvim_create_augroup("Indentscope", {})

	local au = function(event, pattern, callback, desc)
		vim.api.nvim_create_autocmd(event, { group = gr, pattern = pattern, callback = callback, desc = desc })
	end

	local events =
		{ "CursorMoved", "CursorMovedI", "ModeChanged", "TextChanged", "TextChangedI", "TextChangedP", "WinScrolled" }
	au(events, "*", function()
		draw()
	end, "Auto draw indentscope")

	au("ColorScheme", "*", create_default_hl, "Ensure colors")
end

local function setup()
	create_autocommands()
	create_default_hl()
end

return { setup = setup }
