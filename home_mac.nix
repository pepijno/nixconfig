{ config, lib, pkgs, ...}:

{
  imports = [
    ./fonts.nix

    ./applications/alacritty.nix
    ./applications/tmux.nix

    ./applications/ranger/ranger.nix
    ./applications/vim/vim.nix
  ];

  home.packages = with pkgs; [
    bat
    fd
    nix-prefetch-git
  ];

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "poverbeeke";
  home.homeDirectory = "/Users/poverbeeke";

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
