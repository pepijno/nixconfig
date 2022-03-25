local M = {}

function M.config()
	local ok, null_ls = pcall(require, "null-ls")
	if not ok then
		return
	end

	null_ls.setup({
		sources = {
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.diagnostics.eslint,
			null_ls.builtins.completion.spell,
		},
		on_attach = function(client)
			if client.resolved_capabilities.document_formatting then
				vim.cmd([[
			augroup LspFormatting
				autocmd! * <buffer>
				autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
			augroup END
			]])
			end
		end,
	})
end

return M
