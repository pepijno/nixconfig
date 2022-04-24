require("configs.lsp.handlers").load_server("sumneko_lua", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
vim.opt.tabstop = 2 -- Number of space in a tab
vim.opt.shiftwidth = 2 -- Number of space inserted for indentation
vim.opt.expandtab = false -- Enable the use of space in tab
