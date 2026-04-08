-- Number of spaces shown per <tab>
vim.opt.tabstop = 4
-- Number of spaces applied when pressing <tab>
vim.opt.softtabstop = 4
-- Amount to indent with << and >>
vim.opt.shiftwidth = 4
-- Convert tabs to spaces
vim.opt.expandtab = true

-- <Backspace> will delete a 'shiftwidth' worth of space at the start of the line
vim.opt.smarttab = true
-- Smart auto indenting on new line
vim.opt.smartindent = true
-- Copy indent from current line on new line
vim.opt.autoindent = true

-- Show line numbers
vim.opt.number = true
-- Show relative line numbers
vim.opt.relativenumber = true

-- Highlight the text line of the cursor
vim.opt.cursorline = true

-- Store undo between sessions
vim.opt.undofile = true
-- Disable use of swap files
vim.opt.swapfile = false
-- Disabled the use of backup files
vim.opt.backup = false

-- Disable showing modes in status line as we have custom status line
vim.opt.showmode = false

-- Highlight all the matches of search pattern
vim.opt.hlsearch = true
-- Set incremental search
vim.opt.incsearch = true
-- Case insensitive searching
vim.opt.ignorecase = true
-- Case sensitivie searching when upper case characters are in search
vim.opt.smartcase = true

-- Always show the sign column
vim.opt.signcolumn = "yes"

-- Length of time to wait before triggering the plugin
vim.opt.updatetime = 300

-- Splitting a new window below the current one
vim.opt.splitbelow = true
-- Splitting a new window at the right of the current one
vim.opt.splitright = true

-- Number of lines to keep above and below the cursor
vim.opt.scrolloff = 999

-- Number of columns to keep at the sides of the cursor
vim.opt.sidescrolloff = 8

-- Disable mouse support
vim.opt.mouse = "n"

-- Do not abandon unloaded buffers
vim.opt.hidden = true

-- Disable line wrapping
vim.opt.wrap = false

-- Maximum number of items in popup window
vim.opt.pumheight = 10

-- Length of time to wait for a mapped sequence
vim.opt.timeoutlen = 300

-- Enable showing special characters
vim.opt.list = true
-- Show line breaks
vim.opt.showbreak = "↪\\"
-- Set display of whitespace characters
vim.opt.listchars = { nbsp = "␣", space = "⋅", tab = "> ", trail = "-" }

-- Use c file type for .h files
vim.g.c_syntax_for_h = true

-- Set the border of all windows
vim.opt.winborder = "single"

-- Enable system clipboard access
-- vim.opt.clipboard = "unnamedplus"

-- Have global status line, even for splits
vim.opt.laststatus = 3

-- Set two lines for cmd
vim.opt.cmdheight = 2

-- Disable native vim plugins
vim.g.loaded_2html_plugin = false
vim.g.loaded_getscript = false
vim.g.loaded_getscriptPlugin = false
vim.g.loaded_gzip = false
vim.g.loaded_logipat = false
vim.g.loaded_remote_plugins = false
vim.g.loaded_tar = false
vim.g.loaded_tarPlugin = false
vim.g.loaded_zip = false
vim.g.loaded_zipPlugin = false
vim.g.loaded_vimball = false
vim.g.loaded_vimballPlugin = false
vim.g.zipPlugin = false

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 3000 })
	end,
})

vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
	command = "tabdo wincmd =",
})
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufRead", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("LuaHighlight", { clear = true }),
	command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})
vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup("tree_sitter_start", { clear = true }),
	callback = function (args)
		local bufnr = args.buf
		local parser = vim.treesitter.get_parser(bufnr)
		if parser then
			vim.treesitter.start()
		end
	end
})

require("statusline")

vim.pack.add({
	"https://github.com/tpope/vim-sleuth",
	"https://github.com/catppuccin/nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/echasnovski/mini.icons",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/lewis6991/gitsigns.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
})

vim.keymap.set({}, "<Space>", "<Nop>")
vim.g.mapleader = vim.keycode("<Space>")
vim.g.maplocalleader = vim.keycode("<Space>")

for _, key in pairs({ ",", ".", "`", ";", "!", "?", "{", "}", "(", ")", "[", "]" }) do
	vim.keymap.set("i", key, key .. "<C-g>u", { noremap = true })
end

vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })
vim.keymap.set("n", "<", "<<_", { noremap = true })
vim.keymap.set("n", ">", ">>_", { noremap = true })

vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })

for _, key in pairs({ "<C-u>", "<C-d>", "<C-y>", "<C-e>" }) do
	vim.keymap.set("n", key, key .. "zz", { noremap = true })
end

local formatters_by_ft = {
	asm = { "asmfmt" },
	lua = { "stylua" },
	nix = { "nixfmt" },
	zig = { "zigfmt" },
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

require("conform").setup({
	formatters_by_ft = formatters_by_ft,
	formatters = formatters,
})
vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ lsp_fallback = true })
end, {})

vim.lsp.config["lua_ls"] = {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
}

vim.lsp.config["clangd"] = {
	capabilities = {
		textDocument = {
			completion = {
				completionItem = {
					snippetSupport = false,
				},
			},
		},
	},
}

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
	-- "jdtls",
	"fennel_ls",
})

require("catppuccin").setup({
	flavour = "latte",
	transparent_background = true,
})
vim.cmd.colorscheme("catppuccin-latte")

require("oil").setup()
vim.keymap.set("n", "-", "<cmd>Oil<Return>", { desc = "Open Oil" })

local fzf_lua = function(builtin, opts)
	return function()
		return require("fzf-lua")[builtin](opts)
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
		fzf = {
			["ctrl-q"] = "select-all+accept",
		},
	},
	files = {
		file_icons = "mini",
	},
	grep = {
		file_icons = "mini",
	},
})

vim.keymap.set("n", "<leader>ff", fzf_lua("files"), { desc = "[F]iles" })
vim.keymap.set("n", "<leader>fr", fzf_lua("live_grep_native"), { desc = "[R]ipgrep" })
vim.keymap.set("v", "<leader>fR", fzf_lua("grep_visual"), { desc = "[R]ipgrep visual" })
vim.keymap.set("n", "<leader>fR", fzf_lua("grep_cword"), { desc = "[R]ipgrep word" })
vim.keymap.set("n", "<leader>fk", fzf_lua("keymaps"), { desc = "[K]eymaps" })
vim.keymap.set("n", "<leader>fc", fzf_lua("resume"), { desc = "[C]ontinue" })

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

vim.keymap.set("n", "<leader>?", function()
	wk.show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

local cmp = require("blink.cmp")
cmp.setup({
	keymap = {
		preset = "none",
		["<C-n>"] = { "select_next", "fallback_to_mappings" },
		["<C-p>"] = { "select_prev", "fallback_to_mappings" },
		["<C-y>"] = { "select_and_accept", "fallback_to_mappings" },
	},
	appearance = { nerd_font_variant = "mono" },
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
		list = { selection = { auto_insert = false, preselect = false } },
	},
	sources = { default = { "lsp", "path", "buffer" }, providers = { lsp = { fallbacks = { "buffer" } } } },
	fuzzy = { implementation = "lua" },
	signature = { enabled = true },
})

local config = {
	fzf = {
		code_actions = {
			winopts = {
				preview = {
					hidden = true,
				},
				fullscreen = false,
			},
		},
	},
	diagnostic = {
		severity_sort = true,
		float = {
			border = "rounded",
			source = "if_many",
		},
		virtual_text = {
			source = "if_many",
			spacing = 2,
		},

		signs = {
			error = "󰅚 ",
			warn = "󰀪 ",
			info = "󰋽 ",
			hint = "󰌶 ",
		},
	},
}

local function create_fzf_handler(builtin, opts)
	return function()
		return require("fzf-lua")[builtin](opts or {})
	end
end

local function create_diagnostic_jump(direction, severity)
	local count
	if direction == "next" then
		count = 1
	else
		count = -1
	end
	local opts = { count = count, float = true }
	if severity then
		opts["severity"] = severity
	end
	return function()
		return vim.diagnostic.jump(opts)
	end
end

local function setup_document_highlight(client, bufnr)
	if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
		local highlight_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
		local detach_group = vim.api.nvim_create_augroup("lsp-detach", { clear = true })

		vim.api.nvim_create_autocmd(
			{ "CursorHold", "CursorHoldI" },
			{ buffer = bufnr, group = highlight_group, callback = vim.lsp.buf.document_highlight }
		)
		vim.api.nvim_create_autocmd(
			{ "CursorMoved", "CursorMovedI" },
			{ buffer = bufnr, group = highlight_group, callback = vim.lsp.buf.clear_references }
		)

		return vim.api.nvim_create_autocmd({ "LspDetach" }, {
			group = detach_group,
			callback = function(event)
				vim.lsp.buf.clear_references()
				return vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event.buf })
			end,
		})
	else
		return nil
	end
end

vim.api.nvim_create_autocmd({ "LspAttach" }, {
	callback = function(event)
		local lsp = vim.lsp
		local opts = { silent = true }
		local function opt(desc, _3fothers)
			return vim.tbl_extend("force", opts, { desc = desc }, (_3fothers or {}))
		end
		vim.keymap.set({ "n" }, "<leader>lgd", create_fzf_handler("lsp_definitions"), opt("[D]efinition"))
		vim.keymap.set({ "n" }, "<leader>lgi", create_fzf_handler("lsp_implementations"), opt("[I]mplementations"))
		vim.keymap.set({ "n" }, "<leader>lgr", create_fzf_handler("lsp_references"), opt("[R]eferences"))
		vim.keymap.set(
			{ "v", "n" },
			"<leader>la",
			create_fzf_handler("lsp_code_actions", { winopts = { preview = { hidden = true }, fullscreen = false } }),
			opt("Code [A]ctions")
		)
		local function _8_()
			return lsp.buf.hover()
		end
		vim.keymap.set({ "n" }, "<leader>lh", _8_, opt("[H]over"))
		local function _9_()
			return require("conform").format({ lsp_fallback = true })
		end
		vim.keymap.set({ "n" }, "<leader>lf", _9_, opt("[F]ormat"))
		local function _10_()
			return lsp.buf.signature_help()
		end
		vim.keymap.set({ "n" }, "<leader>lH", _10_, opt("Signature [H]elp"))
		local function _11_()
			return lsp.buf.signature_help()
		end
		vim.keymap.set({ "n" }, "<C-h>", _11_, opt("Signature [H]elp"))
		vim.keymap.set({ "n" }, "<leader>ldj", create_diagnostic_jump("next"), opt("Next Diagnostic"))
		vim.keymap.set({ "n" }, "<leader>ldh", create_diagnostic_jump("prev"), opt("Prev Diagnostic"))
		vim.keymap.set(
			{ "n" },
			"<leader>lej",
			create_diagnostic_jump("next", vim.diagnostic.severity.ERROR),
			opt("Next Error")
		)
		vim.keymap.set(
			{ "n" },
			"<leader>leh",
			create_diagnostic_jump("prev", vim.diagnostic.severity.ERROR),
			opt("Prev Error")
		)
		vim.keymap.set(
			{ "n" },
			"<leader>lwj",
			create_diagnostic_jump("next", vim.diagnostic.severity.WARN),
			opt("Next Warning")
		)
		vim.keymap.set(
			{ "n" },
			"<leader>lwh",
			create_diagnostic_jump("prev", vim.diagnostic.severity.WARN),
			opt("Prev Warning")
		)
		vim.keymap.set({ "n" }, "<leader>lr", function()
			return lsp.buf.rename()
		end, opt("[R]ename"))
		local client = lsp.get_client_by_id(event.data.client_id)
		setup_document_highlight(client, event.buf)
	end,
})

local signs = {}
signs[vim.diagnostic.severity.ERROR] = config.diagnostic.signs.error
signs[vim.diagnostic.severity.WARN] = config.diagnostic.signs.warn
signs[vim.diagnostic.severity.INFO] = config.diagnostic.signs.info
signs[vim.diagnostic.severity.HINT] = config.diagnostic.signs.hint
vim.diagnostic.config({
	severity_sort = config.diagnostic["severity-sort"],
	float = config.diagnostic.float,
	signs = { text = signs },
	virtual_text = vim.tbl_extend("force", config.diagnostic.virtual_text, {
		format = function(diagnostic)
			return diagnostic.message
		end,
	}),
})

require("nvim-treesitter").install({
	"markdown",
	"markdown_inline",
	"asm",
	"nix",
	"zig",
	"haskell",
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
	"fennel",
	"cpp",
})

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
