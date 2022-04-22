{ config, lib, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    noto-fonts
    fantasque-sans-mono
    # nerdfonts
    (pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" "FiraCode" "Mononoki" "Iosevka" "DroidSansMono" ]; })
  ];
}
