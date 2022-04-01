{ config, pkgs, ... }:

let
  sw = "/run/current-system/sw";
in
pkgs.writeShellScriptBin "sysmenu" ''
  . ${config.home.homeDirectory}/.cache/wal/colors.sh
  FOREGROUND=$color7
  BACKGROUND=$color0
  HIGHLIGHT_BACKGROUND=$color6
  HIGHLIGHT_FOREGROUND=$color0
  MENU="$(echo -e "  Lock\n  Logout\n  Suspend\n⏾  Hibernate\n  Reboot\n  Shutdown" \
    | ${pkgs.dmenu}/bin/dmenu -bw 8 -c -i -l 20 \
    -p "System :" \
    -fn "Fantasque Sans Mono 10" \
    -nb $BACKGROUND \
    -nf $FOREGROUND \
    -sb $HIGHLIGHT_BACKGROUND \
    -sf $HIGHLIGHT_FOREGROUND \
    )"
    case "$MENU" in
      *Lock)
          ${pkgs.betterlockscreen}/bin/betterlockscreen --lock blur
          ;;
      *Logout)
          ${pkgs.busybox}/bin/killall xmonad
          ;;
      *Suspend)
          ${sw}/bin/systemctl suspend
          ;;
      *Hibernate)
          ${sw}/bin/systemctl hibernate
          ;;
      *Reboot)
          ${sw}/bin/systemctl reboot
          ;;
      *Shutdown)
          ${sw}/bin/systemctl -i poweroff
          ;;
    esac
''
