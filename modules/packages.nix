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
    dosbox
    inotify-tools
    timidity
    soundfont-fluid
    ltunify
    mullvad-vpn
    playerctl
    ripgrep

    electrum
    torbrowserWithAudio
    firefox
    vivaldi
    widevine-cdm
    vivaldi-ffmpeg-codecs

    libnotify

    openrct2

    discord
  ];
}
