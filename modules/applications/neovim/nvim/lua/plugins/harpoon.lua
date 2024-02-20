return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local action_state = require("telescope.actions.state")
		local action_utils = require("telescope.actions.utils")
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup()
		-- REQUIRED

		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():append()
		end, { desc = "Harpoon [a]dd" })

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-T>", function()
			harpoon:list():prev()
		end, { desc = "Harpoon prev" })
		vim.keymap.set("n", "<C-G>", function()
			harpoon:list():next()
		end, { desc = "Harpoon next" })

		local delete_mark_selections = function(prompt_bufnr)
			local selections = {}
			action_utils.map_selections(prompt_bufnr, function(entry)
				table.insert(selections, entry)
			end)
			table.sort(selections, function(a, b)
				return a.index < b.index
			end)

			local count = 0

			if #selections > 0 then
				-- delete marks from multi-selection
				for i = #selections, 1, -1 do
					local selection = selections[i]
					harpoon:list():removeAt(selection.index)
					count = count + 1
				end
			else
				-- delete marks from single-selection
				local selection = action_state.get_selected_entry()
				if selection ~= nil then
					harpoon:list():removeAt(selection.index)
					count = count + 1
				else
					return 0
				end
			end

			-- delete picker-selections
			local current_picker = action_state.get_current_picker(prompt_bufnr)
			current_picker:delete_selection(function() end)

			return count
		end

		local delete_mark_selections_prompt = function(prompt_bufnr)
			vim.ui.input({
				prompt = "Delete selected marks? [Yes/no]: ",
				default = "y",
			}, function(input)
				if input == nil then
					return
				end
				local input_str = string.lower(input)
				if input_str == "y" or input_str == "yes" then
					local deletion_count = delete_mark_selections(prompt_bufnr)
					if deletion_count == 0 then
						print("No marks deleted")
					elseif deletion_count == 1 then
						print("Deleted 1 mark")
					else
						print("Deleted " .. deletion_count .. " marks")
					end
				else
					print("No action taken")
				end
			end)
		end

		-- basic telescope configuration
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = false,
					sorter = conf.generic_sorter({}),
					attach_mappings = function(_, map)
						map("n", "<c-d>", delete_mark_selections_prompt)
						map("i", "<c-d>", delete_mark_selections_prompt)
						return true
					end,
				})
				:find()
		end

		vim.keymap.set("n", "<C-e>", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Open harpoon window" })
	end,
}
