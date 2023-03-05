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

function M.bootstrap()
	local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		PACKER_BOOTSTRAP = vim.fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		})
		print("Cloning packer...\nSetup NeoVim")
		vim.cmd([[packadd packer.nvim]])
	end
end

return M
