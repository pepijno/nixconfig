return {
	{ "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			-- "nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/playground",
		},
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdateSync" },
		opts = {
			ensure_installed = { "c", "lua", "vim" },
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
					init_selection = "<C-h>",
					node_incremental = "<C-h>",
					node_decremental = "<C-l>",
				},
			},
			indent = {
				enable = true,
			},
			-- textobjects = {
			--      select = {
			--              enable = true,
			--              lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			--              keymaps = {
			--                      -- You can use the capture groups defined in textobjects.scm
			--                      ["aa"] = "@parameter.outer",
			--                      ["ia"] = "@parameter.inner",
			--                      ["af"] = "@function.outer",
			--                      ["if"] = "@function.inner",
			--                      ["ac"] = "@class.outer",
			--                      ["ic"] = "@class.inner",
			--              },
			--      },
			--      move = {
			--              enable = true,
			--              set_jumps = true, -- whether to set jumps in the jumplist
			--              goto_next_start = {
			--                      ["]m"] = "@function.outer",
			--                      ["]]"] = "@class.outer",
			--              },
			--              goto_next_end = {
			--                      ["]M"] = "@function.outer",
			--                      ["]["] = "@class.outer",
			--              },
			--              goto_previous_start = {
			--                      ["[m"] = "@function.outer",
			--                      ["[["] = "@class.outer",
			--              },
			--              goto_previous_end = {
			--                      ["[M"] = "@function.outer",
			--                      ["[]"] = "@class.outer",
			--              },
			--      },
			--      swap = {
			--              enable = true,
			--              swap_next = {
			--                      ["<leader>a"] = "@parameter.inner",
			--              },
			--              swap_previous = {
			--                      ["<leader>A"] = "@parameter.inner",
			--              },
			--      },
			-- },
		},
		config = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				---@type table<string, boolean>
				local added = {}
				opts.ensure_installed = vim.tbl_filter(function(lang)
					if added[lang] then
						return false
					end
					added[lang] = true
					return true
				end, opts.ensure_installed)
			end
			require("nvim-treesitter.configs").setup(opts)

			-- if load_textobjects then
			-- 	-- PERF: no need to load the plugin, if we only need its queries for mini.ai
			-- 	if opts.textobjects then
			-- 		for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
			-- 			if opts.textobjects[mod] and opts.textobjects[mod].enable then
			-- 				local Loader = require("lazy.core.loader")
			-- 				Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
			-- 				local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
			-- 				require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
			-- 				break
			-- 			end
			-- 		end
			-- 	end
			-- end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-refactor",
		config = function()
			require("nvim-treesitter.configs").setup({
				refactor = {
					highlight_definitions = {
						enable = true,
						-- Set to false if you have an `updatetime` of ~100.
						clear_on_cursor_move = true,
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 20, -- Maximum number of lines to show for a single context
				trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- Separator between context and content. Should be a single character string, like '-'.
				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
				separator = nil,
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			})
		end,
	},
}
