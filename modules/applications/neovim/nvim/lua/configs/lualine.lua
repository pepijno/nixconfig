local M = {}

function M.config()
	local status_ok, lualine = pcall(require, "lualine")
	if not status_ok then
		return
	end

	require("lualine").setup({
		options = {
			disabled_filetypes = { "NvimTree", "neo-tree", "dashboard", "Outline" },
			theme = 'gruvbox',
			component_separators = "",
		},
		inactive_sections = {
			lualine_c = { "%f %y %m" },
			lualine_x = {},
		},
	})
end

return M
