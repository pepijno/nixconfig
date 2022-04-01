{ config, lib, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    noto-fonts
    fantasque-sans-mono
    # nerdfonts
    (pkgs.nerdfonts.override { fonts = [ "Mononoki" "Iosevka" "DroidSansMono" ]; })
  ];
}
