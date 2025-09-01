{ config, pkgs, lib, ... }:

let sw = "/run/current-system/sw";
  runDwl = pkgs.writeShellScriptBin "runDwl" ''
    while true; do
      dwl
    done
  '';
  startDwl = pkgs.writeShellScriptBin "startDwl" ''
    #!${pkgs.stdenv.shell}

    if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
            eval $(dbus-launch --exit-with-session --sh-syntax)
    fi
    exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
    exec dbus-launch --sh-syntax --exit-with-session ${runDwl}/bin/runDwl
  '';
in {

  services.playerctld = {
    enable = true;
  };

  home.packages = [
    startDwl
    (pkgs.dwl.overrideAttrs (oldAttrs: rec {
      src = ./dwl;
      configFile = pkgs.writeText "config.def.h" (builtins.replaceStrings [
        "\${wmenu}"
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
        "${pkgs.wmenu}"
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
      ] (builtins.readFile ./dwl/config.h));
      postPatch = ''
        cp ${configFile} config.h
      '';
    }))
  ];

  home.activation.dwl = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    oldDwl="$oldGenPath/home-path/bin/dwl"
    newDwl="$newGenPath/home-path/bin/dwl"
    if ! [ "$oldDwl" -ef "$newDwl" ]; then
      warnEcho "Please reload dwl manually."
    fi
  '';
}
