{ pkgs, ... }:

let
  sway-launcher = import ./sway-launcher.nix { inherit pkgs; };
in {
  nixpkgs.config.pulseaudio = true;
  home.packages = [
    sway-launcher
    pkgs.unzip
    pkgs.pywal
    pkgs.solaar
    pkgs.redshift
    pkgs.imagemagick
    pkgs.ctags
    pkgs.nix-du
    pkgs.wget
    pkgs.betterlockscreen
    pkgs.pfetch
    pkgs.stack
    pkgs.sway
    pkgs.xwayland
    pkgs.dmenu
    pkgs.nix-prefetch-git
    pkgs.waybar
    pkgs.wineWowPackages.stable
    pkgs.wlr-randr
    pkgs.swaybg
    pkgs.steam-run
    pkgs.ueberzug
  ];
}
