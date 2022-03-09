{ pkgs, config, ... }:

let
  steam = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [ pango harfbuzz libthai ];
  };
  torbrowserWithAudio = pkgs.tor-browser-bundle-bin.override {
    audioSupport = true;
    mediaSupport = true;
  };
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
    dmenu
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
    haskell-language-server
    dosbox
    hlint
    playerctl
    jdk11
    cargo
    maven
    neovim
    ripgrep
    # sway stuff
    # waybar
    # wlr-randr
    # swaybg
    # sway
    # xwayland

    electrum
    discord
    torbrowserWithAudio
    firefox-bin
    vivaldi
    vivaldi-widevine
    vivaldi-ffmpeg-codecs
  ];
}
