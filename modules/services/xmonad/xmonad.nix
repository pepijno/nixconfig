{ config, pkgs, libs, ... }:

let
  restart-dunst = pkgs.callPackage ../scripts/restart-dunst.nix { config = config; };
  menu = pkgs.callPackage ../scripts/menu.nix { config = config; };
  sysmenu = pkgs.callPackage ../scripts/sysmenu.nix { config = config; };
in
{
  home.file.".xinitrc".text = ''
    #!/usr/bin/env sh

    if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
            eval $(dbus-launch --exit-with-session --sh-syntax)
    fi
    systemctl --user import-environment DISPLAY XAUTHORITY

    if command -v dbus-update-activation-environment >/dev/null 2>&1; then
            dbus-update-activation-environment DISPLAY XAUTHORITY
    fi
    exec ${pkgs.haskellPackages.xmonad_0_17_0}/bin/xmonad
  '';

  home.file.".xserverrc".text = ''
    #!/usr/bin/env sh
    exec /run/current-system/sw/bin/Xorg -nolisten tcp -nolisten local "$@" "vt""$XDG_VTNR"
  '';

  home.packages = with pkgs; [
    xorg.xmessage
  ];

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
      ] (builtins.readFile ./xmonad.hs)
      );
    };
  };
}
