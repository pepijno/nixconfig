return {
	-- {
	-- 	"sainnhe/gruvbox-material",
	-- 	config = function()
	-- 		vim.o.background = "light"
	-- 		vim.cmd([[colorscheme gruvbox-material]])
	-- 		vim.g.gruvbox_material_transparent_background = 2
	-- 		vim.g.gruvbox_material_contrast_light = "hard"
	-- 		vim.g.gruvbox_material_invert_selection = "0"
	-- 		vim.g.gruvbox_material_better_performance = 1
	-- 		vim.g.gruvbox_material_dim_inactive_windows = 1
	-- 		vim.g.gruvbox_material_enable_italic = 1
	-- 		vim.g.gruvbox_material_enable_bold = 1
	-- 		vim.g.gruvbox_material_ui_contrast = "high"
	-- 		vim.cmd([[autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE]])
	-- 	end,
	-- },
	{
		"ellisonleao/gruvbox.nvim",
		config = function()
			require("gruvbox").setup({
				italic = {
					operators = true,
					contrast = "hard",
					dim_inactive = true,
					transparent_mode = true,
				},
			})
			vim.o.background = "light"
			vim.cmd("colorscheme gruvbox")
			vim.g.gruvbox_transparent_bg = 1
			-- 	vim.g.gruvbox_contrast_light = "hard"
			-- 	vim.g.gruvbox_invert_selection = "0"
			vim.cmd([[autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE]])
			-- end
		end,
	},
	-- {
	-- 	"yorik1984/newpaper.nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.g.transparent_enabled = true
	-- 		require("newpaper").setup({
	-- 			style = "dark",
	-- 			disable_background = true,
	-- 		})
	-- 		vim.cmd([[highlight ColorColumn ctermbg=16 guibg=#3E3E3E]])
	-- 	end,
	-- 	dependencies = {
	-- 		"xiyaowong/transparent.nvim",
	-- 	},
	-- },
}
