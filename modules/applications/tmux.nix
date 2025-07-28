{ config, pkgs, mkSymlinkAttrs, ... }:

{
  home.packages = with pkgs; [ tmux tmux-mem-cpu-load ];

  xdg.configFile = mkSymlinkAttrs config {
    "tmux" = {
      source = ../../dotfiles/tmux;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };
}
