{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      window = {
        padding = {
          x = 25;
          y = 20;
        };
        dynamic_padding = true;
        decorations = "none";
        startup_mode = "Maximized";
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        normal = {
          family = "DejaVu Sans Mono";
          style = "Light";
        };
        bold = {
          family = "DejaVu Sans Mono";
          style = "Light";
        };
        italic = {
          family = "DejaVu Sans Mono";
          style = "Light";
        };
        size = 11.0;
      };

      draw_bold_text_with_bright_colors = false;

      bell = {
        duration = 0;
      };

      background_opacity = 0.80;

      cursor = {
        style = "Block";
        unfocused_hollow = true;
      };

      live_config_reload = true;
    };
  };
}
