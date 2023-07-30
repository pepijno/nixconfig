return {
	-- {
	-- 	"ellisonleao/gruvbox.nvim",
	-- 	config = function()
	-- 		if vim.g.colors_name ~= "gruvbox" then
	-- 			vim.g.colors_name = gruvbox
	-- 			vim.cmd([[colorscheme gruvbox]])
	-- 			vim.opt.termguicolors = true
	-- 			vim.opt.background = "dark"
	-- 			vim.g.gruvbox_transparent_bg = 1
	-- 			vim.g.gruvbox_contrast_light = "hard"
	-- 			vim.g.gruvbox_invert_selection = "0"
	-- 			vim.cmd([[autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE]])
	-- 		end
	-- 	end,
	-- },
	{
		"yorik1984/newpaper.nvim",
		priority = 1000,
		config = function()
			vim.g.transparent_enabled = true
			require("newpaper").setup({
				style = "dark",
				disable_background = true,
			})
			vim.cmd([[highlight ColorColumn ctermbg=16 guibg=#3E3E3E]])
		end,
		dependencies = {
			"xiyaowong/transparent.nvim",
		},
	},
}
