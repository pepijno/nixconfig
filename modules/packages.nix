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
    lutris
    hicolor-icon-theme
    # dosbox
    ltunify
    mullvad-vpn
    dosbox
    playerctl
    jdk11
    cargo
    maven
    ripgrep

    electrum
    discord
    torbrowserWithAudio
    firefox
    vivaldi
    vivaldi-widevine
    vivaldi-ffmpeg-codecs

    ytmdl
    spotdl

    libnotify

    obsidian
    openrct2

    playonlinux

    # nixgl.nixGLIntel
  ];
}
