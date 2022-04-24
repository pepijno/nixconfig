{ config, pkgs, ... }:

pkgs.writeShellScriptBin "menu" ''
  ${pkgs.rofi}/bin/rofi -no-lazy-grab -show drun \
      -display-drun "Applications :" -drun-display-format "{name}" \
      -hide-scrollbar true
''
