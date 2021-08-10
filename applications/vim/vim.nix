{ pkgs, config, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  vimrc    = pkgs.callPackage ./vimrc.nix {};
  formatter = pkgs.vimUtils.buildVimPlugin {
    name = "formatter";
    src = pkgs.fetchFromGitHub {
      owner = "mhartington";
      repo = "formatter.nvim";
      rev = "51f10c8acc610d787cad2257224cee92b40216e5";
      sha256 = "15jkrypcd3fa6vcz035yvcpd1rfrxcwvp93mqnihm0g1a74klrql";
    };
  };
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
    fzy
    ripgrep
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
      # ayu-vim
      # coc-nvim
      # coc-java
      # fzf-vim
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
      nvim-web-devicons
      vim-easymotion
      vim-easy-align
      vim-eunuch
      vim-fish
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

      formatter

      # Colors
      gruvbox
      lsp-colors-nvim
      vim-highlightedyank

      # telecope
      telescope-nvim
      plenary-nvim
      popup-nvim
      telescope-fzy-native-nvim
    ];
    extraConfig = vimrc;
    extraPackages = with pkgs; [
      tree-sitter
    ];
  };
}
