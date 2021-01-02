{ config, lib, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    noto-fonts
    powerline-fonts
    fantasque-sans-mono
    # these are manually installed because the latest versions are bugged
    # (pkgs.nerdfonts.override { fonts = [ "Iosevka" "DroidSansMono" ]; })
    nerdfonts
    hermit
    source-code-pro
    material-design-icons
  ];
}
