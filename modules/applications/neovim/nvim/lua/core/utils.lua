local M = {}

function M.disabled_builtins()
	vim.g.loaded_2html_plugin = false
	vim.g.loaded_getscript = false
	vim.g.loaded_getscriptPlugin = false
	vim.g.loaded_gzip = false
	vim.g.loaded_logipat = false
	-- vim.g.loaded_netrwFileHandlers = false
	-- vim.g.loaded_netrwPlugin = false
	-- vim.g.loaded_netrwSettngs = false
	vim.g.loaded_remote_plugins = false
	vim.g.loaded_tar = false
	vim.g.loaded_tarPlugin = false
	vim.g.loaded_zip = false
	vim.g.loaded_zipPlugin = false
	vim.g.loaded_vimball = false
	vim.g.loaded_vimballPlugin = false
	vim.g.zipPlugin = false
end

return M
