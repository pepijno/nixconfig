{ config, pkgs, ... }:

let
  systemctl = "/run/current-system/sw/bin/systemctl";
  customLock = import ../../applications/customLock.nix { inherit pkgs config; };
in
  pkgs.writeScriptBin "sysmenu" ''
    #!${pkgs.stdenv.shell}
    MENU="$(${pkgs.wofi}/bin/wofi --show dmenu -i --hide-scroll \
      <<< "  Lock
     Logout
     Suspend
   ⏾  Hibernate
     Reboot
     Shutdown")"
    case "$MENU" in
      *Lock)
          ${customLock}/bin/customLock
          ;;
      *Logout)
          swaymsg 'exit'
          ;;
      *Suspend)
          ${customLock}/bin/customLock & ${systemctl} suspend
          ;;
      *Hibernate)
          ${customLock}/bin/customLock & ${systemctl} hibernate
          ;;
      *Reboot)
          ${systemctl} reboot
          ;;
      *Shutdown)
          ${systemctl} -i poweroff
          ;;
    esac
  ''
