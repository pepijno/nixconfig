{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/fonts.nix
    ./modules/packages.nix

    ./modules/applications/alacritty.nix
    ./modules/applications/fish.nix
    ./modules/applications/git.nix
    ./modules/applications/tmux.nix
    ./modules/applications/bat.nix
    ./modules/applications/neovim/neovim.nix

    ./modules/applications/ranger/ranger.nix

    ./modules/services/backup.nix
    ./modules/services/betterlockscreen.nix
    ./modules/services/dunst.nix
    ./modules/services/picom.nix
    ./modules/services/xmonad/xmonad.nix
    ./modules/services/redshift.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
