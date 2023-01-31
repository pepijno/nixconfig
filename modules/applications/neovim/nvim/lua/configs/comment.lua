local M = {}

function M.config()
	local status_ok, comment = pcall(require, "Comment")
	if not status_ok then
		return
	end

	comment.setup({
		opleader = {
			line = "gc",
			block = "gb",
		},
	})
end

return M
