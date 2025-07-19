return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		dependencies = {
			"nvim-treesitter/playground",
		},
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdateSync" },
		opts = {
			ensure_installed = { "vim" },
			highlight = {
				enable = true,
				use_languagetree = true,
			},
			autopairs = {
				enable = false,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-h>",
					node_incremental = "<C-h>",
					node_decremental = "<C-l>",
				},
			},
			indent = {
				enable = true,
			},
		},
		config = function (_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
