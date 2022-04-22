{ config, pkgs, ... }:

let
  sw = "/run/current-system/sw";
in
pkgs.writeShellScriptBin "sysmenu" ''
  MENU="$(echo -e "  Lock\n  Logout\n  Suspend\n⏾  Hibernate\n  Reboot\n  Shutdown" \
    | ${pkgs.dmenu}/bin/dmenu -bw 8 -c -i -l 20 \
    -p "System :" \
    -fn "Fantasque Sans Mono 10" \
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
