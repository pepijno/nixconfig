return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdateSync" },
		opts = {
			ensure_installed = {
				-- "bash",
				-- "nix",
				-- "zig",
				-- "haskell",
				"lua",
				-- "c",
				-- "cpp",
				-- "fish",
				-- "erlang",
				-- "java",
			},
			highlight = {
				enable = true,
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			autopairs = {
				enable = true,
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
			-- 	select = {
			-- 		enable = true,
			-- 		lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			-- 		keymaps = {
			-- 			-- You can use the capture groups defined in textobjects.scm
			-- 			["aa"] = "@parameter.outer",
			-- 			["ia"] = "@parameter.inner",
			-- 			["af"] = "@function.outer",
			-- 			["if"] = "@function.inner",
			-- 			["ac"] = "@class.outer",
			-- 			["ic"] = "@class.inner",
			-- 		},
			-- 	},
			-- 	move = {
			-- 		enable = true,
			-- 		set_jumps = true, -- whether to set jumps in the jumplist
			-- 		goto_next_start = {
			-- 			["]m"] = "@function.outer",
			-- 			["]]"] = "@class.outer",
			-- 		},
			-- 		goto_next_end = {
			-- 			["]M"] = "@function.outer",
			-- 			["]["] = "@class.outer",
			-- 		},
			-- 		goto_previous_start = {
			-- 			["[m"] = "@function.outer",
			-- 			["[["] = "@class.outer",
			-- 		},
			-- 		goto_previous_end = {
			-- 			["[M"] = "@function.outer",
			-- 			["[]"] = "@class.outer",
			-- 		},
			-- 	},
			-- 	swap = {
			-- 		enable = true,
			-- 		swap_next = {
			-- 			["<leader>a"] = "@parameter.inner",
			-- 		},
			-- 		swap_previous = {
			-- 			["<leader>A"] = "@parameter.inner",
			-- 		},
			-- 	},
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

			if load_textobjects then
				-- PERF: no need to load the plugin, if we only need its queries for mini.ai
				if opts.textobjects then
					for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
						if opts.textobjects[mod] and opts.textobjects[mod].enable then
							local Loader = require("lazy.core.loader")
							Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
							local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
							require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
							break
						end
					end
				end
			end
		end,
	},
}
