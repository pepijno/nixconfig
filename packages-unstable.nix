{ config, pkgs, lib, ... }:

let
in
{
  # nixpkgs.overlays = [(self: super: { discord = super.discord.overrideAttrs (_: { src = builtins.fetchTarball https://discord.com/api/download/stable?platform=linux&format=tar.gz; });})];

  home.packages = with pkgs; [
    # thunderbird
    electrum
    # steam
    # steam-run
    # protontricks
    # mumble
    discord
    # jetbrains.idea-community
    # pkgs.discord
    torbrowserWithAudio
    firefox-bin
    vivaldi
    vivaldi-widevine
    vivaldi-ffmpeg-codecs
  ];
}
