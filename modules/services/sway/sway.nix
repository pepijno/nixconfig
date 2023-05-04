{ config, pkgs, lib, ... }:

let
  mod = "Mod1";
  sw = "/run/current-system/sw";
  run-swaybg = pkgs.callPackage ./run-swaybg.nix { config = config; };
in
{
  home.packages = with pkgs; [
    swaybg
    swayidle
    swaylock
  ];
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.sway}/bin/swaymsg \"output * dpms off\""; resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * dpms on\"; ${sw}/bin/systemctl --user restart wlsunset.service"; }
      { timeout = 600; command = "${sw}/bin/systemctl hibernate"; }
    ];
  };

  wayland = {
    windowManager.sway = {
      enable = true;

      config = {
        bars = [{
          command = "${pkgs.waybar}/bin/waybar";
        }];
        modifier = mod;
        terminal = "${pkgs.alacritty}/bin/alacritty";
        gaps = {
          inner = 10;
          outer = 2;
          smartGaps = false;
        };
        # output = {
        #   DP-1 = { bg = "~/Pictures/Wallpapers/ fill"; };
        # };
        fonts = [ "Noto sans 10" "FontAwesome 10" ];
        window = {
          border = 0;
          hideEdgeBorders = "both";
        };
        floating = {
          border = 0;
        };
        startup = [
          { command = "${pkgs.solaar}/bin/solaar"; always = false; }
          { command = "/usr/lib/polkit-gnome-polkit-gnome-authentication-agent-1"; always = false; }
          { command = "${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-1 --off"; always = true; }
          { command = "${run-swaybg}/bin/run-swaybg"; always = false; }
          # { command = "/run/current-system/sw/bin/systemctl --user start dunst.service"
        ];
        assigns = {
          "1: term" = [{ class = "Alacritty"; }];
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
          # "${mod}+Shift+l" = "exec ${customLock}/bin/customLock";
          "${mod}+d" = "exec --no-startup-id ${pkgs.sirula}/bin/sirula";
          # "${mod}+Shift+e" = "exec --no-startup-id ${sysmenu}/bin/sysmenu";
          # "${mod}+p" = "exec --no-startup-id ${pkgs.grim}/bin/grim -o $(swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name') - | ${pkgs.wl-clipboard}/bin/wl-copy";
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ toggle";
          "XF86AudioPlay" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play";
          "XF86AudioPause" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl pause";
          "XF86AudioNext" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl previous";
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
        for_window [app_id="firefox" title="^Picture-in-Picture$"] floating enable, move position 877 450, sticky enable
        seat * hide_cursor 2000
      '';
    };
  };
}
