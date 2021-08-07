" Toggle undo tree
nnoremap <leader>ut :UndotreeToggle<CR>

lua << EOF
local actions = require('telescope.actions');
require('telescope').setup{
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			},
		prompt_prefix = "❯ ",
		selection_caret = "❯ ",
		sorting_strategy = "descending",
		color_devicons = true,
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		layout_strategy = "flex",
		layout_config = {
			horizontal = {
				mirror = false,
				},
			vertical = {
				mirror = false,
				},
			},
		mappings = {
			n = {
				["<C-c>"] = actions.close
				}
			},
		file_sorter =  require'telescope.sorters'.get_fuzzy_file,
		file_ignore_patterns = {},
		generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
		winblend = 0,
		border = {},
		borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
		use_less = true,
		path_display = {},
		set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
		file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
		grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
		qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

		-- Developer configurations: Not meant for general override
		buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
	}
}
EOF

nnoremap <silent> <leader>ff <cmd>lua require('telescope.builtin').find_files({["layout_config.preview_width"] = 0.2})<CR>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').file_browser()<cr>
nnoremap <leader>ft <cmd>lua require('telescope.builtin').treesitter()<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').tags()<cr>
