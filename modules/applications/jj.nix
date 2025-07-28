{ pkgs, config, mkSymlinkAttrs, ... }:

{
  home.packages = with pkgs; [ jujutsu ];

  xdg.configFile = mkSymlinkAttrs config {
    "jj" = {
      source = ../../dotfiles/jj;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };
}
