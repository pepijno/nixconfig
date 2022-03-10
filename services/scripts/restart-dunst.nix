{ pkgs, ... }:

pkgs.writeShellScriptBin "restart-dunst" ''
  systemctl --user restart dunst.service
''
