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
    wget
    nix-prefetch-git
    fd
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
    librewolf
    vivaldi
    widevine-cdm
    vivaldi-ffmpeg-codecs

    libnotify

    # betterlockscreen
    audacity
  ];
}
