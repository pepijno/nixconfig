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
	{
		"ariel-frischer/bmessages.nvim",
		event = "CmdlineEnter",
		opts = {},
	},
	{
		"smjonas/inc-rename.nvim",
		config = function()
			vim.keymap.set("n", "<leader>lr", function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end, { expr = true })
		end,
	},
	{
		"tpope/vim-sleuth",
	},
}
