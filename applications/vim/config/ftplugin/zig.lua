require("lsp").setup "zig"
vim.opt.tabstop                                      = 4 -- insert 4 spaces for a tab
vim.opt.shiftwidth                                   = 4 -- use 4 spaces for << en >>
vim.opt.expandtab                                    = false -- use tab character instead of spaces for tabs
vim.cmd[[setlocal commentstring=//\ %s]]
