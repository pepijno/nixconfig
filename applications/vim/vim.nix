{ pkgs, config, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  vimrc    = pkgs.callPackage ./vimrc.nix {};
in {
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  home.packages = with pkgs; [
    fzf
    ripgrep
    nodejs-slim
    nodePackages.npm
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      # auto-pairs
      ale
      ayu-vim
      coc-nvim
      coc-java
      fzf-vim
      kotlin-vim
      haskell-vim
      nvim-treesitter
      quick-scope
      rust-vim
      # scrollbar-nvim
      tagbar
      undotree
      vim-abolish
      vim-commentary
      vim-devicons
      vim-easymotion
      vim-easy-align
      vim-eunuch
      vim-highlightedyank
      vim-lua
      vim-nix
      vim-rooter
      vim-smoothie
      vim-surround
      vim-which-key
      vim-matchup
      wal-vim
      zig-vim
      # vim-gutentags
      # vim-gitgutter
      # haskell-vim

      # telecope
      telescope-nvim
      plenary-nvim
      popup-nvim
    ];
    extraConfig = vimrc;
    extraPackages = with pkgs; [
      tree-sitter
      rustfmt
      rust-analyzer
    ];
  };
}
