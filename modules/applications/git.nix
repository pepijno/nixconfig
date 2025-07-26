{ pkgs, config, mkSymlinkAttrs, ... }:

{
  home.packages = with pkgs; [
    git
  ];

  xdg.configFile = mkSymlinkAttrs config {
    "git" = {
      source = ../../dotfiles/git;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };
}
