local root_patterns = { ".git", "lua" }

function get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

function telescope(builtin, opts)
  -- local params = { builtin = builtin, opts = opts }
  return function()
  --   builtin = params.builtin
  --   opts = params.opts
  --   opts = vim.tbl_deep_extend("force", { cwd = get_root() }, opts or {})
  --   if builtin == "files" then
  --     if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
  --       opts.show_untracked = true
  --       builtin = "git_files"
  --     else
  --       builtin = "find_files"
  --     end
  --   end
  --   if opts.cwd and opts.cwd ~= vim.loop.cwd() then
  --     opts.attach_mappings = function(_, map)
  --       map("i", "<a-c>", function()
  --         local action_state = require("telescope.actions.state")
  --         local line = action_state.get_current_line()
  --         telescope(
  --           params.builtin,
  --           vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line })
  --         )()
  --       end)
  --       return true
  --     end
  --   end

    require("telescope.builtin")[builtin](opts)
  end
end

return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = { 'nvim-lua/plenary.nvim' },
	cmd = 'Telescope',
	keys = {
		-- find
		{ "<leader>ff", telescope('find_files'), desc = "[F]iles" },
		{ "<leader>fr", telescope('live_grep'), desc = "[R]ipgrep" },
		-- lsp
		{ "<leader>ld", '<cmd>Telescope diagnostics<cr>', desc = 'Buffer [D]iagnostics' },
		{ "<leader>ls", '<cmd>Telescope lsp_document_symbols<cr>', desc = 'LSP Document [S]ymbols' },
		{ "<leader>la", '<cmd>Telescope lsp_code_actions<cr>', desc = 'LSP Code [A]ctions' },
		-- git
		-- { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
		-- { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
		-- search
		-- { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
		-- { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
		-- { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
		-- { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		-- { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
		-- { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
		-- { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
		-- { "<leader>sg", telescope("live_grep"), desc = "Grep (root dir)" },
		-- { "<leader>sG", telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
		-- { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
		-- { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
		-- { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
		-- { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
		-- { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
		-- { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
		-- { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
		-- { "<leader>sw", telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
		-- { "<leader>sW", telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
		-- { "<leader>sw", telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
		-- { "<leader>sW", telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
		-- { "<leader>uC", telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
		-- {
		-- 	"<leader>ss",
		-- 	telescope("lsp_document_symbols", {
		-- 		symbols = {
		-- 			"Class",
		-- 			"Function",
		-- 			"Method",
		-- 			"Constructor",
		-- 			"Interface",
		-- 			"Module",
		-- 			"Struct",
		-- 			"Trait",
		-- 			"Field",
		-- 			"Property",
		-- 		},
		-- 	}),
		-- 	desc = "Goto Symbol",
		-- },
		-- {
		-- 	"<leader>sS",
		-- 	telescope("lsp_dynamic_workspace_symbols", {
		-- 		symbols = {
		-- 			"Class",
		-- 			"Function",
		-- 			"Method",
		-- 			"Constructor",
		-- 			"Interface",
		-- 			"Module",
		-- 			"Struct",
		-- 			"Trait",
		-- 			"Field",
		-- 			"Property",
		-- 		},
		-- 	}),
		-- 	desc = "Goto Symbol (Workspace)",
		-- },
	},
	config = function ()
		require('telescope').setup({
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
			},
		})
	end
}
