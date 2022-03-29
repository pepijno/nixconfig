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

    ghc
    haskell-language-server
    haskellPackages.brittany
  ];

  xdg.configFile."nvim".source = ./nvim;
}
