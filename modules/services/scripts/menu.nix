{ config, pkgs, ... }:

pkgs.writeShellScriptBin "menu" ''
  ${pkgs.dmenu}/bin/dmenu_run -bw 8 -c -i -l 20 \
    -p "Applications :" \
    -fn "Fantasque Sans Mono 10"
''
