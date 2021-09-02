local M = {}

M.config = function()
end

M.setup = function()
	vim.opt.termguicolors = true
	vim.opt.background = "light"
	vim.g.gruvbox_transparent_bg = 1
	vim.g.gruvbox_contract_light = "hard"
	vim.g.gruvbox_invert_selction = "0"
	vim.cmd("colorscheme gruvbox")
	vim.cmd("autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE")
end

return M
