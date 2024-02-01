local telescope = function(builtin, opts)
	return function()
		require("telescope.builtin")[builtin](opts)
	end
end

return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
	cmd = "Telescope",
	keys = {
		-- find
		{ "<leader>ff", telescope("find_files"), desc = "[F]iles" },
		{ "<leader>fr", telescope("live_grep"), desc = "[R]ipgrep" },
		-- git
		-- { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
		-- { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
		-- search
		-- { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
		-- { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
		-- { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
		-- { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		-- { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
		-- { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
		-- { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
		-- { "<leader>sg", telescope("live_grep"), desc = "Grep (root dir)" },
		-- { "<leader>sG", telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
		-- { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
		-- { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
		-- { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
		-- { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
		-- { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
		-- { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
		-- { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
		-- { "<leader>sw", telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
		-- { "<leader>sW", telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
		-- { "<leader>sw", telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
		-- { "<leader>sW", telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
		-- { "<leader>uC", telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
		{
			"<leader>ss",
			telescope("lsp_document_symbols", {
				symbols = {
					"Class",
					"Function",
					"Method",
					"Constructor",
					"Interface",
					"Module",
					"Struct",
					"Trait",
					"Field",
					"Property",
				},
			}),
			desc = "Goto Symbol",
		},
		{
			"<leader>sS",
			telescope("lsp_dynamic_workspace_symbols", {
				symbols = {
					"Class",
					"Function",
					"Method",
					"Constructor",
					"Interface",
					"Module",
					"Struct",
					"Trait",
					"Field",
					"Property",
				},
			}),
			desc = "Goto Symbol (Workspace)",
		},
	},
	config = function()
		require("telescope").setup({
			defaults = {
				prompt_prefix = "  ",
				selection_caret = " ❯ ",
				entry_prefix = "  ",
				initial_mode = "insert",
				selection_strategy = "reset",
				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
					},
					vertical = {
						mirror = false,
					},
				},
				file_sorter = require("telescope.sorters").get_fuzzy_file,
				file_ignore_patterns = { "node_modules" },
				generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
				path_display = { "truncate" },
				winblend = 0,
				border = {},
				borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				color_devicons = true,
				set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
				pickers = {
					find_files = {
						find_command = { "fd", "--type=file", "--hidden", "--smart-case" },
					},
					live_grep = {
						--@usage don't include the filename in the search results
						only_sort_text = true,
					},
				},
				file_previewer = require("telescope.previewers").vim_buffer_cat.new,
				grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
				qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--glob=!.git/",
				},
			},
		})
	end,
}
