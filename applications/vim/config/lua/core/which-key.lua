local M = {}

M.config = function()
	conf.which_key = {
		opts = {
			mode = "n", -- NORMAL mode
			prefix = "<leader>",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
		},
		mappings = {
			-- "<leader>l" = {
			-- 	name = "LSP",
			-- 	a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
			-- 	d = {
			-- 		"<cmd>Telescope lsp_document_diagnostics<cr>",
			-- 		"Document Diagnostics",
			-- 	},
			-- 	w = {
			-- 		"<cmd>Telescope lsp_workspace_diagnostics<cr>",
			-- 		"Workspace Diagnostics",
			-- 	},
			-- 	-- f = { "<cmd>silent FormatWrite<cr>", "Format" },
			-- 	f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
			-- 	i = { "<cmd>LspInfo<cr>", "Info" },
			-- 	j = {
			-- 		"<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = lvim.lsp.popup_border}})<cr>",
			-- 		"Next Diagnostic",
			-- 	},
			-- 	k = {
			-- 		"<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = lvim.lsp.popup_border}})<cr>",
			-- 		"Prev Diagnostic",
			-- 	},
			-- 	p = {
			-- 		name = "Peek",
			-- 		d = { "<cmd>lua require('lsp.peek').Peek('definition')<cr>", "Definition" },
			-- 		t = { "<cmd>lua require('lsp.peek').Peek('typeDefinition')<cr>", "Type Definition" },
			-- 		i = { "<cmd>lua require('lsp.peek').Peek('implementation')<cr>", "Implementation" },
			-- 	},
			-- 	q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
			-- 	r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
			-- 	s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
			-- 	S = {
			-- 		"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			-- 		"Workspace Symbols",
			-- 	},
			-- },
		}
	}
end

M.setup = function()
	local which_key = require "which-key"

	which_key.setup()

	which_key.register(conf.which_key.mappings, conf.which_key.otps)
end

return M
