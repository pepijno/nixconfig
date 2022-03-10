{ pkgs, ... }:

let
  pkill = "/run/current-system/sw/bin/pkill";
in
pkgs.writeShellScriptBin "launch-dunst" ''
  [ -f "$1" ] && . "$1"
  ${pkgs.dunst}/bin/dunst \
    -lf  "''${color7:-#ffffff}" \
    -lb  "''${color3:-#eeeeee}" \
    -lfr "''${color3:-#dddddd}" \
    -nf  "''${color7:-#cccccc}" \
    -nb  "''${color2:-#bbbbbb}" \
    -nfr "''${color2:-#aaaaaa}" \
    -cf  "''${color7:-#999999}" \
    -cb  "''${color1:-#888888}" \
    -cfr "''${color1:-#777777}"
''
