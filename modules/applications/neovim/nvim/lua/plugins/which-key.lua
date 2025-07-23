return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		win = {
			border = "single",
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
	init = function ()
		local wk = require("which-key")
		wk.add({
			{ "<leader>f", group = "[F]ind" },
			{ "<leader>l", group = "[L]SP" },
			{ "<leader>lg", group = "[G]oto" },
			{ "<leader>t", group = "[T]reesitter" },
		})
	end
}
