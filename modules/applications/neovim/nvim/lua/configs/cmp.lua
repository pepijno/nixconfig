local M = {}

function M.config()
	local cmp_status_ok, cmp = pcall(require, "cmp")
	if not cmp_status_ok then
		return
	end
	local ok, lspkind = pcall(require, "lspkind")
	if not ok then
		return
	end

	lspkind.init()

	local snip_status_ok, luasnip = pcall(require, "luasnip")
	if not snip_status_ok then
		return
	end

	cmp.setup({
		formatting = {
			preselect = cmp.PreselectMode.None,
			format = lspkind.cmp_format({
				with_text = true,
				menu = {
					buffer = "[buf]",
					nvim_lsp = "[LSP]",
					nvim_lua = "[api]",
					path = "[path]",
					luasnip = "[snip]",
				},
			}),
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		experimental = {
			ghost_text = true,
			native_menu = false,
		},
		completion = {
			keyword_length = 1,
		},
		window = {
			completion = {
				winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
				col_offset = -3,
				side_padding = 0,
			},
			documentation = cmp.config.window.bordered(),
		},
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
				local strings = vim.split(kind.kind, "%s", { trimempty = true })
				kind.kind = " " .. (strings[1] or "") .. " "
				kind.menu = "    (" .. (strings[2] or "") .. ")"

				return kind
			end,
		},
		mapping = {
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			['<C-d>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			-- ['<CR>'] = cmp.mapping.confirm {
			-- 	behavior = cmp.ConfirmBehavior.Replace,
			-- 	select = true,
			-- },
			['<Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { 'i', 's' }),
			['<S-Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { 'i', 's' }),
		},
		sources = {
			{ name = 'nvim_lsp_signature_help' },
			{
				name = "nvim_lsp",
				-- entry_filter = function(entry, ctx)
				-- 	return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind()
				-- end
			},
			{ name = "nvim_lua" },
			{ name = "path" },
			{ name = "luasnip" },
		}, {
			{ name = "buffer" },
		},
	})
end

return M
