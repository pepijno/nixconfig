{ config, pkgs, ... }:

let
  menu = pkgs.callPackage ./scripts/menu.nix { config = config; };
  sysmenu = pkgs.callPackage ./scripts/sysmenu.nix { config = config; };
  check-network = pkgs.callPackage ./scripts/check-network.nix { config = config; };
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
      vivaldi = {
        proprietaryCodecs = true;
        enableWideVine = true;
      };
    };
  };

  bg = "\${xrdb:color0}";
  fg = "\${xrdb:color7}";
  fg-alt = "\${xrdb:color7}";

  acolor = "\${xrdb:color7}";
  curgent = "\${xrdb:color3}";
  coccupied = "\${xrdb:color2}";

  shade1 = "\${xrdb:color1}";
  shade2 = "\${xrdb:color2}";
  shade3 = "\${xrdb:color3}";
  shade4 = "\${xrdb:color3}";
  shade5 = "\${xrdb:color4}";
  shade6 = "\${xrdb:color4}";
  shade7 = "\${xrdb:color5}";
  shade8 = "\${xrdb:color5}";
  shade9 = "\${xrdb:color4}";
  txt = "\${xrdb:color7}";
in {
  home.packages = with pkgs; [
    libnotify
    rofi
  ];

  services.polybar = {
    enable = true;

    package = pkgs.polybar.override {
      i3GapsSupport = true;
      alsaSupport = true;
    };

    script = "polybar -q -r main &";

    config = {
      "bar/main" = {
        width = "100%";
        height = 32;
        offset-x = "2%";
        offset-y = "2%";
        bottom = false;
        fixed-center = false;
        line-size = 2;

        background = bg;
        foreground = fg;

        font-0 = "Fantasque Sans Mono:pixelsize=10;3";
        font-1 = "Iosevka Nerd Font:pixelsize=13;3";

        enable-ipc = true;

        scroll-up = "i3wm-wsnext";
        scroll-down = "i3wm-wsprev";

        modules-left = "menu workspaces terminal vivaldi firefox tor steam";
        modules-right = "filesystem swap memory cpu volume network date powermenu";

        tray-position = "center";
        tray-padding = "";
        tray-transparent = true;
        tray-background = bg;
        tray-detatched = false;
      };

      "module/menu" = {
        type = "custom/text";
        content = "";
        content-padding = 2;
        content-background = shade1;
        content-foreground = fg;
        click-left = "${menu}/bin/menu";
        click-right = "${menu}/bin/menu full";
      };

      "module/workspaces" = {
        type = "internal/xworkspaces";
        pin-workspaces = false;
        enable-click = true;
        enable-scroll = true;
        format-padding = 1;

        icon-default = "";

        format = "<label-state>";
        format-background = shade9;
        label-active = "";
        label-occupied = "";
        label-urgent = "";
        label-empty = "";

        label-empty-padding = 1;
        label-active-padding = 1;
        label-urgent-padding = 1;
        label-occupied-padding = 1;

        label-empty-foreground = fg;
        label-active-foreground = acolor;
        label-urgent-foreground = curgent;
        label-occupied-foreground = coccupied;
      };

      "module/terminal" = {
        type = "custom/text";
        content = "";
        content-padding = 2;
        content-foreground = fg-alt;
        click-left = "${pkgs.rxvt-unicode-unwrapped}/bin/urxvt &";
      };

      "module/vivaldi" = {
        type = "custom/text";
        content = "";
        content-padding = 2;
        content-foreground = fg-alt;
        click-left = "${unstable.vivaldi}/bin/vivaldi &";
      };

      "module/firefox" = {
        type = "custom/text";
        content = "";
        content-padding = 2;
        content-foreground = fg-alt;
        click-left = "${unstable.firefox}/bin/firefox &";
      };

      "module/tor" = {
        type = "custom/text";
        content = "";
        content-padding = 2;
        content-foreground = fg-alt;
        click-left = "${unstable.tor-browser-bundle-bin}/bin/tor-browser &";
      };

      "module/steam" = {
        type = "custom/text";
        content = "";
        content-padding = 2;
        content-foreground = fg-alt;
        click-left = "${unstable.steam}/bin/steam &";
      };

      "module/filesystem" = {
        type = "internal/fs";
        mount-0 = "/";
        mount-1 = "/home";
        mount-2 = "/backups";
        internal = 10;
        fixed-values = true;
        label-mounted = "%mountpoint% %free% ";
        format-padding = 2;
        spacing = 2;
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = 4;
        format-background = shade5;
        label = "CPU %percentage%%";
        format-padding = 2;
        tail = true;
      };

      "module/swap" = {
        type = "internal/memory";
        format-padding = 2;
        format-background = shade5;
        tail = true;
        interval = 3;
        label = "SWAP %percentage_swap_used%%";
      };

      "module/memory" = {
        type = "internal/memory";
        format-padding = 2;
        format-background = shade5;
        tail = true;
        interval = 3;
        label = "RAM %percentage_used%%";
      };

      "module/volume" = {
        type = "internal/alsa";
        format-volume = "<ramp-volume> <label-volume>";
        format-volume-padding = 2;
        format-volume-background = shade4;
        label-volume = "%percentage%%";
        label-muted = "婢";
        label-muted-background = shade4;
        label-muted-padding = 2;

        ramp-volume-0 = "奄";
        ramp-volume-1 = "奄";
        ramp-volume-2 = "奔";
        ramp-volume-3 = "奔";
        ramp-volume-4 = "墳";
        ramp-volume-5 = "墳";
        ramp-volume-6 = "墳";
      };

      "module/network" = {
        type = "custom/script";
        exec = "${pkgs.stdenv.shell} -c ${check-network}/bin/check-network";
        format-background = shade4;
        format-padding = 2;
        click-left = "networkmanager_dmenu &";
        click-right = "networkmanager_dmenu &";
        tail = true;
      };

      "module/date" = {
        type = "internal/date";
        interval = 1;
        label = " %time%";
        label-padding = 2;
        label-background = shade3;
        time = " %H:%M:%S";
        time-alt = " %Y-%m-%d";
      };

      "module/powermenu" = {
        type = "custom/text";
        content = "襤";
        content-padding = 2;
        content-background = shade2;
        content-foreground = fg;
        click-left = "${sysmenu}/bin/sysmenu";
        click-right = "${sysmenu}/bin/sysmenu";
      };
    };
  };
}
