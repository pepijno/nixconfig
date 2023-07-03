{ pkgs, config, ... }:

let
  torbrowserWithAudio = pkgs.tor-browser-bundle-bin.override {
    audioSupport = true;
    mediaSupport = true;
  };
in
{
  nixpkgs.config.pulseaudio = true;
  home.packages = with pkgs; [
    bash
    imagemagick
    # nix-du
    wget
    nix-prefetch-git
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
    playerctl
    jdk11
    cargo
    maven
    ripgrep

    electrum
    torbrowserWithAudio
    firefox
    vivaldi
    vivaldi-widevine
    vivaldi-ffmpeg-codecs

    ytmdl
    # spotdl

    libnotify

    openrct2

    discord
    # kicad-small
    # vial
  ];
}
