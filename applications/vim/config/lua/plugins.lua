return {
	{ "wbthomason/packer.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "tamago324/nlsp-settings.nvim" },
	{ "jose-elias-alvarez/null-ls.nvim" },
	{
		"kabouzeid/nvim-lspinstall",
		event = "VimEnter",
		config = function()
			require("core.lspinstall").setup()
		end,
	},
	{
		"folke/lsp-colors.nvim",
		config = function()
			require("lsp-colors").setup()
		end,
	},

	{ "nvim-lua/popup.nvim" },
	{ "nvim-lua/plenary.nvim" },
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		config = function()
			require("core.telescope").setup()
		end
	},
	-- {
	-- 	'rmagatti/session-lens',
	-- 	requires = {'rmagatti/auto-session', 'nvim-telescope/telescope.nvim'},
	-- 	config = function()
	-- 		require("core.auto-session").setup_lens()
	-- 	end
	-- },

	-- Completion
	{
		"hrsh7th/nvim-compe",
		event = "InsertEnter",
		config = function()
			require("core.cmp").setup()
		end,
	},

	{
		"folke/which-key.nvim",
		config = function()
			require("core.which-key").setup()
		end
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("core.treesitter").setup()
		end,
	},
	{ "nvim-treesitter/playground" },

	-- NvimTree
	{
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("core.nvimtree").setup()
		end,
	},

	-- project.nvim
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("core.project").setup()
		end,
	},
	-- Autopairs
	{
		"windwp/nvim-autopairs",
		-- event = "InsertEnter",
		-- after = "nvim-compe",
		config = function()
			require("core.autopairs").setup()
		end,
	},
	-- Gitsigns
	{
		"lewis6991/gitsigns.nvim",

		config = function()
			require("core.gitsigns").setup()
		end,
		event = "BufRead",
	},
	-- Comments
	{
		"terrortylor/nvim-comment",
		event = "BufRead",
		config = function()
			require("core.nvim_comment").setup()
		end,
	},

	-- lualine
	{
		"shadmansaleh/lualine.nvim",
		config = function()
			require("core.lualine").setup()
		end,
	},

	-- Barbar
	{
		"romgrk/barbar.nvim",
		config = function()
			require("core.barbar").setup()
		end,
		event = "BufWinEnter",
	},

	-- Icons
	{ "kyazdani42/nvim-web-devicons" },

	-- Color scheme
	{
		"morhetz/gruvbox",
		config = function()
			require("core.gruvbox").setup()
		end
	},

	{
		"glepnir/dashboard-nvim",
		config = function()
			require("core.dashboard").setup()
		end,
	},

	-- auto-sessions
	-- {
	-- 	"rmagatti/auto-session",
	-- 	config = function()
	-- 		require("core.auto-session").setup()
	-- 	end
}
	-- }
