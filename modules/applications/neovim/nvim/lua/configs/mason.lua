local M = {}

function M.config()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn",  text = "" },
		{ name = "DiagnosticSignHint",  text = "" },
		{ name = "DiagnosticSignInfo",  text = "" },
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

	local function on_attach(client, bufnr)
		lsp_highlight_document(client)
	end

	local servers = {
		rnix = {},
	}

	require('neodev').setup()

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

	-- Setup mason so it can manage external tooling
	require('mason').setup()

	-- Ensure the servers above are installed
	local mason_lspconfig = require 'mason-lspconfig'

	mason_lspconfig.setup {
		ensure_installed = vim.tbl_keys(servers),
	}

	require("lspconfig").zls.setup {}
	require("lspconfig").clangd.setup {}
	require("lspconfig").lua_ls.setup {}
	require("lspconfig").hls.setup {}

	mason_lspconfig.setup_handlers {
		function(server_name)
			require('lspconfig')[server_name].setup {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = servers[server_name],
			}
		end,
	}

	local mason_registry = require("mason-registry")
	mason_registry:on("package:install:success", function(pkg)
		pkg:get_receipt():if_present(function(receipt)
			-- Figure out the interpreter inspecting nvim itself
			-- This is the same for all packages, so compute only once

			for _, rel_path in pairs(receipt.links.bin) do
				local bin_abs_path = pkg:get_install_path() .. "/" .. rel_path
				if pkg.name == "lua-language-server" then
					bin_abs_path = pkg:get_install_path() .. "/libexec/bin/lua-language-server"
				end

				-- Set the interpreter on the binary
				os.execute(
					(
						"/bin/sh -c \"patchelf --set-interpreter $(patchelf --print-interpreter $(grep -oE '\\/nix\\/store\\/[a-z0-9]+-neovim-unwrapped-[0-9]+\\.[0-9]+\\.[0-9]+\\/bin\\/nvim' $(which nvim))) %q\""
					):format(bin_abs_path)
				)
			end
		end)
	end)

	-- Turn on lsp status information
	require('fidget').setup()

	vim.keymap.set('n', '<leader>ld', '<cmd>Telescope diagnostics<cr>', { desc = 'Buffer [D]iagnostics' })
	vim.keymap.set('n', '<leader>ls', '<cmd>Telescope lsp_document_symbols<cr>', { desc = 'LSP Document [S]ymbols' })
	vim.keymap.set('n', '<leader>la', '<cmd>Telescope lsp_code_actions<cr>', { desc = 'LSP Code [A]ctions' })
	vim.keymap.set('n', '<leader>lf', '<cmd>lua vim.lsp.buf.format { async = true }<cr>', { desc = '[F]ormat' })
	vim.keymap.set('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>', { desc = '[R]ename' })
	vim.keymap.set('n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<cr>', { desc = '[H]over' })
	vim.keymap.set('n', '<leader>lj', '<cmd>lua vim.diagnostic.goto_next()<cr>', { desc = 'Next Diagnostic' })
	vim.keymap.set('n', '<leader>lk', '<cmd>lua vim.diagnostic.goto_prev()<cr>', { desc = 'Prev Diagnostic' })
	vim.keymap.set('n', '<leader>lgd', '<cmd>Telescope lsp_definitions<cr>', { desc = '[D]efinitions' })
	vim.keymap.set('n', '<leader>lgr', '<cmd>Telescope lsp_references<cr>', { desc = '[R]eferences' })
	vim.keymap.set('n', '<leader>lgi', '<cmd>Telescope lsp_implementations<cr>', { desc = '[I]mplementations' })
end

return M
