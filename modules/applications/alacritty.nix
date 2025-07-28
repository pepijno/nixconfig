{ pkgs, config, mkSymlinkAttrs, ... }:

{
  home.packages = with pkgs; [ alacritty ];

  xdg.configFile = mkSymlinkAttrs config {
    "alacritty" = {
      source = ../../dotfiles/alacritty;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };
}
