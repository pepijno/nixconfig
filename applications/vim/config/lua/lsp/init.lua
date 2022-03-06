local M = {}

DATA_PATH = vim.fn.stdpath "data"

conf.lsp = {
	completion = {
		item_kind = {
			"   (Text) ",
			"   (Method)",
			"   (Function)",
			"   (Constructor)",
			" ﴲ  (Field)",
			"[] (Variable)",
			"   (Class)",
			" ﰮ  (Interface)",
			"   (Module)",
			" 襁 (Property)",
			"   (Unit)",
			"   (Value)",
			" 練 (Enum)",
			"   (Keyword)",
			"   (Snippet)",
			"   (Color)",
			"   (File)",
			"   (Reference)",
			"   (Folder)",
			"   (EnumMember)",
			" ﲀ  (Constant)",
			" ﳤ  (Struct)",
			"   (Event)",
			"   (Operator)",
			"   (TypeParameter)",
		},
	},
	diagnostics = {
		signs = {
			active = true,
			values = {
				{ name = "LspDiagnosticsSignError", text = "" },
				{ name = "LspDiagnosticsSignWarning", text = "" },
				{ name = "LspDiagnosticsSignHint", text = "" },
				{ name = "LspDiagnosticsSignInformation", text = "" },
			},
		},
		virtual_text = {
			prefix = "",
			spacing = 0,
		},
		underline = true,
		severity_sort = true,
	},
	override = {},
	document_highlight = true,
	popup_border = "single",
	null_ls = {
		setup = {},
	},
}

conf.languages = {
	zig = {
		formatters = {},
		linters = {},
		lsp = {
			provider = "zls",
			setup = {
				cmd = {
					"zls",
				},
			},
		},
	},
	hs = {
		formatters = {},
		linters = {},
		lsp = {
			provider = "haskell-language-server-wrapper",
			setup = {
				cmd = {
					"--lsp"
				},
			},
		},
	},
	c = {
		formatters = {
			-- {
			--   exe = "clang_format",
			--   args = {},
			-- },
			{
				exe = "uncrustify",
				args = {},
			},
		},
		linters = {},
		lsp = {
			provider = "clangd",
			setup = {
				cmd = {
					"clangd",
					"--background-index",
					"--header-insertion=never",
					"--cross-file-rename",
					"--clang-tidy",
					"--clang-tidy-checks=-*,llvm-*,clang-analyzer-*",
				},
			},
		},
	},
	cpp = {
		formatters = {
			-- {
			--   exe = "clang_format",
			--   args = {},
			-- },
			-- {
			-- 	exe = "uncrustify",
			-- 	args = {},
			-- },
		},
		linters = {},
		lsp = {
			provider = "clangd",
			setup = {
				cmd = {
					"clangd",
					"--background-index",
					"--header-insertion=never",
					"--cross-file-rename",
					"--clang-tidy",
					"--clang-tidy-checks=-*,llvm-*,clang-analyzer-*",
				},
			},
		},
	},
}

M.config = function()
	vim.lsp.protocol.CompletionItemKind = conf.lsp.completion.item_kind

	for _, sign in pairs(conf.lsp.diagnostics.signs.values) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
	end

	require("lsp.handlers").setup()
end

local function lsp_highlight_document(client)
	if conf.lsp.document_highlight == false then
		return -- we don't need further
	end
	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
		[[
		hi LspReferenceRead cterm=bold ctermbg=red guibg=white
		hi LspReferenceText cterm=bold ctermbg=red guibg=white
		hi LspReferenceWrite cterm=bold ctermbg=red guibg=white
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

local function add_lsp_buffer_keybindings(bufnr)
	local keys = {
		g = {
			name = "LSP",
			["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show hover" },
			["d"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
			["D"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" },
			["r"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "Goto references" },
			["I"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
			["s"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "show signature help" },
			["p"] = { "<cmd>lua require'lsp.peek'.Peek('definition')<CR>", "Peek definition" },
			["l"] = {
				"<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ show_header = false, border = 'single' })<CR>",
				"Show line diagnostics",
			},
		},
	}
	require("which-key").register(keys, { mode = "n", buffer = bufnr })
end

function M.common_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}
	return capabilities
end

function M.get_ls_capabilities(client_id)
	local client
	if not client_id then
		local buf_clients = vim.lsp.buf_get_clients()
		for _, buf_client in ipairs(buf_clients) do
			if buf_client.name ~= "null-ls" then
				client_id = buf_client.id
				break
			end
		end
	end
	if not client_id then
		error "Unable to determine client_id"
	end

	client = vim.lsp.get_client_by_id(tonumber(client_id))

	local enabled_caps = {}

	for k, v in pairs(client.resolved_capabilities) do
		if v == true then
			table.insert(enabled_caps, k)
		end
	end

	return enabled_caps
end

function M.common_on_init(client, bufnr)
	local formatters = conf.lang[vim.bo.filetype].formatters
	if not vim.tbl_isempty(formatters) and formatters[1]["exe"] ~= nil and formatters[1].exe ~= "" then
		client.resolved_capabilities.document_formatting = false
	end
end

function M.common_on_attach(client, bufnr)
	lsp_highlight_document(client)
	add_lsp_buffer_keybindings(bufnr)
	-- require("lsp.null-ls").setup(vim.bo.filetype)
end

M.setup = function(language)
	local utils = require "lsp.utils"
	local lsp = conf.languages[language].lsp
	if utils.is_client_active(lsp.provider) then
		return
	end

	if lsp.provider ~= nil and lsp.provider ~= "" then
		local lspconfig = require "lspconfig"

		if not lsp.setup.on_attach then
			lsp.setup.on_attach = M.common_on_attach
		end
		if not lsp.setup.on_init then
			lsp.setup.on_init = M.common_on_init
		end
		if not lsp.setup.capabilities then
			lsp.setup.capabilities = M.common_capabilities()
		end

		lspconfig[lsp.provider].setup(lsp.setup)

		require("autocommands").define_augroups {
			autoformat = {
				{
					"BufWritePre",
					"*",
					":silent lua vim.lsp.buf.formatting_sync()",
				},
			},
		}
	end
end

return M
