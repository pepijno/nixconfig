{ pkgs, ... }:

let
  pink-moon = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "pink-moon";
    version = "2020-10-02";
    src = pkgs.fetchFromGitHub {
      owner = "sts10";
      repo = "vim-pink-moon";
      rev = "ab1980d1f216aea8060d935b7220bdc42d05a92b";
      sha256 = "1fwcwb9a7n3vp6c0c7k53i6dzjzjrk3id62j5nq31rlssjcbps6i";
    };
  };
in {

  home.packages = with pkgs; [
    fzf
    ripgrep
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      ayu-vim
      fzf-vim
      gruvbox-community
      pink-moon
      tagbar
      undotree
      vim-abolish
      vim-commentary
      vim-devicons
      vim-easymotion
      vim-nix
      vim-startify
      wal-vim
      # vim-gutentags
      # vim-gitgutter
      # haskell-vim
    ];
	extraConfig = builtins.readFile ./init.vim;
  };
}
