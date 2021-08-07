{ config, lib, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./packages.nix
    ./packages-unstable.nix

    ./applications/alacritty.nix
    ./applications/fish.nix
    ./applications/git.nix
    ./applications/tmux.nix
    ./applications/urxvt.nix
    ./applications/bat.nix

    ./applications/ranger/ranger.nix
    ./applications/vim/vim.nix
    # ./applications/wofi/wofi.nix

    ./services/backup.nix
    ./services/compton.nix
    ./services/i3.nix
    # ./services/sway.nix
    ./services/redshift.nix
    # ./services/gammastep.nix
    ./services/dunst.nix
    ./services/polybar.nix
    ./services/wal.nix

    ./languages/rust.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.configFile."nvim/parser/rust.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";

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
