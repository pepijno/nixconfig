{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unzip
    pywal
    solaar
    redshift
    imagemagick
    ctags
    nix-du
    wget
    alacritty
    betterlockscreen
    i3lock-color
    xorg.xdpyinfo
    xorg.xrandr
    bc
    feh
    neofetch
  ];
}
