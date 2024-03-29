return {
	{
		"numToStr/Comment.nvim",
		lazy = false,
		opts = {},
		config = function()
			local comment = require("Comment")
			local ft = require("Comment.ft")

			local commentstr = "<!--%s-->"

			ft.set("angular", { commentstr, commentstr })

			comment.setup()
		end,
	},
}
