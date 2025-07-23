return {
	{
		"folke/lazy.nvim",
		lazy = false,
	},
	{ "nvim-tree/nvim-web-devicons" },
	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({
				notification = {
					window = {
						winblend = 100,
					},
				},
			})
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		keys = {
			{
				"<leader>lr",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				desc = "Rename",
				mode = "n",
				expr = true,
			},
		},
	},
	{
		"tpope/vim-sleuth",
	},
}
