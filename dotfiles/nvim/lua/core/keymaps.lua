local map = vim.keymap.set
local g = vim.g

local opts = { noremap = true, silent = true }

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
-- map("n", "<C-J>", ":m .+1<CR>==", opts)
-- map("n", "<C-K>", ":m .-2<CR>==", opts)
-- map("v", "<C-J>", ":m '>+1<CR>gv=gv", opts)
-- map("v", "<C-K>", ":m '<-2<CR>gv=gv", opts)

-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)
map("n", ">", ">>_", opts)
map("n", "<", "<<_", opts)

map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

map("n", "<C-u>", "<C-u>zz", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-y>", "<C-y>zz", opts)
map("n", "<C-e>", "<C-e>zz", opts)
