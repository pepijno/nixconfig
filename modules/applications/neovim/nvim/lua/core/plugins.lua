local M = {}

local packer_status_ok, packer = pcall(require, "packer")
if not packer_status_ok then
	return
end

local file_exists = function(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

local compile_path = vim.fn.stdpath("data") .. "/lua/packer_compiled.lua"

if file_exists(compile_path) then
	vim.cmd("luafile " .. compile_path)
end

packer.startup({
	function(use)
		use({ "wbthomason/packer.nvim" })

		-- use({
		-- 	"lewis6991/impatient.nvim",
		-- 	config = function()
		-- 		require("impatient")
		-- 	end,
		-- })

		use({ "nvim-lua/plenary.nvim" })
		use({ "nvim-lua/popup.nvim" })
		use({ "antoinemadec/FixCursorHold.nvim" })

		---------------
		-- Styling   --
		---------------
		use({
			"kyazdani42/nvim-web-devicons",
			config = function()
				require("configs.icons").config()
			end,
		})
		use({ "ellisonleao/gruvbox.nvim" })
		use({
			"nvim-lualine/lualine.nvim",
			after = { "nvim-web-devicons", "gruvbox.nvim" },
			config = function()
				require("configs.lualine").config()
			end,
		})

		----------------
		-- Nvim Tree  --
		----------------
		use({
			"kyazdani42/nvim-tree.lua",
			cmd = { "NvimTreeToggle", "NvimTreeFocus" },
			config = function()
				require("configs.nvim-tree").config()
			end,
		})

		----------------
		-- Treesitter --
		----------------
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
		use({
			"lewis6991/nvim-treesitter-context",
			after = "nvim-treesitter",
			config = function()
				require("configs.treesitter").context_config()
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
			"andymass/vim-matchup",
			after = "nvim-treesitter",
		})
		use({
			"mfussenegger/nvim-ts-hint-textobject",
			after = "nvim-treesitter",
			config = function()
				vim.cmd([[omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>]])
				vim.cmd([[vnoremap <silent> m :lua require('tsht').nodes()<CR>]])
			end,
		})

		-------------
		--   cmp   --
		-------------

		use({
			"hrsh7th/nvim-cmp",
			event = "BufRead",
			after = { "lspkind.nvim", "LuaSnip" },
			config = function()
				require("configs.cmp").config()
			end,
		})
		use({
			"hrsh7th/cmp-buffer",
			after = "nvim-cmp",
		})
		use({
			"hrsh7th/cmp-path",
			after = "nvim-cmp",
		})
		use({
			"hrsh7th/cmp-nvim-lua",
			after = "nvim-cmp",
		})
		use({
			"hrsh7th/cmp-nvim-lsp",
			after = "nvim-cmp",
		})
		use("onsails/lspkind.nvim")
		use({
			"saadparwaiz1/cmp_luasnip",
			after = "nvim-cmp",
		})

		-------------
		--   LSP   --
		-------------
		use({
			"neovim/nvim-lspconfig",
			after = "cmp-nvim-lsp",
			config = function()
				require("configs.lsp")
			end,
		})
		use({
			"jose-elias-alvarez/null-ls.nvim",
			event = "BufRead",
			config = function()
				require("configs.null-ls").config()
			end,
		})
		use({
			"j-hui/fidget.nvim",
			config = function()
				require("fidget").setup({
					window = {
						blend = 0,
					},
				})
				vim.cmd([[highlight FidgetTitle ctermbg=NONE guibg=NONE]])
				vim.cmd([[highlight FidgetTask ctermbg=NONE guibg=NONE]])
			end,
		})

		--------------
		-- Snippits --
		--------------
		use({
			"L3MON4D3/LuaSnip",
			config = function()
				require("configs.snips").config()
			end,
		})

		-- use "mfussenegger/nvim-dap"
		--   use "rcarriga/nvim-dap-ui"
		--   use "theHamsta/nvim-dap-virtual-text"
		--   use "nvim-telescope/telescope-dap.nvim"
		--
		--   use "mfussenegger/nvim-dap-python"
		--   use "jbyuki/one-small-step-for-vimkind"

		---------------
		-- Telescope --
		---------------
		use({
			"nvim-telescope/telescope.nvim",
			cmd = "Telescope",
			config = function()
				require("configs.telescope").config()
			end,
		})

		--------------
		-- Comments --
		--------------
		use({
			"numToStr/Comment.nvim",
			event = "BufRead",
			after = "nvim-ts-context-commentstring",
			config = function()
				require("configs.comment").config()
			end,
		})

		------------------------
		-- Indentation guides --
		------------------------
		use({
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("configs.indent-line").config()
			end,
		})

		---------------
		-- Which key --
		---------------
		use({
			"folke/which-key.nvim",
			config = function()
				require("configs.which-key").config()
			end,
		})

		-------------------
		-- Better escape --
		-------------------
		use({
			"max397574/better-escape.nvim",
			event = { "InsertEnter" },
			config = function()
				require("configs.better_escape").config()
			end,
		})
		-- use({
		-- 	"ahmedkhalf/project.nvim",
		-- 	config = function()
		-- 		require("project_nvim").setup({})
		-- 	end,
		-- })

		--------------
		-- surround --
		--------------
		use("tpope/vim-surround")

		---------------
		-- committia --
		---------------
		use("rhysd/committia.vim")

		---------------------
		-- Faster filtypes --
		---------------------
		use("nathom/filetype.nvim")

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
		auto_reload_compiled = true,
	},
})

if not file_exists(compile_path) then
	require("packer").sync()
end

return M
