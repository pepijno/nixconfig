{ config, pkgs, ... }:

pkgs.writeScriptBin "sysmenu" ''
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
  MENU="$(${pkgs.rofi}/bin/rofi -no-lazy-grab -sep "|" -dmenu -i -p 'System :' \
    -hide-scrollbar true \
    -bw 0 \
    -lines 6 \
    -line-padding 10 \
    -padding 20 \
    -width 15 \
    -xoffset -27 -yoffset 60 \
    -location 3 \
    -columns 1 \
    -show-icons -icon-theme "Papirus" \
    -font "Fantasque Sans Mono 10" \
    -color-enabled true \
    -color-window "$BACKGROUND,$BORDER,$SEPARATOR" \
    -color-normal "$BACKGROUND_ALT,$FOREGROUND,$BACKGROUND_ALT,$HIGHLIGHT_BACKGROUND,$HIGHLIGHT_FOREGROUND" \
    -color-active "$BACKGROUND,$ALT1,$BACKGROUND_ALT,$HIGHLIGHT_BACKGROUND,$HIGHLIGHT_FOREGROUND" \
    -color-urgent "$BACKGROUND,$ALT2,$BACKGROUND_ALT,$HIGHLIGHT_BACKGROUND,$HIGHLIGHT_FOREGROUND" \
    <<< "  Lock|  Logout|  Suspend|⏾  Hibernate|  Reboot|  Shutdown")"
    case "$MENU" in
      *Lock)
          ${pkgs.betterlockscreen}/bin/betterlockscreen --lock blur
          ;;
      *Logout)
          i3-msg exit
          ;;
      *Suspend)
          ${pkgs.betterlockscreen}/bin/betterlockscreen --lock blur && systemctl suspend
          ;;
      *Hibernate)
          ${pkgs.betterlockscreen}/bin/betterlockscreen --lock blur && systemctl hibernate
          ;;
      *Reboot)
          systemctl reboot
          ;;
      *Shutdown)
          systemctl -i poweroff
          ;;
    esac
''
