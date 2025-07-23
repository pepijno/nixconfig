require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.lsp")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	vim.cmd("redraw")
	vim.api.nvim_echo({ { "  Installing lazy.nvim & plugins ...", "Bold" } }, true, {})
	local repo = "https://github.com/folke/lazy.nvim.git"
	local shell_args = { "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath }
	local output = vim.fn.system(shell_args)
	assert(vim.v.shell_error == 0, "External call failed with error code: " .. vim.v.shell_error .. "\n" .. output)
	vim.opt.rtp:prepend(lazypath)
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins/langs" },
	},
	rocks = {
		enabled = false,
	},
	change_detection = {
		notify = false,
	},
	lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",
	performance = {
		rtp = {
			disabled_plugins = {
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tohtml",
				"tutor",
			},
		},
	},
})
