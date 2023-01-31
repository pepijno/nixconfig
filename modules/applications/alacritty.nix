{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      colors = {
        primary = {
          background = "#2B2E37";
          foreground = "#B4BCCD";
        };

        normal = {
          black = "#01060E";
          red = "#FF6C6B";
          green = "#98BE65";
          yellow = "#ECBE7B";
          blue = "#51AFEF";
          magenta = "#C678DD";
          cyan = "#A9A1E1";
          white = "#B4BCCD";
        };

        # Bright colors
        bright = {
          black = "#686868";
          red = "#F07178";
          green = "#C2D94C";
          yellow = "#FFB454";
          blue = "#59C2FF";
          magenta = "#FFEE99";
          cyan = "#95E6CB";
          white = "#FFFFFF";
        };
      };

      window = {
        padding = {
          x = 25;
          y = 20;
        };
        dynamic_padding = true;
        decorations = "none";
        startup_mode = "Maximized";
        opacity = 0.98;
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        normal = {
          family = "DejaVu Sans Mono Nerd Font";
          style = "Light";
        };
        bold = {
          family = "DejaVu Sans Mono Nerd Font";
          style = "Light";
        };
        italic = {
          family = "DejaVu Sans Mono Nerd Font";
          style = "Light";
        };
        size = 11.0;
      };

      draw_bold_text_with_bright_colors = false;

      bell = {
        duration = 0;
      };

      cursor = {
        style = "Block";
        unfocused_hollow = true;
      };

      live_config_reload = true;
    };
  };
}
