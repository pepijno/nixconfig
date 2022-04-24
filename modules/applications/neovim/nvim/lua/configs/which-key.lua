local M = {}

function M.config()
	local status_ok, which_key = pcall(require, "which-key")
	if not status_ok then
		return
	end

	local setup = {
		plugins = {
			marks = true, -- shows a list of your marks on ' and `
			registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
			-- the presets plugin, adds help for a bunch of default keybindings in Neovim
			-- No actual key bindings are created
			presets = {
				operators = false, -- adds help for operators like d, y, ...
				motions = false, -- adds help for motions
				text_objects = false, -- help for text objects triggered after entering an operator
				windows = true, -- default bindings on <c-w>
				nav = true, -- misc bindings to work with windows
				z = true, -- bindings for folds, spelling and others prefixed with z
				g = true, -- bindings for prefixed with g
			},
			spelling = { enabled = true, suggestions = 20 }, -- use which-key for spelling hints
		},
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "➜", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
		window = {
			border = "single", -- none, single, double, shadow
			position = "bottom", -- bottom, top
			margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
			padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		},
		layout = {
			height = { min = 4, max = 25 }, -- min and max height of the columns
			width = { min = 20, max = 50 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
		},
		hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
		show_help = true, -- show help message on the command line when the popup is visible
	}

	local opts = {
		mode = "n", -- NORMAL mode
		prefix = "<leader>",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = true, -- use `nowait` when creating keymaps
	}
	local vopts = {
		mode = "v", -- VISUAL mode
		prefix = "<leader>",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = true, -- use `nowait` when creating keymaps
	}
	-- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
	-- see https://neovim.io/doc/user/map.html#:map-cmd
	local vmappings = {}

	local mappings = {
		["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
		["r"] = { "<cmd>source $MYVIMRC<CR>", "Reload nvim config" },
		p = {
			name = "Packer",
			c = { "<cmd>PackerCompile<cr>", "Compile" },
			i = { "<cmd>PackerInstall<cr>", "Install" },
			s = { "<cmd>PackerSync<cr>", "Sync" },
			S = { "<cmd>PackerStatus<cr>", "Status" },
			u = { "<cmd>PackerUpdate<cr>", "Update" },
		},
		["e"] = { "<cmd>NvimTreeToggle<CR>", "Toggle Nvim tree" },
		["o"] = { "<cmd>NvimTreeFocus<CR>", "Focus to Nvim tree" },
		l = {
			name = "LSP",
			d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
			s = { "<cmd>Telescope lsp_document_symbols bufnr=0 theme=get_ivy<cr>", "Document Symbols" },
			S = { "<cmd>Telescope lsp_dynamic_workspace_symbols bufnr=0 theme=get_ivy<cr>", "Workspace Symbols" },
			a = { "<cmd>Telescope lsp_code_actions bufnr=0 theme=get_ivy<cr>", "Workspace Symbols" },
			f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
			r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
			h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
			j = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
			k = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
			i = { "<cmd>LspInfo<cr>", "Info" },
			I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
			g = {
				name = "Goto",
				d = { "<cmd>Telescope lsp_definitions bufnr=0 theme=get_ivy<cr>", "Definition" },
				r = { "<cmd>Telescope lsp_references bufnr=0 theme=get_ivy<cr>", "References" },
				i = { "<cmd>Telescope lsp_implementations bufnr=0 theme=get_ivy<cr>", "Implementations" },
			},
		},
		f = {
			name = "Telescope",
			r = { "<cmd>Telescope live_grep bufnr=0 theme=get_ivy<CR>", "Grep" },
			f = { "<cmd>Telescope find_files bufnr=0 theme=get_ivy<CR>", "Find files" },
			b = { "<cmd>Telescope buffers bufnr=0 theme=get_ivy<CR>", "Buffers" },
			h = { "<cmd>Telescope help_tags bufnr=0 theme=get_ivy<CR>", "Help tags" },
			c = { "<cmd>Telescope commands bufnr=0 theme=get_ivy<CR>", "All commands" },
			k = { "<cmd>Telescope keymaps bufnr=0 theme=get_ivy<CR>", "Keymaps" },
			g = {
				name = "Git",
				s = { "<cmd>Telescope git_status bufnr=0 theme=get_ivy<CR>", "Status" },
				b = { "<cmd>Telescope git_branches bufnr=0 theme=get_ivy<CR>", "Branches" },
				c = { "<cmd>Telescope git_commits bufnr=0 theme=get_ivy<CR>", "Commits" },
			},
		},
		T = {
			name = "Treesitter",
			i = { ":TSConfigInfo<cr>", "Info" },
		},
		s = {
			name = "snippits",
			r = { "<cmd>source ~/.config/nvim/lua/configs/snips/snips.lua<CR>", "Reload snippits" },
		},
	}

	which_key.setup(setup)

	which_key.register(mappings, opts)
	which_key.register(vmappings, vopts)
end

return M
