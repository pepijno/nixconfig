local M = {}

local map = vim.keymap.set
local g = vim.g

local opts = { noremap = true, silent = true }

M.init_keymaps = function()
	map("", "<Space>", "<Nop>", opts)
	g.mapleader = " "
	g.maplocalleader = " "

	-- undo breakpoints
	map("i", ",", ",<C-g>u", opts)
	map("i", ".", ".<C-g>u", opts)
	map("i", "`", "`<C-g>u", opts)
	map("i", ";", ";<C-g>u", opts)
	map("i", "!", "!<C-g>u", opts)
	map("i", "?", "?<C-g>u", opts)
	map("i", "{", "{<C-g>u", opts)
	map("i", "}", "}<C-g>u", opts)
	map("i", "(", "(<C-g>u", opts)
	map("i", ")", ")<C-g>u", opts)
	map("i", "[", "[<C-g>u", opts)
	map("i", "]", "]<C-g>u", opts)

	-- Move text up and down
	-- map("i", "<C-j>", "<ESC>:m .+1<CR>==li", opts) -- move line down
	-- map("i", "<C-k>", "<ESC>:m .-2<CR>==li", opts) -- move line up
	map("n", "<C-j>", ":m .+1<CR>==", opts)
	map("n", "<C-k>", ":m .-2<CR>==", opts)
	map("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
	map("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

	-- Stay in indent mode
	map("v", "<", "<gv", opts)
	map("v", ">", ">gv", opts)

	map("n", "<C-u>", "<C-u>zz", opts)
	map("n", "<C-d>", "<C-d>zz", opts)
	map("n", "<C-y>", "<C-y>zz", opts)
	map("n", "<C-e>", "<C-e>zz", opts)
end

return M
