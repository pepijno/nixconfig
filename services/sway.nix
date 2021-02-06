{ config, pkgs, lib, ... }:

let
  restart-dunst = pkgs.callPackage ./scripts/restart-dunst.nix { config = config; };
  menu = pkgs.callPackage ./scripts/menu.nix { config = config; };
  menu_wayland = pkgs.callPackage ./scripts/menu_wayland.nix { config = config; };
  sysmenu = pkgs.callPackage ./scripts/sysmenu.nix { config = config; };
  new-pywal = pkgs.callPackage ./scripts/new-pywal.nix { config = config; };
  sway-launcher = import ./scripts/sway-launcher.nix { inherit pkgs; };
  customLock = import ../applications/customLock.nix { inherit pkgs config; };
  sysmenu-wayland = import ./scripts/sysmenu-wayland.nix { inherit pkgs config; };
  mod = "Mod1";
in {
  imports = [
    ./waybar.nix
  ];
  home.packages = with pkgs; [
    menu_wayland
    sysmenu-wayland
    mako
    # swaylock-effects
  ];

  wayland = {
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
          { command = "${pkgs.solaar}/bin/solaar"; }
          # { command = "/usr/lib/polkit-gnome-polkit-gnome-authentication-agent-1"; }
          { command = "${pkgs.pywal}/bin/wal -R"; }
          { command = "include \"$HOME/.cache/wal/colors.sway\"; ${pkgs.mako}/bin/mako --background-color \"$background\" --text-color \"$foreground\" --border-color \"$color13\""; }
          # { command = "${pkgs.swayidle}/bin/swayidle -w timeout 600 '${customLock}/bin/customLock -f -c 000000' timeout 300 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"' before-sleep '${customLock}/bin/customLock -f -c 000000'"; }
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
          "${mod}+Shift+e" = "exec --no-startup-id ${sysmenu-wayland}/bin/sysmenu-wayland";
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
        for_window [app_id="^sysmenu-launcher$"] floating enable, border pixel 7, resize set width 234px height 234px
        for_window [class=".*"] border pixel 0

        include "$HOME/.cache/wal/colors-sway"
        output "*" bg $wallpaper fill

        seat * hide_cursor 2000
      '';
    };
  };
}
