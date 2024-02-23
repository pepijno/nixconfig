return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- autopairing of (){}[] etc
			-- {
			-- 	"windwp/nvim-autopairs",
			-- 	opts = {
			-- 		fast_wrap = {},
			-- 		disable_filetype = { "TelescopePrompt", "vim" },
			-- 	},
			-- 	config = function(_, opts)
			-- 		require("nvim-autopairs").setup(opts)
			--
			-- 		-- setup cmp for autopairs
			-- 		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			-- 		require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
			-- 	end,
			-- },

			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets
					-- This step is not supported in many windows environments
					-- Remove the below condition to re-enable on windows
					if vim.fn.has("win32") == 1 then
						return
					end
					return "make install_jsregexp"
				end)(),
			},

			-- cmp sources plugins
			{
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"onsails/lspkind.nvim",
				-- Adds a number of user-friendly snippets
				"rafamadriz/friendly-snippets",
			},
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local luasnip = require("luasnip")

			lspkind.init({
				mode = "text",
			})

			local icons = {
				Namespace = "󰌗",
				Text = "󰉿",
				Method = "󰆧",
				Function = "󰆧",
				Constructor = "",
				Field = "󰜢",
				Variable = "󰀫",
				Class = "󰠱",
				Interface = "",
				Module = "",
				Property = "󰜢",
				Unit = "󰑭",
				Value = "󰎠",
				Enum = "",
				Keyword = "󰌋",
				Snippet = "",
				Color = "󰏘",
				File = "󰈚",
				Reference = "󰈇",
				Folder = "󰉋",
				EnumMember = "",
				Constant = "󰏿",
				Struct = "󰙅",
				Event = "",
				Operator = "󰆕",
				TypeParameter = "󰊄",
				Table = "",
				Object = "󰅩",
				Tag = "",
				Array = "[]",
				Boolean = "",
				Number = "",
				Null = "󰟢",
				String = "󰉿",
				Calendar = "",
				Watch = "󰥔",
				Package = "",
				Copilot = "",
				Codeium = "",
				TabNine = "",
			}

			local cmp_style = {
				icons = true,
				lspkind_text = true,
				style = "atom", -- default/flat_light/flat_dark/atom/atom_colored
				border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
				selected_item_bg = "colored", -- colored / simple
			}

			local formatting_style = {
				fields = { "kind", "abbr", "menu" },

				preselect = cmp.PreselectMode.None,

				format = function(_, item)
					local icon = (cmp_style.icons and icons[item.kind]) or ""

					if cmp_style == "atom" or cmp_style == "atom_colored" then
						icon = " " .. icon .. " "
						item.menu = cmp_style.lspkind_text and "   (" .. item.kind .. ")" or ""
						item.kind = icon
					else
						icon = cmp_style.lspkind_text and (" " .. icon .. " ") or icon
						item.kind = string.format("%s %s", icon, cmp_style.lspkind_text and item.kind or "")
					end

					return item
				end,
			}

			local border = function(hl_name)
				return {
					{ "╭", hl_name },
					{ "─", hl_name },
					{ "╮", hl_name },
					{ "│", hl_name },
					{ "╯", hl_name },
					{ "─", hl_name },
					{ "╰", hl_name },
					{ "│", hl_name },
				}
			end

			local options = {
				completion = {
					keyword_length = 1,
				},

				window = {
					completion = {
						side_padding = 1,
						-- winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
						scrollbar = true,
						border = border("CmpDocBorder"),
					},
					documentation = {
						border = border("CmpDocBorder"),
						-- winhighlight = "Normal:CmpDoc",
					},
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				formatting = formatting_style,

				experimental = {
					ghost_text = true,
					native_menu = false,
				},

				mapping = {
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-y>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					}),
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				},
				sources = {
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer" },
				},
			}

			cmp.setup(options)
		end,
	},
}
