{ pkgs, config, mkSymlinkAttrs, ...}:

{
  home.packages = with pkgs; [ starship ];
  xdg.configFile = mkSymlinkAttrs config {
    "starship.toml" = {
      source = ../../dotfiles/starship/starship.toml;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };
}
