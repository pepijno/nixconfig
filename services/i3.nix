{ config, pkgs, lib, ... }:

let
  restart-dunst = pkgs.callPackage ./scripts/restart-dunst.nix { config = config; };
  menu = pkgs.callPackage ./scripts/menu.nix { config = config; };
  sysmenu = pkgs.callPackage ./scripts/sysmenu.nix { config = config; };
  mod = "Mod1";
in
{
  home.file.".xinitc".text = ''
    #!/usr/bin/env sh

    if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
            eval $(dbus-launch --exit-with-session --sh-syntax)
    fi
    systemctl --user import-environment DISPLAY XAUTHORITY

    if command -v dbus-update-activation-environment >/dev/null 2>&1; then
            dbus-update-activation-environment DISPLAY XAUTHORITY
    fi
    exec dbus-launch --sh-syntax --exit-with-session i3
  '';

  home.packages = with pkgs; [
    i3lock-color
  ];

  xsession = {
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        bars = [ ];
        modifier = mod;
        terminal = "${pkgs.alacritty}/bin/alacritty";
        gaps = {
          inner = 5;
          outer = 5;
          top = 47;
        };
        fonts = [ "Noto sans 10" "FontAwesome 10" ];
        window = {
          border = 0;
          hideEdgeBorders = "both";
        };
        floating = {
          border = 0;
        };
        startup = [
          { command = "${pkgs.xorg.xrandr}/bin/xrandr -s 1920x1080"; always = true; notification = false; }
          { command = "${pkgs.solaar}/bin/solaar"; }
          { command = "/usr/lib/polkit-gnome-polkit-gnome-authentication-agent-1"; }
          { command = "${pkgs.pywal}/bin/wal -R"; }
          { command = "${restart-dunst}/bin/restart-dunst"; always = true; }
          { command = "${pkgs.betterlockscreen}/bin/betterlockscreen -u ~/Pictures/Wallpapers/"; always = true; notification = false; }
          { command = "systemctl --user start dunst.service"; }
          { command = "systemctl --user restart picom.service"; always = true; notification = false; }
          { command = "systemctl --user restart polybar.service"; always = true; notification = false; }
          { command = "systemctl --user restart redshift.service"; always = true; notification = false; }
        ];
        assigns = {
          "2: vivaldi" = [{ class = "Vivaldi"; }];
          "3: firefox" = [{ class = "Firefox"; }];
          "4: tor" = [{ class = "Tor Browser"; }];
          "5: steam" = [{ class = "Steam"; }];
        };
        keybindings = pkgs.lib.mkOptionDefault {
          "${mod}+Shift+b" = "exec vivaldi";
          "${mod}+Shift+f" = "exec firefox";
          "${mod}+Shift+o" = "exec tor-browser";
          "${mod}+Shift+s" = "exec steam";
          "${mod}+p" = "exec scrot ~/Pictures/Screenshots/%Y-%m-%d-%H-%M-%S.png";
          "${mod}+d" = "exec --no-startup-id ${menu}/bin/menu";
          "${mod}+Shift+e" = "exec --no-startup-id ${sysmenu}/bin/sysmenu";
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play";
          "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        };
        modes = {
          resize = {
            "Left" = "resize shrink width 10 px or 10 ppt";
            "Down" = "resize grow height 10 px or 10 ppt";
            "Up" = "resize shrink height 10 px or 10 ppt";
            "Right" = "resize grow width 10 px or 10 ppt";
            "h" = "resize shrink width 10 px or 10 ppt";
            "j" = "resize grow height 10 px or 10 ppt";
            "k" = "resize shrink height 10 px or 10 ppt";
            "l" = "resize grow width 10 px or 10 ppt";
            "Escape" = "mode default";
            "Return" = "mode default";
          };
        };
      };
      extraConfig = ''
        for_window [class=".*"] border pixel 0
      '';
    };
  };
}
