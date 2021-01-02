{ pkgs, ... }:

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
      vivaldi = {
        proprietaryCodecs = true;
        enableWideVine = true;
      };
    };
  };
in {
  home.packages = with unstable; [
    thunderbird
    electrum
    steam
    discord
    tor-browser-bundle-bin
    firefox
    vivaldi
    vivaldi-widevine
    vivaldi-ffmpeg-codecs
  ];
}
