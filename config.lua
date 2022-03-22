--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "gruvbox"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = false
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"
lvim.keys.insert_mode = {
	["kj"] = "<ESC>", -- alternative escape
	["<C-j>"] = "<ESC>:m .+1<CR>==li", -- move line down
	["<C-k>"] = "<ESC>:m .-2<CR>==li", -- move line up
	--undo breakpoints
	[","] = ",<C-g>u",
	["."] = ".<C-g>u",
	["`"] = "`<C-g>u",
	[";"] = ";<C-g>u",
	["!"] = "!<C-g>u",
	["?"] = "?<C-g>u",
	["{"] = "{<C-g>u",
	["}"] = "}<C-g>u",
	["("] = "(<C-g>u",
	[")"] = ")<C-g>u",
	["["] = "[<C-g>u",
	["]"] = "]<C-g>u"
}
lvim.keys.normal_mode = {
	["<SPACE>"] = "<NOP>", -- remap space to nothing
	["<C-j>"] = ":m .+1<CR>==", -- move line down
	["<C-k>"] = ":m .-2<CR>==", -- move line up
	["sa"] = "ggVG" -- select all
}
lvim.keys.visual_mode = {
	["<C-j>"] = ":m '>+1<CR>gv=gv", -- move line down
	["<C-k>"] = ":m '<-2<CR>gv=gv", -- move line up
	-- better indenting
	["<"] = "<gv",
	[">"] = ">gv"
}

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" }
lvim.builtin.which_key.mappings["f"] = {
	name = "Telescope",
	r = { "<cmd>Telescope live_grep<CR>", "Text" },
	f = { "<cmd>Telescope find_files<CR>", "Files" },
	t = { "<cmd>Telescope treesitter<CR>", "Treesitter" },
	p = { "<cmd>Telescope projects<CR>", "Projects" },
}
lvim.builtin.which_key.mappings["t"] = {
	name = "Treesitter",
	p = { "<cmd>TSPlaygroundToggle<CR>", "Playground" },
}
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
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
-- }

vim.opt.fileencoding = "utf-8" -- set file encoding
vim.opt.mouse = "a" -- enable mouse
vim.opt.relativenumber = true -- set relative line numbers
vim.opt.number = true -- set current line number
vim.opt.hlsearch = true -- highlight when searched
vim.opt.incsearch = true -- set incremental search
vim.opt.ignorecase = true -- ingore cases when searching
vim.opt.smartcase = true -- enable smart cases
vim.opt.hidden = true -- keep multiple files with unsaved changes open
-- vim.opt.noerrorbells = true -- remove error bells
vim.opt.signcolumn = "yes" -- always show the sign column
vim.opt.colorcolumn = "80" -- set the color column
vim.opt.cursorline = true -- highlight current line
vim.opt.cmdheight = 2 -- set command prompt height
vim.opt.wrap = false -- disable text wrapping
vim.opt.scrolloff = 999 -- set scrolloff large, puts current line in the middle
vim.opt.sidescrolloff = 8 -- set side scrolloff
vim.opt.pumheight = 10 -- pop up menu height
vim.opt.showmode = false -- don't show stuff like -- INSERT --
vim.opt.termguicolors = true -- set colors in terminals
vim.opt.timeoutlen = 300 -- the timeout for a mapped sequence
vim.opt.completeopt = { "menuone", "noselect", } -- something to do with completion
-- vim.opt.title = true
vim.opt.updatetime = 300 -- faster completion
-- vim.opt.foldmethod = "expr" -- use treesitter based folding
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- use treesitter based folding
vim.opt.tabstop = 4 -- insert 4 spaces for a tab
vim.opt.shiftwidth = 4 -- use 4 spaces for << en >>
vim.opt.expandtab = false -- use tab character instead of spaces for tabs
vim.opt.swapfile = false -- no swap files
vim.opt.backup = false -- no backup files
-- vim.opt.undodir = utils.get_cache_path() .. "/undo" -- set undo directory
vim.opt.undofile = true -- enable undo files
vim.opt.list = true -- enable showing special characters
vim.opt.showbreak = "↪\\" -- show line breaks
vim.opt.listchars = "eol:↵,tab:>-,nbsp:␣,trail:•,extends:>,precedes:<" -- set visibility of whitespaces
-- vim.opt.shadafile = utils.get_cache_path() .. "/lvim.shada"

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "cpp",
  "haskell",
  -- "javascript",
  "json",
  "lua",
  -- "python",
  -- "typescript",
  -- "tsx",
  -- "css",
  "rust",
  "java",
  "yaml",
  "nix",
}

lvim.builtin.treesitter.ignore_install = {}
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins
lvim.plugins = {
    {"morhetz/gruvbox"}
    -- {"folke/tokyonight.nvim"},
    -- {
    --   "folke/trouble.nvim",
    --   cmd = "TroubleToggle",
    -- },
}
vim.opt.termguicolors = true
vim.opt.background = "light"
vim.g.gruvbox_transparent_bg = 1
vim.g.gruvbox_contract_light = "hard"
vim.g.gruvbox_invert_selction = "0"
vim.cmd("colorscheme gruvbox")
vim.cmd("autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE")

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
	{
		"TextYankPost",
		"*",
		"lua vim.highlight.on_yank{higroup=\"IncSearch\", timeout=3000}",
	},
{
		"BufWinEnter",
		"*",
		"setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
	},
{
		"BufRead",
		"*",
		"setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
	},
{
		"BufNewFile",
		"*",
		"setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
	},
}
