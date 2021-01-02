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
  ];
}
