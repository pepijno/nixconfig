{ pkgs, config, ... }:

pkgs.writeScriptBin "launch-mak" ''
  #!${pkgs.stdenv.shell}
  ${pkgs.procps}/bin/pkill mako
  . ${config.home.homeDirectory}/.cache/wal/colors.sh
  ${pkgs.mako}/bin/mako --background-color "$background" --text-color "$foreground" --border-color "$color13"
''
