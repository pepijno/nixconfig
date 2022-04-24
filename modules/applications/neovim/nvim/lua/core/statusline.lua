local M = {}

M.trunc_width = setmetatable({
	-- You can adjust these values to your liking, if you want
	-- I promise this will all makes sense later :)
	mode = 80,
	git_status = 90,
	filename = 140,
	line_col = 60,
}, {
	__index = function()
		return 80 -- handle edge cases, if there's any
	end,
})

M.is_truncated = function(_, width)
	local current_width = api.nvim_win_get_width(0)
	return current_width < width
end

M.colors = {
	active = "%#StatusLine#",
	inactive = "%#StatuslineNC#",
	mode = "%#Mode#",
	mode_alt = "%#ModeAlt#",
	git = "%#Git#",
	git_alt = "%#GitAlt#",
	filetype = "%#Filetype#",
	filetype_alt = "%#FiletypeAlt#",
	line_col = "%#LineCol#",
	line_col_alt = "%#LineColAlt#",
}
M.separators = {
	arrow = { "", "" },
	rounded = { "", "" },
	blank = { "", "" },
}

local active_sep = "blank"

M.modes = setmetatable({
	["n"] = { "Normal", "N" },
	["no"] = { "N·Pending", "N·P" },
	["v"] = { "Visual", "V" },
	["V"] = { "V·Line", "V·L" },
	[""] = { "V·Block", "V·B" },
	["s"] = { "Select", "S" },
	["S"] = { "S·Line", "S·L" },
	[""] = { "S·Block", "S·B" },
	["i"] = { "Insert", "I" },
	["ic"] = { "Insert", "I" },
	["R"] = { "Replace", "R" },
	["Rv"] = { "V·Replace", "V·R" },
	["c"] = { "Command", "C" },
	["cv"] = { "Vim·Ex ", "V·E" },
	["ce"] = { "Ex ", "E" },
	["r"] = { "Prompt ", "P" },
	["rm"] = { "More ", "M" },
	["r?"] = { "Confirm ", "C" },
	["!"] = { "Shell ", "S" },
	["t"] = { "Terminal ", "T" },
}, {
	__index = function()
		return { "Unknown", "U" } -- handle edge cases
	end,
})

M.get_current_mode = function()
	local current_mode = vim.api.nvim_get_mode().mode

	if M.is_truncated(M.trunc_width.mode) then
		return string.format(" %s ", M.modes[current_mode][2]):upper()
	end

	return string.format(" %s ", M.modes[current_mode][1]):upper()
end

M.get_git_status = function(self)
	-- use fallback because it doesn't set this variable on the initial `BufEnter`
	local signs = vim.b.gitsigns_status_dict or { head = "", added = 0, changed = 0, removed = 0 }
	local is_head_empty = signs.head ~= ""

	if self:is_truncated(self.trunc_width.git_status) then
		return is_head_empty and string.format("  %s ", signs.head or "") or ""
	end

	return is_head_empty
			and string.format(" +%s ~%s -%s |  %s ", signs.added, signs.changed, signs.removed, signs.head)
		or ""
end

M.get_filetype = function()
	local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
	local icon = require("nvim-web-devicons").get_icon(file_name, file_ext, { default = true })
	local filetype = vim.bo.filetype

	if filetype == "" then
		return ""
	end
	return string.format(" %s %s ", icon, filetype):lower()
end

M.get_line_col = function(self)
	if self:is_truncated(self.trunc_width.line_col) then
		return " %l:%c "
	end
	return " Ln %l, Col %c "
end

M.get_lsp_diagnostic = function(self)
	local result = {}
	local levels = {
		errors = "Error",
		warnings = "Warning",
		info = "Information",
		hints = "Hint",
	}

	for k, level in pairs(levels) do
		result[k] = vim.lsp.diagnostic.get_count(0, level)
	end

	if self:is_truncated(self.trunc_width.diagnostic) then
		return ""
	else
		return string.format(
			"| :%s :%s :%s :%s ",
			result["errors"] or 0,
			result["warnings"] or 0,
			result["info"] or 0,
			result["hints"] or 0
		)
	end
end

M.set_active = function(self)
	local colors = self.colors

	local mode = colors.mode .. self:get_current_mode()
	local mode_alt = colors.mode_alt .. self.separators[active_sep][1]
	local git = colors.git .. self:get_git_status()
	local git_alt = colors.git_alt .. self.separators[active_sep][1]
	local filename = colors.inactive .. self:get_filename()
	local filetype_alt = colors.filetype_alt .. self.separators[active_sep][2]
	local filetype = colors.filetype .. self:get_filetype()
	local line_col = colors.line_col .. self:get_line_col()
	local line_col_alt = colors.line_col_alt .. self.separators[active_sep][2]

	return table.concat({
		colors.active,
		mode,
		mode_alt,
		git,
		git_alt,
		"%=",
		filename,
		"%=",
		filetype_alt,
		filetype,
		line_col_alt,
		line_col,
	})
end

M.set_inactive = function(self)
	return self.colors.inactive .. "%= %F %="
end

M.set_explorer = function(self)
	local title = self.colors.mode .. "   "
	local title_alt = self.colors.mode_alt .. self.separators[active_sep][2]

	return table.concat({ self.colors.active, title, title_alt })
end

M.config = function()
	Statusline = setmetatable(M, {
		__call = function(statusline, mode)
			return self["set_" .. mode](self)
		end,
	})

	api.nvim_exec(
		[[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline('active')
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline('inactive')
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline('explorer')
  augroup END
]],
		false
	)
end

return M
