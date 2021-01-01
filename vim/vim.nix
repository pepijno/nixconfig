{ pkgs, ... }:

let
  vimrc = import ./vimrc.nix { pkgs = pkgs; };
in {

  home.packages = with pkgs; [
    fzf
    ripgrep
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      lightline-vim
      vim-abolish
      vim-commentary
      vim-easymotion
      tagbar
      fzf-vim
      vim-startify
      vim-gutentags
      gruvbox
      wal-vim
      vim-devicons
      vim-gitgutter
      haskell-vim
    ];
    extraConfig = vimrc.config;
  };
}
