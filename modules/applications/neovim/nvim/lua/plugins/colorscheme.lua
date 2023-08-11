return {
	-- {
	-- 	"sainnhe/edge",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.o.background = "light"
	-- 		vim.cmd("colorscheme edge")
	-- 		vim.cmd([[autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE]])
	-- 	end,
	-- },
	-- {
	-- 	"yorik1984/newpaper.nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("newpaper").setup({
	-- 			style = "light",
	-- 			disable_background = true,
	-- 		})
	-- 		vim.cmd([[autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE]])
	-- 	end,
	-- },
	{
		"catppuccin/nvim",
		config = function()
			require("catppuccin").setup({
				flavour = "latte",
				transparent_background = true,
				dim_inactive = {
					enabled = true,
					percentage = 0.30,
				},
			});
			vim.cmd.colorscheme "catppuccin-latte"
		end,
	},
	-- {
	-- 	"ellisonleao/gruvbox.nvim",
	-- 	config = function()
	-- 		require("gruvbox").setup({
	-- 			italic = {
	-- 				operators = true,
	-- 				contrast = "hard",
	-- 				dim_inactive = true,
	-- 				transparent_mode = true,
	-- 			},
	-- 		})
	-- 		vim.o.background = "light"
	-- 		vim.cmd("colorscheme gruvbox")
	-- 		vim.g.gruvbox_transparent_bg = 1
	-- 		-- 	vim.g.gruvbox_contrast_light = "hard"
	-- 		-- 	vim.g.gruvbox_invert_selection = "0"
	-- 		vim.cmd([[autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE]])
	-- 		-- end
	-- 	end,
	-- },
}
