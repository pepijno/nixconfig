{ config, lib, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    noto-fonts
    powerline-fonts
    fantasque-sans-mono
    hermit
    source-code-pro
    material-design-icons
  ];
}
