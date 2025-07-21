{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.neovim

    # needed for Mason
    unzip
    gzip
    patchelf
    gcc
    cargo
    nodejs_20

    stylua
    beautysh
  ];

  # xdg.configFile."nvim".source = ./nvim;
}
