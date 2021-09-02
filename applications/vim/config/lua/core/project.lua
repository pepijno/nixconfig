local M = {}

M.config = function()
	conf.project = {
		active = true,
		on_config_done = nil,
		manual_mode = false,
		detection_methods = { "lsp", "pattern" },
		patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
		show_hidden = false,
		silent_chdir = true,
		ignore_lsp = {},
		datapath = CACHE_DIR
	}
end

M.setup = function()
	local project = require "project_nvim"
	project.setup(conf.project)
	require('telescope').load_extension('projects')
end

return M
