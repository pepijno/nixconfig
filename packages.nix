{ pkgs, config, ... }:

let
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  parsec = import ./pkgs/parsec.nix { inherit pkgs; };

  # steam = pkgs.steam.override {
  #   nativeOnly = true;
  # };
in {
  nixpkgs.config.pulseaudio = true;
  home.packages = with pkgs; [
    gradle
    bash
    unzip
    pywal
    solaar
    redshift
    imagemagick
    ctags
    nix-du
    wget
    betterlockscreen
    pfetch
    stack
    sway
    xwayland
    dmenu
    nix-prefetch-git
    waybar
    wineWowPackages.stable
    wlr-randr
    swaybg
    ueberzug
    ncpamixer
    fff
    fd
    lm_sensors
    stress
    s-tui
    sysbench
    openjdk11
    minecraft
    steam
    steam-run
    dosbox
  ];
}
