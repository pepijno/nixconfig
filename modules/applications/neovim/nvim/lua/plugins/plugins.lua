return {
	{
		"folke/lazy.nvim",
		version = "*",
	},
	"nvim-tree/nvim-web-devicons",
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
			window = {
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
	-- {
	-- 	"folke/flash.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = {},
	-- 	-- stylua: ignore
	-- 	keys = {
	-- 		{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
	-- 		{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
	-- 		{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
	-- 		{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
	-- 		{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
	-- 	},
	-- },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			require("neo-tree").setup({
				filesystem = {
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
					},
					follow_current_file = {
						enabled = true,
					},
				},
				buffers = {
					follow_current_file = {
						enabled = true,
					},
				},
			})
			vim.keymap.set(
				"n",
				"<leader>e",
				":Neotree toggle<cr>",
				{ noremap = true, silent = true, desc = "Toggle neotree" }
			)
		end,
	},
}
