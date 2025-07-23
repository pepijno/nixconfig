return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/playground",
		},
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdateSync" },
		opts = {
			ensure_installed = { "vim" },
			sync_install = false,
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
					init_selection = "<Enter>",
					node_incremental = "<Enter>",
					node_decremental = "<Backspace>",
				},
			},
			indent = {
				enable = true,
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		init = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>ta"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>tA"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
}
