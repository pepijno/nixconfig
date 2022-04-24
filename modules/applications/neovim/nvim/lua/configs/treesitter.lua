local M = {}

function M.config()
	local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
	if not status_ok then
		return
	end

	local custom_captures = {
		["function.call"] = "LuaFunctionCall",
		["function.bracket"] = "Type",
		["namespace.type"] = "TSNamespaceType",
	}

	require("nvim-treesitter.highlight").set_custom_captures(custom_captures)

	treesitter.setup({
		sync_install = false,
		ensure_installed = {
			"nix",
			"rust",
			"zig",
			"haskell",
			"lua",
			"c",
			"cpp",
			"fish",
			"make",
			"vim",
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
			custom_captures = custom_captures,
		},
		context_commentstring = {
			enable = true,
			enable_autocmd = false,
		},
		autopairs = {
			enable = true,
		},
		incremental_selection = {
			enable = true,
			keymaps ={
				node_incremental = "<C-h>",
				node_decremental = "<C-l>",
			},
		},
		indent = {
			enable = true,
		},
		rainbow = {
			enable = true,
			disable = { "html" },
			extended_mode = false,
			max_file_lines = nil,
		},
		autotag = {
			enable = true,
		},
		matchup = {
			enable = true,
		},
	})
end

function M.context_config()
	require("treesitter-context").setup({
		enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
		throttle = true, -- Throttles plugin updates (may improve performance)
		max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.

		patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
			-- For all filetypes
			default = {
				"class",
				"function",
				"method",
				"for",
				"while",
				"if",
				"switch",
				"case",
			},
		},
	})
end

return M
