{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim

    rnix-lsp
    nixfmt

    uncrustify
    clang-tools

    sumneko-lua-language-server
    stylua
  ];

  xdg.configFile."nvim".source = ./nvim;
}
