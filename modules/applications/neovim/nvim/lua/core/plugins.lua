local M = {}

local packer_status_ok, packer = pcall(require, "packer")
if not packer_status_ok then
	return
end

function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
end

local compile_path = vim.fn.stdpath("data") .. "/lua/packer_compiled.lua"

if (file_exists(compile_path)) then
	vim.cmd("luafile " .. compile_path)
end

packer.startup({
	function(use)
		use({ "wbthomason/packer.nvim" })
		use({ "nvim-lua/plenary.nvim" })
		use({ "nvim-lua/popup.nvim" })
		use({ "antoinemadec/FixCursorHold.nvim" })
		use({
			"kyazdani42/nvim-web-devicons",
			config = function()
				require("configs.icons").config()
			end,
		})
		use({ "moll/vim-bbye" })
		use({
			"kyazdani42/nvim-tree.lua",
			cmd = { "NvimTreeToggle", "NvimTreeFocus" },
			config = function()
				require("configs.nvim-tree").config()
			end,
		})
		use({
			"nvim-lualine/lualine.nvim",
			after = { "nvim-web-devicons", "gruvbox.nvim" },
			config = function()
				require("configs.lualine").config()
			end,
		})
		use({
			"p00f/nvim-ts-rainbow",
			after = "nvim-treesitter",
		})
		use({
			"windwp/nvim-ts-autotag",
			after = "nvim-treesitter",
			config = function()
				require("nvim-ts-autotag").setup()
			end,
		})
		use({
			"JoosepAlviste/nvim-ts-context-commentstring",
			after = "nvim-treesitter",
		})
		use({
			"nvim-treesitter/nvim-treesitter",
			branch = vim.fn.has("nvim-0.6") == 1 and "master" or "0.5-compat",
			run = ":TSUpdate",
			event = "BufRead",
			cmd = {
				"TSInstall",
				"TSInstallInfo",
				"TSInstallSync",
				"TSUninstall",
				"TSUpdate",
				"TSUpdateSync",
				"TSDisableAll",
				"TSEnableAll",
			},
			config = function()
				require("configs.treesitter").config()
			end,
		})
		use({
			"nvim-treesitter/playground",
			after = "nvim-treesitter",
			cmd = {
				"TSPlaygroundToggle",
			},
		})
		-- 	{
		-- 		"rafamadriz/friendly-snippets",
		-- 		event = "InsertEnter",
		-- 	},
		-- use {
		-- 	"L3MON4D3/LuaSnip",
		-- 	after = "friendly-snippets",
		-- 	config = function()
		-- 		require("configs.luasnip").config()
		-- 	end,
		-- }
		use({
			"hrsh7th/nvim-cmp",
			event = "BufRead",
			config = function()
				require("configs.cmp").config()
			end,
		})
		-- 	{
		-- 		"saadparwaiz1/cmp_luasnip",
		-- 		after = "nvim-cmp",
		-- 		config = function()
		-- 			require("core.utils").add_cmp_source "luasnip"
		-- 		end,
		-- 	},
		use({
			"hrsh7th/cmp-buffer",
			after = "nvim-cmp",
			config = function()
				require("configs.cmp").add_cmp_source("buffer")
			end,
		})
		use({
			"hrsh7th/cmp-path",
			after = "nvim-cmp",
			config = function()
				require("configs.cmp").add_cmp_source("path")
			end,
		})
		use({
			"hrsh7th/cmp-nvim-lsp",
			after = "nvim-cmp",
			config = function()
				require("configs.cmp").add_cmp_source("nvim_lsp")
			end,
		})
		use({
			"neovim/nvim-lspconfig",
			after = "cmp-nvim-lsp",
			config = function()
				require("configs.lsp")
			end,
		})
		use({
			"tami5/lspsaga.nvim",
			event = "BufRead",
			config = function()
				require("configs.lsp.lspsaga").config()
			end,
		})
		use({
			"simrat39/symbols-outline.nvim",
			cmd = "SymbolsOutline",
			setup = function()
				require("configs.symbols-outline").setup()
			end,
		})
		use({
			"jose-elias-alvarez/null-ls.nvim",
			-- event = "BufRead",
			config = function()
				require("configs.null-ls").config()
			end,
		})
		use({ "williamboman/nvim-lsp-installer" })
		use({
			"nvim-telescope/telescope.nvim",
			cmd = "Telescope",
			config = function()
				require("configs.telescope").config()
			end,
		})
		use({
			"lewis6991/gitsigns.nvim",
			event = "BufRead",
			config = function()
				require("configs.gitsigns").config()
			end,
		})
		use({
			"norcalli/nvim-colorizer.lua",
			event = "BufRead",
			config = function()
				require("configs.colorizer").config()
			end,
		})
		use({
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = function()
				require("configs.autopairs").config()
			end,
		})
		-- 	{
		-- 		"akinsho/nvim-toggleterm.lua",
		-- 		cmd = "ToggleTerm",
		-- 		config = function()
		-- 			require("configs.toggleterm").config()
		-- 		end,
		-- 	},
		use({
			"numToStr/Comment.nvim",
			event = "BufRead",
			after = "nvim-ts-context-commentstring",
			config = function()
				require("configs.comment").config()
			end,
		})
		use({
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("configs.indent-line").config()
			end,
		})
		use({
			"folke/which-key.nvim",
			config = function()
				require("configs.which-key").config()
			end,
		})
		use({
			"karb94/neoscroll.nvim",
			event = "BufRead",
			config = function()
				require("configs.neoscroll").config()
			end,
		})
		use({
			"max397574/better-escape.nvim",
			event = { "InsertEnter" },
			config = function()
				require("configs.better_escape").config()
			end,
		})
		use({ "ellisonleao/gruvbox.nvim" })
		use({
			"ahmedkhalf/project.nvim",
			config = function()
				require("project_nvim").setup({})
			end,
		})

		-- if packer_bootstrap then
		-- 	require('packer').sync()
		-- end
	end,
	config = {
		compile_path = compile_path,
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "rounded" })
			end,
		},
		-- profile = {
		-- 	enable = true,
		-- 	threshold = 0.0001,
		-- },
		-- git = {
		-- 	clone_timeout = 300,
		-- },
		auto_clean = true,
		compile_on_sync = true,
		-- auto_reload_compiled = true,
	},
})


if not file_exists(compile_path) then
	require('packer').sync()
end

return M
