local M = {}

local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- Remap space as leader key
map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

-- Explorer
map("n", "<leader>pv", vim.cmd.Ex, opts)

return M
