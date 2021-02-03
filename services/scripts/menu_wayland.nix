{ config, pkgs, ... }:

let
  sway-launcher = import ./sway-launcher.nix { inherit pkgs; };
in
  pkgs.writeScriptBin "menu_wayland" ''
    #!${pkgs.stdenv.shell}
    exec alacritty --class 'launcher' --command ${pkgs.fish}/bin/fish -c '${sway-launcher}/bin/sway-launcher'
  ''
