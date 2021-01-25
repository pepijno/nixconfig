{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./fish.nix
    ./fonts.nix
    ./git.nix
    ./packages.nix
    ./packages-unstable.nix
    ./tmux.nix
    ./urxvt.nix

    ./ranger/ranger.nix
    ./vim/vim.nix

    ./services/backup.nix
    # ./services/compton.nix
    # ./services/i3.nix
    ./services/sway.nix
    # ./services/redshift.nix
    ./services/gammastep.nix
    # ./services/dunst.nix
    # ./services/polybar.nix
    ./services/wal.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "pepijn";
  home.homeDirectory = "/home/pepijn";

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
