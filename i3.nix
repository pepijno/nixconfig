{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    i3lock
  ];

  xsession = {
    pointerCursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 25;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = rec {
        bars = [];
        modifier = "Mod1";
        terminal = "${pkgs.rxvt-unicode-unwrapped}/bin/urxvt";
        gaps = {
          inner = 10;
          outer = 10;
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
          { command = "wal -i ~/Pictures/Wallpapers/ -a 90 -o ~/bin/restart_dunst"; always = true; notification = false; }
          { command = "~/.config/polybar/launch.sh"; always = true; notification = false; }
          { command = "xrandr -s 1920x1080"; always = true; notification = false; }
          { command = "redshift"; }
          { command = "solaar"; }
          { command = "/usr/lib/polkit-gnome-polkit-gnome-authentication-agent-1"; }
          { command = "wal -R"; }
          { command = "compton"; always = true; }
        ];
        assigns = {
          "2: vivaldi" = [{ class = "Vivaldi"; }];
          "3: firefox" = [{ class = "Firefox"; }];
          "4: tor" = [{ class = "Tor Browser"; }];
          "5: steam" = [{ class = "Steam"; }];
        };
        keybindings = pkgs.lib.mkOptionDefault {
          "${modifier}+Shift+b" = "exec ${pkgs.vivaldi}/bin/vivaldi";
          "${modifier}+Shift+f" = "exec ${pkgs.firefox}/bin/firefox";
          "${modifier}+Shift+o" = "exec ${pkgs.tor-browser-bundle-bin}/bin/tor-browser";
          "${modifier}+Shift+s" = "exec ${pkgs.steam}/bin/steam";
          "${modifier}+d" = "exec --no-startup-id /home/pepijn/.config/polybar/scripts/menu";
          "${modifier}+Shift+e" = "exec --no-startup-id /home/pepijn/.config/polybar/scripts/sysmenu";
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ toggle";
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
        bindsym $mod+Shift+e exec --no-startup-id /home/pepijn/.config/polybar/scripts/sysmenu
      '';
    };
  };
}
