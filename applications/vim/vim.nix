{ pkgs, config, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  vimrc    = pkgs.callPackage ./vimrc.nix {};

  scrollbar = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname   = "scrollbar";
    version = "2020-09-28";
    src     = pkgs.fetchFromGitHub {
      owner  = "xuyuanp";
      repo   = "scrollbar.nvim";
      rev    = "72a4174a47a89b7f89401fc66de0df95580fa48c";
      sha256 = "10kk74pmbzc4v70n8vwb2zk0ayr147xy9zk2sbr78zwqf12gas9y";
    };
  };
in {
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  home.packages = with pkgs; [
    bat
    fzf
    ripgrep
    nodejs-slim
    nodePackages.npm
  ];

  programs.vim = {
    enable = true;
    # package = pkgs.neovim-nightly;
    # viAlias = true;
    # vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      # auto-pairs
      ayu-vim
      coc-nvim
      coc-java
      fzf-vim
      kotlin-vim
      haskell-vim
      nvim-treesitter
      quick-scope
      scrollbar
      tagbar
      undotree
      vim-abolish
      vim-commentary
      vim-devicons
      vim-easymotion
      vim-easy-align
      vim-eunuch
      vim-highlightedyank
      vim-nix
      vim-rooter
      vim-smoothie
      vim-surround
      vim-which-key
      wal-vim
      zig-vim
      # vim-gutentags
      # vim-gitgutter
      # haskell-vim
    ];
    extraConfig = vimrc;
  };
}
