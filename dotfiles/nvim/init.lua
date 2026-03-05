vim.opt.tabstop = 4 -- Number of spaces shown per <tab>
vim.opt.softtabstop = 4 -- Number of spaces applied when pressing <tab>
vim.opt.shiftwidth = 4 -- Amount to indent with << and >>
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smarttab = true -- <Backspace> will delete a 'shiftwidth' worth of space at the start of the line
vim.opt.smartindent = true -- Smart auto indenting on new line
vim.opt.autoindent = true -- Copy indent from current line on new line

vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.cursorline = true -- Highlight the text line of the cursor
vim.opt.wrap = false -- Disable line wrapping
vim.opt.scrolloff = 999 -- Number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor

vim.opt.undofile = true -- Store undo between sessions
vim.opt.swapfile = false -- Disable use of swap files
vim.opt.backup = false -- Disabled the use of backup files

vim.opt.hlsearch = true -- Highlight all the matches of search pattern
vim.opt.incsearch = true -- Set incremental search
vim.opt.ignorecase = true -- Case insensitive searching
vim.opt.smartcase = true -- Case sensitivie searching when upper case characters are in search

vim.opt.signcolumn = "yes" -- Always show the sign column
vim.opt.cmdheight = 2 -- Set two lines for cmd
vim.opt.showmode = false -- Disable showing modes in status line as we have custom status line
vim.opt.completeopt = "menuone,noinsert,noselect" -- Completion options
vim.opt.pumheight = 10 -- Popup menu height
vim.opt.pumblend = 10 -- Popup menu transparency
vim.opt.winblend = 0 -- Floating window transparency
vim.opt.list = true -- Enable showing special characters
vim.opt.showbreak = "↪\\" -- Show line breaks
vim.opt.listchars = { nbsp = "␣", space = "⋅", tab = "> ", trail = "-" } -- Set display of whitespace characters
vim.opt.winborder = "single" -- Set the border of all windows
vim.opt.laststatus = 3 -- Have global status line, even for splits

vim.opt.updatetime = 300 -- Length of time to wait before triggering the plugin
vim.opt.timeoutlen = 300 -- Length of time to wait for a mapped sequence

vim.opt.foldmethod = "expr" -- Use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding
vim.opt.foldlevel = 99 -- Start with all folds open

vim.opt.splitbelow = true -- Splitting a new window below the current one
vim.opt.splitright = true -- Splitting a new window at the right of the current one

vim.opt.hidden = true -- Do not abandon unloaded buffers
vim.opt.errorbells = false -- No error sounds
vim.opt.backspace = "indent,eol,start" -- Better backspace behaviour
vim.opt.iskeyword:append("-") -- Inlcude '-' in words
vim.opt.path:append("**") -- Include subdirs in search
vim.opt.selection = "inclusive" -- Include last char in selection
vim.opt.mouse = "a" -- Enable mouse support

vim.g.c_syntax_for_h = true -- Use c file type for .h files

-- vim.opt.clipboard = "unnamedplus" -- Enable system clipboard access

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

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank({ timeout = 3000 })
	end,
})

vim.api.nvim_create_autocmd("VimResized", {
	group = augroup,
	command = "tabdo wincmd =",
})
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufRead", "BufNewFile" }, {
	group = augroup,
	command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function()
		if vim.o.diff then
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- { line, col }
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit", "jjdescription" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
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
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/j-hui/fidget.nvim",
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

require("catppuccin").setup({
	flavour = "latte",
	transparent_background = true,
})
vim.cmd.colorscheme("catppuccin-latte")

require("oil").setup()
vim.keymap.set("n", "-", "<cmd>Oil<Return>", { desc = "Open Oil" })

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

local fzf_lua = function(builtin, opts)
	return function()
		return require("fzf-lua")[builtin](opts)
	end
end

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

vim.lsp.config["*"] = {
	capabilities = require("blink.cmp").get_lsp_capabilities()
}

local signs = {
	error = "󰅚 ",
	warn = "󰀪 ",
	info = "󰋽 ",
	hint = "󰌶 ",
}
vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = signs.error,
			[vim.diagnostic.severity.WARN] = signs.warn,
			[vim.diagnostic.severity.INFO] = signs.info,
			[vim.diagnostic.severity.HINT] = signs.hint,
		},
	},
	virtual_text = { source = "if_many", spacing = 4 },
	float = {
		border = "rounded",
		source = "if_many",
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

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
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		local bufnr = event.buf
		local opts = { silent = true, buffer = bufnr }
		local function opt(desc, other_opts)
			return vim.tbl_extend("force", opts, { desc = desc }, (other_opts or {}))
		end
		vim.keymap.set({ "n" }, "<leader>lgd", fzf_lua("lsp_definitions"), opt("[D]efinition"))
		vim.keymap.set({ "n" }, "<leader>lgi", fzf_lua("lsp_implementations"), opt("[I]mplementations"))
		vim.keymap.set({ "n" }, "<leader>lgr", fzf_lua("lsp_references"), opt("[R]eferences"))
		vim.keymap.set(
			{ "v", "n" },
			"<leader>la",
			fzf_lua("lsp_code_actions", { winopts = { preview = { hidden = true }, fullscreen = false } }),
			opt("Code [A]ctions")
		)
		local function _8_()
			return vim.lsp.buf.hover()
		end
		vim.keymap.set({ "n" }, "<leader>lh", _8_, opt("[H]over"))
		local function _9_()
			return require("conform").format({ lsp_fallback = true })
		end
		vim.keymap.set({ "n" }, "<leader>lf", _9_, opt("[F]ormat"))
		local function _10_()
			return vim.lsp.buf.signature_help()
		end
		vim.keymap.set({ "n" }, "<leader>lH", _10_, opt("Signature [H]elp"))
		local function _11_()
			return vim.lsp.buf.signature_help()
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
			return vim.lsp.buf.rename()
		end, opt("[R]ename"))

		if client:supports_method("textDocument/codeAction", bufnr) then
			vim.keymap.set({ "n" }, "<leader>loi", function()
				vim.lsp.buf.code_action({
					context = { only = { "source.organizeImports" }, diagnostics = {} },
					apply = true,
					bufnr = bufnr,
				})
			end, opt("Organize imports"));
		end

		setup_document_highlight(client, event.buf)
	end,
})

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
})

local setup_treesitter = function()
	local treesitter = require("nvim-treesitter")
	treesitter.setup({})
	local ensure_installed = {
		"lua",
		"c",
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
		"cpp",
	}

	local config = require("nvim-treesitter.config")

	local already_installed = config.get_installed()
	local parsers_to_install = {}

	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end

	vim.api.nvim_create_autocmd("FileType", {
		group = augroup,
		callback = function(args)
			if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end

setup_treesitter()

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

require("fidget").setup({})
