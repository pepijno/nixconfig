{ config, pkgs, ... }:

let
  sysmenu = pkgs.callPackage ./scripts/sysmenu.nix { config = config; };
  sysmenu-wayland = import ./scripts/sysmenu-wayland.nix { inherit pkgs config; };
in {
  home.packages = with pkgs; [
    libnotify
    rofi
  ];

  programs.waybar = {
    enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 32;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [];
        modules-right = [ "network" "disk#root" "disk#home" "disk#backups" "pulseaudio" "memory" "cpu" "clock" "custom/poweroff" ];

        modules = {
          "sway/workspaces" = {
            format = "{icon}";
            format-icons = {
              focused = "";
              default = "";
            };
            disable-scroll = false;
            disable-click = false;
            disable-scroll-wraparound = false;
            enable-bar-scroll = true;
          };

          "sway/mode" = {
            format = "{}";
          };
          "clock" = {
            interval = 1;
            format = "{:%H:%M:%S}";
            tooltip-format = "{:%Y-%m-%d | %H:%M:%S}";
            format-alt = "{:%Y-%m-%d}";
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
            format = "CPU {usage}%";
          };
          "memory" = {
            format = "RAM {}%";
          };
          "network" = {
            format-ethernet = "{bandwidthUpBits}   {bandwidthDownBits}   泌";
            format-disconnected = "睊";
            interval  = 2;
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
              default = ["" ""];
            };
            on-click = "/run/current-system/sw/bin/amixer set Master toggle";
          };
          "custom/poweroff" = {
            tooltip = false;
            format = "";
            on-click = "${sysmenu-wayland}/bin/sysmenu-wayland";
          };
        };
      }
    ];

    style = ''
      @import "/home/pepijn/.cache/wal/colors-waybar.css";

      * {
          border: none;
          border-radius: 0;
          font-family: 'Fantasque Sans Mono 10', 'Iosevka Nerd Font 13';
          min-height: 0;
      }

      window#waybar {
          background: @background;
          color: @foreground;
      }

      window#waybar.hidden {
          opacity: 0.0;
      }
      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      #workspaces button {
          padding: 6px;
          background: @color4;
          color: @color7;
      }

      #workspaces button.urgent {
          background-color: @color5;
      }

      #mode {
          background: @color2;;
      }

      #clock, #battery, #cpu, #memory, #temperature, #backlight, #network, #pulseaudio, #custom-media, #tray, #mode, #idle_inhibitor, #custom-poweroff, #custom-menu {
          padding: 0 15px;
          margin: 0;
      }

      #custom-poweroff, #workspaces {
          font-size: 15px;
      }

      #clock, #cpu, #memory, #network, #pulseaudio, #mode, #disk {
          font-size: 12px;
      }

      #custom-poweroff {
          background-color: @color1;
          color: @color7;
          padding: 0 11px;
      }

      #clock, #cpu, #memory {
          background-color: @color2;
      }

      #network.disconnected {
          background: red;
      }

      #pulseaudio {
          background: @color3;
      }

      #disk {
          background: @color4;
          padding: 0 10px;
      }
    '';
  };
}
