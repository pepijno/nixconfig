local M = {}

function M.config()
	local present, better_escape = pcall(require, "better_escape")
	if not present then
		return
	end

	better_escape.setup({
		mapping = { "kj" },
		timeout = vim.o.timeoutlen,
		keys = "<ESC>",
	})
end

return M
