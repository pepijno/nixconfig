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
  torbrowserWithAudio = unstable.torbrowser.override {
    audioSupport = true;
    mediaSupport = true;
  };
in {
  home.packages = with unstable; [
    thunderbird
    electrum
    steam
    protontricks
    mumble
    discord
    torbrowserWithAudio
    firefox-wayland
    vivaldi
    vivaldi-widevine
    vivaldi-ffmpeg-codecs
  ];
}
