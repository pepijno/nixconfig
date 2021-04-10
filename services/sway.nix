{ config, pkgs, lib, ... }:

let
  sysmenu = pkgs.callPackage ./scripts/sysmenu.nix { config = config; };
  new-pywal = pkgs.callPackage ./scripts/new-pywal.nix { config = config; };
  customLock = import ../applications/customLock.nix { inherit pkgs config; };
  launch-mak = import ./scripts/launch-mak.nix { inherit pkgs config; };
  mod = "Mod1";
in {
  imports = [
    ./waybar.nix
    ../applications/wofi/wofi.nix
  ];
  home.packages = with pkgs; [
    launch-mak
    mako
    grim
    jq
    wl-clipboard
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
          {
            command = "${pkgs.pywal}/bin/wal -R";
          }
          {
            command = "${launch-mak}/bin/launch-mak";
            always = true;
          }
          # {
          #   command = "${pkgs.swayidle}/bin/swayidle -w timeout 600 '${customLock}/bin/customLock' \\
          #     timeout 300 'swaymsg \"output * dpms off\"' \\
          #     resume 'swaymsg \"output * dpms on\"' \\
          #     before-sleep '${customLock}/bin/customLock'";
          # }
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
          "${mod}+Shift+l" = "exec ${customLock}/bin/customLock";
          "${mod}+d" = "exec --no-startup-id ${pkgs.wofi}/bin/wofi --show drun";
          "${mod}+Shift+e" = "exec --no-startup-id ${sysmenu}/bin/sysmenu";
          "${mod}+p" = "exec --no-startup-id ${pkgs.grim}/bin/grim -o $(swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name') - | ${pkgs.wl-clipboard}/bin/wl-copy";
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

        include "$HOME/.cache/wal/colors-sway"

        # class                 border    backgr.   text      indicator child_border
        client.focused          $color2   $color2   $color1   $color2   $color2
        client.unfocused        $color0   $color0   $color0   $color0   $color0
        client.focused_inactive $color3   $color3   $color1   $color3   $color3
        client.urgent           $color15  $color15  $color7   $color15  $color15
        client.placeholder      $color3   $color3   $color7   $color3   $color3

        client.background       $bg

        output "*" bg $wallpaper fill

        seat * hide_cursor 2000
      '';
    };
  };
}
