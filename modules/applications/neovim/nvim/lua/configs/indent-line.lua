local M = {}

function M.config()
	local status_ok, indent_blankline = pcall(require, "indent_blankline")
	if not status_ok then
		return
	end

	vim.g.indentLine_enabled = 1
	vim.g.indent_blankline_show_trailing_blankline_indent = false
	vim.g.indent_blankline_show_first_indent_level = true
	vim.g.indent_blankline_use_treesitter = true
	vim.g.indent_blankline_show_current_context = true
	vim.g.indent_blankline_char = "▏"
	vim.g.indent_blankline_buftype_exclude = {
		"nofile",
		"terminal",
		"lsp-installer",
		"lspinfo",
	}
	vim.g.indent_blankline_filetype_exclude = {
		"help",
		"startify",
		"dashboard",
		"packer",
		"neogitstatus",
		"NvimTree",
		"neo-tree",
		"Trouble",
	}

	indent_blankline.setup({
		show_current_context = true,
		show_current_context_start = true,
	})
end

return M
