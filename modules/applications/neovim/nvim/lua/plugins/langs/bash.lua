vim.lsp.config('bashls', {
	cmd = { 'bash-language-server', 'start' },
	settings = {
		bashIde = {
			-- Glob pattern for finding and parsing shell script files in the workspace.
			-- Used by the background analysis features across files.

			-- Prevent recursive scanning which will cause issues when opening a file
			-- directly in the home directory (e.g. ~/foo.sh).
			--
			-- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
			globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
		},
	},
	filetypes = { 'bash', 'sh' },
	root_markers = { '.git' },
})
vim.lsp.enable('bashls')

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "bash" })
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft, {
				bash = { "beautysh" },
				sh = { "beautysh" },
			})
		end,
	},
}
