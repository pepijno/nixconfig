local M = {}

M.config = function()
	conf.autopairs = {
		active = true,
		map_cr = true, -- map <CR> on insert map
		enable_check_bracket_line = true, -- don't add pair if it already has a closing pair

		---@usage check treesitter
		check_ts = true,
		ts_config = {
			lua = { "string" },
			javascript = { "template_string" },
		},
	}
end

M.setup = function()
	local autopairs = require "nvim-autopairs"
	local remap = vim.api.nvim_set_keymap

	autopairs.setup(conf.autopairs)

	require("nvim-treesitter.configs").setup { autopairs = { enable = true } }

	-- skip it, if you use another global object
	_G.MUtils= {}

	MUtils.completion_confirm=function()
		if vim.fn.pumvisible() ~= 0  then
			return autopairs.esc("<cr>")
		else
			return autopairs.autopairs_cr()
		end
	end


	remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})
end

return M
