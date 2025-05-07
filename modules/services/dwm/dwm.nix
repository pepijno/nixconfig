{ config, pkgs, lib, ... }:

let
  sw = "/run/current-system/sw";
  rundwm = pkgs.writeShellScriptBin "rundwm" ''
    while true; do
      dwm
    done
  '';
  runbar = pkgs.callPackage ./runbar.nix { config = config; };
  dmenu = (pkgs.dmenu.overrideAttrs (oldAttrs: rec {
    src = ./dmenu;
    configFile = pkgs.writeText "config.def.h" (builtins.replaceStrings [
      "\${base00}"
      "\${base01}"
      "\${base02}"
      "\${base03}"
      "\${base04}"
      "\${base05}"
      "\${base06}"
      "\${base07}"
      "\${base08}"
      "\${base09}"
      "\${base0A}"
      "\${base0B}"
      "\${base0C}"
      "\${base0D}"
      "\${base0E}"
      "\${base0F}"
    ] [
      "${config.colorScheme.palette.base00}"
      "${config.colorScheme.palette.base01}"
      "${config.colorScheme.palette.base02}"
      "${config.colorScheme.palette.base03}"
      "${config.colorScheme.palette.base04}"
      "${config.colorScheme.palette.base05}"
      "${config.colorScheme.palette.base06}"
      "${config.colorScheme.palette.base07}"
      "${config.colorScheme.palette.base08}"
      "${config.colorScheme.palette.base09}"
      "${config.colorScheme.palette.base0A}"
      "${config.colorScheme.palette.base0B}"
      "${config.colorScheme.palette.base0C}"
      "${config.colorScheme.palette.base0D}"
      "${config.colorScheme.palette.base0E}"
      "${config.colorScheme.palette.base0F}"
    ]
      (builtins.readFile ./dmenu/config.h)
    );
    postPatch = ''
      cp ${configFile} config.h
    '';
  }));
in
{
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  services.playerctld = {
    enable = true;
  };

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
    dmenu
    (pkgs.dwm.overrideAttrs (oldAttrs: rec {
      src = ./dwm;
      configFile = pkgs.writeText "config.def.h" (builtins.replaceStrings [
        "\${dmenu}"
        "\${betterlockscreen}"
        "\${kitty}"
        "\${librewolf}"
        "\${vivaldi}"
        "\${tor-browser}"
        "\${steam}"
        "\${sw}"
        "\${playerctl}"
        "\${base00}"
        "\${base01}"
        "\${base02}"
        "\${base03}"
        "\${base04}"
        "\${base05}"
        "\${base06}"
        "\${base07}"
        "\${base08}"
        "\${base09}"
        "\${base0A}"
        "\${base0B}"
        "\${base0C}"
        "\${base0D}"
        "\${base0E}"
        "\${base0F}"
      ] [
        "${dmenu}"
        "${pkgs.betterlockscreen}"
        "${pkgs.kitty}"
        "${pkgs.librewolf}"
        "${pkgs.vivaldi}"
        "${pkgs.tor-browser-bundle-bin}"
        "${pkgs.steam}"
        "${sw}"
        "${pkgs.playerctl}"
        "${config.colorScheme.palette.base00}"
        "${config.colorScheme.palette.base01}"
        "${config.colorScheme.palette.base02}"
        "${config.colorScheme.palette.base03}"
        "${config.colorScheme.palette.base04}"
        "${config.colorScheme.palette.base05}"
        "${config.colorScheme.palette.base06}"
        "${config.colorScheme.palette.base07}"
        "${config.colorScheme.palette.base08}"
        "${config.colorScheme.palette.base09}"
        "${config.colorScheme.palette.base0A}"
        "${config.colorScheme.palette.base0B}"
        "${config.colorScheme.palette.base0C}"
        "${config.colorScheme.palette.base0D}"
        "${config.colorScheme.palette.base0E}"
        "${config.colorScheme.palette.base0F}"
      ]
        (builtins.readFile ./dwm/config.h)
      );
      postPatch = ''
        cp ${configFile} config.h
      '';
    }))
  ];

  xdg.dataFile."dwm/autostart.sh".text = ''
    #!${pkgs.stdenv.shell}

    ${sw}/bin/pgrep solaar > /dev/null || ${pkgs.solaar}/bin/solaar --window hide --battery-icons symbolic &
    /usr/lib/polkit-gnome-polkit-gnome-authentication-agent-1 &
    ${sw}/bin/systemctl --user --quiet is-active dunst.service || ${sw}/bin/systemctl --user start dunst.service &
    ${sw}/bin/systemctl --user --quiet is-active redshift.service || ${sw}/bin/systemctl --user start redshift.service &
    ${sw}/bin/systemctl --user --quiet is-active xidlehook.service || ${sw}/bin/systemctl --user start xidlehook.service &
    pkill feh; ${pkgs.feh}/bin/feh --randomize --bg-fill ~/Pictures/Wallpapers/ &
    # pkill betterlockscreen; ${pkgs.betterlockscreen}/bin/betterlockscreen -u ~/Pictures/Wallpapers/ &
    pkill runbar; ${runbar}/bin/runbar &
  '';
  xdg.dataFile."dwm/autostart.sh".executable = true;

  xdg.dataFile."dwm/autoclose_blocking.sh".text = ''
    #!${pkgs.stdenv.shell}

    ${sw}/bin/systemctl --user --quiet is-active dunst.service && ${sw}/bin/systemctl --user stop dunst.service
    ${sw}/bin/systemctl --user --quiet is-active redshift.service && ${sw}/bin/systemctl --user stop redshift.service
    ${sw}/bin/systemctl --user --quiet is-active xidlehook.service && ${sw}/bin/systemctl --user stop xidlehook.service
    pkill feh
    # pkill betterlockscreen
    pkill runbar
  '';
  xdg.dataFile."dwm/autoclose_blocking.sh".executable = true;

  home.activation.dwm = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    oldDwm="$oldGenPath/home-path/bin/dwm"
    newDwm="$newGenPath/home-path/bin/dwm"
    if ! [ "$oldDwm" -ef "$newDwm" ]; then
      warnEcho "Please reload dwm manually."
    fi
  '';
}

