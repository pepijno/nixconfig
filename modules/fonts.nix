{ config, lib, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    noto-fonts
    fantasque-sans-mono
    # nerdfonts
    # these are manually installed because we don't want all fonts
    (pkgs.nerdfonts.override { fonts = [ "Mononoki" "Hack" ]; })
  ];
}
