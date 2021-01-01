{ config, pkgs, lib, ... }:

with lib;

let

  toDunstIni = generators.toINI {
    mkKeyValue = key: value:
      let
        value' = if isBool value then
          (if value then "yes" else "no")
        else if isString value then
          ''"${value}"''
        else
          toString value;
      in "${key}=${value'}";
  };

in {
  home.file."bin/launch_dunst".source = ./launch_dunst;
  home.file."bin/restart_dunst".source = ./restart_dunst;

  home.packages = with pkgs; [
    dunst
  ];

  xdg.dataFile."dbus-1/services/org.knopwob.dunst.service".source =
    "${pkgs.dunst}/share/dbus-1/services/org.knopwob.dunst.service";

  services.dunst.settings.global.icon_path = let
    basePaths = [
      "/run/current-system/sw"
      config.home.profileDirectory
    ];

    themes = [
    ];

    categories = [
      "actions"
      "animations"
      "apps"
      "categories"
      "devices"
      "emblems"
      "emotes"
      "filesystem"
      "intl"
      "legacy"
      "mimetypes"
      "places"
      "status"
      "stock"
    ];
  in concatStringsSep ":" (concatMap (theme:
    concatMap (basePath:
      map (category:
        "${basePath}/share/icons/${theme.name}/${theme.size}/${category}")
      categories) basePaths) themes);

  systemd.user.services.dunst = {
    Unit = {
      Description = "Dunst notification daemon";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecStart = "/home/pepijn/bin/launch_dunst ${pkgs.dunst}/bin/dunst /home/pepijn/.cache/wal/colors.sh";
      Environment = "PATH=/run/wrappers/bin:/home/pepijn/.nix-profile/bin:/etc/profiles/per-user/pepijn/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
    };
  };

  xdg.configFile."dunst/dunstrc" = {
    text = toDunstIni {
      global = {
        monitor = 0;
        follow = "mouse";
        geometry = "300x5-30+20";
        indicate_hidden = "yes";
        shrink = "no";
        transparency = 10;
        notification_height = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        frame_width = 3;
        frame_color = "#aaaaaa";
        separator_color = "frame";
        sort = "yes";
        idle_threshold = 120;
        font = "DejaVu Sans Mono 10";
        line_height = 4;
        markup = "full";
        format = ''
          %s %p %I
          %b
        '';
        alignment = "left";
        show_age_threshold = 30;
        word_wrap = "yes";
        ellipsize = "middle";
        stack_duplicates = true;
        ignore_newline = "no";
        hide_duplicate_count = false;
        show_indicators = "yes";
        icon_position = "left";
        max_icon_size = 32;
        sticky_history = "yes";
        history_length = 20;
        startup_notification = false;
      };

      urgency_low = {
        timeout = 10;
      };

      urgency_normal = {
        timeout = 10;
      };

      urgency_critical = {
        timeout = 0;
      };
    };
    onChange = ''
      pkillVerbose=""
      if [[ -v VERBOSE ]]; then
        pkillVerbose="-e"
      fi
      $DRY_RUN_CMD ${pkgs.procps}/bin/pkill -u $USER $pkillVerbose dunst || true
      unset pkillVerbose
    '';
  };
}
