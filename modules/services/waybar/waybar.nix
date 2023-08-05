{ config, pkgs, libs, ... }:

{
  home.packages = with pkgs; [
    libnotify
  ];

  services.playerctld.enable = true;

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ]; });

    settings = [
      {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "custom/nix" "custom/separator" "wlr/workspaces" "custom/separator" "mpris" ];
        modules-right = [ "network" "custom/separator" "disk#root" "disk#home" "disk#backups" "custom/separator" "cpu" "custom/separator" "memory" "custom/separator" "pulseaudio" "custom/separator" "clock" "custom/separator" "tray" ];

        modules = {
          "custom/nix" = {
            format = "󱄅 ";
          };

          "wlr/workspaces" = {
            sort-by-number = true;
            on-click = "activate";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };

          mpris = {
            format = "{status_icon}<span weight='bold'>{artist}</span> | {title}";
            max-length = 50;
            status-icons = {
              playing = "󰎈 ";
              paused = "󰏤 ";
              stopped = "󰓛 ";
            };
          };

          "clock" = {
            format = "{:<span rise='-500'> </span> %H:%M:%S   <span rise='890'></span><span rise='1200'> %A %B</span> %d}";
            interval = 1;
          };
          "disk#home" = {
            interval = 30;
            format = "{path} {free}";
            path = "/home";
          };
          "disk#backups" = {
            interval = 30;
            format = "{path} {free}";
            path = "/backups";
          };
          "disk#root" = {
            interval = 30;
            format = "{path} {free}";
            path = "/";
          };
          "cpu" = {
            interval = 1;
            format = "CPU {usage}%";
          };
          "memory" = {
            interval = 1;
            format = "RAM {}%";
          };
          "network" = {
            format-ethernet = "{bandwidthUpBits}   {bandwidthDownBits}   󰖩 ";
            format-disconnected = "󰖪 ";
            interval = 1;
          };
          "pulseaudio" = {
            # scroll-step = 1;
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-muted = "";
            format-icons = {
              headphones = "";
              handsfree = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" ];
            };
            on-click = "/run/current-system/sw/bin/amixer set Master toggle";
          };
          "tray" = {
            icon-size = 16;
            spacing = 8;
          };
          "custom/separator" = {
            format = "|";
            interval = "once";
            tooltip = false;
          };
        };
      }
    ];

    style = (builtins.readFile ./waybar.css);
  };
}
	
