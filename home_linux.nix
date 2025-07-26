{ inputs, ... }:

{
  imports = [
    ./modules/fonts.nix
    ./modules/packages.nix

    ./modules/applications/kitty.nix
    ./modules/applications/fish.nix
    ./modules/applications/git.nix
    ./modules/applications/jj.nix
    ./modules/applications/tmux.nix
    ./modules/applications/neovim.nix

    ./modules/services/backup/backup.nix
    # ./modules/services/betterlockscreen.nix
    ./modules/services/dunst.nix
    ./modules/services/redshift.nix

    ./modules/services/dwm/dwm.nix

    ./modules/services/bluetooth.nix

    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-latte;

  xdg.enable = true;

  home.username = "pepijn";
  home.homeDirectory = "/home/pepijn";
  home.stateVersion = "21.03";

  home.enableNixpkgsReleaseCheck = false;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
