return {
	{
		"catppuccin/nvim",
		lazy = false,
		config = function()
			require("catppuccin").setup({
				flavour = "latte",
				transparent_background = true,
			})
			vim.cmd.colorscheme("catppuccin-latte")
		end,
		priority = 1000,
	},
}
