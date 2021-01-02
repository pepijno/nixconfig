{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unzip
    pywal
    solaar
    redshift
    ranger
    imagemagick
    ctags
    nix-du
    wget
    alacritty
  ];
}
