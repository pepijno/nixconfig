{ pkgs, config, mkSymlinkAttrs, ... }:

{
  home.packages = if pkgs.system == "aarch64-darwin" then [] else with pkgs; [ git ];

  xdg.configFile = mkSymlinkAttrs config {
    "git" = {
      source = ../../dotfiles/git;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };
}
