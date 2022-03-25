local M = {}

function M.config()
	local status_ok, telescope = pcall(require, "telescope")
	if not status_ok then
		return
	end

	local ok, actions = pcall(require, "telescope.actions")
	if not ok then
		return
	end

	telescope.setup({
		defaults = {
			prompt_prefix = " ",
			selection_caret = "❯ ",
			initial_mode = "insert",
			path_display = { "truncate" },
			selection_strategy = "reset",
			sorting_strategy = "ascending",
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					prompt_position = "top",
					results_width = 0.8,
					preview_width = function(_, cols, _)
						if cols < 120 then
							return math.floor(cols * 0.5)
						end
						return math.floor(cols * 0.6)
					end,
					mirror = false,
				},
				vertical = {
					mirror = false,
				},
				width = 0.87,
				height = 0.80,
				preview_cutoff = 120,
			},
			file_ignore_patterns = {},
			path_display = { shorten = 5 },
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
			mappings = {
				i = {
					["<C-n>"] = actions.move_selection_next,
					["<C-p>"] = actions.move_selection_previous,
					["<C-c>"] = actions.close,
					["<C-j>"] = actions.cycle_history_next,
					["<C-k>"] = actions.cycle_history_prev,
					["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					["<CR>"] = actions.select_default + actions.center,
				},
				n = {
					["<C-n>"] = actions.move_selection_next,
					["<C-p>"] = actions.move_selection_previous,
					["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				},
			},
		},
	})
end

return M
