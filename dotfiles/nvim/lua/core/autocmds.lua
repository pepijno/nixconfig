local create_cmd = vim.api.nvim_create_autocmd
local create_group = vim.api.nvim_create_augroup

create_cmd("TextYankPost", {
	group = create_group("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 3000 })
	end,
})

create_cmd("VimResized", {
	group = create_group("resize_splits", { clear = true }),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

create_cmd("WinLeave", {
	group = create_group("cursor_off", { clear = true }),
	callback = function()
		vim.opt.cursorline = false
	end,
})

create_cmd("WinEnter", {
	group = create_group("cursor_on", { clear = true }),
	callback = function()
		vim.opt.cursorline = true
	end,
})

create_cmd({ "BufWinEnter", "BufRead", "BufNewFile" }, {
	group = create_group("LuaHighlight", { clear = true }),
	command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})
