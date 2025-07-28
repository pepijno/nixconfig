require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.lsp")

vim.opt.packpath:append(vim.fn.stdpath("data") .. "/site")

local keymap = vim.keymap.set

local github = function(name)
	return "https://github.com/" .. name
end

vim.pack.add({
	github("folke/which-key.nvim"),
	github("tpope/vim-sleuth"),
	github("stevearc/oil.nvim"),
	github("j-hui/fidget.nvim"),
	github("catppuccin/nvim"),
	github("nvim-lualine/lualine.nvim"),
	github("lewis6991/gitsigns.nvim"),
	github("numToStr/Comment.nvim"),
	{ src = github("L3MON4D3/LuaSnip"), version = vim.version.range("2.*") },
	github("folke/lazydev.nvim"),
	{ src = github("saghen/blink.cmp"), version = vim.version.range("1.*") },
	github("ibhagwan/fzf-lua"),
	github("echasnovski/mini.icons"),
	github("nvim-treesitter/nvim-treesitter"),
	github("nvim-treesitter/nvim-treesitter-textobjects"),
	github("nvim-treesitter/playground"),
	github("stevearc/conform.nvim"),
	github("neovim/nvim-lspconfig"),
})

local langs_ensure_installed = {
	"asm",
	"lua",
	"nix",
	"zig",
	"haskell",
	"c",
	"bash",
	"angular",
	"typescript",
	"javascript",
	"html",
	"css",
	"json",
	"fish",
	"java",
	"kotlin",
	"xml",
}
local formatters_by_ft = {
	asm = { "asmfmt" },
	lua = { "stylua" },
	nix = { "nixfmt" },
	zig = { "zigfmt" },
	haskell = { "ormolu" },
	c = { "clang_format" },
	bash = { "beautysh" },
	sh = { "beautysh" },
	angular = { "prettier" },
	typescript = { "prettier" },
	json = { "jq" },
	fish = { "fish_indent" },
}

vim.lsp.enable("asm_lsp")
vim.lsp.enable("nixd")
vim.lsp.enable("zls")
vim.lsp.enable("hls")
vim.lsp.enable("clangd")
vim.lsp.enable("bashls")
vim.lsp.enable("cssls")
vim.lsp.enable("html")
vim.lsp.enable("ts_lua")
vim.lsp.enable("jsonls")
vim.lsp.enable("fish_lsp")
vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		})
	end,
	settings = {
		Lua = {},
	},
})
vim.lsp.enable("lua_ls")

-- catppuccin
------------------------------------------------------------------------------------------------------------------------
require("catppuccin").setup({
	flavour = "latte",
	transparent_background = true,
})
vim.cmd.colorscheme("catppuccin-latte")

-- lualine.nvim
------------------------------------------------------------------------------------------------------------------------
require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = "catppuccin-latte",
		component_separators = "|",
		section_separators = "",
	},
})

-- Which Key
------------------------------------------------------------------------------------------------------------------------
local wk = require("which-key")
wk.setup({
	win = {
		border = "single",
	},
	icon = {
		colors = true,
	},
})
wk.add({
	{ "<leader>f", group = "[F]ind" },
	{ "<leader>l", group = "[L]SP" },
	{ "<leader>lg", group = "[G]oto" },
	{ "<leader>t", group = "[T]reesitter" },
})
keymap("n", "<leader>?", function()
	wk.show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

-- Comment.nvim
------------------------------------------------------------------------------------------------------------------------
local comment = require("Comment")
local ft = require("Comment.ft")

local commentstr = "<!--%s-->"

ft.set("angular", { commentstr, commentstr })

comment.setup()

-- oil.nvim
------------------------------------------------------------------------------------------------------------------------
require("oil").setup({})

keymap("n", "-", "<cmd>Oil<Return>", { desc = "Open Oil" })

-- fidget
------------------------------------------------------------------------------------------------------------------------
require("fidget").setup({
	notification = {
		window = {
			winblend = 100,
		},
	},
})

-- gitsigns.nvim
------------------------------------------------------------------------------------------------------------------------
require("gitsigns").setup({
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	attach_to_untracked = true,
})

-- luasnip
------------------------------------------------------------------------------------------------------------------------
local ls = require("luasnip")
local types = require("luasnip.util.types")
ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	override_builtin = true,
	exp_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "<-", "Error" } },
			},
		},
	},
})

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/custom/snippets/*.lua", true)) do
	loadfile(ft_path)()
	vim.print("loaded snips " .. ft_path)
end

keymap({ "i", "s" }, "<C-k>", function()
	vim.print(ls.expand_or_jumpable())
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { desc = "Expand or jump to next item" })
keymap({ "i", "s" }, "<C-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true, desc = "Jump to previous item" })
keymap({ "i", "s" }, "<C-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true, desc = "Change choice" })

-- blink.cmp
------------------------------------------------------------------------------------------------------------------------
local cmp = require("blink.cmp")
cmp.setup({
	keymap = {
		preset = "none",
		["<C-n>"] = { "select_next", "fallback_to_mappings" },
		["<C-p>"] = { "select_prev", "fallback_to_mappings" },
		["<C-y>"] = {
			function(cmp)
				local luasnip = require("luasnip")
				if luasnip.expandable() then
					cmp.cancel()
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
})

vim.lsp.config("*", {
	capabilities = cmp.get_lsp_capabilities({
		textDocument = { completion = { completionItem = { snippetSupport = false } } },
	}),
})

-- fzf-lua
------------------------------------------------------------------------------------------------------------------------
local fzf_lua = function(builtin, opts)
	return function()
		require("fzf-lua")[builtin](opts)
	end
end

require("fzf-lua").setup({
	winopts = {
		border = "single",
		preview = {
			border = "single",
			horizontal = "right:50%",
		},
		fullscreen = true,
	},
	fzf_colors = true,
	keymap = {
		builtin = {
			["<C-d>"] = "preview-page-down",
			["<C-u>"] = "preview-page-up",
		},
	},
	files = {
		file_icons = "mini",
	},
	grep = {
		file_icons = "mini",
	},
})
keymap("n", "<leader>ff", fzf_lua("files"), { desc = "[F]iles" })
keymap("n", "<leader>fr", fzf_lua("live_grep_native"), { desc = "[R]ipgrep" })
keymap("v", "<leader>fR", fzf_lua("grep_visual"), { desc = "[R]ipgrep visual" })
keymap("n", "<leader>fR", fzf_lua("grep_cword"), { desc = "[R]ipgrep word" })
keymap("n", "<leader>fk", fzf_lua("keymaps"), { desc = "[K]eymaps" })

-- fzf-lua
------------------------------------------------------------------------------------------------------------------------
local current_installed = require("nvim-treesitter.info").installed_parsers()
local madatory_installed = { "c", "lua", "markdown", "markdown_inline", "query", "vim", "vimdoc" }

for _, parser in ipairs(madatory_installed) do
	if not vim.list_contains(langs_ensure_installed, parser) then
		vim.list_extend(langs_ensure_installed, { parser })
	end
end

local has_new_ts_parsers = false
for _, parser in ipairs(langs_ensure_installed) do
	if not vim.list_contains(current_installed, parser) then
		has_new_ts_parsers = true
		break
	end
end

local old_parsers = {}
for _, parser in ipairs(current_installed) do
	if not vim.list_contains(langs_ensure_installed, parser) then
		old_parsers[#old_parsers + 1] = parser
	end
end

require("nvim-treesitter.configs").setup({
	ensure_installed = langs_ensure_installed,
	highlight = {
		enable = true,
		use_languagetree = true,
	},
	autopairs = {
		enable = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<Enter>",
			node_incremental = "<Enter>",
			node_decremental = "<Backspace>",
		},
	},
	indent = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>ta"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>tA"] = "@parameter.inner",
			},
		},
	},
})

if has_new_ts_parsers then
	vim.cmd("TSUpdate")
end

for _, parser in ipairs(old_parsers) do
	vim.cmd("TSUninstall " .. parser)
end

-- conform
------------------------------------------------------------------------------------------------------------------------
require("conform").setup({
	formatters_by_ft = formatters_by_ft,
})
