local latte = require("catppuccin.palettes").get_palette("latte")

local section_colors = {
	NORMAL = {
		a = { bg = latte.blue, fg = latte.base, gui = "bold" },
		b = { bg = latte.surface0, fg = latte.blue },
		c = { bg = latte.base, fg = latte.blue },
	},
	INSERT = {
		a = { bg = latte.green, fg = latte.base, gui = "bold" },
		b = { bg = latte.surface0, fg = latte.green },
		c = { bg = latte.base, fg = latte.green },
	},
	REPLACE = {
		a = { bg = latte.red, fg = latte.base, gui = "bold" },
		b = { bg = latte.surface0, fg = latte.red },
		c = { bg = latte.base, fg = latte.red },
	},
	VISUAL = {
		a = { bg = latte.mauve, fg = latte.base, gui = "bold" },
		b = { bg = latte.surface0, fg = latte.mauve },
		c = { bg = latte.base, fg = latte.mauve },
	},
	COMMAND = {
		a = { bg = latte.yellow, fg = latte.base, gui = "bold" },
		b = { bg = latte.surface0, fg = latte.yellow },
		c = { bg = latte.base, fg = latte.yellow },
	},
	background = {
		a = { bg = latte.base, fg = latte.surface0 },
	},
}

section_colors.TERMINAL = section_colors.COMMAND
section_colors.INACTIVE = section_colors.NORMAL

local function highlight(name, foreground, background, gui)
	gui = gui or "nocombine"
	local command = string.format("highlight! %s guifg=%s guibg=%s gui=%s", name, foreground, background, gui)
	vim.cmd(command)
end

local function create_highlight_groups()
	for mode, sections in pairs(section_colors) do
		for section, color in pairs(sections) do
			local hlgroup = string.format("statusline_%s_%s", mode, section)
			highlight(hlgroup, color.fg, color.bg, color.gui)
		end
	end
end

create_highlight_groups()

local function highlight_group(mode, section)
	return string.format("%%#statusline_%s_%s#", mode, section)
end

local modes = {
	["n"] = "NORMAL",
	["no"] = "O-PENDING",
	["nov"] = "O-PENDING",
	["noV"] = "O-PENDING",
	["no\22"] = "O-PENDING",
	["niI"] = "NORMAL",
	["niR"] = "NORMAL",
	["niV"] = "NORMAL",
	["nt"] = "NORMAL",
	["ntT"] = "NORMAL",
	["v"] = "VISUAL",
	["vs"] = "VISUAL",
	["V"] = "V-LINE",
	["Vs"] = "V-LINE",
	["\22"] = "V-BLOCK",
	["\22s"] = "V-BLOCK",
	["s"] = "SELECT",
	["S"] = "S-LINE",
	["\19"] = "S-BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["ix"] = "INSERT",
	["R"] = "REPLACE",
	["Rc"] = "REPLACE",
	["Rx"] = "REPLACE",
	["Rv"] = "V-REPLACE",
	["Rvc"] = "V-REPLACE",
	["Rvx"] = "V-REPLACE",
	["c"] = "COMMAND",
	["cv"] = "EX",
	["ce"] = "EX",
	["r"] = "REPLACE",
	["rm"] = "MORE",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}

local function get_mode()
	local mode_code = vim.api.nvim_get_mode().mode
	if modes[mode_code] == nil then
		return mode_code
	end
	return modes[mode_code]
end

local function get_file_name()
	local data = vim.fn.expand("%:t")

	if data == "" then
		data = "[No Name]"
	end

	data = data:gsub("%%", "%%%%")

	local symbols = {}
	if vim.bo.modified then
		table.insert(symbols, "[+]")
	end
	if vim.bo.modifiable == false or vim.bo.readonly == true then
		table.insert(symbols, "[-]")
	end

	return data .. (#symbols > 0 and " " .. table.concat(symbols, "") or "")
end

local function get_filetype()
	local ft = vim.bo.filetype or ""
	return ft:gsub('%%', '%%%%')
end

local function get_progress()
	local cur = vim.fn.line(".")
	local total = vim.fn.line("$")
	if cur == 1 then
		return "Top"
	elseif cur == total then
		return "Bot"
	else
		return string.format("%2d%%%%", math.floor(cur / total * 100))
	end
end

local function get_location()
	local line = vim.fn.line(".")
	local col = vim.fn.charcol(".")
	return string.format("%3d:%-2d", line, col)
end

local function surround_spaces(str)
	return " " .. str .. " "
end

local function update_statusline()
	local mode = get_mode()
	local filename = get_file_name()
	local filetype = get_filetype()
	local progress = get_progress()
	local location = get_location()

	if filetype ~= "" then
		filetype = string.format(" %s |", filetype)
	end

	local parts = {
		highlight_group(mode, "c"),
		"",
		highlight_group(mode, "a"),
		surround_spaces(mode),
		highlight_group(mode, "b"),
		surround_spaces(filename),
		highlight_group("background", "a"),
		"",
		"%*%=",
		highlight_group("background", "a"),
		"",
		highlight_group(mode, "b"),
		filetype,
		surround_spaces(progress),
		highlight_group(mode, "a"),
		surround_spaces(location),
		highlight_group(mode, "c"),
		"",
	}
	return table.concat(parts, "")
end

vim.opt.showmode = false
vim.opt.statusline = [[%{%luaeval('require("core.statusline").update_statusline()')%}]]
vim.cmd([[
  augroup statusline
    autocmd!
    autocmd ModeChanged,WinEnter,BufEnter * setlocal statusline=%{%luaeval('require(\"core.statusline\").update_statusline()')%}
  augroup END
  ]])

return {
	update_statusline = update_statusline,
}
