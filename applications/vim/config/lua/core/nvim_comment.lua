local M = {}

M.config = function()
	conf.nvim_comment = {
		enable = true,
		marker_adding = true, -- comment and line should have whitespace between them
		comment_empty = false, -- should not comment out empty lines
		create_mappings = true, -- create keymappin
	}
end

M.setup = function()
	local nvim_comment = require "nvim_comment"
	nvim_comment.setup(conf.nvim_comment)
end

return M
