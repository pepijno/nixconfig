{ inputs, pkgs, config, mkSymlinkAttrs, ... }:

{
  home.packages = with pkgs; [
    inputs.neovim-nightly-overlay.packages.${pkgs.system}.default
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
