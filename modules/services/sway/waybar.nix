{ config, pkgs, ... }:

# sysmenu = pkgs.callPackage ./scripts/sysmenu.nix { config = config; };
{
  home.packages = with pkgs; [
    libnotify
  ];

  programs.waybar = {
    enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 30;
        modules-center = [ ];
        modules-left = [ "sway/workspaces" ];
        modules-right = ["network" "disk#root" "disk#home" "disk#backups" "cpu" "memory" "pulseaudio" "clock" "sway/mode" "tray"];

        modules = {
          "sway/workspaces" = {
            format = "{icon}";
            format-icons = {
              focused = "<span rise='870'></span>";
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
            format = "{:<span rise='-500'> </span> %H:%M:%S   <span rise='890'></span><span rise='1200'> %A %B</span> %d}";
            interval = 1;
            # format = "{:%H:%M:%S}";
            # tooltip-format = "{:%Y-%m-%d | %H:%M:%S}";
            # format-alt = "{:%Y-%m-%d}";
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
            interval = 2;
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
          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          "temperature" = {
            hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
            critical-threshold = 80;
            format-critical = "{temperatureC}°C ";
            format = "{temperatureC}°C ";
            interval = 2;
          };
          "custom/poweroff" = {
            tooltip = false;
            format = "";
            # on-click = "${sysmenu}/bin/sysmenu";
          };
        };
      }
    ];

    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "Fantasque Sans Mono 10', 'Iosevka Nerd Font 13";
          min-height: 0;
      }

      window#waybar {
          background: rgba(43, 46, 55, 0.98);
          color: #bebebe;
      }

      #workspaces {
          font-size: 20px;
      }

      #workspaces button {
          color: #bebebe;
          background: transparent;
          padding: 0px 0px 0 0px;
          margin: 10px 7px 10px 12px;
          border-radius: 4px;
      }
      #workspaces button.focused {
          color: white;
       }

      #mode {
          margin: 0px 15px 0px 15px;
          padding: 0px 12px 0px 12px;
          color: black;
          background: white;
      }

      #network, #cpu, #memory, #pulseaudio, #disk {
          margin:7px 4px 0 4px;
          border-radius: 6px;
          padding: 3px 6px 0px 8px;
      }
      @keyframes critical {
          to {
          color: rgba(187,56,0, 1);
          }
      }

      #clock {
          margin:7px 0 0 13px;
          border-radius: 6px;
          padding: 4px 6px 0px 0px;
      }

      #clock:hover {
      	background: rgba(40,40,40, .95);
      }
 
      #tray {
          margin: 7px 15px 0 4px;
          background: rgba(40,40,40, .65);
          border-radius: 6px;
          padding: 1px 5px 1px 5px;
      }
    '';
  };
}
	
