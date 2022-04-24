local M = {}

function M.config()
	local status_ok, comment = pcall(require, "Comment")
	if not status_ok then
		return
	end

	comment.setup({
		-- LHS of operator-pending mapping in NORMAL + VISUAL mode
		opleader = {
			-- line-comment keymap
			line = "gc",
			-- block-comment keymap
			block = "gb",
		},
		-- Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
		mappings = {
			-- operator-pending mapping
			-- Includes:
			--  `gcc`               -> line-comment  the current line
			--  `gcb`               -> block-comment the current line
			--  `gc[count]{motion}` -> line-comment  the region contained in {motion}
			--  `gb[count]{motion}` -> block-comment the region contained in {motion--[[ } ]]
			basic = true,
			-- extra mapping
			-- Includes `gco`, `gcO`, `gcA`
			extra = true,
			-- extended mapping
			-- Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
			extended = true,
		},
		-- LHS of toggle mapping in NORMAL + VISUAL mode
		toggler = {
			-- line-comment keymap
			--  Makes sense to be related to your opleader.line
			line = "gcc",
			-- block-comment keymap
			--  Make sense to be related to your opleader.block
			block = "ghc",
		},
		pre_hook = function(ctx)
			local U = require("Comment.utils")

			local location = nil
			if ctx.ctype == U.ctype.block then
				location = require("ts_context_commentstring.utils").get_cursor_location()
			elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
				location = require("ts_context_commentstring.utils").get_visual_start_location()
			end

			return require("ts_context_commentstring.internal").calculate_commentstring({
				key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
				location = location,
			})
		end,
	})
end

return M
