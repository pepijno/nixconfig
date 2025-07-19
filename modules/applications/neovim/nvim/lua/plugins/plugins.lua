return {
	{
		"folke/lazy.nvim",
		lazy = false,
	},
	{ "nvim-tree/nvim-web-devicons" },
	{
		"stevearc/oil.nvim",
		keys = {
			{ "-", "<cmd>Oil<cr>", desc = "Open Oil", mode = "n" },
		},
		config = function()
			require("oil").setup({})
		end,
	},
	{
		"folke/which-key.nvim",
		opts = {
			win = {
				border = "single",
			},
		},
	},
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
		"NMAC427/guess-indent.nvim",
	},
}
