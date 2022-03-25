local M = {}

function M.config()
	local cmp_status_ok, cmp = pcall(require, "cmp")
	if not cmp_status_ok then
		return
	end

	-- local snip_status_ok, luasnip = pcall(require, "luasnip")
	-- if not snip_status_ok then
	-- 	return
	-- end

	local kind_icons = {
		Text = "",
		Method = "",
		Function = "",
		Constructor = "",
		Field = "ﰠ",
		Variable = "",
		Class = "",
		Interface = "",
		Module = "",
		Property = "",
		Unit = "",
		Value = "",
		Enum = "",
		Keyword = "",
		Snippet = "",
		Color = "",
		File = "",
		Reference = "",
		Folder = "",
		EnumMember = "",
		Constant = "",
		Struct = "פּ",
		Event = "",
		Operator = "",
		TypeParameter = "",
	}
	local duplicates = {
		nvim_lsp = 0,
		-- luasnip = 1,
		-- cmp_tabnine = 1,
		buffer = 1,
		path = 1,
	}
	local source_names = {
		nvim_lsp = "(LSP)",
		emoji = "(Emoji)",
		path = "(Path)",
		calc = "(Calc)",
		vsnip = "(Snippet)",
		luasnip = "(Snippet)",
		buffer = "(Buffer)",
	}

	cmp.setup({
		preselect = cmp.PreselectMode.None,
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
				vim_item.menu = string.format("%s", source_names[entry.source.name])
				vim_item.dup = string.format("%s", duplicates[entry.source.name])
				return vim_item
			end,
		},
		-- snippet = {
		-- 	expand = function(args)
		-- 		luasnip.lsp_expand(args.body)
		-- 	end,
		-- },
		confirm_opts = {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		documentation = {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		},
		experimental = {
			ghost_text = true,
			native_menu = false,
		},
		completion = {
			keyword_length = 1,
		},
		mapping = {
			["<C-k>"] = cmp.mapping.select_prev_item(),
			["<C-j>"] = cmp.mapping.select_next_item(),
			["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
			["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<C-y>"] = cmp.config.disable,
			["<C-e>"] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			["<CR>"] = cmp.mapping.confirm(),
			["<Tab>"] = cmp.mapping(function(fallback)
				-- 	if luasnip.expandable() then
				-- 		luasnip.expand()
				-- 	elseif luasnip.expand_or_jumpable() then
				-- 		luasnip.expand_or_jump()
				-- 	else
				fallback()
				-- 	end
			end, {
				"i",
				"s",
			}),
			-- ["<S-Tab>"] = cmp.mapping(function(fallback)
			-- 	if luasnip.jumpable(-1) then
			-- 		luasnip.jump(-1)
			-- 	else
			-- 		fallback()
			-- 	end
			-- end, {
			-- 		"i",
			-- 		"s",
			-- 	}),
		},
	})
end

function M.add_cmp_source(source)
	local cmp_ok, cmp = pcall(require, "cmp")
	if cmp_ok then
		local config = cmp.get_config()
		table.insert(config.sources, { name = source })
		cmp.setup(config)
	end
end

return M
