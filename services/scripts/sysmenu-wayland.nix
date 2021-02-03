{ config, pkgs, ... }:

let
  systemctl = "/run/current-system/sw/bin/systemctl";
  customLock = import ../../applications/customLock.nix { inherit pkgs config; };
  sysmenu = pkgs.writeScriptBin "sysmenu" ''
    #!${pkgs.stdenv.shell}
    MENU=$(echo "  Lock
      Logout
      Suspend
    ⏾  Hibernate
      Reboot
      Shutdown" | fzf --ansi +s -x -d '\034' --nth ..3 --with-nth ..3 --no-multi --cycle --header="" --no-info --margin='1,2' --color='16,gutter:-1')
    case "$MENU" in
      *Lock)
          ${pkgs.betterlockscreen}/bin/betterlockscreen --lock blur
          ;;
      *Logout)
          ${pkgs.i3-gaps}/bin/i3-msg exit
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
  '';
in
  pkgs.writeScriptBin "sysmenu-wayland" ''
    #!${pkgs.stdenv.shell}
    exec alacritty --class 'sysmenu-launcher' --command ${pkgs.fish}/bin/fish -c '${sysmenu}/bin/sysmenu'
  ''
