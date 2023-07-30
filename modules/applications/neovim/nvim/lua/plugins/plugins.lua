return {
	{
		"folke/lazy.nvim",
		version = "*"
	},
	"tpope/vim-sleuth",
	{
		"nathom/filetype.nvim",
		config = function()
			vim.g.did_load_filetypes = 1
		end,
	},
	"nvim-tree/nvim-web-devicons",
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			char = "│",
			show_trailing_blankline_indent = false,
			show_current_context = true,
			show_current_context_start = true,
		},
	},
	{
		"echasnovski/mini.indentscope",
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- symbol = "▏",
			symbol = "│",
			options = { try_as_border = true },
		},
	},
	{ "echasnovski/mini.pairs", version = "*", event = "VeryLazy", opts = {} },
}
