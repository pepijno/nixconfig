{ config, lib, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./packages.nix

    ./applications/alacritty.nix
    ./applications/fish.nix
    ./applications/git.nix
    ./applications/tmux.nix
    # ./applications/bat.nix

    ./applications/ranger/ranger.nix
    # ./applications/vim/vim.nix

    ./services/backup.nix
    ./services/compton.nix
    ./services/i3.nix
    ./services/redshift.nix
    ./services/dunst.nix
    ./services/polybar.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
