{ pkgs, config, mkSymlinkAttrs, ... }:

{
  home.packages = with pkgs; [ jujutsu ];

  xdg.configFile = mkSymlinkAttrs config {
    "jj" = {
      source = if pkgs.system == "aarch64-darwin" then ../../dotfiles/jj_mac else ../../dotfiles/jj;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };
}
