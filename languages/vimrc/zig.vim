lua <<EOF
-- nvim_lsp object
local nvim_lsp = require'lspconfig'
local configs = require('lspconfig/configs')
local util = require('lspconfig/util')

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

configs.zls = {
    default_config = {
      cmd = {'/home/pepijn/.nix-profile/bin/zls'};
      filetypes = {'zig'};
      root_dir = util.root_pattern("build.zig");
      settings = {};
	  enable_semantic_tokens = false;
    };
  }

-- Enable analyzer
nvim_lsp.zls.setup {
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
