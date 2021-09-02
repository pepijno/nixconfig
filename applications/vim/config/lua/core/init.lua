local M = {}

local builtins = {
	"core.gruvbox",
	"core.barbar",
	"core.nvim_comment",
	"core.lualine",
	"core.dashboard",
	"core.gitsigns",
	"core.telescope",
	"core.autopairs",
	"core.treesitter",
	"core.nvimtree",
	"core.project",
	"core.which-key",
	"core.cmp",
}

M.config = function(config)
	for _, builtin_path in ipairs(builtins) do
		local builtin = require(builtin_path)
		builtin.config(config)
	end
end

return M
