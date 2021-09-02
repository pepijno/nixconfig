local M = {}

M.config = function()
  conf.lspinstall = {
    active = true,
  }
end

M.setup = function()
  local lspinstall = require "lspinstall"
  lspinstall.setup()
end

return M
