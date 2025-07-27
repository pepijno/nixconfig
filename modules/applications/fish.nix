{ pkgs, config, mkSymlinkAttrs, ... }:

{
  home.packages = with pkgs; [ fish ];

  xdg.configFile = mkSymlinkAttrs config {
    "fish" = {
      source = ../../dotfiles/fish;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };
}
