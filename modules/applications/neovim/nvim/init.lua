local utils = require('core.utils')

utils.disabled_builtins()

utils.bootstrap()

require('core.options')
require('core.autocmds')
require("core.mappings")

require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use {
		'neovim/nvim-lspconfig',
		requires = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'j-hui/fidget.nvim',
			'folke/neodev.nvim',
		},
	}

	use { -- Autocompletion
		'hrsh7th/nvim-cmp',
		requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', 'onsails/lspkind.nvim',
			'hrsh7th/cmp-path', 'hrsh7th/cmp-buffer' },
	}

	use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
			pcall(require('nvim-treesitter.install').update { with_sync = true })
		end,
	}

	use {
		'nvim-treesitter/nvim-treesitter-textobjects',
		after = 'nvim-treesitter',
	}

	use 'tpope/vim-fugitive'
	use 'tpope/vim-rhubarb'
	use 'lewis6991/gitsigns.nvim'

	use 'nvim-lualine/lualine.nvim'
	use 'numToStr/Comment.nvim'
	use 'tpope/vim-sleuth'

	use 'max397574/better-escape.nvim'

	use 'nathom/filetype.nvim'

	use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

	use 'kyazdani42/nvim-web-devicons'
	use 'ellisonleao/gruvbox.nvim'
	use 'norcalli/nvim-colorizer.lua'

	use 'kyazdani42/nvim-tree.lua'

	use 'folke/which-key.nvim'

	local has_plugins, plugins = pcall(require, 'custom.plugins')
	if has_plugins then
		plugins(use)
	end
end)

require('configs.lualine').config()
require('configs.comment').config()
require('configs.better_escape').config()
require('configs.gitsigns').config()
require('configs.colorizer').config()
require('configs.telescope').config()
require('configs.treesitter').config()
-- require('configs.nvim-tree').config()
require('configs.mason').config()
require('configs.cmp').config()
require('configs.which-key').config()
require("configs.gruvbox").config()
