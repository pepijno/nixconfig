{ config, pkgs, lib, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        notification_limit = 0;
        follow = "none";
        width = 250;
        height = 250;
        origin = "top-right";
        scale = 0;
        offset = "15x55";
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 400;
        indicate_hidden = "yes";
        transparency = 30;
        separator_height = 3;
        padding = 20;
        horizontal_padding = 20;
        text_icon_padding = 0;
        frame_width = 0;
        frame_color = "#8BABF000";
        sort = "yes";
        font =
          "xft:Ubuntu:weight=bold:pixelsize=12:antialias=true:hinting=true";
        line_height = 0;
        markup = "full";
        format = ''
          <b>%s</b>
          %b'';
        alignment = "center";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 128;
        sticky_history = "yes";
        history_length = 20;
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 2;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
        startup_notification = true;
      };

      urgency_low = {
        background = "#2B2E37";
        foreground = "#929AAD";
        timeout = 10;
      };

      urgency_normal = {
        background = "#2B2E37";
        foreground = "#929AAD";
        timeout = 10;
      };

      urgency_critical = {
        background = "#ff6c6b";
        foreground = "#e8e8e8";
        frame_color = "#eade00";
        frame_width = 4;
        timeout = 0;
      };
    };
  };
}
