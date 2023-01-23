local M = {}

function M.setup()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = true,
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})

	local capabilities = vim.lsp.protocol.make_client_capabilities()

	--local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	--if not status_ok then
	--	return
	--end

	--M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

local function lsp_highlight_document(client)
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
	  augroup lsp_document_highlight
		autocmd! * <buffer>
		autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
		autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
	  augroup END
	]],
			false
		)
	end
end

M.on_attach = function(client, bufnr)
	lsp_highlight_document(client)
end

M.load_server = function(server, configs)
	local status_ok, lsp_config = pcall(require, "lspconfig")
	if not status_ok then
		return
	end
	if not configs then
		configs = {}
	end
	configs.on_attach = M.on_attach
	lsp_config[server].setup(configs)
	local bufnr = vim.api.nvim_get_current_buf()
	lsp_config[server].manager.try_add_wrapper(bufnr)
end

return M
