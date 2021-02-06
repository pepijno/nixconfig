{ pkgs, config, ... }:

let
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  parsec = import ./pkgs/parsec.nix { inherit pkgs; };

in {
  nixpkgs.config.pulseaudio = true;
  home.packages = [
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
    pkgs.ncpamixer
    pkgs.fff
    pkgs.fd
    pkgs.lm_sensors
    pkgs.stress
    pkgs.s-tui
    pkgs.sysbench
  ];
}
