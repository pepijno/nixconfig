vim.opt.packpath:append(vim.fn.stdpath("data") .. "/site")

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.lsp")

local keymap = vim.keymap.set
keymap("n", "<leader>x", ":source ~/.config/nvim/init.lua<Return>", { desc = "Soure init.lua" })

local github = function(name)
	return "https://github.com/" .. name
end

vim.pack.add({
	github("folke/which-key.nvim"),
	github("tpope/vim-sleuth"),
	github("j-hui/fidget.nvim"),
	github("catppuccin/nvim"),
	github("stevearc/oil.nvim"),
	github("lewis6991/gitsigns.nvim"),
	{ src = github("saghen/blink.cmp"), version = vim.version.range("1.*") },
	github("ibhagwan/fzf-lua"),
	github("echasnovski/mini.icons"),
	github("nvim-treesitter/nvim-treesitter"),
	github("nvim-treesitter/nvim-treesitter-textobjects"),
	github("nvim-treesitter/playground"),
	github("stevearc/conform.nvim"),
	github("neovim/nvim-lspconfig"),
	github("windwp/nvim-autopairs"),
	github("nvim-treesitter/nvim-treesitter-context"),
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
	"toml",
	"sql",
	"cpp",
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
	toml = { "tombi" },
	xml = { "xmllint" },
}

local formatters = {
	prettier = {
		printWidth = 100,
		useTabs = false,
		semi = true,
		singleQuote = true,
		trailingComma = "all",
		arrowParens = "always",
		htmlWhitespaceSensitivity = "strict",
		bracketSpacing = true,
	},
}

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})
vim.lsp.config("clangd", {
	capabilities = {
		textDocument = {
			completion = {
				completionItem = {
					snippetSupport = false,
				},
			},
		},
	},
})
vim.lsp.enable({
	"lua_ls",
	"asm_lsp",
	"nixd",
	"zls",
	"hls",
	"clangd",
	"bashls",
	"cssls",
	"html",
	"ts_ls",
	"jsonls",
	"fish_lsp",
	"angularls",
	"tombi",
	"lemminx",
	"jdtls",
})

-- catppuccin
------------------------------------------------------------------------------------------------------------------------
require("catppuccin").setup({
	flavour = "latte",
	transparent_background = true,
})
vim.cmd.colorscheme("catppuccin-latte")

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

-- fidget
------------------------------------------------------------------------------------------------------------------------
require("fidget").setup({
	notification = {
		window = {
			winblend = 100,
		},
	},
})

-- Oil.nvim
------------------------------------------------------------------------------------------------------------------------
require("oil").setup()

keymap("n", "-", "<cmd>Oil<Return>", { desc = "Open Oil" })

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

-- blink.cmp
------------------------------------------------------------------------------------------------------------------------
local cmp = require("blink.cmp")
cmp.setup({
	keymap = {
		preset = "none",
		["<C-n>"] = { "select_next", "fallback_to_mappings" },
		["<C-p>"] = { "select_prev", "fallback_to_mappings" },
		["<C-y>"] = { "select_and_accept", "fallback_to_mappings" },
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
		default = { "lsp", "path", "buffer" },
		providers = {
			lsp = {
				fallbacks = { "buffer" },
			},
		},
	},
	fuzzy = { implementation = "lua" },
	signature = { enabled = true },
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
		fullscreen = false,
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
keymap("n", "<leader>fc", fzf_lua("resume"), { desc = "[C]ontinue" })

-- treesitter
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
	formatters = formatters,
})

-- nvim-autopairs
------------------------------------------------------------------------------------------------------------------------
require("nvim-autopairs").setup({})

require("core.statusline").setup()
require("core.indentscope").setup()

local function switch_case()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	local word = vim.fn.expand("<cword>")
	local word_start = vim.fn.matchstrpos(vim.fn.getline("."), "\\k*\\%" .. (col + 1) .. "c\\k*")[2]

	-- Detect camelCase
	if word:find("[a-z][A-Z]") then
		-- Convert camelCase to snake_case
		local snake_case_word = word:gsub("([a-z])([A-Z])", "%1_%2"):lower()
		vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { snake_case_word })
	-- Detect snake_case
	elseif word:find("_[a-z]") then
		-- Convert snake_case to camelCase
		local camel_case_word = word:gsub("(_)([a-z])", function(_, l)
			return l:upper()
		end)
		vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { camel_case_word })
	else
		print("Not a snake_case or camelCase word")
	end
end

keymap("n", "<leader>ss", switch_case, { desc = "Switch case" })
