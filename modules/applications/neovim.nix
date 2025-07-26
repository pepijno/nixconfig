{ inputs, pkgs, config, runtimeRoot, context, ... }:

let
  mkSymlinkAttrs = import ../../lib/mkSymlinkAttrs.nix {
    inherit pkgs;
    inherit context;
    inherit runtimeRoot;
    hm = config.lib;
  };
in {
  home.packages = with pkgs; [
    inputs.neovim-nightly-overlay.packages.${pkgs.system}.default
    fzf

    # needed for treesitter
    gcc
  ];

  xdg.configFile = mkSymlinkAttrs {
    "nvim" = {
      source = ../../dotfiles/nvim;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };
}
