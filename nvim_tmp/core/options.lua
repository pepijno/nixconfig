local M = {}

vim.opt.fileencoding = "utf-8" -- File content encoding for the buffer
vim.opt.mouse = "n" -- Disable mouse support
vim.opt.relativenumber = true -- Show relative numberline
vim.opt.number = true -- Show numberline
vim.opt.hlsearch = true -- Highlight all the matches of search pattern
vim.opt.incsearch = true -- Set incremental search
vim.opt.ignorecase = true -- Case insensitive searching
vim.opt.smartcase = true -- Case sensitivie searching
vim.opt.hidden = true -- Ignore unsaved buffers
vim.opt.signcolumn = "yes" -- Always show the sign column
vim.opt.colorcolumn = "80" -- Fix for the indentline problem
vim.opt.cursorline = true -- Highlight the text line of the cursor
vim.opt.cmdheight = 2 -- Number of screen lines to use for the command line
vim.opt.wrap = false -- Disable wrapping of lines longer than the width of window
vim.opt.scrolloff = 999 -- Number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor
vim.opt.pumheight = 10 -- Height of the pop up menu
vim.opt.showmode = false -- Disable showing modes in command line
vim.opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
vim.opt.timeoutlen = 300 -- Length of time to wait for a mapped sequence
vim.opt.completeopt = { "menuone", "noselect" } -- Options for insert mode completion
vim.opt.updatetime = 300 -- Length of time to wait before triggering the plugin
vim.opt.tabstop = 4 -- Number of space in a tab
vim.opt.shiftwidth = 4 -- Number of space inserted for indentation
vim.opt.expandtab = false -- Enable the use of space in tab
vim.opt.swapfile = false -- Disable use of swapfile for the buffer
vim.opt.backup = false -- Disable making a backup file
vim.opt.undofile = true -- Enable persistent undo
vim.opt.list = true -- Enable showing special characters
vim.opt.showbreak = "↪\\" -- show line breaks
-- vim.opt.listchars = "eol:↵,tab:>-,nbsp:␣,trail:•,extends:>,precedes:<" -- set visibility of whitespaces
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"
vim.opt.foldmethod = "manual" -- Create folds manually
vim.opt.smartindent = true -- Do auto indenting when starting a new line
vim.opt.splitbelow = true -- Splitting a new window below the current one
vim.opt.splitright = true -- Splitting a new window at the right of the current one

return M
