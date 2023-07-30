return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "java" })
			end
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = { "folke/which-key.nvim", "mfussenegger/nvim-jdtls" },
		opts = {
			-- make sure mason installs the server
			servers = {
				jdtls = {
					mason = false,
					-- stylua: ignore
					keys = {
						{ "<leader>lco", function() require("jdtls").organize_imports() end, desc = "Organize Imports", },
						{ "<leader>lcR", function() require("jdtls").rename_file() end, desc = "Rename File", },
						{ "<leader>lcxv", function() require("jdtls").extract_variable() end, desc = "Extract Variable", },
						{ "<leader>lcxv", function() require("jdtls").extract_variable({ visual = true }) end, mode = "v", desc = "Extract Variable", },
						{ "<leader>lcxc", function() require("jdtls").extract_constant() end, desc = "Extract Constant", },
						{ "<leader>lcxc", function() require("jdtls").extract_constant({ visual = true }) end, mode = "v", desc = "Extract Constant", },
						{ "<leader>lcxm", function() require("jdtls").extract_method({ visual = true }) end, mode = "v", desc = "Extract Method", },
					},
				},
			},
		},
	},
}
