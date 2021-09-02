local M = {}

M.config = function()
end

M.setup = function()
	-- vim.g.bufferline = {
	-- 	animation = false,
	-- 	closable = true,
	-- 	clickable = true,
	-- }

	vim.api.nvim_set_keymap("i", "<C-b><C-b>", "<cmd>BufferPrevious<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("i", "<C-b>q", "<cmd>BufferClose<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("i", "<C-b>1", "<cmd>BufferGoto 1<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("i", "<C-b>2", "<cmd>BufferGoto 2<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("i", "<C-b>3", "<cmd>BufferGoto 3<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("i", "<C-b>4", "<cmd>BufferGoto 4<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("i", "<C-b>5", "<cmd>BufferGoto 5<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("i", "<C-b>6", "<cmd>BufferGoto 6<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("i", "<C-b>7", "<cmd>BufferGoto 7<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("i", "<C-b>8", "<cmd>BufferGoto 8<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("i", "<C-b>9", "<cmd>BufferGoto 9<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("i", "<C-b>s", "<cmd>BufferPick<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("n", "<C-b><C-b>", "<cmd>BufferPrevious<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("n", "<C-b>q", "<cmd>BufferClose<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("n", "<C-b>1", "<cmd>BufferGoto 1<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("n", "<C-b>2", "<cmd>BufferGoto 2<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("n", "<C-b>3", "<cmd>BufferGoto 3<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("n", "<C-b>4", "<cmd>BufferGoto 4<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("n", "<C-b>5", "<cmd>BufferGoto 5<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("n", "<C-b>6", "<cmd>BufferGoto 6<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("n", "<C-b>7", "<cmd>BufferGoto 7<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("n", "<C-b>8", "<cmd>BufferGoto 8<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("n", "<C-b>9", "<cmd>BufferGoto 9<CR>", { noremap = true, silent = true, })
	vim.api.nvim_set_keymap("n", "<C-b>s", "<cmd>BufferPick<CR>", { noremap = true, silent = true, })
end

return M
