{ config, pkgs, ... }:

pkgs.writeScriptBin "menu" ''
  #!${pkgs.stdenv.shell}
  . ${config.home.homeDirectory}/.cache/wal/colors.sh
  BORDER=$color1
  SEPARATOR=$color0
  FOREGROUND=$color7
  BACKGROUND=$color0
  BACKGROUND_ALT=$color0
  HIGHLIGHT_BACKGROUND=$color6
  HIGHLIGHT_FOREGROUND=$color0
  ALT1=$color2
  ALT2=$color3
  params=()
  if [ "$1" == "full" ]; then
    params+=(-fullscreen)
  fi
  echo $params
  ${pkgs.rofi}/bin/rofi -no-lazy-grab -show drun \
    -display-drun "Applications :" -drun-display-format "{name}" \
    -hide-scrollbar true \
    -bw 0 \
    -lines 10 \
    -line-padding 10 \
    -padding 20 \
    -width 30 \
    -xoffset 27 -yoffset 60 \
    -location 1 \
    -columns 2 \
    -show-icons -icon-theme "Papirus" \
    -font "Fantasque Sans Mono 10" \
    -color-enabled true \
    -color-window "$BACKGROUND,$BORDER,$SEPARATOR" \
    -color-normal "$BACKGROUND_ALT,$FOREGROUND,$BACKGROUND_ALT,$HIGHLIGHT_BACKGROUND,$HIGHLIGHT_FOREGROUND" \
    -color-active "$BACKGROUND,$ALT1,$BACKGROUND_ALT,$HIGHLIGHT_BACKGROUND,$HIGHLIGHT_FOREGROUND" \
    -color-urgent "$BACKGROUND,$ALT2,$BACKGROUND_ALT,$HIGHLIGHT_BACKGROUND,$HIGHLIGHT_FOREGROUND" \
    "''${params[@]}"
''
