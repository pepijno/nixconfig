{ allowed-unfree-packages, pkgs, lib, ... }:

let
  torbrowserWithAudio = pkgs.tor-browser-bundle-bin.override {
    audioSupport = true;
    mediaSupport = true;
  };
in {
  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) allowed-unfree-packages;
    pulseaudio = true;
  };

  home.packages = with pkgs; [
    bash
    imagemagick
    # nix-du
    wget
    nix-prefetch-git
    ueberzug
    fd
    # minecraft
    steam
    steam-run
    hicolor-icon-theme
    dosbox-staging
    inotify-tools
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

    wineWowPackages.base
    playonlinux
    # libreoffice
  ];
}
