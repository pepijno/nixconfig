return {
	"hrsh7th/nvim-cmp",
	version = false, -- last release is way too old
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"onsails/lspkind.nvim",
	},
	config = function ()
		local cmp = require('cmp')
		local lspkind = require('lspkind')

		lspkind.init({
			mode = 'text',
		})

		cmp.setup({
			formatting = {
				preselect = cmp.PreselectMode.None,
				fields = { "kind", "abbr", "menu" },
				-- format = lspkind.cmp_format({
				-- 	with_text = true,
				-- 	menu = {
				-- 		buffer = "[buf]",
				-- 		nvim_lsp = "[LSP]",
				-- 		nvim_lua = "[api]",
				-- 		path = "[path]",
				-- 		luasnip = "[snip]",
				-- 	},
				-- }),
				-- format = function (entry, vim_item)
				-- 	local kind = lspkind.cmp_format({mode = "symbol_text", maxwidth = 50})(entry, vim_item)
				-- 	local strings = vim.split(kind.kind, "%s", {trimempty = true})
				-- 	kind.kind = " " .. (strings[1] or "") .. " "
				-- 	kind.menu = "    (" .. (strings[2] or "") .. ")"
				-- 	return kind
				-- end
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
				-- documentation = cmp.config.window.bordered(),
				-- completion = cmp.config.window.bordered(),
			},
			mapping = {
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
			},
			sources = {
				{ name = 'nvim_lsp_signature_help' },
				{ name = 'nvim_lsp' },
				{ name = 'nvim_lua' },
				{ name = 'path' },
				{ name = 'buffer' },
			},
		})
	end,
}
