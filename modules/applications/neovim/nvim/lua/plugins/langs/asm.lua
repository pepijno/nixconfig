vim.lsp.config('asm_lsp', {
	cmd = { 'asm-lsp' },
	filetypes = { 'asm', 'vmasm' },
	root_markers = { '.asm-lsp.toml', '.git' },
})
vim.lsp.enable('asm_lsp')

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "asm" })
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft, { asm = { "asmfmt" } })
		end,
	},
}
