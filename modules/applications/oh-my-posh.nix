{ pkgs, config, mkSymlinkAttrs, ...}:

{
  home.packages = with pkgs; [ oh-my-posh ];
  xdg.configFile = mkSymlinkAttrs config {
    "ohmyposh.toml" = {
      source = ../../dotfiles/ohmyposh/ohmyposh.toml;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };
}
