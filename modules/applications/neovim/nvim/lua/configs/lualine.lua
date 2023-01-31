local M = {}

function M.config()
	local status_ok, lualine = pcall(require, 'lualine')
	if not status_ok then
		return
	end

	lualine.setup({
		options = {
			disabled_filetypes = { 'NvimTree', 'neo-tree', 'dashboard', 'Outline' },
			icons_enabled = false,
			theme = 'gruvbox',
			component_separators = '|',
			section_separators = '',
		},
	})
end

return M
