local M = {}

function M.config()
	vim.g.colors_name = gruvbox
	vim.cmd([[colorscheme gruvbox]])
	vim.opt.termguicolors = true
	vim.opt.background = "light"
	vim.g.gruvbox_transparent_bg = 1
	vim.g.gruvbox_contract_light = "hard"
	vim.g.gruvbox_invert_selection = "0"
	vim.cmd([[autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE]])
end

return M
