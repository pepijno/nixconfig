{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim

    # needed for Mason
    unzip
    patchelf
    gcc
    cargo
    nodejs_20

    stylua
  ];

  xdg.configFile."nvim".source = ./nvim;
}
