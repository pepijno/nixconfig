return {
	"L3MON4D3/LuaSnip",
	version = "2.*",
	build = (function()
		-- Build Step is needed for regex support in snippets.
		-- This step is not supported in many windows environments.
		-- Remove the below condition to re-enable on windows.
		if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
			return
		end
		return "make install_jsregexp"
	end)(),
	config = function()
		local ls = require("luasnip")
		local types = require("luasnip.util.types")
		ls.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			override_builtin = true,
			exp_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { "<-", "Error" } },
					},
				},
			},
		})

		for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/custom/snippets/*.lua", true)) do
			loadfile(ft_path)()
			vim.print("loaded snips " .. ft_path)
		end

		local keymap = vim.keymap.set

		keymap({ "i", "s" }, "<C-j>", function()
			vim.print(ls.expand_or_jumpable())
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			end
		end, { desc = "Expand snippet or jump to next part" })
		keymap({ "i", "s" }, "<C-k>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end, { silent = true, desc = "Snippet jump to previous part" })
		keymap({ "i", "s" }, "<C-l>", function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end, { silent = true, desc = "Snippet change choice" })
	end,
}
