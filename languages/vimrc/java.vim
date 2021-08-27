lua <<EOF
-- nvim_lsp object
local nvim_lsp = require'lspconfig'
local configs = require'lspconfig/configs'

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

configs.java_language_server = {
	default_config = {
		cmd = {'java-language-server'};
		root_dir = nvim_lsp.util.root_pattern('build.gradle', 'pom.xml', '.git');
		filetype = {'java'};
	};
}

-- Enable rust_analyzer
nvim_lsp.java_language_server.setup {
	on_attach=on_attach
}

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)
EOF
