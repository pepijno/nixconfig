{ config, pkgs, ... }:

let
  sw = "/run/current-system/sw";
in
pkgs.writeShellScriptBin "sysmenu" ''
  MENU="$(${pkgs.rofi}/bin/rofi -no-lazy-grab -sep "|" -dmenu -i -p 'System :' \
    -hide-scrollbar true \
    -show-icons \
    -icon-theme "Papirus" \
    <<< "  Lock|  Logout|  Suspend|⏾  Hibernate|  Reboot|  Shutdown")"
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
