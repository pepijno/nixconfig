return {
	{
		"folke/lazy.nvim",
		version = "*",
	},
	"nvim-tree/nvim-web-devicons",
	-- {
	-- 	"echasnovski/mini.indentscope",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	opts = {
	-- 		symbol = "│",
	-- 		options = { try_as_border = true },
	-- 	},
	-- },
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		-- config = function()
		-- 	local highlight = {
		-- 		"RainbowRed",
		-- 		"RainbowYellow",
		-- 		"RainbowBlue",
		-- 		"RainbowOrange",
		-- 		"RainbowGreen",
		-- 		"RainbowViolet",
		-- 		"RainbowCyan",
		-- 	}
		--
		-- 	local hooks = require("ibl.hooks")
		-- 	-- create the highlight groups in the highlight setup hook, so they are reset
		-- 	-- every time the colorscheme changes
		-- 	hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
		-- 		vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
		-- 		vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
		-- 		vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
		-- 		vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
		-- 		vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
		-- 		vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
		-- 		vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
		-- 	end)
		--
		-- 	require("ibl").setup({ indent = { highlight = highlight } })
		-- end,
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
			require("fidget").setup()
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
	{
		"vim-test/vim-test",
	},
}
