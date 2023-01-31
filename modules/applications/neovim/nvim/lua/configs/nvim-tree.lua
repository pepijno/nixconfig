local M = {}

function M.config()
	local status_ok, nvimtree = pcall(require, "nvim-tree")
	if not status_ok then
		return
	end

	vim.g.nvim_tree_icons = {
		default = "",
		symlink = "",
		git = {
			deleted = "",
			ignored = "◌",
			renamed = "➜",
			staged = "✓",
			unmerged = "",
			unstaged = "✗",
			untracked = "★",
		},
		folder = {
			default = "",
			empty = "",
			empty_open = "",
			open = "",
			symlink = "",
			symlink_open = "",
		},
	}

	nvimtree.setup({
		filters = {
			dotfiles = true,
			custom = {
				".git",
			},
		},
		disable_netrw = true,
		hijack_netrw = true,
		hijack_cursor = true,
		update_cwd = true,
		update_focused_file = {
			enable = true,
			update_cwd = true,
			ignore_list = {},
		},
	})

	vim.keymap.set('n', '<leader>e', "<cmd>NvimTreeToggle<CR>", { desc = 'Toggle Nvim tree' })
	vim.keymap.set('n', '<leader>o', "<cmd>NvimTreeFocus<CR>", { desc = 'Focus to Nvim tree' })
end

return M
