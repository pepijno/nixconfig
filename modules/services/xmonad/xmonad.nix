{ config, pkgs, libs, ... }:

let
  restart-dunst = pkgs.callPackage ../scripts/restart-dunst.nix { config = config; };
  menu = pkgs.callPackage ../scripts/menu.nix { config = config; };
  sysmenu = pkgs.callPackage ../scripts/sysmenu.nix { config = config; };
  trayer-padding = pkgs.callPackage ../scripts/trayer-padding.nix { config = config; };
in
{
  home.file.".xinitrc".text = ''
    #!${pkgs.stdenv.shell}

    if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
            eval $(dbus-launch --exit-with-session --sh-syntax)
    fi
    systemctl --user import-environment DISPLAY XAUTHORITY

    if command -v dbus-update-activation-environment >/dev/null 2>&1; then
            dbus-update-activation-environment DISPLAY XAUTHORITY
    fi
    xsetroot -cursor_name left_ptr
    exec dbus-launch --sh-syntax --exit-with-session ${pkgs.haskellPackages.xmonad_0_17_0}/bin/xmonad
  '';

  home.file.".xserverrc".text = ''
    #!${pkgs.stdenv.shell}
    exec /run/current-system/sw/bin/Xorg -nolisten tcp -nolisten local "$@" "vt""$XDG_VTNR"
  '';

  home.packages = with pkgs; [
    xorg.xmessage
    xdotool
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

  xdg.configFile."xmobar/icons/menu.xpm".source = ./menu.xpm;

  xsession = {
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
        hp.xmonad_0_17_0
        hp.xmonad-contrib_0_17_0
        hp.xmonad-extras_0_17_0
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
        "\${pywal}"
        "\${solaar}"
        "\${xrandr}"
        "\${restart-dunst}"
        "\${betterlockscreen}"
        "\${trayer}"
      ] [
        "${pkgs.alacritty}"
        "${menu}"
        "${sysmenu}"
        "${pkgs.haskellPackages.xmonad_0_17_0}"
        "${pkgs.vivaldi}"
        "${pkgs.firefox}"
        "${pkgs.tor-browser-bundle-bin}"
        "${pkgs.steam}"
        "${pkgs.playerctl}"
        "${pkgs.pywal}"
        "${pkgs.solaar}"
        "${pkgs.xorg.xrandr}"
        "${restart-dunst}"
        "${pkgs.betterlockscreen}"
        "${pkgs.trayer}"
      ]
        (builtins.readFile ./xmonad.hs)
      );
    };
  };
}
