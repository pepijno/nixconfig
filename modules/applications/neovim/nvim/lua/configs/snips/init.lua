local M = {}

M.config = function()
	local status_ok, ls = pcall(require, "luasnip")
	if not status_ok then
		return
	end

	local types = require("luasnip.util.types")

	ls.config.set_config({
		history = true,
		updateevents = "TextChanged,TextChangedI",
		enable_autosnips = true,
		ext_opts = {
			[types.choiceNode] = {
				active = {
					virt_text = { { "choiceNode", "Comment" } },
				},
			},
		},
	})

	vim.keymap.set({ "i", "s" }, "<C-k>", function()
		if ls.expand_or_jumpable() then
			ls.expand_or_jump()
		end
	end, { silent = true })

	vim.keymap.set({ "i", "s" }, "<C-j>", function()
		if ls.jumpable(-1) then
			ls.jump(-1)
		end
	end, { silent = true })

	vim.keymap.set("i", "<C-l>", function()
		if ls.choice_active() then
			ls.change_choice(1)
		end
	end, { silent = true })

	require("configs.snips.snips")
end

return M
