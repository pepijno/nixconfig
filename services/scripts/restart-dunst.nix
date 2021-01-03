{ pkgs, ... }:

pkgs.writeScriptBin "restart-dunst" ''
  #!${pkgs.stdenv.shell}
  systemctl --user restart dunst.service
''
