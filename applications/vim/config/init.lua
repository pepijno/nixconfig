-- {{{ Bootstrap
local home_dir = vim.loop.os_homedir()

CACHE_PATH = vim.fn.stdpath "cache"

vim.cmd [[let &packpath = &runtimepath]]
-- }}}

conf = {}

require("config").load_options()
require("core").config()

local plugins = require "plugins"
local plugin_loader = require("plugin-loader").init()
plugin_loader:load { plugins }
vim.cmd ":PackerCompile"
vim.cmd ":PackerInstall"

require("lsp").config()
require("autocommands").setup()

require("keymappings").setup()

vim.cmd('source ~/.config/nvim/bla.vim')
