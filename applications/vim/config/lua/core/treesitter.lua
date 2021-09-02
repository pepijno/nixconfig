local M = {}

M.config = function()
	conf.treesitter = {
		---		ensure_installed = { "nix", "lua", "c", "cpp", "bash", "fish", "java", "kotlin", "zig" },
		ensure_installed = "maintained",
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = true
		},
		indent = {
			enable = true,
		},
		playground = {
			enable = true,
			disable = {},
			updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
			persist_queries = false, -- Whether the query persists across vim sessions
			keybindings = {
				toggle_query_editor = "o",
				toggle_hl_groups = "i",
				toggle_injected_languages = "t",
				toggle_anonymous_nodes = "a",
				toggle_language_display = "I",
				focus_language = "f",
				unfocus_language = "F",
				update = "R",
				goto_node = "<cr>",
				show_help = "?",
			},
		},
	}
end

M.setup = function()
	local treesitter_configs = require("nvim-treesitter.configs")
	treesitter_configs.setup(conf.treesitter)
end

return M
