{ config, lib, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    ubuntu_font_family
    nerdfonts
    fira-code
    monoid
    hasklig
  ];
}
