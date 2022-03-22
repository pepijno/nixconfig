{ config, pkgs, ... }:

pkgs.writeShellScriptBin "menu" ''
  . ${config.home.homeDirectory}/.cache/wal/colors.sh
  FOREGROUND=$color7
  BACKGROUND=$color0
  HIGHLIGHT_BACKGROUND=$color6
  HIGHLIGHT_FOREGROUND=$color0
  ${pkgs.dmenu}/bin/dmenu_run -i -l 6 \
    -p "Applications :" \
    -fn "Fantasque Sans Mono 10" \
    -nb $BACKGROUND \
    -nf $FOREGROUND \
    -sb $HIGHLIGHT_BACKGROUND \
    -sf $HIGHLIGHT_FOREGROUND
''
