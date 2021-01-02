{ config, lib, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./fish.nix
    ./urxvt.nix
    ./fonts.nix
    ./vim/vim.nix
    ./backup/backup.nix
    ./dunst/dunst.nix
    ./polybar/polybar.nix

    ./packages.nix
    ./packages-unstable.nix

    # ./compton.nix
  ];

  nixpkgs.config.allowUnfree = true;

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
