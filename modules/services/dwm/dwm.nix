{ config, pkgs, ... }:

let
  sysmenu = pkgs.callPackage ../scripts/sysmenu.nix { config = config; };
  sw = "/run/current-system/sw";
  rundwm = pkgs.writeShellScriptBin "rundwm" ''
    while true; do
      dwm
    done
  '';
  runbar = pkgs.callPackage ./runbar.nix { config = config; };
in
{
  home.file.".xinitrc".text = ''
    #!${pkgs.stdenv.shell}

    if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
            eval $(dbus-launch --exit-with-session --sh-syntax)
    fi
    ${sw}/bin/systemctl --user import-environment DISPLAY XAUTHORITY

    if command -v dbus-update-activation-environment >/dev/null 2>&1; then
            dbus-update-activation-environment DISPLAY XAUTHORITY
    fi
    xsetroot -cursor_name left_ptr
    exec dbus-launch --sh-syntax --exit-with-session ${rundwm}/bin/rundwm
  '';

  home.file.".xserverrc".text = ''
    #!${pkgs.stdenv.shell}
    exec ${sw}/bin/Xorg -nolisten tcp -nolisten local "$@" "vt""$XDG_VTNR"
  '';

  home.packages = [
    (pkgs.dmenu.overrideAttrs (oldAttrs: {
      src = ./dmenu;
    }))
    pkgs.pamixer
    (pkgs.dwm.overrideAttrs (oldAttrs: rec {
      src = ./dwm;
      configFile = pkgs.writeText "config.def.h" (builtins.replaceStrings [
        "\${dmenu}"
        "\${kitty}"
        "\${sysmenu}"
        "\${firefox}"
        "\${vivaldi}"
        "\${tor-browser}"
        "\${steam}"
        "\${sw}"
        "\${playerctl}"
      ] [
        "${pkgs.dmenu}"
        "${pkgs.kitty}"
        "${sysmenu}"
        "${pkgs.firefox}"
        "${pkgs.vivaldi}"
        "${pkgs.tor-browser-bundle-bin}"
        "${pkgs.steam}"
        "${sw}"
        "${pkgs.playerctl}"
      ]
        (builtins.readFile ./dwm/config.h)
      );
      postPatch = ''
        cp ${configFile} config.h
      '';
    }))
    pkgs.feh
    sysmenu
  ];

  xdg.dataFile."dwm/autostart.sh".text = ''
    #!${pkgs.stdenv.shell}

    ${sw}/bin/pgrep solaar > /dev/null || ${pkgs.solaar}/bin/solaar &
    /usr/lib/polkit-gnome-polkit-gnome-authentication-agent-1 &
    ${sw}/bin/systemctl --user --quiet is-active dunst.service || ${sw}/bin/systemctl --user start dunst.service &
    ${sw}/bin/systemctl --user --quiet is-active redshift.service || ${sw}/bin/systemctl --user start redshift.service &
    ${sw}/bin/systemctl --user --quiet is-active xidlehook.service || ${sw}/bin/systemctl --user start xidlehook.service &
    pkill feh; ${pkgs.feh}/bin/feh --randomize --bg-fill ~/Pictures/Wallpapers/ &
    pkill betterlockscreen; ${pkgs.betterlockscreen}/bin/betterlockscreen -u ~/Pictures/Wallpapers/ &
    pkill runbar; ${runbar}/bin/runbar &
  '';
  xdg.dataFile."dwm/autostart.sh".executable = true;

  xdg.dataFile."dwm/autoclose_blocking.sh".text = ''
    #!${pkgs.stdenv.shell}

    ${sw}/bin/systemctl --user --quiet is-active dunst.service && ${sw}/bin/systemctl --user stop dunst.service
    ${sw}/bin/systemctl --user --quiet is-active redshift.service && ${sw}/bin/systemctl --user stop redshift.service
    ${sw}/bin/systemctl --user --quiet is-active xidlehook.service && ${sw}/bin/systemctl --user stop xidlehook.service
    pkill feh
    pkill betterlockscreen
    pkill runbar
  '';
  xdg.dataFile."dwm/autoclose_blocking.sh".executable = true;

  # home.activation.dwm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   warnEcho "Please reload dwm manually."
  # '';

  # programs.dwm = {
  #   enable = true;
  #   # extraConfig = builtins.replaceStrings [
  #   #   "\${trayer-padding}"
  #   #   "\${xdotool}"
  #   # ] [
  #   #   "${trayer-padding}"
  #   #   "${pkgs.xdotool}"
  #   # ] (builtins.readFile ./xmobarrc);
  # };
  #
  # xsession = {
  #   windowManager.dwm = {
  #     enable = true;
  #     # enableContribAndExtras = true;
  #     # extraPackages = hp: [
  #     #   hp.dbus
  #     #   hp.monad-logger
  #     #   hp.xmonad
  #     #   hp.xmonad-contrib
  #     #   hp.xmonad-extras
  #     # ];
  #     # config = pkgs.writeText "xmonad.hs" (builtins.replaceStrings [
  #     #   "\${alacritty}"
  #     #   "\${menu}"
  #     #   "\${sysmenu}"
  #     #   "\${xmonad}"
  #     #   "\${vivaldi}"
  #     #   "\${firefox}"
  #     #   "\${tor}"
  #     #   "\${steam}"
  #     #   "\${playerctl}"
  #     #   "\${solaar}"
  #     #   "\${xrandr}"
  #     #   "\${betterlockscreen}"
  #     #   "\${trayer}"
  #     #   "\${xdotool}"
  #     #   "\${start-trayer}"
  #     #   "\${busybox}"
  #     #   "\${sw}"
  #     #   "\${feh}"
  #     # ] [
  #     #   "${pkgs.alacritty}"
  #     #   "${menu}"
  #     #   "${sysmenu}"
  #     #   "${pkgs.haskellPackages.xmonad}"
  #     #   "${pkgs.vivaldi}"
  #     #   "${pkgs.firefox}"
  #     #   "${pkgs.tor-browser-bundle-bin}"
  #     #   "${pkgs.steam}"
  #     #   "${pkgs.playerctl}"
  #     #   "${pkgs.solaar}"
  #     #   "${pkgs.xorg.xrandr}"
  #     #   "${pkgs.betterlockscreen}"
  #     #   "${pkgs.trayer}"
  #     #   "${pkgs.xdotool}"
  #     #   "${start-trayer}"
  #     #   "${pkgs.busybox}"
  #     #   sw
  #     #   "${pkgs.feh}"
  #     # ]
  #     #   (builtins.readFile ./xmonad.hs)
  #     # );
  #   };
  # };
}

