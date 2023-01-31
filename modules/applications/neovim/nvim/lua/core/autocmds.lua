local M = {}

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

vim.cmd([[
  augroup cursor_off
    autocmd!
    autocmd WinLeave * set nocursorline
    autocmd WinEnter * set cursorline
  augroup end
]])

vim.cmd([[
  augroup LuaHighlight
    autocmd!
    autocmd TextYankPost * lua require'vim.highlight'.on_yank{higroup="IncSearch", timeout=3000}
    autocmd BufWinEnter * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    autocmd BufRead * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    autocmd BufNewFile * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  augroup end
]])

return M
