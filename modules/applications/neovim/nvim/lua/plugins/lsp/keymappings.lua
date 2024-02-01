local M = {}

M._keys = nil

function M.get()
	-- local format = function()
	--      require("lazyvim.plugins.lsp.format").format({ force = true })
	-- end
	if not M._keys then
		M._keys = {
			{ "<leader>ld", "<cmd>Telescope diagnostic<cr>", desc = "Buffer [D]iagnostics" },
			{ "<leader>li", "<cmd>LspInfo<cr>", desc = "Lsp [I]nfo" },
			{
				"<leader>lgd",
				function()
					require("telescope.builtin").lsp_definitions({ reuse_win = true })
				end,
				desc = "Goto [D]efinition",
				has = "definition",
			},
			{ "<leader>lgr", "<cmd>Telescope lsp_references<cr>", desc = "[R]eferences" },
			{ "<leader>lge", vim.lsp.buf.declaration, desc = "Goto D[e]claration" },
			{
				"<leader>lgi",
				function()
					require("telescope.builtin").lsp_implementations({ reuse_win = true })
				end,
				desc = "Goto [I]mplementation",
			},
			{
				"<leader>lgy",
				function()
					require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
				end,
				desc = "Goto T[y]pe Definition",
			},
			{ "<leader>lh", vim.lsp.buf.hover, desc = "[H]over" },
			{
				"<leader>lf",
				function()
					require("conform").format({ lsp_fallback = true })
				end,
				desc = "[F]ormat",
			},
			{ "<leader>lH", vim.lsp.buf.signature_help, desc = "Signature [H]elp", has = "signatureHelp" },
			{ "<c-h>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
			{ "<leader>ldj", M.diagnostic_goto(true), desc = "Next Diagnostic" },
			{ "<leader>ldk", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
			{ "<leader>lej", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
			{ "<leader>lek", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
			{ "<leader>lwj", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
			{ "<leader>lwk", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
			-- { "<leader>cf", format, desc = "Format Document", has = "formatting" },
			-- { "<leader>cf", format, desc = "Format Range", mode = "v", has = "rangeFormatting" },
			{ "<leader>la", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
			{ "<leader>lr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
			-- {
			--      "<leader>cA",
			--      function()
			--              vim.lsp.buf.code_action({
			--                      context = {
			--                              only = {
			--                                      "source",
			--                              },
			--                              diagnostics = {},
			--                      },
			--              })
			--      end,
			--      desc = "Source Action",
			--      has = "codeAction",
			-- }
		}
	end
	return M._keys
end

---@param method string
function M.has(buffer, method)
	method = method:find("/") and method or "textDocument/" .. method
	local clients = vim.lsp.get_active_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		if client.supports_method(method) then
			return true
		end
	end
	return false
end

function M.on_attach(_, buffer)
	local Keys = require("lazy.core.handler.keys")

	for _, keys in pairs(M.get()) do
		if not keys.has or M.has(buffer, keys.has) then
			local opts = Keys.opts(keys)
			opts.has = nil
			opts.silent = opts.silent ~= false
			opts.buffer = buffer
			vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
		end
	end
end

function M.diagnostic_goto(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end

return M
