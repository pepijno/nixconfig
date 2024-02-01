return {
	{
		"folke/lazy.nvim",
		version = "*",
	},
	"nvim-tree/nvim-web-devicons",
	{
		"echasnovski/mini.indentscope",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			symbol = "│",
			options = { try_as_border = true },
		},
	},
	{
		"stevearc/oil.nvim",
		keys = {
			{ "-", "<cmd>Oil<cr>", desc = "Open Oil", mode = "n" },
		},
		config = function()
			require("oil").setup({})
		end,
	},
	{ "folke/which-key.nvim", opts = {} },
}
