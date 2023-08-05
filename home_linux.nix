{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/fonts.nix
    ./modules/packages.nix

    ./modules/applications/kitty.nix
    ./modules/applications/fish.nix
    ./modules/applications/git.nix
    ./modules/applications/tmux.nix
    ./modules/applications/neovim/neovim.nix

    ./modules/services/backup.nix
    ./modules/services/hyprland.nix
    ./modules/services/wlsunset.nix
    ./modules/services/sirula/sirula.nix
    ./modules/services/waybar/waybar.nix
  ];
  home.username = "pepijn";
  home.homeDirectory = "/home/pepijn";
  home.stateVersion = "21.03";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
