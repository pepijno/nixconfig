{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    ubuntu_font_family
    nerdfonts
    # (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    fira-code
    mononoki
  ];
}
