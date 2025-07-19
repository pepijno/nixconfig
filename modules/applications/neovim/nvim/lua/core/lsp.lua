local function client_supports_method(client, method, bufnr)
	if vim.fn.has("nvim-0.11") == 1 then
		return client:supports_method(method, bufnr)
	else
		return client.supports_method(method, { bufnr = bufnr })
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local keymap = vim.keymap.set
		local lsp = vim.lsp
		local opts = { silent = true }
		local opt = function(desc, others)
			return vim.tbl_extend("force", opts, { desc = desc }, others or {})
		end
		local hover_opts = {
			border = "single",
			max_width = math.floor(vim.o.columns * 0.7),
			max_height = math.floor(vim.o.lines * 0.7),
		}

		keymap("n", "<leader>ld", "<cmd>Telescope diagnostic<cr>", opt("Buffer [D]iagnostics"))
		keymap("n", "<leader>lgd", function()
			require("telescope.builtin").lsp_definitions({ reuse_win = true })
		end, opt("[G]oto [D]efinition"))
		keymap("n", "<leader>lgi", function()
			require("telescope.builtin").lsp_implementations({ reuse_win = true })
		end, opt("[G]oto [I]mplementation"))
		keymap("n", "<leader>lgy", function()
			require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
		end, opt("[G]oto T[y]pe Definitions"))
		keymap("n", "<leader>lh", function()
			lsp.buf.hover(hover_opts)
		end, opt("[H]over"))
		keymap("n", "<leader>lf", function()
			require("conform").format({ lsp_fallback = true })
		end, opt("[F]ormat"))
		keymap("n", "<leader>lH", function()
			lsp.buf.signature_help(hover_opts)
		end, opt("Signature [H]elp"))
		keymap("n", "<C-h>", function()
			lsp.buf.signature_help(hover_opts)
		end, opt("Signature [H]elp"))
		keymap({ "n", "v" }, "<leader>la", lsp.buf.code_action, opt("Code [A]ction"))
		keymap("n", "<leader>ldj", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, opt("Next Diagnostic"))
		keymap("n", "<leader>ldk", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, opt("Prev Diagnostic"))
		keymap("n", "<leader>lej", function()
			vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
		end, opt("Next Error"))
		keymap("n", "<leader>lek", function()
			vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
		end, opt("Prev Error"))
		keymap("n", "<leader>lwj", function()
			vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.WARN })
		end, opt("Next Warning"))
		keymap("n", "<leader>lwk", function()
			vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.WARN })
		end, opt("Prev Warning"))

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if
			client
			and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
		then
			local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			-- When LSP detaches: Clears the highlighting
			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(evt)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = evt.buf })
				end,
			})
		end
	end,
})

vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	virtual_text = {
		source = "if_many",
		spacing = 2,
		format = function(diagnostic)
			local diagnostic_message = {
				[vim.diagnostic.severity.ERROR] = diagnostic.message,
				[vim.diagnostic.severity.WARN] = diagnostic.message,
				[vim.diagnostic.severity.INFO] = diagnostic.message,
				[vim.diagnostic.severity.HINT] = diagnostic.message,
			}
			return diagnostic_message[diagnostic.severity]
		end,
	},
})
