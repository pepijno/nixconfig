local M = {}

M.config = function()
	conf.auto_session = {
		auto_session_enable_last_session = true,
		auto_session_enabled = true,
		auto_save_enabled = true,
		auto_restore_enabled = true,
		pre_save_cmds = {"tabdo NvimTreeClose"},
		post_restore_cmds = {"tabdo NvimTreeRefresh"}
	}
end

M.setup = function()
	local auto_session = require "auto-session"

	vim.o.sessionoptions="blank,buffers,curdir,folds,help,options,tabpages,winsize,resize,winpos,terminal"

	auto_session.setup(conf.auto_session)
end

M.setup_lens = function()
	require("telescope").load_extension("session-lens")
	local session_lens = require "session-lens"
	session_lens.setup()
	conf.which_key.mappings["<leader>fs"] = { "<cmd>Telescope session-lens search_session<CR>", "Sessions" }
end

return M
