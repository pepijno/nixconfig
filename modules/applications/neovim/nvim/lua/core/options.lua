
local opt = vim.opt
local g = vim.g

g.have_nerd_font = true
opt.fileencoding = "utf-8" -- File content encoding for the buffer
opt.mouse = "n" -- Disable mouse support
opt.relativenumber = true -- Show relative numberline
opt.number = true -- Show numberline
opt.hlsearch = true -- Highlight all the matches of search pattern
opt.incsearch = true -- Set incremental search
opt.ignorecase = true -- Case insensitive searching
opt.smartcase = true -- Case sensitivie searching
opt.hidden = true -- Ignore unsaved buffers
opt.signcolumn = "yes" -- Always show the sign column
opt.colorcolumn = "80" -- Fix for the indentline problem
opt.cursorline = true -- Highlight the text line of the cursor
opt.cmdheight = 2 -- Number of screen lines to use for the command line
opt.wrap = false -- Disable wrapping of lines longer than the width of window
opt.scrolloff = 999 -- Number of lines to keep above and below the cursor
opt.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor
opt.pumheight = 10 -- Height of the pop up menu
opt.showmode = false -- Disable showing modes in command line
opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
opt.timeoutlen = 300 -- Length of time to wait for a mapped sequence
opt.completeopt = { "menuone", "noselect" } -- Options for insert mode completion
opt.updatetime = 300 -- Length of time to wait before triggering the plugin
opt.tabstop = 4 -- Number of space in a tab
opt.shiftwidth = 4 -- Number of space inserted for indentation
opt.expandtab = false -- Enable the use of space in tab
opt.swapfile = false -- Disable use of swapfile for the buffer
opt.backup = false -- Disable making a backup file
opt.undofile = true -- Enable persistent undo
opt.list = true -- Enable showing special characters
opt.showbreak = "↪\\" -- show line breaks
-- opt.listchars = "eol:↵,tab:>-,nbsp:␣,trail:•,extends:>,precedes:<" -- set visibility of whitespaces
opt.listchars:append("space:⋅")
opt.listchars:append("eol:↴")
opt.foldmethod = "manual" -- Create folds manually
opt.smartindent = true -- Do auto indenting when starting a new line
opt.splitbelow = true -- Splitting a new window below the current one
opt.splitright = true -- Splitting a new window at the right of the current one
opt.laststatus = 3
-- opt.loaded_matchparen = 1
-- opt.winborder = "rounded"

g.c_syntax_for_h = true

g.loaded_2html_plugin = false
g.loaded_getscript = false
g.loaded_getscriptPlugin = false
g.loaded_gzip = false
g.loaded_logipat = false
g.loaded_netrwFileHandlers = false
g.loaded_netrwPlugin = false
g.loaded_netrwSettngs = false
g.loaded_remote_plugins = false
g.loaded_tar = false
g.loaded_tarPlugin = false
g.loaded_zip = false
g.loaded_zipPlugin = false
g.loaded_vimball = false
g.loaded_vimballPlugin = false
g.zipPlugin = false
