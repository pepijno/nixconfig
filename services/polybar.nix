{ config, pkgs, ... }:

let
  menu = pkgs.callPackage ./scripts/menu.nix { config = config; };
  sysmenu = pkgs.callPackage ./scripts/sysmenu.nix { config = config; };
  check-network = pkgs.callPackage ./scripts/check-network.nix { config = config; };

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

    script = ''
      polybar -q -r primary &
      polybar -q -r secondary &
      polybar -q -r tertiary &
    '';

    config = {
      "global/wm" = {
        margin-bottom = 0;
        margin-top = 0;
      };

      "bar/main" = {
        width = "21%";
        height = 32;
        bottom = false;
        fixed-center = true;
        line-size = 2;
        line-color = fg;
        override-redirect = true;
        wm-restack = "i3";

        background = bg;
        foreground = fg;

        font-0 = "Fantasque Sans Mono:pixelsize=10;3";
        font-1 = "Iosevka Nerd Font:pixelsize=13;3";
        # font-0 = "Tamsyn:pixelsize=12;0";
        # font-1 = "Roboto:size=11:weight=bold;2";
        # font-2 = "Noto Sans:size=11;1";
        # font-3 = "Iosevka Nerd Font:size=18;3";

        enable-ipc = true;

        scroll-up = "i3wm-wsnext";
        scroll-down = "i3wm-wsprev";

        # modules-left = "menu workspaces terminal vivaldi firefox tor steam";
        # modules-right = "filesystem swap memory cpu volume network date powermenu";

        offset-x = "10";
        offset-y = "10";
      };

      "bar/primary" = {
        "inherit" = "bar/main";
        offset-x = "9";
        offset-y = "10";
        bottom = false;
        width = "29%";

        module-margin-left = 0;
        module-margin-right = 0;

        modules-left = "menu workspaces title";
        enable-ipc = true;
      };

      "bar/secondary" = {
        "inherit" = "bar/main";
        offset-x = "40%";
        offset-y = "10";
        bottom = false;
        width = "34%";

        module-margin-left = 0;
        module-margin-right = 0;

        modules-left = "network";
        modules-center = "filesystem";
        modules-right = "swap memory cpu";
        enable-ipc = true;

        tray-position = "right";
        tray-padding = "";
        tray-transparent = true;
        tray-background = bg;
        tray-detatched = false;

      };

      "bar/tertiary" = {
        "inherit" = "bar/main";
        offset-x = "87%:-9";
        offset-y = "10";
        bottom = false;
        width = "13%";

        module-margin-left = 0;
        module-margin-right = 0;

        modules-right = "powermenu";
        modules-left = "volume";
        modules-center = "date";
        enable-ipc = true;
      };

      "module/title" = {
        type = "internal/xwindow";
        format-padding = 2;
        label-maxlen = 50;
      };

      "module/menu" = {
        type = "custom/text";
        content = "";
        content-padding = 1;
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
        content-padding = 1;
        content-foreground = fg-alt;
        click-left = "${pkgs.rxvt-unicode-unwrapped}/bin/urxvt &";
      };

      "module/vivaldi" = {
        type = "custom/text";
        content = "";
        content-padding = 1;
        content-foreground = fg-alt;
        click-left = "vivaldi &";
      };

      "module/firefox" = {
        type = "custom/text";
        content = "";
        content-padding = 1;
        content-foreground = fg-alt;
        click-left = "firefox &";
      };

      "module/tor" = {
        type = "custom/text";
        content = "";
        content-padding = 1;
        content-foreground = fg-alt;
        click-left = "tor-browser &";
      };

      "module/steam" = {
        type = "custom/text";
        content = "";
        content-padding = 1;
        content-foreground = fg-alt;
        click-left = "steam &";
      };

      "module/filesystem" = {
        type = "internal/fs";
        mount-0 = "/";
        mount-1 = "/home";
        mount-2 = "/backups";
        internal = 10;
        fixed-values = true;
        label-mounted = "%mountpoint% %free% ";
        format-padding = 1;
        spacing = 1;
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = 4;
        format-background = shade5;
        label = "﬙ %percentage%%";
        format-padding = 1;
        tail = true;
      };

      "module/swap" = {
        type = "internal/memory";
        format-padding = 1;
        format-background = shade5;
        tail = true;
        interval = 3;
        label = " %percentage_swap_used%%";
      };

      "module/memory" = {
        type = "internal/memory";
        format-padding = 1;
        format-background = shade5;
        tail = true;
        interval = 3;
        label = " %percentage_used%%";
      };

      "module/volume" = {
        type = "internal/alsa";
        format-volume = "<ramp-volume> <label-volume>";
        format-volume-padding = 1;
        format-volume-background = shade4;
        label-volume = "%percentage%%";
        label-muted = "婢";
        label-muted-background = shade4;
        label-muted-padding = 1;

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
        format-padding = 1;
        click-left = "networkmanager_dmenu &";
        click-right = "networkmanager_dmenu &";
        tail = true;
      };

      "module/date" = {
        type = "internal/date";
        interval = 1;
        label = " %time%";
        # label-padding = 2;
        # label-background = shade3;
        time = " %m-%d %H:%M:%S";
        # time-alt = " %Y-%m-%d";
      };

      "module/powermenu" = {
        type = "custom/text";
        content = "襤";
        content-padding = 1;
        content-background = shade2;
        content-foreground = fg;
        click-left = "${sysmenu}/bin/sysmenu";
        click-right = "${sysmenu}/bin/sysmenu";
      };

      "settings" = {
        pseudo-transparency = true;
        compositing-background = "source";
        compositing-foreground = "over";
        compositing-overline = "over";
        compositing-underline = "over";
        compositing-border = "over";
      };
    };
  };
}
