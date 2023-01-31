{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim

    # needed for Mason
    unzip
    patchelf
    gcc

    # rnix-lsp
    # nixfmt

    # uncrustify
    # clang-tools

    # sumneko-lua-language-server
    # stylua

    # ghc
    # haskell-language-server
    # haskellPackages.brittany

    # zig
    zls
  ];

  xdg.configFile."nvim".source = ./nvim;
}
