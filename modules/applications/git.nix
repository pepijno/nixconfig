{ pkgs, config, mkSymlinkAttrs, ... }:

{
  home.packages = with pkgs; [ git ];

  xdg.configFile = mkSymlinkAttrs config {
    "git" = {
      source = if pkgs.system == "aarch64-darwin" then ../../dotfiles/git_mac else ../../dotfiles/git;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };
}
