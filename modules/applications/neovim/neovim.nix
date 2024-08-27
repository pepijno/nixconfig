{ pkgs, ... }:

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
    beautysh
  ];

  xdg.configFile."nvim".source = ./nvim;
}
