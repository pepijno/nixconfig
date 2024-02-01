require("core.options").init_options()
require("core.options").disable_builtins()
require("core.keymaps").init_keymaps()
require("core.autocmds").init_autocmds()

vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
