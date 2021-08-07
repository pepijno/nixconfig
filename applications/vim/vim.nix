{ pkgs, config, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  vimrc    = pkgs.callPackage ./vimrc.nix {};
  cheatsheet-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "cheatsheet.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "sudormrfbin";
      repo = "cheatsheet.nvim";
      rev = "d7a051fc25b331b560f115515a4030f9e3b86099";
      sha256 = "1kbsbf61mmsg3m6rgbz9qys62nd1qvimpll4d3rn66mimxnb1fvi";
    };
  };
in {
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  home.packages = with pkgs; [
    fzf
    ripgrep
    # nodejs-slim
    # nodePackages.npm
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      cheatsheet-nvim
      # auto-pairs
      # ale
      ayu-vim
      # coc-nvim
      # coc-java
      fzf-vim
      kotlin-vim
      haskell-vim
      nvim-lspconfig
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
      vim-fish
      vim-highlightedyank
      vim-lua
      vim-nix
      vim-rooter
      vim-surround
      vim-which-key
      vim-matchup
      wal-vim
      zig-vim
      # vim-gutentags
      # vim-gitgutter
      # haskell-vim

      lualine-nvim

      vim-startuptime

      vim-closer

      lsp_extensions-nvim

      completion-nvim

      gruvbox
      lsp-colors-nvim

      # telecope
      telescope-nvim
      plenary-nvim
      popup-nvim
    ];
    extraConfig = vimrc;
    extraPackages = with pkgs; [
      tree-sitter
    ];
  };
}
