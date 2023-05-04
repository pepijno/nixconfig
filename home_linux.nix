{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/fonts.nix
    ./modules/packages.nix

    ./modules/applications/alacritty.nix
    ./modules/applications/fish.nix
    ./modules/applications/git.nix
    ./modules/applications/tmux.nix
    # ./modules/applications/bat.nix
    ./modules/applications/rofi.nix
    ./modules/applications/neovim/neovim.nix

    ./modules/applications/ranger/ranger.nix

    ./modules/services/backup.nix
    # ./modules/services/betterlockscreen.nix
    # ./modules/services/dunst.nix
    # ./modules/services/picom.nix
    # ./modules/services/xmonad/xmonad.nix
    ./modules/services/sway/sway.nix
    ./modules/services/sway/wlsunset.nix
    ./modules/services/sway/sirula/sirula.nix
    ./modules/services/sway/waybar.nix
    # ./modules/services/sway/run-swaybg.nix
    # ./modules/services/redshift.nix
  ];
  home.username = "pepijn";
  home.homeDirectory = "/home/pepijn";
  home.stateVersion = "21.03";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
