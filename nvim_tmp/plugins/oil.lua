return {
	{
		'stevearc/oil.nvim',
		keys = {
			{ '-', "<cmd>Oil<cr>", desc = "Open Oil", mode = 'n' },
		},
		config = function()
			require("oil").setup({})
		end,
	},
}
