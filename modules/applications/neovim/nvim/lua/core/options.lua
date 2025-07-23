-- Number of spaces shown per <tab>
vim.opt.tabstop = 4
-- Number of spaces applied when pressing <tab>
vim.opt.softtabstop = 4
-- Amount to indent with << and >>
vim.opt.shiftwidth = 4
-- Convert tabs to spaces
vim.opt.expandtab = true

-- <Backspace> will delete a 'shiftwidth' worth of space at the start of the line
vim.opt.smarttab = true
-- Smart auto indenting on new line
vim.opt.smartindent = true
-- Copy indent from current line on new line
vim.opt.autoindent = true

-- Show line numbers
vim.opt.number = true
-- Show relative line numbers
vim.opt.relativenumber = true

-- Highlight the text line of the cursor
vim.opt.cursorline = true

-- Store undo between sessions
vim.opt.undofile = true
-- Disable use of swap files
vim.opt.swapfile = false
-- Disabled the use of backup files
vim.opt.backup = false

-- Disable showing modes in status line as we have custom status line
vim.opt.showmode = false

-- Highlight all the matches of search pattern
vim.opt.hlsearch = true
-- Set incremental search
vim.opt.incsearch = true
-- Case insensitive searching
vim.opt.ignorecase = true
-- Case sensitivie searching when upper case characters are in search
vim.opt.smartcase = true

-- Always show the sign column
vim.opt.signcolumn = "yes"

-- Length of time to wait before triggering the plugin
vim.opt.updatetime = 300

-- Splitting a new window below the current one
vim.opt.splitbelow = true
-- Splitting a new window at the right of the current one
vim.opt.splitright = true

-- Number of lines to keep above and below the cursor
vim.opt.scrolloff = 999

-- Number of columns to keep at the sides of the cursor
vim.opt.sidescrolloff = 8

-- Disable mouse support
vim.opt.mouse = "n"

-- Do not abandon unloaded buffers
vim.opt.hidden = true

-- Disable line wrapping
vim.opt.wrap = false

-- Maximum number of items in popup window
vim.opt.pumheight = 10

-- Length of time to wait for a mapped sequence
vim.opt.timeoutlen = 300

-- Enable showing special characters
vim.opt.list = true
-- Show line breaks
vim.opt.showbreak = "↪\\"
-- Set display of whitespace characters
vim.opt.listchars = { tab = "> ", space = "⋅", nbsp = "␣", trail = "-" }

-- Use c file type for .h files
vim.g.c_syntax_for_h = true

-- Set the border of all windows
vim.opt.winborder = "single"

-- Disable native vim plugins
vim.g.loaded_2html_plugin = false
vim.g.loaded_getscript = false
vim.g.loaded_getscriptPlugin = false
vim.g.loaded_gzip = false
vim.g.loaded_logipat = false
vim.g.loaded_netrwFileHandlers = false
vim.g.loaded_netrwPlugin = false
vim.g.loaded_netrwSettngs = false
vim.g.loaded_remote_plugins = false
vim.g.loaded_tar = false
vim.g.loaded_tarPlugin = false
vim.g.loaded_zip = false
vim.g.loaded_zipPlugin = false
vim.g.loaded_vimball = false
vim.g.loaded_vimballPlugin = false
vim.g.zipPlugin = false
