local M = {}

M.config = function()
	conf.telescope = {
		active = true
	}
	local status_ok, actions = pcall(require, "telescope.actions")
	if not status_ok then
		return
	end
	conf.telescope = vim.tbl_extend("force", conf.telescope, {
			defaults = {
				layout_config = {
					prompt_position = "top",
				},
				vimgrep_arguments = {
					"rg",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--fixed-strings",
				},
				prompt_prefix = "❯ ",
				selection_caret = "❯ ",
				color_devicons = true,
				selection_strategy = "reset",
				layout_strategy = "flex",
				mappings = {
--					i = {
--						["<C-i>"] = actions.create_md_link
--					},
					n = {
						["<C-c>"] = actions.close,
--						["<C-i>"] = actions.create_md_link
					}
				},
				set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
			}
		})
end

M.setup = function()
	local telescope = require "telescope"

	telescope.setup()

	local keys = {
		name = "Telescope",
		r = { "<cmd>Telescope live_grep<CR>", "Text" },
		f = { "<cmd>Telescope find_files<CR>", "Files" },
		t = { "<cmd>Telescope treesitter<CR>", "Treesitter" },
		p = { "<cmd>Telescope projects<CR>", "Projects" },
	}
	conf.which_key.mappings["f"] = keys
end

return M
