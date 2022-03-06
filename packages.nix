{ pkgs, config, ... }:

let
  steam = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [ pango harfbuzz libthai ];
  };
  # nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
  #     inherit pkgs;
  #   };
  # parsec = import ./pkgs/parsec.nix { inherit pkgs; };

  # steam = pkgs.steam.override {
  #   nativeOnly = true;
  # };
in
{
  nixpkgs.config.pulseaudio = true;
  home.packages = with pkgs; [
    bash
    unzip
    pywal
    imagemagick
    nix-du
    wget
    stack
    # sway
    # xwayland
    dmenu
    nix-prefetch-git
    # waybar
    # wlr-randr
    # swaybg
    ueberzug
    fd
    lm_sensors
    # minecraft
    steam
    steam-run
    hicolor-icon-theme
    # dosbox
    ltunify
    mullvad-vpn
    haskell-language-server
    dosbox
    hlint
    playerctl
    jdk11
    cargo
    maven
    /* clang-tools */
  ];
}
