return {
	{
		"catppuccin/nvim",
		config = function()
			require("catppuccin").setup({
				flavour = "latte",
				transparent_background = true,
				show_end_of_buffer = false,
				default_integrations = true,
				integrations = {
					neotest = true,
				},
			})
			vim.cmd.colorscheme("catppuccin-latte")
		end,
	},
}
