local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/neodev.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
				},
				severity_sort = true,
			},
			capabilities = capabilities,
			format_notify = false,
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			setup = {},
		},
		config = function(_, opts)
			require("inc_rename").setup()

			vim.keymap.set("n", "<leader>rn", function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end, { expr = true })

			require("neodev").setup()

			vim.diagnostic.config({
				float = { border = "rounded" },
			})

			local keys = require("plugins.lsp.keymappings")

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(args)
					local buffer = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					keys.on_attach(client, buffer)
					if client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
					end
				end,
			})

			local register_capability = vim.lsp.handlers["client/registerCapability"]

			vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
				local ret = register_capability(err, res, ctx)
				local client_id = ctx.client_id
				---@type lsp.Client
				local client = vim.lsp.get_client_by_id(client_id)
				local buffer = vim.api.nvim_get_current_buf()
				keys.on_attach(client, buffer)
				return ret
			end

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

			-- diagnostics
			local diagnostics = {
				Error = " ",
				Warn = " ",
				Hint = " ",
				Info = " ",
			}
			for name, icon in pairs(diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end

			-- local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
			--
			-- if opts.inlay_hints.enabled and inlay_hint then
			-- 	vim.api.nvim_create_autocmd("LspAttach", {
			-- 		callback = function(args)
			-- 			local buffer = args.buf
			-- 			local client = vim.lsp.get_client_by_id(args.data.client_id)
			-- 			if client.supports_method('textDocument/inlayHint') then
			-- 				inlay_hint(buffer, true)
			-- 			end
			-- 		end,
			-- 	})
			-- end

			if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
				opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
					or function(diagnostic)
						for d, icon in pairs(diagnostics) do
							if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
								return icon
							end
						end
					end
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = opts.servers
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local caps = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				opts.capabilities or {}
			)

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					caps = vim.deepcopy(caps),
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- get all the servers that are available thourgh mason-lspconfig
			-- local have_mason, mlsp = pcall(require, "mason-lspconfig")
			-- local all_mslp_servers = {}
			-- if have_mason then
			-- 	all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			-- end
			--
			-- local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				-- 	if server_opts then
				-- 		server_opts = server_opts == true and {} or server_opts
				-- 		-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
				-- 		if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
				setup(server)
				-- 		else
				-- 			ensure_installed[#ensure_installed + 1] = server
				-- 		end
				-- 	end
			end
			--
			-- if have_mason then
			-- 	mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
			-- end
		end,
	},

	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate", "MasonUninstall" },
		opts = {
			ensure_installed = {},
		},
		config = function(_, opts)
			require("mason").setup({

				PATH = "append",

				ui = {
					icons = {
						package_pending = " ",
						package_installed = "󰄳 ",
						package_uninstalled = " 󰚌",
					},

					keymaps = {
						toggle_server_expand = "<CR>",
						install_server = "i",
						update_server = "u",
						check_server_version = "c",
						update_all_servers = "U",
						check_outdated_servers = "C",
						uninstall_server = "X",
						cancel_installation = "<C-c>",
					},
				},

				max_concurrent_installers = 10,
			})

			vim.api.nvim_create_user_command("MasonInstallAll", function()
				if opts.ensure_installed and #opts.ensure_installed > 0 then
					vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
				end
			end, {})

			vim.g.mason_binaries_list = opts.ensure_installed
		end,
	},

	{
		"stevearc/conform.nvim",
		config = function(_, opts)
			require("conform").setup(opts)
		end,
	},
}
