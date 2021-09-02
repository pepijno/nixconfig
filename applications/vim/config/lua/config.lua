local M = {}

M.load_options = function()
	vim.opt.fileencoding                                 = "utf-8" -- set file encoding
	vim.opt.mouse                                        = "a" -- enable mouse
	vim.opt.relativenumber                               = true -- set relative line numbers
	vim.opt.number                                       = true -- set current line number
	vim.opt.hlsearch                                     = true -- highlight when searched
	vim.opt.incsearch                                    = true -- set incremental search
	vim.opt.ignorecase                                   = true -- ingore cases when searching
	vim.opt.smartcase                                    = true -- enable smart cases
	vim.opt.hidden                                       = true -- keep multiple files with unsaved changes open
	-- vim.opt.noerrorbells                              = true -- remove error bells
	vim.opt.signcolumn                                   = "yes" -- always show the sign column
	vim.opt.colorcolumn                                  = "80" -- set the color column
	vim.opt.cursorline                                   = true -- highlight current line
	vim.opt.cmdheight                                    = 2 -- set command prompt height
	vim.opt.wrap                                         = false -- disable text wrapping
	vim.opt.scrolloff                                    = 999 -- set scrolloff large, puts current line in the middle
	vim.opt.sidescrolloff                                = 8 -- set side scrolloff
	vim.opt.pumheight                                    = 10 -- pop up menu height
	vim.opt.showmode                                     = false -- don't show stuff like -- INSERT --
	vim.opt.termguicolors                                = true -- set colors in terminals
	vim.opt.timeoutlen                                   = 300 -- the timeout for a mapped sequence
	vim.opt.completeopt                                  = { "menuone", "noselect" } -- something to do with completion
	-- vim.opt.title                                     = true
	vim.opt.updatetime                                   = 300 -- faster completion

	-- vim.opt.foldmethod                                = "expr" -- use treesitter based folding
	-- vim.opt.foldexpr                                  = "nvim_treesitter#foldexpr()" -- use treesitter based folding

	vim.opt.tabstop                                      = 4 -- insert 4 spaces for a tab
	vim.opt.shiftwidth                                   = 4 -- use 4 spaces for << en >>
	vim.opt.expandtab                                    = false -- use tab character instead of spaces for tabs

	vim.opt.swapfile                                     = false -- no swap files
	vim.opt.backup                                       = false -- no backup files
	vim.opt.undodir                                      = CACHE_PATH .. "/undo" -- set undo directory
	vim.opt.undofile                                     = true -- enable undo files

	vim.opt.list                                         = true -- enable showing special characters
	vim.opt.showbreak                                    = "↪\\" -- show line breaks
	vim.opt.listchars                                    = "eol:↵,tab:>-,nbsp:␣,trail:•,extends:>,precedes:<" -- set visibility of whitespaces

	vim.cmd "au ColorScheme * hi Normal ctermbg          = none guibg=none"
	vim.cmd "au ColorScheme * hi SignColumn ctermbg      = none guibg=none"
	vim.cmd "au ColorScheme * hi NormalNC ctermbg        = none guibg=none"
	vim.cmd "au ColorScheme * hi MsgArea ctermbg         = none guibg=none"
	vim.cmd "au ColorScheme * hi TelescopeBorder ctermbg = none guibg=none"
	vim.cmd "au ColorScheme * hi NvimTreeNormal ctermbg  = none guibg=none"
	vim.cmd "let &fcs                                    = 'eob: '"
end

return M
