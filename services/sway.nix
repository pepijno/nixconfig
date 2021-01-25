{ config, pkgs, lib, ... }:

let
  restart-dunst = pkgs.callPackage ./scripts/restart-dunst.nix { config = config; };
  menu = pkgs.callPackage ./scripts/menu.nix { config = config; };
  menu_wayland = pkgs.callPackage ./scripts/menu_wayland.nix { config = config; };
  sysmenu = pkgs.callPackage ./scripts/sysmenu.nix { config = config; };
  new-pywal = pkgs.callPackage ./scripts/new-pywal.nix { config = config; };
  sway-launcher = import ../sway-launcher.nix { inherit pkgs; };
  mod = "Mod1";
in {
  imports = [
    ./waybar.nix
  ];
  home.packages = with pkgs; [
    # i3lock-color
    menu_wayland
  ];

  wayland = {
    # pointerCursor = {
    #   package = pkgs.capitaine-cursors;
    #   name = "capitaine-cursors";
    #   size = 25;
    # };

    windowManager.sway = {
      enable = true;
      # package = pkgs.i3-gaps;
      config = {
        bars = [{
          command = "${pkgs.waybar}/bin/waybar";
        }];
        modifier = mod;
        terminal = "${pkgs.alacritty}/bin/alacritty";
        gaps = {
          inner = 10;
          outer = 2;
          smartGaps = true;
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
          { command = "${new-pywal}/bin/new-pywal"; }
          # { command = "${pkgs.xorg.xrandr}/bin/xrandr -s 1920x1080"; always = true; notification = false; }
          { command = "${pkgs.solaar}/bin/solaar"; }
          # { command = "/usr/lib/polkit-gnome-polkit-gnome-authentication-agent-1"; }
          { command = "${pkgs.pywal}/bin/wal -R"; }
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
          "${mod}+d" = "exec --no-startup-id ${menu_wayland}/bin/menu_wayland";
          "${mod}+Shift+e" = "exec --no-startup-id ${sysmenu}/bin/sysmenu";
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
        for_window [app_id="^launcher$"] floating enable, border pixel 7
        for_window [class=".*"] border pixel 0

        include "$HOME/.cache/wal/colors-sway"
        output "*" bg $wallpaper fill
        output DP-1 resolution 1920x1080 position 0,0
        output HDMI-A-2 disable
      '';
    };
  };
}
