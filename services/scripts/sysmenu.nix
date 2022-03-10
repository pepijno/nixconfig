{ config, pkgs, ... }:

let
  systemctl = "/run/current-system/sw/bin/systemctl";
in
pkgs.writeShellScriptBin "sysmenu" ''
  . ${config.home.homeDirectory}/.cache/wal/colors.sh
  FOREGROUND=$color7
  BACKGROUND=$color0
  HIGHLIGHT_BACKGROUND=$color6
  HIGHLIGHT_FOREGROUND=$color0
  MENU="$(echo -e "  Lock\n  Logout\n  Suspend\n⏾  Hibernate\n  Reboot\n  Shutdown" \
    | ${pkgs.dmenu}/bin/dmenu -i -l 6 \
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
          ${pkgs.i3-gaps}/bin/i3-msg exit
          ;;
      *Suspend)
          ${pkgs.betterlockscreen}/bin/betterlockscreen --lock blur; ${systemctl} suspend
          ;;
      *Hibernate)
          ${pkgs.betterlockscreen}/bin/betterlockscreen --lock blur; ${systemctl} hibernate
          ;;
      *Reboot)
          ${systemctl} reboot
          ;;
      *Shutdown)
          ${systemctl} -i poweroff
          ;;
    esac
''
