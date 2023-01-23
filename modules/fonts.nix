{ config, lib, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    noto-fonts
    fantasque-sans-mono
    ubuntu_font_family
    # nerdfonts
    (pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" "FiraCode" "Mononoki" "Iosevka" "DroidSansMono" ]; })
  ];
}
