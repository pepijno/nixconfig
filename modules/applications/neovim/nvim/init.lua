local utils = require("core.utils")

utils.disabled_builtins()

utils.bootstrap()

require("core.options")
require("core.autocmds")
require("core.plugins")
require("core.mappings")

require("configs.treesitter").config()
require("configs.gruvbox").config()
