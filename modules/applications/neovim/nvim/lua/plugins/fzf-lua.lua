local fzf_lua = function(builtin, opts)
	return function()
		require("fzf-lua")[builtin](opts)
	end
end

return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "echasnovski/mini.icons" },
		opts = {
			winopts = {
				border = "single",
				preview = {
					border = "single",
					horizontal = "right:50%",
				},
				fullscreen = true,
			},
			fzf_colors = true,
			keymap = {
				builtin = {
					["<C-d>"] = "preview-page-down",
					["<C-u>"] = "preview-page-up",
				},
			},
			files = {
				file_icons = "mini",
				path_shorten = true,
			},
			grep = {
				file_icons = "mini",
			},
		},
		keys = {
			{ "<leader>ff", fzf_lua("files"), desc = "[F]iles" },
			{ "<leader>fr", fzf_lua("live_grep_native", { path_shorten = true }), desc = "[R]ipgrep" },
			{ "<leader>fR", fzf_lua("grep_visual"), desc = "[R]ipgrep visual", mode = "v" },
			{ "<leader>fR", fzf_lua("grep_cword"), desc = "[R]ipgrep word", mode = "n" },
			{ "<leader>fk", fzf_lua("keymaps"), desc = "[K]eymaps" },
		},
	},
}
