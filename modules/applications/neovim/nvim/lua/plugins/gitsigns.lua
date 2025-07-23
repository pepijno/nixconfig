return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
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
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				-- map("n", "]c", function()
				-- 	if vim.wo.diff then
				-- 		return "]c"
				-- 	end
				-- 	vim.schedule(function()
				-- 		gs.next_hunk()
				-- 	end)
				-- 	return "<Ignore>"
				-- end, { expr = true })
				--
				-- map("n", "[c", function()
				-- 	if vim.wo.diff then
				-- 		return "[c"
				-- 	end
				-- 	vim.schedule(function()
				-- 		gs.prev_hunk()
				-- 	end)
				-- 	return "<Ignore>"
				-- end, { expr = true })

				-- Actions
				map("n", "<leader>gs", gs.stage_hunk, { desc = "[s]tage hunk" })
				map("n", "<leader>gr", gs.reset_hunk, { desc = "[r]eset hunk" })
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "[s]tage hunk" })
				map("v", "<leader>gr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "[r]eset hunk" })
				map("n", "<leader>gS", gs.stage_buffer, { desc = "[S]tage buffer" })
				map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "[u]ndo stage hunk" })
				map("n", "<leader>gR", gs.reset_buffer, { desc = "[R]eset buffer" })
				map("n", "<leader>gp", gs.preview_hunk, { desc = "[p]review hunk" })
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, { desc = "[b]lame" })
				map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "[t]oggle line [b]lame" })
				map("n", "<leader>gd", gs.diffthis, { desc = "[d]iff" })
				map("n", "<leader>gD", function()
					gs.diffthis("~")
				end)
				map("n", "<leader>gtd", gs.toggle_deleted)

				-- Text object
				map({ "o", "x" }, "gh", ":<C-U>Gitsigns select_hunk<Return>")
			end,
		})
	end,
}
