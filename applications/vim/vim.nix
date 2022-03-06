{ pkgs, config, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

#  xdg.configFile.nvim = {
#	  source = ./config;
#	  recursive = true;
#  };

  home.packages = with pkgs; [
    ripgrep
    fzy
    fzf
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      ripgrep
      fzy
      fzf
      tree-sitter
    ];
  };
}
