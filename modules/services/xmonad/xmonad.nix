{ config, pkgs, libs, ... }:

let
  menu = pkgs.callPackage ../scripts/menu.nix { config = config; };
  sysmenu = pkgs.callPackage ../scripts/sysmenu.nix { config = config; };
  trayer-padding = pkgs.callPackage ../scripts/trayer-padding.nix { config = config; };
  start-trayer = pkgs.callPackage ../scripts/start-trayer.nix { config = config; };
  sw = "/run/current-system/sw";
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
    exec dbus-launch --sh-syntax --exit-with-session ${pkgs.haskellPackages.xmonad}/bin/xmonad
  '';

  home.file.".xserverrc".text = ''
    #!${pkgs.stdenv.shell}
    exec /run/current-system/sw/bin/Xorg -nolisten tcp -nolisten local "$@" "vt""$XDG_VTNR"
  '';

  home.packages = with pkgs; [
    xorg.xmessage
  ];

  programs.xmobar = {
    enable = true;
    extraConfig = builtins.replaceStrings [
      "\${trayer-padding}"
      "\${xdotool}"
    ] [
      "${trayer-padding}"
      "${pkgs.xdotool}"
    ] (builtins.readFile ./xmobarrc);
  };

  xsession = {
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
        hp.xmonad
        hp.xmonad-contrib
        hp.xmonad-extras
      ];
      config = pkgs.writeText "xmonad.hs" (builtins.replaceStrings [
        "\${alacritty}"
        "\${menu}"
        "\${sysmenu}"
        "\${xmonad}"
        "\${vivaldi}"
        "\${firefox}"
        "\${tor}"
        "\${steam}"
        "\${playerctl}"
        "\${solaar}"
        "\${xrandr}"
        "\${betterlockscreen}"
        "\${trayer}"
        "\${xdotool}"
        "\${start-trayer}"
        "\${busybox}"
        "\${sw}"
      ] [
        "${pkgs.alacritty}"
        "${menu}"
        "${sysmenu}"
        "${pkgs.haskellPackages.xmonad}"
        "${pkgs.vivaldi}"
        "${pkgs.firefox}"
        "${pkgs.tor-browser-bundle-bin}"
        "${pkgs.steam}"
        "${pkgs.playerctl}"
        "${pkgs.solaar}"
        "${pkgs.xorg.xrandr}"
        "${pkgs.betterlockscreen}"
        "${pkgs.trayer}"
        "${pkgs.xdotool}"
        "${start-trayer}"
        "${pkgs.busybox}"
        sw
      ]
        (builtins.readFile ./xmonad.hs)
      );
    };
  };
}
