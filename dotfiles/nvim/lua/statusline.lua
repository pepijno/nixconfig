vim.pack.add({ "https://github.com/catppuccin/nvim" })
local latte = require("catppuccin.palettes").get_palette("latte")
local config = { ["no-name-text"] = "[No Name]", ["modified-symbol"] = "[+]", ["readonly-symbol"] = "[-]" }
local theme_colors = {
	normal = { primary = latte.blue },
	insert = { primary = latte.green },
	replace = { primary = latte.red },
	visual = { primary = latte.mauve },
	command = { primary = latte.yellow },
}
local function create_section_colors()
	local sections = {}
	for mode, colors in pairs(theme_colors) do
		sections[mode] = {
			a = { bg = colors.primary, fg = latte.base, gui = "bold" },
			b = { bg = latte.surface0, fg = colors.primary },
			c = { bg = latte.base, fg = colors.primary },
		}
	end
	sections["terminal"] = sections.command
	sections["inactive"] = sections.normal
	sections["background"] = { a = { bg = latte.base, fg = latte.surface0 } }
	return sections
end
local section_colors = create_section_colors()
local vim_modes = {
	n = "NORMAL",
	nt = "NORMAL",
	ntT = "NORMAL",
	niI = "NORMAL",
	niR = "NORMAL",
	niV = "NORMAL",
	i = "INSERT",
	ic = "INSERT",
	ix = "INSERT",
	v = "VISUAL",
	vs = "VISUAL",
	V = "V-LINE",
	Vs = "V-LINE",
	["\22"] = "V-BLOCK",
	["\22s"] = "V-BLOCK",
	s = "SELECT",
	S = "S-LINE",
	["\19"] = "S-BLOCK",
	R = "REPLACE",
	Rc = "REPLACE",
	Rx = "REPLACE",
	r = "REPLACE",
	Rv = "V-REPLACE",
	Rvc = "V-REPLACE",
	Rvx = "V-REPLACE",
	c = "COMMAND",
	ce = "EX",
	cv = "EX",
	["!"] = "SHELL",
	t = "TERMINAL",
	no = "O-PENDING",
	["no\22"] = "O-PENDING",
	noV = "O-PENDING",
	nov = "O-PENDING",
	["r?"] = "CONFIRM",
	rm = "MORE",
}
local mode_color_map = {
	NORMAL = "normal",
	INSERT = "insert",
	VISUAL = "visual",
	["V-LINE"] = "visual",
	["V-BLOCK"] = "visual",
	SELECT = "visual",
	["S-LINE"] = "visual",
	["S-BLOCK"] = "visual",
	REPLACE = "replace",
	["V-REPLACE"] = "replace",
	COMMAND = "command",
	EX = "command",
	SHELL = "command",
	TERMINAL = "command",
	["O-PENDING"] = "normal",
	CONFIRM = "command",
	MORE = "command",
}
local function highlight(name, foreground, background, _3fgui)
	local gui = (_3fgui or "nocombine")
	local command = string.format("highlight! %s guifg=%s guibg=%s gui=%s", name, foreground, background, gui)
	return vim.cmd(command)
end
local function create_highlight_groups()
	for mode, sections in pairs(section_colors) do
		for section, color in pairs(sections) do
			local hlgroup = string.format("statusline_%s_%s", mode, section)
			highlight(hlgroup, color.fg, color.bg, color.gui)
		end
	end
	return nil
end
local function highlight_group(mode, section)
	return string.format("%%#statusline_%s_%s#", mode, section)
end
local function get_mode()
	local mode_code = vim.api.nvim_get_mode().mode
	return (vim_modes[mode_code] or mode_code)
end
local function get_file_name()
	local filename = vim.fn.expand("%:t")
	local name
	if filename == "" then
		name = config["no-name-text"]
	else
		name = filename
	end
	local escaped_name = name:gsub("%%", "%%%%")
	local symbols = {}
	if vim.bo.modified then
		table.insert(symbols, config["modified-symbol"])
	else
	end
	if not vim.bo.modifiable or vim.bo.readonly then
		table.insert(symbols, config["readonly-symbol"])
	else
	end
	if #symbols > 0 then
		return (escaped_name .. " " .. table.concat(symbols, ""))
	else
		return escaped_name
	end
end
local function get_filetype()
	local ft = (vim.bo.filetype or "")
	return ft:gsub("%%", "%%%%")
end
local function get_progress()
	local cur = vim.fn.line(".")
	local total = vim.fn.line("$")
	if cur == 1 then
		return "Top"
	elseif cur == total then
		return "Bot"
	else
		return string.format("%2d%%%%", math.floor(((cur / total) * 100)))
	end
end
local function get_location()
	local line = vim.fn.line(".")
	local col = vim.fn.charcol(".")
	return string.format("%3d:%-2d", line, col)
end
local function with_spaces(text)
	return (" " .. text .. " ")
end
local function build_statusline()
	local mode = get_mode()
	local filename = get_file_name()
	local filetype = get_filetype()
	local progress = get_progress()
	local location = get_location()
	local mode_color = mode_color_map[mode]
	local ft_section
	if filetype == "" then
		ft_section = ""
	else
		ft_section = string.format(" %s |", filetype)
	end
	local parts = {
		highlight_group(mode_color, "c"),
		"\238\130\182",
		highlight_group(mode_color, "a"),
		with_spaces(mode),
		highlight_group(mode_color, "b"),
		with_spaces(filename),
		highlight_group("background", "a"),
		"\238\130\180",
		"%*%=",
		highlight_group("background", "a"),
		"\238\130\182",
		highlight_group(mode_color, "b"),
		filetype,
		with_spaces(progress),
		highlight_group(mode_color, "a"),
		with_spaces(location),
		highlight_group(mode_color, "c"),
		"\238\130\180",
	}
	return table.concat(parts, "")
end
local function create_autocommands()
	local group = vim.api.nvim_create_augroup("CustomStatusline", {})
	local function _7_()
		return vim.wo.statusline("%{%luaeval('require(\"statusline\").update_statusline()')%}")
	end
	return vim.api.nvim_create_autocmd(
		{ "ModeChanged", "WinEnter", "BufEnter" },
		{ group = group, desc = "Update statusline", callback = _7_ }
	)
end
local function setup()
	create_highlight_groups()
	vim.opt.showmode = false
	vim.opt.statusline = "%{%luaeval('require(\"statusline\").update_statusline()')%}"
end
setup()
return { update_statusline = build_statusline }
