{ pkgs, config, mkSymlinkAttrs, ... }:

{
  home.packages = with pkgs; [
    neovim
    tree-sitter
    fzf

    # needed for treesitter
    gcc
  ];

  xdg.configFile = mkSymlinkAttrs config {
    "nvim" = {
      source = ../../dotfiles/nvim;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };
}
