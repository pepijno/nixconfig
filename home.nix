{ config, lib, pkgs, ... }:

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

  imports = [
    ./git.nix
    ./fish.nix
    ./urxvt.nix
    ./fonts.nix
    ./vim/vim.nix
    ./backup/backup.nix
    ./polybar/polybar.nix
    ./dunst/dunst.nix
  ];

  home.packages = [
    pkgs.unzip
    pkgs.pywal
    pkgs.solaar
    pkgs.redshift
    # these are manually installed because the latest versions are bugged
    # (pkgs.nerdfonts.override { fonts = [ "Iosevka" "DroidSansMono" ]; })
    pkgs.ranger
    pkgs.imagemagick
    pkgs.ctags
    pkgs.nix-du

    unstable.thunderbird

    unstable.electrum

    unstable.steam
    unstable.discord

    unstable.tor-browser-bundle-bin

    unstable.vivaldi
    unstable.vivaldi-widevine
    unstable.vivaldi-ffmpeg-codecs
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # programs.rofi.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "pepijn";
  home.homeDirectory = "/home/pepijn";

  home.file.".config/i3/config".source = ./i3/config;

  nixpkgs.config.allowUnfree = true;
  # home.file.".config/nixpkgs/config.nix".text = ''
  #   { allowUnfree = true; }
  # '';

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}
