{ config, pkgs, ... }:

let 
  sw = "/run/current-system/sw";
  swaybg = "${pkgs.swaybg}/bin/swaybg -m fill -i $(find ~/Pictures/Wallpapers/. -type f | /run/current-system/sw/bin/shuf -n1)";
in{
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 600; command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off"; resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on; ${sw}/bin/systemctl --user restart wlsunset.service; ${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-1 --off"; }
      { timeout = 1200; command = "${sw}/bin/systemctl hibernate"; }
    ];
  };

  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = ${pkgs.solaar}/bin/solaar
    exec = /usr/lib/polkit-gnome-polkit-gnome-authentication-agent-1
    exec-once = ${swaybg}
    exec-once = ${pkgs.waybar}/bin/waybar
    exec = ${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-1 --off

    general {
      gaps_in=4
      gaps_out=20
      border_size=0
      no_border_on_floating = true
      layout = dwindle
    }

    decoration {
      rounding = 2
      multisample_edges = true
    }

    misc {
      disable_hyprland_logo = true
      disable_splash_rendering = true
      mouse_move_enables_dpms = true
      enable_swallow = true
    }

    animations {
      enabled = true
      bezier = overshot, 0.05, 0.9, 0.1, 1.05
      bezier = smoothOut, 0.36, 0, 0.66, -0.56
      bezier = smoothIn, 0.25, 1, 0.5, 1

      animation = windows, 1, 5, overshot, slide
      animation = windowsOut, 1, 4, smoothOut, slide
      animation = windowsMove, 1, 4, default
      animation = border, 1, 10, default
      animation = fade, 1, 10, smoothIn
      animation = fadeDim, 1, 10, smoothIn
      animation = workspaces, 1, 6, default

    }

    $mod = ALT

    monitor = DP-1,preferred,auto,1
    monitor = HDMI-A-1,disable

    windowrulev2 = workspace 1,class:Kitty
    windowrulev2 = workspace 2,class:Vivaldi
    windowrulev2 = workspace 3,class:Firefox
    windowrulev2 = workspace 4,class:Tor Browser
    windowrulev2 = workspace 5,class:Steam
    windowrulev2 = float, class:(firefox), title:(Picture-in-Picture)

    bind = $mod, B, exec, ${sw}/bin/pkill swaybg && ${swaybg}
    bind = $mod SHIFT, Q, killactive
    bind = $mod, F, fullscreen, 0
    bind = $mod, P, forcerendererreload
    bind = $mod SHIFT, X, exit
    bind = $mod, V, togglefloating

    bindm = $mod, mouse:272, movewindow
    bindm = $mod, mouse:273, resizewindow

    bind  = $mod SHIFT, B,      exec, ${pkgs.vivaldi}/bin/vivaldi
    bind  = $mod SHIFT, F,      exec, ${pkgs.firefox}/bin/firefox
    bind  = $mod SHIFT, O,      exec, tor-browser
    bind  = $mod SHIFT, S,      exec, ${pkgs.steam}/bin/steam
    bind  = $mod,       RETURN, exec, ${pkgs.kitty}/bin/kitty
    bindr = $mod,       D,      exec, pkill sirula || ${pkgs.sirula}/bin/sirula
    bind  = $mod SHIFT, E,      exec, ${pkgs.wlogout}/bin/wlogout

    bindle = , XF86AudioRaiseVolume, exec, ${sw}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%
    bindle = , XF86AudioLowerVolume, exec, ${sw}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%
    bindl  = , XF86AudioMute,        exec, ${sw}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle
    bindl  = , XF86AudioPlay,        exec, ${pkgs.playerctl}/bin/playerctl play-pause
    bindl  = , XF86AudioPause,       exec, ${pkgs.playerctl}/bin/playerctl pause-pause
    bindl  = , XF86AudioNext,        exec, ${pkgs.playerctl}/bin/playerctl next
    bindl  = , XF86AudioPrev,        exec, ${pkgs.playerctl}/bin/playerctl previous

    bind = $mod, 1, workspace, 1
    bind = $mod, 2, workspace, 2
    bind = $mod, 3, workspace, 3
    bind = $mod, 4, workspace, 4
    bind = $mod, 5, workspace, 5
    bind = $mod, 6, workspace, 6
    bind = $mod, 7, workspace, 7
    bind = $mod, 8, workspace, 8
    bind = $mod, 9, workspace, 9
    bind = $mod, 0, workspace, 10

    bind = $mod SHIFT, 1, movetoworkspace, 1
    bind = $mod SHIFT, 2, movetoworkspace, 2
    bind = $mod SHIFT, 3, movetoworkspace, 3
    bind = $mod SHIFT, 4, movetoworkspace, 4
    bind = $mod SHIFT, 5, movetoworkspace, 5
    bind = $mod SHIFT, 6, movetoworkspace, 6
    bind = $mod SHIFT, 7, movetoworkspace, 7
    bind = $mod SHIFT, 8, movetoworkspace, 8
    bind = $mod SHIFT, 9, movetoworkspace, 9
    bind = $mod SHIFT, 0, movetoworkspace, 10
  '';
}
