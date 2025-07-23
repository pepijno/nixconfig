return {
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"folke/lazydev.nvim",
	},
	opts = {
		keymap = {
			preset = "none",
			["<C-n>"] = { "select_next", "fallback_to_mappings" },
			["<C-p>"] = { "select_prev", "fallback_to_mappings" },
			["<C-y>"] = {
				function(cmp)
					local luasnip = require("luasnip")
					if luasnip.expandable() then
						cmp.cancel() -- or cmp.hide()
						vim.schedule(function()
							luasnip.expand()
						end) -- wait for blink to close
						return true
					end
				end,
				"select_and_accept",
			},
			-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
			--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			menu = {
				border = "single",
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", gap = 1 },
						{ "kind", gap = 1 },
						{ "source_name" },
					},
				},
			},
			documentation = { auto_show = true, window = { border = "single" } },
			list = { selection = { preselect = false, auto_insert = false } },
		},
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
			},
		},
		snippets = { preset = "luasnip" },
		fuzzy = { implementation = "lua" },
		signature = { enabled = true },
	},
	config = function(_, opts)
		local cmp = require("blink.cmp")
		cmp.setup(opts)
		vim.lsp.config("*", {
			capabilities = cmp.get_lsp_capabilities({
				textDocument = { completion = { completionItem = { snippetSupport = false } } },
			}),
		})
	end,
}
