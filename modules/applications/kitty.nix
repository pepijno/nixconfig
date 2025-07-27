{ pkgs, config, mkSymlinkAttrs, ... }:

{
  home.packages = with pkgs; [ kitty ];
  xdg.configFile = mkSymlinkAttrs config {
    "kitty" = {
      source = ../../dotfiles/kitty;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };
}
