local M = {}

function M.config()
	local status_ok, telescope = pcall(require, 'telescope')
	if not status_ok then
		print 'error requiring telescope'
		return
	end

	local ok, actions = pcall(require, 'telescope.actions')
	if not ok then
		print 'error requiring telescope actions'
		return
	end

	telescope.setup({
		defaults = {
			prompt_prefix = " ",
			selection_caret = "❯ ",
			sorting_strategy = "ascending",
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					prompt_position = "top",
				},
			},
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
					['<C-n>'] = actions.move_selection_next,
					['<C-p>'] = actions.move_selection_previous,
					['kj'] = actions.close,
				},
				n = {
					['<C-n>'] = actions.move_selection_next,
					['<C-p>'] = actions.move_selection_previous,
					['kj'] = actions.close,
				},
			},
		},
	})

	vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
	vim.keymap.set('n', '<leader>fr', require('telescope.builtin').live_grep, { desc = '[F]ind [R]ipgrep' })
end

return M
